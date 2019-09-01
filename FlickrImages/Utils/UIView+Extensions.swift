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
}
