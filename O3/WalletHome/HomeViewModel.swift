//
//  HomeViewModel.swift
//  O3
//
//  Created by Andrei Terentiev on 2/6/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import NeoSwift
import UIKit
import Cache

protocol HomeViewModelDelegate: class {
    func updateWithBalanceData(_ assets: [TransferableAsset])
    func updateWithPortfolioData(_ portfolio: PortfolioValue)
    func showLoadingIndicator()
    func hideLoadingIndicator()
}

class HomeViewModel {
    weak var delegate: HomeViewModelDelegate?

    var cachedWritableAssets: [TransferableAsset] = []
    var cachedReadOnlyAssets: [TransferableAsset] = []
    var assetsReadOnly: [TransferableAsset] = []
    var assetsWriteable: [TransferableAsset] = []
    var selectedNEP5Tokens = UserDefaultsManager.selectedNEP5Token!
    var watchAddresses = [WatchAddress]()
    var group = DispatchGroup()

    var portfolioType: PortfolioType = .writable
    var referenceCurrency: Currency = .usd
    var selectedInterval: PriceInterval = .oneDay

    func setPortfolioType(_ portfolioType: PortfolioType) {
        self.portfolioType = portfolioType
        self.delegate?.updateWithBalanceData(getTransferableAssets())
        loadPortfolioValue()
    }

    func setInterval(_ interval: PriceInterval) {
        self.selectedInterval = interval
        loadPortfolioValue()
    }

    func setReferenceCurrency(_ currency: Currency) {
        self.referenceCurrency = currency
    }

    func combinedReadOnlyAndWriteable() -> [TransferableAsset] {
        var assets: [TransferableAsset] = assetsWriteable
        for asset in assetsReadOnly {
            let index = assets.index(where: { (item) -> Bool in
                item.name == asset.name //test if we've already added this asset from another watch address
            })
            if index == nil {
                assets.append(asset)
            } else {
                assets[index!].balance = assets[index!].balance + asset.balance
            }
        }
        return assets
    }

    func getTransferableAssets() -> [TransferableAsset] {
        var transferableAssetsToReturn: [TransferableAsset]  = []
        switch self.portfolioType {
        case .writable: transferableAssetsToReturn = self.assetsWriteable
        case .readOnlyAndWritable: transferableAssetsToReturn = self.combinedReadOnlyAndWriteable()
        case .readOnly: transferableAssetsToReturn = self.assetsReadOnly
        }

        //Put NEO + GAS at the top
        var sortedAssets = [TransferableAsset]()
        if let indexNEO = transferableAssetsToReturn.index(where: { (item) -> Bool in
            item.symbol == "NEO"
        }) {
            sortedAssets.append(transferableAssetsToReturn[indexNEO])
            transferableAssetsToReturn.remove(at: indexNEO)
        }

        if let indexGAS = transferableAssetsToReturn.index(where: { (item) -> Bool in
            item.symbol == "GAS"
        }) {
            sortedAssets.append(transferableAssetsToReturn[indexGAS])
            transferableAssetsToReturn.remove(at: indexGAS)
        }
        transferableAssetsToReturn.sort {$0.name < $1.name}
        return sortedAssets + transferableAssetsToReturn
    }

    func initiateCache() {
        if let storage =  try? Storage(diskConfig: DiskConfig(name: "O3")) {
            cachedWritableAssets = (try? storage.object(ofType: [TransferableAsset].self, forKey: "writableAssets")) ?? []
            cachedReadOnlyAssets = (try? storage.object(ofType: [TransferableAsset].self, forKey: "readOnlyAssets")) ?? []
        }
    }

    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
        initiateCache()
        reloadBalances()
    }

    func reloadBalances() {
        do {
            watchAddresses = try UIApplication.appDelegate.persistentContainer.viewContext.fetch(WatchAddress.fetchRequest())
        } catch {}
        assetsWriteable = []
        assetsReadOnly = []

        selectedNEP5Tokens = UserDefaultsManager.selectedNEP5Token!
        fetchAssetBalances(address: (Authenticated.account?.address)!, isReadOnly: false)
        for watchAddress in watchAddresses {
            if NEOValidator.validateNEOAddress(watchAddress.address ?? "") {
                self.fetchAssetBalances(address: (watchAddress.address)!, isReadOnly: true)
            }
        }
        group.notify(queue: .main) {
            self.loadPortfolioValue()
            self.delegate?.updateWithBalanceData(self.getTransferableAssets())
        }
    }

    func addWritableAsset(_ asset: TransferableAsset) {
        assetsWriteable.append(asset)

        //Add to writable assets cache
        let index = cachedWritableAssets.index(where: { (item) -> Bool in
            item.name == asset.name
        })
        if index == nil {
            cachedWritableAssets.append(asset)
        } else {
            cachedWritableAssets[index!] = asset
        }
    }

    func addReadOnlyAsset(_ asset: TransferableAsset) {
        let index = assetsReadOnly.index(where: { (item) -> Bool in
            item.name == asset.name //test if we've already added this asset from another watch address
        })
        if index == nil {
            assetsReadOnly.append(asset)
        } else {
            assetsReadOnly[index!].balance = assetsReadOnly[index!].balance + asset.balance
        }

        //update the cache to match
        let cacheIndex = cachedReadOnlyAssets.index(where: { (item) -> Bool in
            item.name == asset.name
        })
        if cacheIndex == nil {
            cachedReadOnlyAssets.append(asset)
        } else {
            cachedReadOnlyAssets[cacheIndex!] = asset
        }
    }

    func fetchTokenFromCache(_ tokenHash: String, isReadOnly: Bool) -> TransferableAsset? {
        if isReadOnly {
            let cacheIndex = cachedReadOnlyAssets.index(where: { (item) -> Bool in
                item.assetID == tokenHash
            })
            if cacheIndex != nil {
                return cachedReadOnlyAssets[cacheIndex!]
            } else {
                return nil
            }
        } else {
            let cacheIndex = cachedWritableAssets.index(where: { (item) -> Bool in
                item.assetID == tokenHash
            })
            if cacheIndex != nil {
                return cachedWritableAssets[cacheIndex!]
            } else {
                return nil
            }
        }
    }

    func fetchNativeAssetsFromCache(isReadOnly: Bool) {
        let cachedNEO = self.fetchTokenFromCache(NeoSwift.AssetId.neoAssetId.rawValue, isReadOnly: isReadOnly)
        if cachedNEO != nil {
            if isReadOnly {
                self.addReadOnlyAsset(cachedNEO!)
            } else {
                self.addWritableAsset(cachedNEO!)
            }
        }

        let cachedGAS = self.fetchTokenFromCache(NeoSwift.AssetId.gasAssetId.rawValue, isReadOnly: isReadOnly)
        if cachedGAS != nil {
            if isReadOnly {
                self.addReadOnlyAsset(cachedGAS!)
            } else {
                self.addWritableAsset(cachedGAS!)
            }
        }
    }

    func fetchAssetBalances(address: String, isReadOnly: Bool) {
        group.enter()
        DispatchQueue.global().async {
             NeoClient(seed: UserDefaultsManager.seed).getAccountState(for: address) { result in
                switch result {
                case .failure:
                    self.fetchNativeAssetsFromCache(isReadOnly: isReadOnly)
                    self.group.leave()
                case .success(let accountState):
                    for asset in accountState.balances {
                        var assetToAdd: TransferableAsset
                        if asset.id.contains(NeoSwift.AssetId.neoAssetId.rawValue) {
                            assetToAdd = TransferableAsset(assetID: NeoSwift.AssetId.neoAssetId.rawValue,
                                                               name: "NEO",
                                                               symbol: "NEO",
                                                               assetType: AssetType.nativeAsset,
                                                               decimal: 0,
                                                               balance: Decimal(Double(asset.value) ?? 0))
                            if !isReadOnly { O3Cache.setNEOForSession(neoBalance: Int(asset.value) ?? 0) }
                        } else {
                            assetToAdd = TransferableAsset(assetID: NeoSwift.AssetId.gasAssetId.rawValue,
                                                          name: "GAS",
                                                          symbol: "GAS",
                                                          assetType: AssetType.nativeAsset,
                                                          decimal: 8,
                                                          balance: Decimal(Double(asset.value) ?? 0))
                            if !isReadOnly { O3Cache.setGASForSession(gasBalance: Double(asset.value) ?? 0.0) }
                        }
                        if isReadOnly {
                            self.addReadOnlyAsset(assetToAdd)
                        } else {
                            self.addWritableAsset(assetToAdd)
                        }
                    }
                    self.group.leave()
                }
            }
        }

        DispatchQueue.global().async {
            for key in self.selectedNEP5Tokens.keys {
                let token = self.selectedNEP5Tokens[key]!
                self.group.enter()
                NeoClient(seed: UserDefaultsManager.seed).getTokenBalanceUInt(token.tokenHash, address: address) { result in
                    switch result {
                    case .failure:
                        let cachedAsset = self.fetchTokenFromCache(token.tokenHash, isReadOnly: isReadOnly)
                        if cachedAsset != nil {
                            if isReadOnly {
                                self.addReadOnlyAsset(cachedAsset!)
                            } else {
                                self.addWritableAsset(cachedAsset!)
                            }
                        }
                        self.group.leave()
                    case .success(let balance):
                        let balanceDecimal = Decimal(balance) / pow(10, token.decimal)
                        let assetToAdd = TransferableAsset(assetID: token.tokenHash,
                                                                     name: token.name,
                                                                     symbol: token.symbol,
                                                                     assetType: AssetType.nep5Token,
                                                                     decimal: token.decimal,
                                                                     balance: balanceDecimal)
                        if isReadOnly {
                            self.addReadOnlyAsset(assetToAdd)
                        } else {
                            self.addWritableAsset(assetToAdd)
                        }
                        self.group.leave()
                    }
                }
            }
        }
    }

    func loadPortfolioValue() {
        delegate?.showLoadingIndicator()
        DispatchQueue.global().async {
            O3Client.shared.getPortfolioValue(self.getTransferableAssets(), interval: self.selectedInterval.rawValue) {result in
                switch result {
                case .failure:
                    self.delegate?.hideLoadingIndicator()
                case .success(let portfolio):
                    self.delegate?.hideLoadingIndicator()
                    self.delegate?.updateWithPortfolioData(portfolio)
                }
            }
        }
    }
}
