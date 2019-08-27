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
        let listViewModel = ListViewModel(dependencies: ListViewModel.Dependencies(networking: dependencies.apiClient))
        let listViewController = ListViewController(viewModel: listViewModel)
        listViewController.view.backgroundColor = .white

        navigationController.viewControllers = [listViewController]
        self.navigationController = navigationController

        presentDetails.subscribe(onNext: { (flickrItem) in
            guard let item = flickrItem else { return }
            self.presentDetails(of: item)
        }).disposed(by: disposeBag)

        listViewModel.presentItem.asObservable().bind(to: presentDetails).disposed(by: disposeBag)
    }


    private func presentDetails(of item: FlickrItem) {
        let detailsViewController = DetailsViewController()
        navigationController.pushViewController(detailsViewController, animated: true)
    }
}
