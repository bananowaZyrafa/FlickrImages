import UIKit
import Foundation
import Kingfisher

class ListImageCell: UITableViewCell {

    override var reuseIdentifier: String? { return "ListImageCell" }

    private let flickrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(flickrImageView)
        flickrImageView.translatesAutoresizingMaskIntoConstraints = false
        let margins = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            flickrImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            flickrImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flickrImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            flickrImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            flickrImageView.topAnchor.constraint(equalTo: margins.topAnchor),
            flickrImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
            ])
    }
    
}
