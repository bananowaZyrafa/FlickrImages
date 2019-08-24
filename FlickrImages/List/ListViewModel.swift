import RxSwift
import RxCocoa

protocol ListViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

final class ListViewModel: ListViewModelType {
    struct Input {
        let ready: Driver<Void>
    }

    struct Output {
        let flickrItems: Driver<[FlickrItem]>
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
            self.dependencies
                .networking
                .fetchDefaultList()
                .asDriver(onErrorJustReturn: [])
        }
        return Output(flickrItems: items)
    }
}
