import UIKit

class LoginViewController: UIViewController {
    
    // UI Components
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let loginButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        // Configure each UI component here (styling, placeholders, etc.)
        emailTextField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        loginButton.setTitle("Log In", for: .normal)
        
        // Add targets for buttons
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        // Add UI components to the view
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }
    
    private func layoutViews() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Email TextField Layout
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Password TextField Layout
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Login Button Layout
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),

        ])
    }

    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // Alert the user that they need to enter both email and password
            return
        }
        
        // Call the login method of NetworkService
        APIService.login(email: email, password: password) { [weak self] success, errorMessage in
            if success {
                // After successful login, fetch the username
                APIService.getUsername(email: email) { success, userName in
                    DispatchQueue.main.async {
                        if success, let userName = userName {
                            // If username is successfully fetched, redirect to UserProfileViewController
                            let userProfileVC = UserProfileViewController()
                            userProfileVC.modalPresentationStyle = .fullScreen // Optional: Present full screen
                            userProfileVC.userName = userName // Set the fetched username here
                            self?.present(userProfileVC, animated: true, completion: nil)
                            print("Login and username fetch successful")
                        } else {
                            // Handle error in fetching username
                            print("Username fetch failed with error: \(errorMessage ?? "Unknown error")")
                        }
                    }
                }
            } else if let errorMessage = errorMessage {
                // Handle the login error message as needed
                DispatchQueue.main.async {
                    print("Login failed with error: \(errorMessage)")
                    // Optionally, show an alert or update the UI to reflect the error
                }
            }
        }
    }
}
