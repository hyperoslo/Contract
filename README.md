![Contract](https://raw.githubusercontent.com/hyperoslo/Contract/master/Assets/cover.png)

Apps that require signatures in a contract, behold!

No more crazyness, `Contract` makes signing your soul away much easier.

## Usage

```swift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, HYPContractViewControllerDelegate {

  var window: UIWindow?

  func application(
    application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
      window = UIWindow(frame: UIScreen.mainScreen().bounds)

      let contractController = HYPContractViewController(
        contractURL: "http://ga.berkeley.edu/wp-content/uploads/2015/02/pdf-sample.pdf",
        firstPartyName: "CEO",
        secondPartyName: "Michael Minion",
        needsSignature: true)

      contractController.delegate = self

      if let window = self.window {
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
```

## How it looks

![Demo](https://raw.githubusercontent.com/hyperoslo/Contract/master/Assets/demo.png)

## Installation

**Contract** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Contract'
```

## Author

Hyper Interaktiv AS, ios@hyper.no

## License

**Contract** is available under the MIT license. See the LICENSE file for more info.
