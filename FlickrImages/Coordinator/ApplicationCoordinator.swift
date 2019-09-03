import Foundation
import UIKit
import RxSwift
import RxCocoa

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

    private let presentDetails: PublishSubject<FlickrItem?> = PublishSubject()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies

        let navigationController = UINavigationController()
        let listViewModel = ListViewModel(ListViewModel.Dependencies(networking: dependencies.apiClient))
        let listViewController = ListViewController(viewModel: listViewModel)

        navigationController.viewControllers = [listViewController]
        self.navigationController = navigationController

        listViewController.view.backgroundColor = .white
        listViewController.didSelectFlickrItem = { [unowned self] flickrItem in
            self.presentDetails(of: flickrItem)
        }
    }

    private func presentDetails(of item: FlickrItem) {
        let detailsViewController = DetailsViewController(flickrItem: item)
        detailsViewController.view.backgroundColor = .white
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
