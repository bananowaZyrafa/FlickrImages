import Foundation
import UIKit
import RxCocoa

class MenuView: UIView {
    public var itemsOrderByDateTakenButtonTapped: ControlEvent<Void> {
        return itemsOrderByDateTakenButton.rx.tap
    }

    public var itemsOrderByDatePublishedButtonTapped: ControlEvent<Void> {
        return itemsOrderByDatePublishedButton.rx.tap
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Order Flickr images by:"
        label.textAlignment = .center
        return label
    }()

    private lazy var itemsOrderByDateTakenButton: UIButton = {
        let button = UIButton()
        button.setTitle("Date taken", for: .normal)
        button.backgroundColor = UIColor(red: 65.0/255.0, green: 146.0/255.0, blue: 248.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 5.0
        return button
    }()

    private lazy var itemsOrderByDatePublishedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Date published", for: .normal)
        button.backgroundColor = UIColor(red: 66.0/255.0, green: 147.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 5.0
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(itemsOrderByDateTakenButton)
        stackView.addArrangedSubview(itemsOrderByDatePublishedButton)
        stackView.distribution = UIStackView.Distribution.fillProportionally
        stackView.spacing = 2.0
        return stackView
    }()

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        setup()
    }

    private func setup() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor, constant: -20.0),
            stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }

}
