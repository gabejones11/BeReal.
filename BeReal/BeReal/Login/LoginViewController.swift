//
//  ViewController.swift
//  BeReal
//
//  Created by Gabe Jones on 3/23/23.
//

import UIKit
import ParseSwift

class LoginViewController: UIViewController {
    
    //MARK: - UIComponents
    let usernameField: UITextField = {
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
    
    let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.white.cgColor
        textField.backgroundColor = .black
        textField.textColor = .white
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        return textField
    }()
    
    let logo: UILabel = {
        let label = UILabel()
        label.text = "BeReal."
        label.font = UIFont(name: "Arial-BoldMT", size: 65)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        let attributedLinkText = NSMutableAttributedString(string: "Sign Up", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5), .underlineStyle: NSUnderlineStyle.single.rawValue])
        attributedText.append(attributedLinkText)
        button.setAttributedTitle(attributedText, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        
    }
    
    //MARK: - Setup UI
    private func setupUI() {
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(logo)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        logo.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameField.topAnchor.constraint(equalTo: logo.bottomAnchor),
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameField.heightAnchor.constraint(equalToConstant: 35),
            
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 15),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            passwordField.heightAnchor.constraint(equalToConstant: 35),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 50),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            signupButton.heightAnchor.constraint(equalToConstant: 35),
            
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 35),
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 225),
            logo.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    //MARK: - Functions
    @objc private func signUpButtonTapped() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    @objc private func logInButtonTapped(){
        //make sure all of the fields are non-nil and non-empty
        guard let username = usernameField.text,
              let password = passwordField.text,
              !username.isEmpty,
              !password.isEmpty else {
            showMissingFieldsAlert()
            return
        }
        
        User.login(username: username, password: password) { [weak self]
            result in
            
            switch result {
            case .success(let user):
                print("Successfully logged in user: \(user)")
                
                //post a notification that the user has successfully logged in
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)
                
            case .failure(let error):
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func showAlert(description: String?) {
        let alertController = UIAlertController(title: "Unable to Log in", message: description ?? "Unknown error", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Oops...", message: "We need all fields filled out in order to log you in.", preferredStyle: .alert)
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
    }
}


