import UIKit
import Foundation

extension UIView {
    func pinToSuperview() {
        guard let superview = superview else { fatalError() }
        precondition(!translatesAutoresizingMaskIntoConstraints)

        superview.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        superview.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        superview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        superview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    func pin(to layoutGuide: UILayoutGuide) {
        guard superview != nil else { fatalError() }
        precondition(!translatesAutoresizingMaskIntoConstraints)

        layoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        layoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        layoutGuide.topAnchor.constraint(equalTo: topAnchor).isActive = true
        layoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
