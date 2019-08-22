import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    let apiClient = APIClient(urlSession: .shared)
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient.fetchDefaultList()
            .subscribe(onSuccess: { (flickrItems) in
            print("flickr items")
        }) { (error) in
            print("error: \(error)")
        }.disposed(by: disposeBag)
    }


}

