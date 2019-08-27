import RxSwift
import RxCocoa

protocol ListViewModelType {
    var state: BehaviorRelay<ListViewModel.State> { get }
    var flickrItems: [FlickrItem] { get }
    var modifyItemsObservable: BehaviorRelay<ListViewModel.ItemsModifyState> { get }
    func loadDefaultList()
}

final class ListViewModel: ListViewModelType {
    private let disposeBag = DisposeBag()

    let modifyItemsObservable: BehaviorRelay<ListViewModel.ItemsModifyState> = BehaviorRelay(value: .filteredByTag(""))
    let state: BehaviorRelay<State> = BehaviorRelay(value: .present([]))

    enum State {
        case loading
        case present([FlickrItem])
        case failed(Error)
    }

    enum ItemsModifyState {
        case filteredByTag(String)
        case orderedByDateTaken
        case orderedByDatePublished
    }

    var flickrItems: [FlickrItem] {
        guard case let .present(items) = state.value else {
            return []
        }
        return items
    }

    private var originalFlickrItems: [FlickrItem] = []

    struct Dependencies {
        let networking: APIClientType
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        prepareModificationObservable()
    }

    func loadDefaultList() {
        state.accept(.loading)
        dependencies.networking.fetchDefaultList()
            .subscribe { [weak self] event in
                self?.updateState(with: event)
            }
            .disposed(by: disposeBag)
    }

    private func prepareModificationObservable() {
        modifyItemsObservable.subscribe(onNext: {[weak self] itemsModificationState in
            guard let safeSelf = self else { return }
            switch itemsModificationState {
            case .filteredByTag(let tag):
                safeSelf.state.accept(.present(safeSelf.itemsFiltered(by: tag)))
            case .orderedByDatePublished:
                safeSelf.state.accept(.present(safeSelf.itemsOrderedByDatePublished()))
            case .orderedByDateTaken:
                safeSelf.state.accept(.present(safeSelf.itemsOrderByDateTaken()))
            }
        }).disposed(by: disposeBag)
    }

    private func itemsOrderByDateTaken() -> [FlickrItem] {
        return flickrItems.sorted {
            $0.dateTaken > $1.dateTaken
        }
    }

    private func itemsOrderedByDatePublished() -> [FlickrItem] {
        return flickrItems.sorted {
            $0.publishedDate > $1.publishedDate
        }
    }

    private func itemsFiltered(by tag: String) -> [FlickrItem] {
        guard tag != "" else { return originalFlickrItems }
        return flickrItems.filter {
            $0.tags.contains(tag.lowercased())
        }
    }

    private func updateState(with event: SingleEvent<[FlickrItem]>) {
        switch event {
        case .success(let items):
            originalFlickrItems = items
            state.accept(.present(items))
        case .error(let error):
            state.accept(.failed(error))
        }
    }
}
