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

    func setupNavBar() {
        DispatchQueue.main.async {
            UIApplication.shared.statusBarStyle = UserDefaultsManager.theme.statusBarStyle
            self.setNeedsStatusBarAppearanceUpdate()
            self.navigationController?.hideHairline()
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
            self.navigationController?.navigationBar.barTintColor = UserDefaultsManager.theme.backgroundColor

            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.backgroundColor = UserDefaultsManager.theme.backgroundColor
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UserDefaultsManager.theme.titleTextColor,
                                                                                 NSAttributedStringKey.font:
                                                                                    O3Theme.largeTitleFont]
        }
    }

    func configureView() {
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UserDefaultsManager.theme.textColor,
            NSAttributedStringKey.font: O3Theme.largeTitleFont as Any]
        self.navigationController?.hideHairline()
        view.backgroundColor = UserDefaultsManager.theme.backgroundColor
        setupNavBar()
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
        let saveQR = UIAlertAction(title: "Save QR Code Image", style: .default) { _ in
            self.saveQRCodeImage()
        }
        alert.addAction(saveQR)
        let copyAddress = UIAlertAction(title: "Copy Address", style: .default) { _ in
            UIPasteboard.general.string = Authenticated.account?.address
            //maybe need some Toast style to notify that it's copied
        }
        alert.addAction(copyAddress)
        let share = UIAlertAction(title: "Share", style: .default) { _ in
            self.share()
        }
        alert.addAction(share)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in

        }
        alert.addAction(cancel)
        alert.popoverPresentationController?.sourceView = addressLabel
        present(alert, animated: true, completion: nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            //change it to Toast style.
            let alert = UIAlertController(title: "Saved!", message: "Image saved successfully", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(showActionSheet))
        self.view.addGestureRecognizer(tap)
    }

    @IBAction func tappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
