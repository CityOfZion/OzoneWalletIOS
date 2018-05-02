//
//  MyAddressViewController.swift
//  O3
//
//  Created by Apisit Toompakdee on 9/30/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit

class MyAddressViewController: UIViewController {

    @IBOutlet var qrImageView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var qrCodeContainerView: UIView!
    @IBOutlet weak var addressInfoLabel: UILabel!

    func configureView() {
        applyNavBarTheme()
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        addressLabel.text = Authenticated.account?.address
        qrImageView.image = UIImage.init(qrData: (Authenticated.account?.address)!, width: qrImageView.bounds.size.width, height: qrImageView.bounds.size.height)
    }

    func saveQRCodeImage() {
        let qrWithBranding = UIImage.imageWithView(view: self.qrCodeContainerView)
        UIImageWriteToSavedPhotosAlbum(qrWithBranding, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    func share() {
        let shareURL = URL(string: "https://o3.network/")
        let qrWithBranding = UIImage.imageWithView(view: self.qrCodeContainerView)
        let activityViewController = UIActivityViewController(activityItems: [shareURL, qrWithBranding], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }

    @IBAction func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveQR = UIAlertAction(title: AccountStrings.saveQRAction, style: .default) { _ in
            self.saveQRCodeImage()
        }
        alert.addAction(saveQR)
        let copyAddress = UIAlertAction(title: AccountStrings.copyAddressAction, style: .default) { _ in
            UIPasteboard.general.string = Authenticated.account?.address
            //maybe need some Toast style to notify that it's copied
        }
        alert.addAction(copyAddress)
        let share = UIAlertAction(title: AccountStrings.shareAction, style: .default) { _ in
            self.share()
        }
        alert.addAction(share)

        let cancel = UIAlertAction(title: OzoneAlert.cancelNegativeConfirmString, style: .cancel) { _ in

        }
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = addressLabel
        present(alert, animated: true, completion: nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: OzoneAlert.errorTitle, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: OzoneAlert.okPositiveConfirmString, style: .default))
            present(alert, animated: true)
        } else {
            //change it to Toast style.
            let alert = UIAlertController(title: AccountStrings.saved, message: AccountStrings.savedMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: OzoneAlert.okPositiveConfirmString, style: .default))
            present(alert, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        configureView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        self.view.addGestureRecognizer(tap)
    }

    @IBAction func tappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    func setLocalizedStrings() {
        addressInfoLabel.text = AccountStrings.myAddressInfo
        title = AccountStrings.myAddressTitle
    }
}
