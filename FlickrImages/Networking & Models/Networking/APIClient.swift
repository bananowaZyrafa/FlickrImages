import Foundation
import RxSwift

protocol APIClientType {
    func fetchDefaultList() -> Single<[FlickrItem]>
}

final class APIClient: APIClientType {

    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    private struct EndpointURL {
        static let baseURL = URL(string: "https://www.flickr.com/services/feeds/photos_public.gne")!
    }

    private enum APIError: Error {
        case invalidURL
        case invalidResponseType
        case JSONSerializationError
        case invalidDataReceived

        var localizedDescription: String {
            switch self {
            case .invalidURL:
                return "Invalid URL address error occured."
            case .invalidResponseType:
                return "Invalid response type error occured."
            case .JSONSerializationError:
                return "JSON serialization error occured."
            case .invalidDataReceived:
                return "Invalid data received from the served."
            }
        }
    }

    func fetchDefaultList() -> Single<[FlickrItem]> {
        return fetchData(from: EndpointURL.baseURL, withParams: ["nojsoncallback": "1",
                                                           "format": "json"])
            .flatMap{ [weak self] data -> Single<FlickrFeed> in
                return self?.parseObservable(data: data) ?? Single.just(FlickrFeed.emptyFlickrFeed)
            }
            .map{$0.items}
    }

    private func fetchData(from url: URL, withParams params: [String: String] = [:]) -> Single<Data> {
        return Single.create { [unowned self] single in
            let queryItems = params.map { parameter in
                URLQueryItem(name: parameter.key, value: parameter.value)
            }
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                single(.error(APIError.invalidURL))
                return Disposables.create()
            }
            if queryItems.count > 0 {
                urlComponents.queryItems = queryItems
            }
            guard let urlWithQueryItems = urlComponents.url else {
                single(.error(APIError.invalidURL))
                return Disposables.create()
            }
            let request = URLRequest(url: urlWithQueryItems)

            let task = self.urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    let error = APIError.invalidResponseType
                    single(.error(error))
                    return
                }
                guard let data = data else {
                    let error = APIError.invalidDataReceived
                    single(.error(error))
                    return
                }
                single(.success(data))
            })
            task.resume()
            return Disposables.create {
                if task.response == nil {
                    task.cancel()
                }
            }
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

