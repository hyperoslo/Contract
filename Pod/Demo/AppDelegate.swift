import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var contractController: HYPContractViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        contractController = HYPContractViewController(
            contractURL: "http://ga.berkeley.edu/wp-content/uploads/2015/02/pdf-sample.pdf",
            firstPartyName: "CEO",
            secondPartyName: "Michael Minion",
            needsSignature: true)
        window?.rootViewController = UINavigationController(rootViewController: contractController!)
        window?.makeKeyAndVisible()

        return true
    }
}


