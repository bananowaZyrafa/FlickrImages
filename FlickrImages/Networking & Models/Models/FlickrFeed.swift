import Foundation

struct FlickrFeed {
    let title: String
    let link: String
    let description: String
    let modified: String
    let generator: String
    let items: [FlickrItem]

    static let emptyFlickrFeed = FlickrFeed(title: "", link: "", description: "", modified: "", generator: "", items: [])
}

extension FlickrFeed: Decodable {
    init(with decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let link = try container.decode(String.self, forKey: .link)
        let description = try container.decode(String.self, forKey: .description)
        let modified = try container.decode(String.self, forKey: .modified)
        let generator = try container.decode(String.self, forKey: .generator)
        var itemsContainer = try container.nestedUnkeyedContainer(forKey: .items)
        var items: [FlickrItem] = []
        while !itemsContainer.isAtEnd {
            let nestedFlickrItems = try itemsContainer.decode([FlickrItem].self)
            items.append(contentsOf: nestedFlickrItems)
        }
        self.init(title: title, link: link, description: description, modified: modified, generator: generator, items: items)
    }
}
