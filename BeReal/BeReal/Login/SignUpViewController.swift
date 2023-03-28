//
//  SignUpViewController.swift
//  BeReal
//
//  Created by Gabe Jones on 3/25/23.
//

import UIKit
import ParseSwift

class SignUpViewController: UIViewController {
    
    //MARK: - UIComponents
    let userNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.white.cgColor
        textField.backgroundColor = .black
        textField.layer.cornerRadius = 10
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let emailField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.white.cgColor
        textField.backgroundColor = .black
        textField.layer.cornerRadius = 10
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.white.cgColor
        textField.backgroundColor = .black
        textField.layer.cornerRadius = 10
        textField.textColor = .white
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        return textField
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        return button
    }()
    
    let screenTitle: UILabel = {
        let screenTitle = UILabel()
        screenTitle.text = "SignUp."
        screenTitle.font = UIFont(name: "Arial-BoldMT", size: 35)
        screenTitle.textAlignment = .center
        screenTitle.textColor = .white
        return screenTitle
    }()

    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    
    }
    
    //MARK: - setupUI
    private func setupUI() {
        view.addSubview(userNameField)
        view.addSubview(passwordField)
        view.addSubview(emailField)
        view.addSubview(screenTitle)
        view.addSubview(signUpButton)
        
        userNameField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        screenTitle.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            screenTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            screenTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            emailField.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 30),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            emailField.heightAnchor.constraint(equalToConstant: 35),
            
            userNameField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15),
            userNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userNameField.heightAnchor.constraint(equalToConstant: 35),
            
            passwordField.topAnchor.constraint(equalTo: userNameField.bottomAnchor, constant: 15),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordField.heightAnchor.constraint(equalToConstant: 35),
            
            signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: - Functions
    @objc private func signUpTapped() {
        //make sure that all fields are non-nil and non-empty
        guard let username = userNameField.text,
                let email = emailField.text,
                let password = passwordField.text,
                !username.isEmpty,
                !email.isEmpty,
                !password.isEmpty else {
            
            showMissingFieldsAlert()
            return
        }
        
        //Parse user sign up
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password
        
        newUser.signup {[weak self] result in
            switch result {
            case .success(let user):
                print("Successfully signed up user \(user)")
                
                //post a notification that the user has succesfully signed up
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                
                
            case .failure(let error):
                //failure to sign up
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Sign Up", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
        
    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Oops...", message: "We need all of the fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        resignFirstResponder()
    }

}
