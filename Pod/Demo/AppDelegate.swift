import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, HYPContractViewControllerDelegate {

  var window: UIWindow?

  func application(
    application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      window = UIWindow(frame: UIScreen.mainScreen().bounds)

      if let window = self.window {
        let contractController = HYPContractViewController(
          contractURL: "http://ga.berkeley.edu/wp-content/uploads/2015/02/pdf-sample.pdf",
          firstPartyName: "CEO",
          secondPartyName: "Michael Minion",
          needsSignature: true)
        contractController.delegate = self

        window.rootViewController = UINavigationController(rootViewController: contractController)
        window.makeKeyAndVisible()
      }

      return true
  }

  func contractControllerDidFinish(
    contractController: HYPContractViewController!,
    withFirstPartySignature firstPartySignature: UIImage!,
    andSecondPartySignature secondPartySignature: UIImage!) {
      println("finished")
  }

  func contractControllerDidDismiss(contractController: HYPContractViewController!) {
    println("dismiss")
  }
}
