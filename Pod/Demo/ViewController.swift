import Foundation

class ViewController: HYPContractViewController, HYPContractViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        super.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        updateButton(false)
    }

    func contractControllerDidSign(
        contractController: HYPContractViewController!,
        firstPartySignature: UIImage!,
        andSecondPartySignature secondPartySignature: UIImage!) {
            println("finished")
    }

    func contractController(
        contractController: HYPContractViewController!,
        didToogleSignatureControl shown: Bool) {
            updateButton(shown)
    }

    func updateButton(wasSigned: Bool) {
        let title = (wasSigned) ? "Hide control" : "Show control"
        let signButton = UIBarButtonItem(
            title: title,
            style: .Done,
            target: self,
            action: "toogleSignatureControl")
        toolbarItems = [signButton]
    }
}
