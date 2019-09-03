import XCTest
import RxBlocking
import RxCocoa
import RxSwift
import RxTest
@testable import FlickrImages

class FlickrImagesTests: XCTestCase {
    private typealias Dependencies = ListViewModel.Dependencies

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    var validAPIClient: APIClientType!
    var invalidAPIClient: APIClientType!

    var viewModelWithValidAPIClient:  ListViewModelType!
    var viewModelWithInvalidAPIClient: ListViewModelType!

    override func setUp() {
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        validAPIClient = FakeAPIClient(fileName: "ValidTestResponse")
        invalidAPIClient = FakeAPIClient(fileName: "InvalidTestResponse")
        viewModelWithValidAPIClient = ListViewModel(Dependencies(networking: validAPIClient))
        viewModelWithInvalidAPIClient = ListViewModel(Dependencies(networking: invalidAPIClient))
        super.setUp()
    }

    override func tearDown() {
        scheduler = nil
        disposeBag = nil
        validAPIClient = nil
        invalidAPIClient = nil
        viewModelWithInvalidAPIClient = nil
        viewModelWithValidAPIClient = nil
        super.tearDown()
    }

    func testResponseInvalidity() {
        XCTAssertThrowsError(try invalidAPIClient.fetchDefaultList().toBlocking().first())
    }

    func testResponseValidity() {
        XCTAssertNotNil(try validAPIClient.fetchDefaultList().toBlocking().first())
        XCTAssert(try validAPIClient.fetchDefaultList().toBlocking().first()!.count > 0)
    }

    func testViewModelValidity() {
        viewModelWithValidAPIClient.loadDefaultList()
        let actualState = viewModelWithValidAPIClient.state.value

        if case let .present(items) = actualState {
            XCTAssertEqual(actualState, .present([]))
            XCTAssert(items.count > 0)
        } else {
            XCTFail()
        }
    }

    func testViewModelInvalidity() {
        viewModelWithInvalidAPIClient.loadDefaultList()
        let actualState = viewModelWithInvalidAPIClient.state.value
        XCTAssertEqual(actualState, ListViewModel.State.failed(FakeAPIClient.FakeAPIError.JSONSerializationError))
    }

    func testValidViewModelFilterTags() {
        let filterTagsObservable: Driver<String> = .just("test")
        viewModelWithValidAPIClient.loadDefaultList()
        filterTagsObservable
            .flatMap { (tag: String) -> Driver<ListViewModel.ItemsModifyState> in
                return .just(.filteredByTag(tag))
            }
            .drive(viewModelWithValidAPIClient.modifyItemsObservable)
            .disposed(by: disposeBag)

        let flickrItems = viewModelWithValidAPIClient.flickrItems.map{$0.tags}
        print(flickrItems)
        XCTAssert(viewModelWithValidAPIClient.flickrItems.map{$0.tags}.contains("test"))
    }

    func testValidViewModelSortByDateTaken() {
        let sortByDateTakenObservable: Driver<Void> = .just(())
        viewModelWithValidAPIClient.loadDefaultList()
        sortByDateTakenObservable.flatMap { _ -> Driver<ListViewModel.ItemsModifyState> in
            return .just(.orderedByDateTaken)
        }
        .drive(viewModelWithValidAPIClient.modifyItemsObservable)
        .disposed(by: disposeBag)

        let actualState = viewModelWithValidAPIClient.modifyItemsObservable.value

        XCTAssertEqual(actualState, ListViewModel.ItemsModifyState.orderedByDateTaken)
    }

    func testValidViewModelSortByDatePublished() {
        let sortByDatePublishedObservable: Driver<Void> = .just(())
        viewModelWithValidAPIClient.loadDefaultList()
        sortByDatePublishedObservable.flatMap { _ -> Driver<ListViewModel.ItemsModifyState> in
            return .just(.orderedByDatePublished)
            }
            .drive(viewModelWithValidAPIClient.modifyItemsObservable)
            .disposed(by: disposeBag)

        let actualState = viewModelWithValidAPIClient.modifyItemsObservable.value

        XCTAssertEqual(actualState, ListViewModel.ItemsModifyState.orderedByDatePublished)
    }
}
