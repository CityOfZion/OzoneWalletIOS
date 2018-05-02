//
//  UIImage.swift
//  O3
//
//  Created by Andrei Terentiev on 9/21/17.
//  Copyright © 2017 drei. All rights reserved.
//

import UIKit
extension UIImage {
    convenience init(qrData: String, width: CGFloat, height: CGFloat) {
        let filterQR = CIFilter(name: "CIQRCodeGenerator", withInputParameters: ["inputMessage": qrData.data(using: .utf8) ?? Data(), "inputCorrectionLevel": "L"])
        guard let ciImageQR = filterQR?.outputImage else {
            self.init()
            return
        }

        let scaleX = width / ciImageQR.extent.size.width
        let scaleY = height / ciImageQR.extent.size.height
        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)

        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), true, UIScreen.main.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        UIGraphicsPushContext(context)
        let qrImage = UIImage(ciImage: ciImageQR.transformed(by: transform))
        qrImage.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        let qrLogo = UIImage(named: "qrLogo")
        let x = (width - (width * 0.25)) * 0.5
        let y = (height - (height * 0.25)) * 0.5
        qrLogo?.draw(in: CGRect(x: x, y: y, width: width * 0.25, height: height * 0.25))
        UIGraphicsPopContext()
        let outputImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: outputImage.cgImage!)
    }

    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, UIScreen.main.scale)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }

    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
