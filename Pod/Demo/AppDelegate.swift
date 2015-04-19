import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

//        let viewController = HYPContractViewController(
//            contractURL: "http://ga.berkeley.edu/wp-content/uploads/2015/02/pdf-sample.pdf",
//            firstPartyName: "CEO",
//            secondPartyName: "Michael Minion",
//            needsSignature: true)

        let viewController = ViewController()
        self.window?.rootViewController = UINavigationController(rootViewController: viewController)
        self.window?.makeKeyAndVisible()

        return true
    }
}

