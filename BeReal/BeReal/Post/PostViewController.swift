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
        let pickImageButton = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(pickImageButtonTapped))
        pickImageButton.tintColor = .white
        
        let shareImageButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonTapped))
        shareImageButton.tintColor = .white
        
        self.navigationItem.rightBarButtonItems = [shareImageButton, pickImageButton]
        
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
            previewImageView.heightAnchor.constraint(equalToConstant: screenWidth * 1.5)

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

                    // Return to previous view controller
                    self?.navigationController?.popViewController(animated: true)

                case .failure(let error):
                    self?.showAlert(description: error.localizedDescription)
                }
            }
        }
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
