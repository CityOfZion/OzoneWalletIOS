//
//  AssetInputToolbar.swift
//  O3
//
//  Created by Apisit Toompakdee on 4/17/18.
//  Copyright © 2018 drei. All rights reserved.
//

import UIKit

protocol AssetInputToolbarDelegate {
    func percentAmountTapped(value: Decimal)
    func maxAmountTapped(value: Decimal)
}

class AssetInputToolbar: UIView {
    var view: UIView! {
        didSet {
            view.theme_backgroundColor = O3Theme.backgroundColorPicker
        }
    }

    @IBOutlet var assetLabel: UILabel?
    @IBOutlet var assetBalance: UILabel?
    @IBOutlet var messageLabel: UILabel?
    var delegate: AssetInputToolbarDelegate?

    var asset: TransferableAsset? {
        didSet {
            if asset == nil {
                return
            }
            assetLabel?.text = String(format: "%@ BALANCE", asset!.symbol)
            assetBalance?.text = asset!.formattedBalanceString

            DispatchQueue.main.async {
                self.view.theme_backgroundColor = O3Theme.backgroundColorPicker
                self.assetLabel?.theme_textColor = O3Theme.titleColorPicker
                self.assetBalance?.theme_textColor = O3Theme.titleColorPicker
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    func setup() {
        xibSetup()
        DispatchQueue.main.async {
            self.view.theme_backgroundColor = O3Theme.backgroundColorPicker
            self.assetLabel?.theme_textColor = O3Theme.titleColorPicker
            self.assetBalance?.theme_textColor = O3Theme.titleColorPicker
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    //mark: -
    @IBAction func percentTapped(_ sender: UIButton) {
        let percent = Double(sender.tag)
        let value = NSDecimalNumber(decimal: self.asset!.balance).doubleValue * (percent / 100.0)
        self.delegate?.percentAmountTapped(value: NSDecimalNumber(value: value) as Decimal)
    }

    @IBAction func maxTapped(_ sender: Any) {
        self.delegate?.maxAmountTapped(value: self.asset!.balance)
    }
}

private extension AssetInputToolbar {

    func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Adding custom subview on top of our view
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
}

extension UIView {
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return UIView()
        }
        return view
    }
}
