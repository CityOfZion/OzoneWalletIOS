//
//  OzoneAlert.swift
//  O3
//
//  Created by Andrei Terentiev on 9/26/17.
//  Copyright © 2017 drei. All rights reserved.
//
import UIKit

class OzoneAlert {

    static func confirmDialog(_ title: String = "", message: String,
                              cancelTitle: String, confirmTitle: String,
                              didCancel: @escaping () -> Void, didConfirm:@escaping () -> Void) {

        let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
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

        let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)

        let dismissAction = UIAlertAction(title: dismissTitle, style: .cancel) { _ in
            didDismiss()
        }

        alertController.addAction(dismissAction)

        UIApplication.shared.keyWindow?.rootViewController?.presentFromEmbedded(alertController, animated: true, completion: nil)
    }
}
