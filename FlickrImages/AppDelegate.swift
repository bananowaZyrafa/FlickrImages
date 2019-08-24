import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: ApplicationCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        guard let window = window else { fatalError("No window set") }
        appCoordinator = ApplicationCoordinator(dependencies: ApplicationCoordinator.Dependencies(apiClient: APIClient()))
        window.rootViewController = appCoordinator?.rootViewController
        window.makeKeyAndVisible()
        return true
    }
}
