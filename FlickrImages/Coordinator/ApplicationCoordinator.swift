import Foundation
import UIKit

protocol Coordinator: class {
    var rootViewController: UIViewController { get }
}

class ApplicationCoordinator: Coordinator {

    private let dependencies: Dependencies
    var rootViewController: UIViewController {
        return navigationController
    }
    private let navigationController: UINavigationController

    struct Dependencies {
        let apiClient: APIClientType
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        let navigationController = UINavigationController()
        let listViewModel = ListViewModel(dependencies: ListViewModel.Dependencies(networking: dependencies.apiClient))
        let listViewController = ListViewController(viewModel: listViewModel)

        navigationController.viewControllers = [listViewController]
        self.navigationController = navigationController
    }


    private func presentDetails() {
        let detailsViewController = DetailsViewController()
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
