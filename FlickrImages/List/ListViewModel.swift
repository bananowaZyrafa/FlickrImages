import RxSwift
import RxCocoa

protocol ListViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

final class ListViewModel: ListViewModelType {
    struct Input {
    }

    struct Output {
    }

    struct Dependencies {
        let networking: APIClientType
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func transform(input: Input) -> Output {

        return Output()
    }
}
