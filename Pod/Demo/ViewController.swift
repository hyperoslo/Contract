import Foundation

class ViewController: HYPContractViewController, HYPContractViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        super.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let signButton = UIBarButtonItem(
            title: "Sign",
            style: .Done,
            target: self,
            action: "sign")
        self.toolbarItems = [signButton]
    }

    func sign(){
        self.presentSignatureControl()
    }

    func contractControllerDidSign(
        contractController: HYPContractViewController!,
        firstPartySignature: UIImage!,
        andSecondPartySignature secondPartySignature: UIImage!) {
            println("finished")
    }
}
