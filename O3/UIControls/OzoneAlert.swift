//
//  OzoneAlert.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//
import UIKit

class OzoneAlert {
    static public let okPositiveConfirmString = NSLocalizedString("ALERT_OK", comment: "Positive Response to an alert message, it is a generic positive action replying ok to whatever the prompt is")
    static public let confirmPositiveConfirmString = NSLocalizedString("ALERT_Confirm", comment: "Positive Response to an alert message, it is a positive action stating that they have read the alert and are confirming whatever action they are about to take")
    static public let cancelNegativeConfirmString =
    NSLocalizedString("ALERT_Cancel", comment: "Negative Response to an alert message, it is a negative action stating that they want to cancel whatever their current action is")
    static public let notYetNegativeConfirmString = NSLocalizedString("ALERT_Not_Yet_Negative_Confirm", comment: "Negative Response to an alert message, it is a negative action stating that they have not yet completed what they need to do")
    static public let errorTitle = NSLocalizedString("Error", comment: "A title for error alert prompts")

    static func confirmDialog(_ title: String = "", message: String,
                              cancelTitle: String, confirmTitle: String,
                              didCancel: @escaping () -> Void, didConfirm:@escaping () -> Void) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            didConfirm()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            didCancel()
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        UIApplication.shared.keyWindow?.rootViewController?.presentFromEmbedded(alertController, animated: true, completion: nil)
    }

    static func alertDialog(_ title: String = "", message: String,
                              dismissTitle: String,
                              didDismiss: @escaping () -> Void) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: dismissTitle, style: .cancel) { _ in
            didDismiss()
        }

        alertController.addAction(dismissAction)

        UIApplication.shared.keyWindow?.rootViewController?.presentFromEmbedded(alertController, animated: true, completion: nil)
    }
}
