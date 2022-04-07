import UIKit
import MessageUI

class SendMailController: MFMailComposeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func sendEmail(recipient: String) {
        let subject = "Test Navigation Schema go!dev"
        let body = "Some email body or Lorem Ipsum"

        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()

            mail.mailComposeDelegate = self
            mail.setCcRecipients([recipient])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)

            present(mail, animated: true)
        }
    }
}

extension SendMailController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("cancelled")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        case .failed:
            print("failed")
        @unknown default:
            print("deafult")
        }
    }
}
