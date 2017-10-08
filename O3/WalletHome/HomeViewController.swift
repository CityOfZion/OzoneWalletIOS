//
//  HomeViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/11/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import ScrollableGraphView
import NeoSwift
import Channel

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GraphPanDelegate, ScrollableGraphViewDataSource {
    // Settings for price graph interval
    @IBOutlet weak var walletHeaderCollectionView: UICollectionView!

    @IBOutlet weak var assetsTable: UITableView!

    // Xcode 9 beta issue with outlet connections gonna just hook up two buttons for now
    @IBOutlet weak var fiveMinButton: UIButton!
    @IBOutlet weak var fifteenMinButton: UIButton!

    @IBOutlet weak var graphViewContainer: UIView!

    @IBOutlet var activatedLineLeftConstraint: NSLayoutConstraint?
    var group: DispatchGroup?
    @IBOutlet weak var activatedLine: UIView!

    var graphView: ScrollableGraphView!
    var portfolio: PortfolioValue?
    var selectedInterval: PriceInterval = .fifteenMinutes
    var activatedIndex = 1
    var panView: GraphPanView!
    var selectedAsset = "neo"
    var firstTimeGraphLoad = true

    var writeableNeoBalance = 0
    var writeableGasBalance = 0.0

    var readOnlyNeoBalance = 0
    var readOnlyGasBalance = 0.0

    var selectedPrice: PriceData?
    var referenceCurrency: Currency = .btc
    var watchAddresses = [WatchAddress]()

    var portfolioType: PortfolioType = .writable {
        didSet {
            self.loadPortfolio()
        }
    }

    var displayedNeoAmount: Int {
        switch portfolioType {
        case .readOnly:
            return readOnlyNeoBalance
        case .writable:
            return writeableNeoBalance
        case .readOnlyAndWritable:
            return readOnlyNeoBalance + writeableNeoBalance
        }
    }

    var displayedGasAmount: Double {
        switch portfolioType {
        case .readOnly:
            return readOnlyGasBalance
        case .writable:
            return writeableGasBalance
        case .readOnlyAndWritable:
            return readOnlyGasBalance + writeableGasBalance
        }
    }

    func loadWatchAddresses() {
        do {
            watchAddresses = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(WatchAddress.fetchRequest())
        } catch {
            return
        }
    }

    func loadPortfolio() {
        O3Client.shared.getPortfolioValue(self.displayedNeoAmount, gas: self.displayedGasAmount, interval: self.selectedInterval.rawValue) {result in
            O3HUD.stop {

            }
            switch result {
            case .failure:
                print(result)
            case .success(let portfolio):
                DispatchQueue.main.async {
                    self.portfolio = portfolio
                    self.graphView.reload()
                    self.selectedPrice = portfolio.data.first
                    self.walletHeaderCollectionView.reloadData()
                    self.assetsTable.reloadData()
                    if self.firstTimeGraphLoad {
                        self.graphView.reload()
                        self.firstTimeGraphLoad = false
                    }
                }
            }
        }
    }

    func loadBalanceData(fromReadOnly: Bool, address: String) {
        Neo.client.getAccountState(for: address) { result in
            switch result {
            case .failure:
                self.group?.leave()
            case .success(let accountState):
                print(result)
                for asset in accountState.balances {
                    if !fromReadOnly {
                        if asset.id.contains(NeoSwift.AssetId.neoAssetId.rawValue) {
                            self.writeableNeoBalance = Int(asset.value) ?? 0
                        } else if asset.id.contains(NeoSwift.AssetId.gasAssetId.rawValue) {
                            self.writeableGasBalance = Double(asset.value) ?? 0
                        }
                    } else {
                        if asset.id.contains(NeoSwift.AssetId.neoAssetId.rawValue) {
                            self.readOnlyNeoBalance += (Int(asset.value) ?? 0)
                        } else if asset.id.contains(NeoSwift.AssetId.gasAssetId.rawValue) {
                            self.readOnlyGasBalance += (Double(asset.value) ?? 0)
                        }
                    }
                }
                self.group?.leave()
            }
        }
    }

    /*
     * We simulatenously load all of your balance data at once
     * Get the sum of your read only addresses and then the hot wallet as well
     * However the display in the graph and asset cells will vary depending on
     * on the portfolio you wish to display read, write, or read + write
     */
    @objc func getBalance() {
        self.readOnlyNeoBalance = 0
        self.readOnlyGasBalance = 0
        self.group = DispatchGroup()
        if let address = Authenticated.account?.address {
            group?.enter()
            loadBalanceData(fromReadOnly: false, address: address)
        }

        for address in Authenticated.watchOnlyAddresses ?? [] {
            group?.enter()
            loadBalanceData(fromReadOnly: true, address: address)
        }
        group?.notify(queue: .main) {
            self.loadPortfolio()
        }
    }

    func setupGraphView() {
        graphView = ScrollableGraphView.ozoneTheme(frame: graphViewContainer.bounds, dataSource: self)
        graphViewContainer.embed(graphView)

        panView = GraphPanView(frame: graphViewContainer.bounds)
        panView.delegate = self
        graphViewContainer.embed(panView)
    }

    func panDataIndexUpdated(index: Int, timeLabel: UILabel) {
        DispatchQueue.main.async {
            self.selectedPrice = self.portfolio?.data.reversed()[index]
            self.walletHeaderCollectionView.reloadData()

            let posixString = self.portfolio?.data.reversed()[index].time ?? ""
            timeLabel.text = posixString.intervaledDateString(self.selectedInterval)
            timeLabel.sizeToFit()
        }
    }

    func panEnded() {
        selectedPrice = self.portfolio?.data.first
        walletHeaderCollectionView.reloadData()
    }

    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.getBalance), name: Notification.Name("ChangedNetwork"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getBalance), name: Notification.Name("UpdatedWatchOnlyAddress"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("ChangedNetwork"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("UpdatedWatchOnlyAddress"), object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        Channel.shared().subscribe(toTopic: (Authenticated.account?.address)!)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: Theme.Light.textColor,
                                                                        NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 32) as Any]

        setupGraphView()

        walletHeaderCollectionView.delegate = self
        walletHeaderCollectionView.dataSource = self
        assetsTable.delegate = self
        assetsTable.dataSource = self
        assetsTable.tableFooterView = UIView(frame: .zero)

        getBalance()

        //control the size of the graph area here
        self.assetsTable.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height * 0.5)
    }

    /*
     * Although we have only two assets right now we expect the asset list to be of arbitrary
     * length as new tokens are introduced, we must be flexible enough to support that
     */

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = assetsTable.dequeueReusableCell(withIdentifier: "neoAssetCell") as? NeoAssetCell else {
                fatalError("undefined table view behavior")
            }
            guard let latestPrice = portfolio?.price["neo"],
                let firstPrice = portfolio?.firstPrice["neo"] else {
                    return UITableViewCell()
            }

            cell.data = NeoAssetCell.Data(amount: displayedNeoAmount,
                                          referenceCurrency: referenceCurrency,
                                          latestPrice: latestPrice,
                                          firstPrice: firstPrice)
            cell.selectionStyle = .none
            return cell
        }
        guard let cell = assetsTable.dequeueReusableCell(withIdentifier: "gasAssetCell") as? GasAssetCell else {
            fatalError("undefined table view behavior")
        }

        guard let latestPrice = portfolio?.price["gas"],
            let firstPrice = portfolio?.firstPrice["gas"] else {
                return UITableViewCell()
        }

        cell.data = GasAssetCell.Data(amount: displayedGasAmount,
                                      referenceCurrency: referenceCurrency,
                                      latestPrice: latestPrice,
                                      firstPrice: firstPrice)
        cell.selectionStyle = .none
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAssetDetail" {
            guard let dest = segue.destination as? AssetDetailViewController else {
                fatalError("Undefined behavior during segue")
            }
            dest.selectedAsset = self.selectedAsset
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAsset = indexPath.row == 0 ? "neo": "gas"
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segueToAssetDetail", sender: nil)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    @IBAction func tappedIntervalButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.view.needsUpdateConstraints()
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                self.activatedLineLeftConstraint?.constant = sender.frame.origin.x
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.selectedInterval = PriceInterval(rawValue: sender.tag)!
                self.loadPortfolio()
            })
        }
    }

    // MARK: - Graph delegate
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.

        if pointIndex > portfolio!.data.count {
            return 0
        }
        return referenceCurrency == .btc ? portfolio!.data.reversed()[pointIndex].averageBTC : portfolio!.data.reversed()[pointIndex].averageUSD
    }

    func label(atIndex pointIndex: Int) -> String {
        return ""//String(format:"%@",portfolio!.data[pointIndex].time)
    }

    func numberOfPoints() -> Int {
        if portfolio == nil {
            return 0
        }
        return portfolio!.data.count
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, WalletHeaderCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return portfolio == nil ? 0 : 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "walletHeaderCollectionCell", for: indexPath) as? WalletHeaderCollectionCell else {
            fatalError("Undefined collection view behavior")
        }
        cell.delegate = self
        var portfolioType = PortfolioType.readOnly
        switch indexPath.row {
        case 0:
            portfolioType = .readOnly
        case 1:
            portfolioType = .writable
        case 2:
            portfolioType = .readOnlyAndWritable
        default: fatalError("Undefined wallet header cell")
        }

        guard let latestPrice = selectedPrice,
            let previousPrice = portfolio?.data.last else {
                fatalError("Undefined wallet header cell")
        }

        let data = WalletHeaderCollectionCell.Data (
            portfolioType: portfolioType,
            index: indexPath.row,
            latestPrice: latestPrice,
            previousPrice: previousPrice,
            referenceCurrency: referenceCurrency,
            selectedInterval: selectedInterval
        )
        cell.data = data
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: 75)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()

        visibleRect.origin = walletHeaderCollectionView.contentOffset
        visibleRect.size = walletHeaderCollectionView.bounds.size

        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        let visibleIndexPath: IndexPath = walletHeaderCollectionView.indexPathForItem(at: visiblePoint)!

        self.portfolioType = self.indexToPortfolioType(visibleIndexPath.row)

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch referenceCurrency {
        case .btc:
            referenceCurrency = .usd
        case .usd:
            referenceCurrency = .btc
        }
        collectionView.reloadData()
        assetsTable.reloadData()
        graphView.reload()
    }

    func indexToPortfolioType(_ index: Int) -> PortfolioType {
        switch index {
        case 0:
            return .writable
        case 1:
            return .readOnly
        case 2:
            return .readOnlyAndWritable
        default:
            fatalError("Invalid Portfolio Index")
        }
    }

    func didTapLeft(index: Int, portfolioType: PortfolioType) {
        DispatchQueue.main.async {
            self.walletHeaderCollectionView.scrollToItem(at: IndexPath(row: index - 1, section: 0), at: .left, animated: true)
            self.portfolioType = self.indexToPortfolioType(index - 1)
        }
    }

    func didTapRight(index: Int, portfolioType: PortfolioType) {
        DispatchQueue.main.async {
            self.walletHeaderCollectionView.scrollToItem(at: IndexPath(row: index + 1, section: 0), at: .right, animated: true)
            self.portfolioType = self.indexToPortfolioType(index + 1)
        }
    }
}
