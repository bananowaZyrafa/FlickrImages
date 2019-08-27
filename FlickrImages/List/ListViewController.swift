import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {
    private let viewModel: ListViewModelType
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
        tableView.delegate = self
        tableView.dataSource = self
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

    var didSelectFlickrItem: (FlickrItem) -> Void = { _ in }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        viewModel.loadDefaultList()
        bindViewModel()
    }

    init(viewModel: ListViewModelType) {
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
        definesPresentationContext = true
    }

    private func bindViewModel() {
        viewModel.state.asDriver()
            .drive(onNext: { [weak self] state in
                self?.render(with: state)
            })
            .disposed(by: disposeBag)

        rightBarButtonItem
            .rx
            .tap
            .flatMap { _ -> Observable<ListViewModel.ItemsModifyState> in
                return .just(ListViewModel.ItemsModifyState.orderedByDatePublished)
            }
            .bind(to: viewModel.modifyItemsObservable)
            .disposed(by: disposeBag)

        searchController
            .searchBar
            .rx
            .cancelButtonClicked
            .flatMap { _ -> Observable<ListViewModel.ItemsModifyState> in
                return .just(ListViewModel.ItemsModifyState.filteredByTag(""))
            }
            .bind(to: viewModel.modifyItemsObservable)
            .disposed(by: disposeBag)

        searchController
            .searchBar
            .rx
            .text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { tag -> Observable<ListViewModel.ItemsModifyState> in
                var searchTag = ""
                searchTag = tag ?? ""
                return .just(ListViewModel.ItemsModifyState.filteredByTag(searchTag))
            }
            .bind(to: viewModel.modifyItemsObservable)
            .disposed(by: disposeBag)
    }

    private func render(with state: ListViewModel.State) {
        switch state {
        case .present(let items):
            print("all tags: \(items.map {$0.tags})")
            tableView.reloadData()
        case .loading:
            print("Loading")
        case .failed(let error):
            print("error: \(error)")
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.flickrItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListImageCell.reuseIdentifier, for: indexPath) as? ListImageCell else { fatalError() }
        cell.configure(with: viewModel.flickrItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectFlickrItem(viewModel.flickrItems[indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
extension ListViewController: UITableViewDataSource {

}
