import UIKit

class CustomFunc {
    static func customAlert(title: String, message: String, theVc: UIViewController, actionHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            actionHandler?()
        }
        alertController.addAction(okAction)
        theVc.present(alertController, animated: true, completion: nil)
    }
}
