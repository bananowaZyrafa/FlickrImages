import RxSwift
import RxCocoa

protocol ListViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

final class ListViewModel: ListViewModelType {
    private let fetchedItems: BehaviorRelay<[FlickrItem]> = BehaviorRelay(value: [])

    private let disposeBag = DisposeBag()
    struct Input {
        let ready: Driver<Void>
        let selectedIndex: Driver<IndexPath>
        let sortByDate: Driver<Void>
    }

    struct Output {
        let items: Driver<[FlickrItem]>
        let selectedItem: Driver<IndexPath>
    }

    struct Dependencies {
        let networking: APIClientType
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: Input) -> Output {

        let items = input.ready.flatMap { _ in
            self.fetchedItems.asDriver(onErrorJustReturn: [])
        }

        let sortedItems = input.sortByDate.flatMap{
            self.fetchedItems.map { (items) in
                return items.sorted(by: { (item1, item2) -> Bool in
                    item1.dateTaken > item2.dateTaken
                })
                }.asDriver(onErrorJustReturn: [])
        }
        
        let merged = Driver.merge(items,sortedItems).asObservable().asDriver(onErrorJustReturn: [])

        let selectedIndex = input.selectedIndex
        return Output(items: merged, selectedItem: selectedIndex)
    }

    func fetchList() {
        dependencies.networking.fetchDefaultList().subscribe(onSuccess: { [weak self] (items) in
            self?.fetchedItems.accept(items)
        }) { (error) in
            print("error: \(error)")
        }.disposed(by: disposeBag)
    }
}
