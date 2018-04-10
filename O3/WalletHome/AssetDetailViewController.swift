//
//  AssetDetailViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/23/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import ScrollableGraphView

class AssetDetailViewController: UIViewController, GraphPanDelegate, ScrollableGraphViewDataSource {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var percentChangeLabel: UILabel!

    @IBOutlet weak var graphContainerView: UIView!
    @IBOutlet weak var fiveMinButton: UIButton!
    @IBOutlet weak var fifteenMinButton: UIButton!
    @IBOutlet weak var thirtyMinButton: UIButton!
    @IBOutlet weak var sixtyMinButton: UIButton!
    @IBOutlet weak var oneDayButton: UIButton!
    @IBOutlet weak var allButton: UIButton!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activatedLine: UIView!
    var activatedLineCenterXAnchor: NSLayoutConstraint?

    var panView: GraphPanView!
    var graphView: ScrollableGraphView!
    var selectedAsset: String!
    var selectedInterval: PriceInterval = .oneDay
    var priceHistory: History?
    var referenceCurrency: Currency = .usd

    func selectedPriceIntervalString() -> String {
        switch selectedInterval {
        case .sixHours:
            return "Past six hours".uppercased()
        case.oneDay:
            return "Past day".uppercased()
        case .oneWeek:
             return "Past week".uppercased()
        case .oneMonth:
            return "Past month".uppercased()
        case .threeMonths:
            return "Past three motnhs".uppercased()
        case .all:
            return ""
        }
    }

    func addThemedElements() {
        applyNavBarTheme()
        let themedTransparentButtons = [fiveMinButton, fifteenMinButton, thirtyMinButton, sixtyMinButton, oneDayButton, allButton]
        view.theme_backgroundColor = O3Theme.backgroundColorPicker

        for button in themedTransparentButtons {
            button?.theme_backgroundColor = O3Theme.backgroundColorPicker
            button?.theme_setTitleColor(O3Theme.primaryColorPicker, forState: UIControlState())
        }
    }

    func setupGraphView() {
        graphView = ScrollableGraphView.ozoneTheme(frame: graphContainerView.bounds, dataSource: self)
        graphContainerView.embed(graphView)

        panView = GraphPanView(frame: graphContainerView.bounds)
        panView.delegate = self
        graphContainerView.embed(panView)
    }

    func loadPriceHistory(asset: String) {
        O3Client.shared.getPriceHistory(asset, interval: selectedInterval.rawValue) {result in
            switch result {
            case .failure:
                print(result)
            case .success(let priceHistory):
                self.priceHistory = priceHistory
                DispatchQueue.main.async {
                    self.showLatestPrice()
                    self.graphView.reload()
                }
            }
        }
    }

    override func viewDidLoad() {
        addThemedElements()
        super.viewDidLoad()
        setupGraphView()
        navigationItem.title = selectedAsset.uppercased()
        loadPriceHistory(asset: selectedAsset)
        activatedLineCenterXAnchor = activatedLine.centerXAnchor.constraint(equalTo: fifteenMinButton.centerXAnchor, constant: 0)
        activatedLineCenterXAnchor?.isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.referenceCurrencyTapped(_:)))
        amountLabel.addGestureRecognizer(tapGesture)
        //TODO: THIS IS A HACK TO GET OVER ANIMATE ON STARTUP
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.graphView.reload() }
    }

    func showLatestPrice() {
        if self.priceHistory == nil || self.priceHistory?.data.count == 0 {
            return
        }
        guard let latestPrice = self.priceHistory?.data.first,
            let earliestPrice = self.priceHistory?.data.last else {
                fatalError("undefined latest price behavior")
        }
        switch referenceCurrency {
        case .btc:
            amountLabel.text = "₿"+latestPrice.averageBTC.string(Precision.btc, removeTrailing: true)
        default:
            amountLabel.text = latestPrice.averageFiatMoney().formattedString()
        }
        percentChangeLabel.text = String.percentChangeString(latestPrice: latestPrice, previousPrice: earliestPrice,
                                                             with: selectedInterval, referenceCurrency: referenceCurrency)
        percentChangeLabel.theme_textColor = latestPrice.averageBTC >= earliestPrice.averageBTC ? O3Theme.positiveGainColorPicker : O3Theme.negativeLossColorPicker
    }

    @objc func referenceCurrencyTapped(_ sender: UITapGestureRecognizer) {
        if referenceCurrency == .btc {
            referenceCurrency = .usd
        } else {
            referenceCurrency = .btc
        }
        DispatchQueue.main.async {
            self.graphView.reload()
            self.showLatestPrice()
        }
    }

    func panEnded() {
        self.showLatestPrice()
    }

    func panDataIndexUpdated(index: Int, timeLabel: UILabel) {
        DispatchQueue.main.async {
            guard let currentValue = self.priceHistory?.data.reversed()[index],
                let originalValue = self.priceHistory?.data.reversed()[0] else {
                    return
            }
            var referenceCurrencyCurrentValue: Double
            var referenceCurrencyOriginalValue: Double
            switch self.referenceCurrency {
            case .btc:
                referenceCurrencyCurrentValue = currentValue.averageBTC
                referenceCurrencyOriginalValue = originalValue.averageBTC
                self.amountLabel.text = String(format: "%@BTC", referenceCurrencyCurrentValue.string(Precision.btc, removeTrailing: true))
            default:
                referenceCurrencyCurrentValue = currentValue.average
                referenceCurrencyOriginalValue = originalValue.average
                self.amountLabel.text = Fiat(amount: Float(referenceCurrencyCurrentValue)).formattedString()
            }
            let percentChange = 0 < referenceCurrencyOriginalValue ? ((referenceCurrencyCurrentValue - referenceCurrencyOriginalValue) / referenceCurrencyOriginalValue * 100) : 0
            self.percentChangeLabel.text = String(format: "%.2f%@", percentChange, "%")
            self.percentChangeLabel.theme_textColor = percentChange >= 0 ? O3Theme.positiveGainColorPicker :
                O3Theme.negativeLossColorPicker

            let posixString = self.priceHistory?.data.reversed()[index].time ?? ""
            timeLabel.text = posixString.intervaledDateString(self.selectedInterval)
            timeLabel.sizeToFit()
        }
    }

    @IBAction func priceIntervalButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.view.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                self.activatedLineCenterXAnchor?.isActive = false
                self.activatedLineCenterXAnchor = self.activatedLine.centerXAnchor.constraint(equalTo: sender.centerXAnchor, constant: 0)
                self.activatedLineCenterXAnchor?.isActive = true
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.selectedInterval = PriceInterval(rawValue: sender.tag.tagToPriceIntervalString())!
                self.loadPriceHistory(asset: self.selectedAsset)
            })
        }
    }

    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.

        if pointIndex > priceHistory!.data.count {
            return 0
        }
        if referenceCurrency == .btc {
            return priceHistory!.data.reversed()[pointIndex].averageBTC
        }
        return priceHistory!.data.reversed()[pointIndex].average
    }

    func label(atIndex pointIndex: Int) -> String {
        return ""//String(format:"%@",priceHistory!.data[pointIndex].time)
    }

    func numberOfPoints() -> Int {
        if priceHistory == nil {
            return 0
        }
        return priceHistory!.data.count
    }
}
