# Contract

[![CI Status](http://img.shields.io/travis/hyperoslo/Contract.svg?style=flat)](https://travis-ci.org/hyperoslo/Contract)
[![Version](https://img.shields.io/cocoapods/v/Contract.svg?style=flat)](http://cocoadocs.org/docsets/Contract)
[![License](https://img.shields.io/cocoapods/l/Contract.svg?style=flat)](http://cocoadocs.org/docsets/Contract)
[![Platform](https://img.shields.io/cocoapods/p/Contract.svg?style=flat)](http://cocoadocs.org/docsets/Contract)

## Usage

```objc
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, HYPContractViewControllerDelegate {

    var window: UIWindow?
    var contractController: HYPContractViewController?

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)

        contractController = HYPContractViewController(
            contractURL: "http://ga.berkeley.edu/wp-content/uploads/2015/02/pdf-sample.pdf",
            firstPartyName: "CEO",
            secondPartyName: "Michael Minion",
            needsSignature: true)
        contractController?.delegate = self
        window?.rootViewController = UINavigationController(rootViewController: contractController!)
        window?.makeKeyAndVisible()

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
