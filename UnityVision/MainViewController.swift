import UIKit
import SwiftUI

class MainViewController: UIViewController {
    let welcomeLabel = UILabel()
    let loginButton = UIButton(type: .system)
    let signUpButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        layoutViews()
    }
    
    private func setupViews() {
        welcomeLabel.text = "Welcome to UnityVision!"
        welcomeLabel.textAlignment = .center
        
        loginButton.setTitle("Log In", for: .normal)
        signUpButton.setTitle("Sign Up", for: .normal)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        view.addSubview(welcomeLabel)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
    }
    
    private func layoutViews() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Example constraints, adjust as needed
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            loginButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    
    @objc private func loginButtonTapped() {
            let loginVC = LoginViewController()
            navigationController?.pushViewController(loginVC, animated: true)
        }
        
        @objc private func signUpButtonTapped() {
            let signUpVC = SignUpViewController()
            navigationController?.pushViewController(signUpVC, animated: true)
        }
}
