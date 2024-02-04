import UIKit

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let greetingLabel = UILabel()
    let profileImageView = UIImageView()
    let takePictureButton = UIButton(type: .system)
    let submitButton = UIButton(type: .system)
    var userName: String? // Add a property to hold the user's name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        view.backgroundColor = .white
        setupGreeting() // Setup the greeting message
    }
    
    private func setupViews() {
        // Greeting Label
        greetingLabel.text = "Hello, \(userName ?? "User")" // Use the userName property
        greetingLabel.textAlignment = .center
        view.addSubview(greetingLabel)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .lightGray // So you can see the view
        view.addSubview(profileImageView)
        
        takePictureButton.setTitle("Take Picture", for: .normal)
        takePictureButton.addTarget(self, action: #selector(takePictureButtonTapped), for: .touchUpInside)
        view.addSubview(takePictureButton)
        
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        view.addSubview(submitButton)
    }
    
    private func setupConstraints() {
            greetingLabel.translatesAutoresizingMaskIntoConstraints = false
            profileImageView.translatesAutoresizingMaskIntoConstraints = false
            takePictureButton.translatesAutoresizingMaskIntoConstraints = false
            submitButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // Constraints for greetingLabel
                greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                greetingLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                
                // Constraints for profileImageView
                profileImageView.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
                profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor), // To make it a square
                
                // Constraints for takePictureButton
                takePictureButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
                takePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                takePictureButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                takePictureButton.heightAnchor.constraint(equalToConstant: 50),
                
                // Constraints for submitButton
                submitButton.topAnchor.constraint(equalTo: takePictureButton.bottomAnchor, constant: 20),
                submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                submitButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                submitButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    
    private func setupGreeting() {
            if let name = userName {
                greetingLabel.text = "Hello, \(name)"
            } else {
                greetingLabel.text = "Hello, User"
            }
        }
    
    @objc private func takePictureButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Select Photo", message: "Choose a source", preferredStyle: .actionSheet)
        
        // Check if device has a camera
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                imagePickerController.sourceType = .camera
                self?.present(imagePickerController, animated: true)
            }))
        }
        
        // Add Photo Library option
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            imagePickerController.sourceType = .photoLibrary
            self?.present(imagePickerController, animated: true)
        }))
        
        // Add Cancel option
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present the action sheet
        present(actionSheet, animated: true)
    }

    
    @objc private func submitButtonTapped() {
            guard let image = profileImageView.image,
                  let imageData = image.jpegData(compressionQuality: 0.9) else { return }
            
            // Assuming 'APIService' is a class that handles network communication
            APIService.uploadFace(imageData) { success in
                DispatchQueue.main.async {
                    if success {
                        // Handle successful upload
                        self.showAlert(title: "Success", message: "Thank you for participating!")
                    } else {
                        // Handle failure
                        self.showAlert(title: "Error", message: "Failed to upload photo.")
                    }
                }
            }
        }

    
    private func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let takenImage = info[.originalImage] as? UIImage {
            profileImageView.image = takenImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

