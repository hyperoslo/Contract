import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      window = UIWindow(frame: UIScreen.mainScreen().bounds)

      if let window = self.window {
        let requestURL = NSURL(string: "http://ga.berkeley.edu/wp-content/uploads/2015/02/pdf-sample.pdf")
        let request = NSURLRequest(URL: requestURL!)

        let contractController = ViewController(
          URLRequest: request,
          firstPartyName: "CEO",
          secondPartyName: "Michael Minion",
          needsSignature: true)

        let navigationController = UINavigationController(rootViewController: contractController)
        navigationController.toolbarHidden = false

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
      }

      return true
  }
}
