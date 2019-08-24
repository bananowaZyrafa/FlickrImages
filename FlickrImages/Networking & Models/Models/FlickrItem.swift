import Foundation

struct FlickrItem: Decodable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: Date
    let description: String
    let publishedDate: Date
    let author: String
    let authorID: String
    let tags: String

    struct Media: Codable {
        private let urlString: String
        public var imageURL: URL? {
            return URL(string: urlString)
        }

        enum CodingKeys: String, CodingKey {
            case urlString = "m"
        }
    }

    enum CodingKeys: String, CodingKey {
        case title
        case link
        case media
        case dateTaken = "date_taken"
        case description
        case publishedDate = "published"
        case author
        case authorID = "author_id"
        case tags
    }
}
