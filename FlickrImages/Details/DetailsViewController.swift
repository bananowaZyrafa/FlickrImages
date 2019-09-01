import Foundation
import UIKit
import Kingfisher

class DetailsViewController: UIViewController {

    private let flickrItem: FlickrItem

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(
            with: flickrItem.media.imageURL,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .transition(.fade(1)),
                .cacheMemoryOnly
            ])
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = "Title: \(flickrItem.title)"
        return titleLabel
    }()

    private lazy var authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.adjustsFontSizeToFitWidth = true
        authorLabel.numberOfLines = 0
        authorLabel.lineBreakMode = .byWordWrapping
        authorLabel.text = "Author: \(flickrItem.author)"
        return authorLabel
    }()

    private lazy var dateTakenLabel: UILabel = {
        let dateTakenLabel = UILabel()
        dateTakenLabel.adjustsFontSizeToFitWidth = true
        dateTakenLabel.numberOfLines = 0
        dateTakenLabel.lineBreakMode = .byWordWrapping
        dateTakenLabel.text = "Date taken: \(flickrItem.dateTaken)"
        return dateTakenLabel
    }()

    private lazy var datePublishedLabel: UILabel = {
        let datePublishedLabel = UILabel()
        datePublishedLabel.adjustsFontSizeToFitWidth = true
        datePublishedLabel.numberOfLines = 0
        datePublishedLabel.lineBreakMode = .byWordWrapping
        datePublishedLabel.text = "Date published: \(flickrItem.publishedDate)"
        return datePublishedLabel
    }()

    private lazy var tagsLabel: UILabel = {
        let tagsLabel = UILabel()
        tagsLabel.numberOfLines = 0
        tagsLabel.lineBreakMode = .byWordWrapping
        tagsLabel.adjustsFontSizeToFitWidth = true
        tagsLabel.text = "Tags: \(flickrItem.tags)"
        return tagsLabel
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(dateTakenLabel)
        stackView.addArrangedSubview(datePublishedLabel)
        stackView.addArrangedSubview(tagsLabel)
        stackView.distribution =  UIStackView.Distribution.fillProportionally
        stackView.spacing = 10.0
        return stackView
    }()

    init(flickrItem: FlickrItem) {
        self.flickrItem = flickrItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stackView)
        print("PRESENTING FLICKR ITEM: \(flickrItem)")
        setupStackViewPosition()
    }

    private func setupStackViewPosition() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.pin(to: view.layoutMarginsGuide)
    }
}
