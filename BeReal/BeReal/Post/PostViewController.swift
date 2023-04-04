//
//  PostViewController.swift
//  BeReal
//
//  Created by Gabe Jones on 3/27/23.
//

import UIKit
import PhotosUI
import ParseSwift

class PostViewController: UIViewController {

    //MARK: - UIComponents
    let captionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Write a caption here..."
        textField.textColor = .white
        return textField
    }()
    
    let previewImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private var pickedImage: UIImage?
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - SetupUI
    private func setupUI() {
        let pickImageButton = UIBarButtonItem(image: UIImage(systemName: "photo.fill"), style: .plain, target: self, action: #selector(pickImageButtonTapped))
        pickImageButton.tintColor = .white
        
        let shareImageButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonTapped))
        shareImageButton.tintColor = .white
        
        let takePhotoButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(onTakePhotoTapped))
        takePhotoButton.tintColor = .white
        
        self.navigationItem.rightBarButtonItems = [shareImageButton, pickImageButton, takePhotoButton]
        
        view.addSubview(previewImageView)
        view.addSubview(captionTextField)
        
        previewImageView.translatesAutoresizingMaskIntoConstraints = false
        captionTextField.translatesAutoresizingMaskIntoConstraints = false
        
        let screenWidth = UIScreen.main.bounds.width
        
        NSLayoutConstraint.activate([
            captionTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 125),
            captionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            captionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            previewImageView.topAnchor.constraint(equalTo: captionTextField.bottomAnchor, constant: 20),
            previewImageView.widthAnchor.constraint(equalToConstant: screenWidth),
            previewImageView.heightAnchor.constraint(equalToConstant: screenWidth)

        ])
        
    }
    
    //MARK: - Functions
    @objc private func pickImageButtonTapped() {
        //present the image picker
        var config = PHPickerConfiguration()
        
        //set the filter to only show images
        config.filter = .images
        
        //request the original file format (fastest method)
        config.preferredAssetRepresentationMode = .current
        
        //allow only one selected image
        config.selectionLimit = 1
        
        //instiantiate a picker passing the config
        let picker = PHPickerViewController(configuration: config)
        
        //set the picker delegate so we can recieve whater image the user picks
        picker.delegate = self
        
        //present the picker
        present(picker, animated: true)
    }
    
    @objc private func shareButtonTapped() {
        //dismiss the keyboard
        view.endEditing(true)

        // Unwrap optional pickedImage
        guard let image = pickedImage,
              // Create and compress image data (jpeg) from UIImage
              let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }

        // Create a Parse File by providing a name and passing in the image data
        let imageFile = ParseFile(name: "image.jpg", data: imageData)

        // Create Post object
        var post = Post()

        // Set properties
        post.imageFile = imageFile
        post.caption = captionTextField.text

        // Set the user as the current user
        post.user = User.current

        // Save object in background (async)
        post.save { [weak self] result in

            // Switch to the main thread for any UI updates
            DispatchQueue.main.async {
                switch result {
                case .success(let post):
                    print("✅ Post Saved! \(post)")

                    // Get the current user
                    if var currentUser = User.current {

                        // Update the `lastPostedDate` property on the user with the current date.
                        currentUser.lastPostedDate = Date()

                        // Save updates to the user (async)
                        currentUser.save { [weak self] result in
                            switch result {
                            case .success(let user):
                                print("✅ User Saved! \(user)")

                                // Switch to the main thread for any UI updates
                                DispatchQueue.main.async {
                                    // Return to previous view controller
                                    self?.navigationController?.popViewController(animated: true)
                                }

                            case .failure(let error):
                                self?.showAlert(description: error.localizedDescription)
                            }
                        }
                    }

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func onTakePhotoTapped() {
        // Make sure the user's camera is available
        // NOTE: Camera only available on physical iOS device, not available on simulator.
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("❌📷 Camera not available")
            return
        }

        // Instantiate the image picker
        let imagePicker = UIImagePickerController()

        // Shows the camera (vs the photo library)
        imagePicker.sourceType = .camera

        // Allows user to edit image within image picker flow (i.e. crop, etc.)
        // If you don't want to allow editing, you can leave out this line as the default value of `allowsEditing` is false
        imagePicker.allowsEditing = true

        // The image picker (camera in this case) will return captured photos via it's delegate method to it's assigned delegate.
        // Delegate assignee must conform and implement both `UIImagePickerControllerDelegate` and `UINavigationControllerDelegate`
        imagePicker.delegate = self

        // Present the image picker (camera)
        present(imagePicker, animated: true)
    }
    
    private func showAlert(description: String? = nil, error: Error? = nil){
        let alertController = UIAlertController(title: "Oops...", message: "\(description ?? "Please try again...")", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

}

//MARK: - Extension
extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        // Dismiss the picker
        picker.dismiss(animated: true)

        // Make sure we have a non-nil item provider
        guard let provider = results.first?.itemProvider,
           // Make sure the provider can load a UIImage
           provider.canLoadObject(ofClass: UIImage.self) else { return }

        // Load a UIImage from the provider
        provider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

           // Make sure we can cast the returned object to a UIImage
           guard let image = object as? UIImage else {

              // ❌ Unable to cast to UIImage
              self?.showAlert()
              return
           }

           // Check for and handle any errors
           if let error = error {
               self?.showAlert(error: error)
              return
           } else {

              // UI updates (like setting image on image view) should be done on main thread
              DispatchQueue.main.async {

                 // Set image on preview image view
                 self?.previewImageView.image = image

                 // Set image to use when saving post
                 self?.pickedImage = image
              }
           }
        }
    }
}

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        // Dismiss the image picker
        picker.dismiss(animated: true)

        // Get the edited image from the info dictionary (if `allowsEditing = true` for image picker config).
        // Alternatively, to get the original image, use the `.originalImage` InfoKey instead.
        guard let image = info[.editedImage] as? UIImage else {
            print("❌📷 Unable to get image")
            return
        }

        // Set image on preview image view
        previewImageView.image = image

        // Set image to use when saving post
        pickedImage = image
    }
}
