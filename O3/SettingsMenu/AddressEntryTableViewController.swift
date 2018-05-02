//
//  AddressEntryTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/27/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import NeoSwift

protocol AddressAddDelegate: class {
    func addressAdded(_ address: String, nickName: String)
}

class AddressEntryTableViewController: UITableViewController, AVCaptureMetadataOutputObjectsDelegate {
    var qrView: UIView!
    @IBOutlet weak var addressTextView: O3TextView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nicknameField: UITextField!
    weak var delegate: AddressAddDelegate?
    @IBOutlet var proceedButton: ShadowedButton!

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!

    @IBOutlet weak var addressInfoCell: UITableViewCell!
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    let supportedCodeTypes = [
        AVMetadataObject.ObjectType.qr]

    @IBAction func addButtonTapped(_ sender: Any) {
        //validate address here
        let address = addressTextView.text.trim()
        if !NEOValidator.validateNEOAddress(address) {
            DispatchQueue.main.async {
                OzoneAlert.alertDialog(message: SettingsStrings.invalidAddressError, dismissTitle: OzoneAlert.okPositiveConfirmString, didDismiss: {
                    self.addressTextView.becomeFirstResponder()
                })
            }
        } else {
            DispatchQueue.main.async {
                self.delegate?.addressAdded(self.addressTextView.text.trim(), nickName: self.nicknameField.text?.trim() ?? "")
                DispatchQueue.main.async { self.dismiss(animated: true) }
            }
        }
    }

    @IBAction func dissmissTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }

    func setThemedElements() {
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker
        addressInfoCell.contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        addressInfoCell.theme_backgroundColor = O3Theme.backgroundColorPicker
        addressLabel.theme_textColor = O3Theme.titleColorPicker
        nicknameLabel.theme_textColor = O3Theme.titleColorPicker
        nicknameField.theme_backgroundColor = O3Theme.textFieldBackgroundColorPicker
        nicknameField.theme_textColor = O3Theme.textFieldTextColorPicker
        nicknameField.theme_keyboardAppearance = O3Theme.keyboardPicker
        addressTextView.theme_backgroundColor = O3Theme.textFieldBackgroundColorPicker
        addressTextView.theme_textColor = O3Theme.textFieldTextColorPicker
        addressTextView.theme_keyboardAppearance = O3Theme.keyboardPicker
        applyNavBarTheme()
    }

    override func viewDidLoad() {
        setThemedElements()
        setLocalizedStrings()
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        addressTextView.delegate = self
        self.checkCanProceed()
        let qrView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.5))
        tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.5)
        tableView.tableHeaderView?.embed(qrView)
        tableView.tableHeaderView?.bringSubview(toFront: closeButton)
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)

        #if (arch(i386) || arch(x86_64)) && os(iOS)
            return
        #endif
        if captureDevice == nil {
            return
        }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)

            captureSession = AVCaptureSession()
            captureSession.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = qrView.layer.bounds
            qrView.layer.insertSublayer(videoPreviewLayer!, at: 0)

            captureSession!.startRunning()
        } catch {
            return
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            return
        }

        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {
            return
        }

        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)

            if let dataString = metadataObj.stringValue {
                DispatchQueue.main.async { self.addressTextView.text = dataString }
            }
        }
    }

    @IBAction func checkCanProceed() {
        var enabled = false
        let validNickname = nicknameField.text?.trim().isEmpty == false
        let address = addressTextView.text?.trim().isEmpty == false
        enabled = validNickname && address
        proceedButton.isEnabled = enabled
    }

    func setLocalizedStrings() {
        addressLabel.text = SettingsStrings.addressLabel
        nicknameField.text = SettingsStrings.nicknameLabel
        closeButton.setTitle(SettingsStrings.close, for: UIControlState())
    }
}

extension AddressEntryTableViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        self.checkCanProceed()
    }
}
