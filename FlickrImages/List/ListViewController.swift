import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

    private let viewModel: ListViewModel
    private let disposeBag = DisposeBag()

    private lazy var rightBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.estimatedRowHeight = 130
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(ListImageCell.self, forCellReuseIdentifier: ListImageCell.reuseIdentifier)
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
        view.addSubview(tableView)
        viewModel.fetchList()
        bindViewModel()
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
        navigationItem.rightBarButtonItem = rightBarButtonItem
//        definesPresentationContext = true

    }

    private func bindViewModel() {
        let tableViewSelected = tableView
            .rx
            .itemSelected
            .asDriver()

        let input = ListViewModel.Input(ready: rx.viewWillAppear.asDriver(), selectedIndex: tableViewSelected, sortByDate: rightBarButtonItem.rx.tap.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input: input)

        output
            .items
            .drive(tableView
                .rx
                .items(cellIdentifier: ListImageCell.reuseIdentifier, cellType: ListImageCell.self)) {
                (row, element, cell) in
                cell.configure(with: element)
            }
            .disposed(by: disposeBag)

        output
            .selectedItem
            .drive(onNext: { [weak self] (indexPath) in
                self?.tableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)



    }

}

