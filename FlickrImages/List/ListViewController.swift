import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

    private let viewModel: ListViewModel
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 120
        return tableView
    }()
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Filter images by tag"
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = nil
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        navigationItem.titleView = searchController.searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
//        definesPresentationContext = true

    }

}

