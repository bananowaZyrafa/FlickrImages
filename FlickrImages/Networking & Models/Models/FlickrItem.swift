import Foundation

struct FlickrItem: Decodable {
    let title: String
    let link: String
    let media: Media
    let dateTaken: String
    let description: String
    let publishedDate: String
    let author: String
    let authorID: String
    let tags: String

    struct Media: Codable {
        let m: String
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

