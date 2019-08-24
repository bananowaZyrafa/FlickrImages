import UIKit
import RxSwift
import RxCocoa

class ListViewController: UIViewController {

    private let viewModel: ListViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

