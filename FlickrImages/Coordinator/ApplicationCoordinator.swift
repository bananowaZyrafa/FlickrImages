import Foundation
import UIKit
import RxSwift

protocol Coordinator: class {
    var rootViewController: UIViewController { get }
}

class ApplicationCoordinator: Coordinator {
    private let disposeBag = DisposeBag()

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
        listViewController.view.backgroundColor = .white

        navigationController.viewControllers = [listViewController]
        self.navigationController = navigationController

//        dependencies.apiClient.fetchDefaultList().subscribe(onSuccess: { (items) in
//            print("items: \(items)")
//        }) { (error) in
//            print("error: \(error)")
//        }.disposed(by: disposeBag)
    }


    private func presentDetails() {
        let detailsViewController = DetailsViewController()
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
