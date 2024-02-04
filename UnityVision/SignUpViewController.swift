import UIKit

class SignUpViewController: UIViewController {
    
    let nameTextField = UITextField()
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let confirmPasswordTextField = UITextField()
    let signUpButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // Set the background color
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        nameTextField.placeholder = "Full Name"
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        confirmPasswordTextField.placeholder = "Confirm Password"
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
        // Configure the buttons
        signUpButton.setTitle("Sign Up", for: .normal)
        
        // Add targets for buttons
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        // Add UI components to the view
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(signUpButton)
    }
    
    private func layoutViews() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Email TextField Layout
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -90),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Password TextField Layout
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Confirm Password TextField Layout
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            // Sign Up Button Layout
            signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc func signUpButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Alert the user that they need to enter both email and password
            return
        }
        
        APIService.signUp(name: name, email: email, password: password) { success, errorMessage in
            if success {
                APIService.getUsername(email: email) { success, userName in
                    DispatchQueue.main.async {
                        if success, let userName = userName {
                            // If username is successfully fetched, redirect to UserProfileViewController
                            let userProfileVC = UserProfileViewController()
                            userProfileVC.modalPresentationStyle = .fullScreen // Optional: Present full screen
                            userProfileVC.userName = userName // Set the fetched username here
                            self.present(userProfileVC, animated: true, completion: nil)
                            print("Login and username fetch successful")
                        } else {
                            // Handle error in fetching username
                            print("Username fetch failed with error: \(errorMessage ?? "Unknown error")")
                        }
                    }
                }
            } else if let errorMessage = errorMessage {
                print("error")
            } else {
                print("idk")
            }
        }
    }
}

