import SwiftUI

struct MainViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let mainVC = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainVC)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // Leave this empty if your view controller doesn't need to update in response to SwiftUI
    }
}

