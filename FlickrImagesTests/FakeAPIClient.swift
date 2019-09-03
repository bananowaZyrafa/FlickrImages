import Foundation
import RxSwift
@testable import FlickrImages

class FakeAPIClient: APIClientType {

    private var fileNameURL: String

    init(fileName: String) {
        fileNameURL = fileName
    }

    public enum FakeAPIError: Error {
        case invalidURL
        case invalidResponseType
        case JSONSerializationError
        case invalidDataReceived
    }

    public func fetchDefaultList() -> Single<[FlickrItem]> {
        return fetchData(from: Bundle(for: FakeAPIClient.self).url(forResource: fileNameURL, withExtension: "json"))
            .flatMap{ [weak self] data -> Single<FlickrFeed> in
                guard let safeSelf = self else {
                    return Single.just(FlickrFeed.emptyFlickrFeed)
                }
                return safeSelf.parseObservable(data: data)
            }.map{$0.items}
    }

    private func fetchData(from fileNameURL: URL?) -> Single<Data> {
        return Single.create { single in
            guard let url = fileNameURL else {
                single(.error(FakeAPIError.invalidURL))
                return Disposables.create()
            }
            do {
                let data = try Data(contentsOf: url)
                single(.success(data))
            } catch {
                single(.error(FakeAPIError.invalidDataReceived))
            }

            return Disposables.create()
        }
    }


    private func parseObservable<T: Decodable>(data: Data) -> Single<T> {
        return Single.create { single in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(.dateFormatter)
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                single(.success(decodedData))
            } catch {
                single(.error(error))
            }
            return Disposables.create()
        }
    }
}
