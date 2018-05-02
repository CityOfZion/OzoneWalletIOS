//
//  CurrencyTableViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 2/26/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit

class CurrencyTableViewController: UITableViewController {

    @IBOutlet weak var usdCell: UITableViewCell!
    @IBOutlet weak var jpyCell: UITableViewCell!
    @IBOutlet weak var eurCell: UITableViewCell!
    @IBOutlet weak var krwCell: UITableViewCell!
    @IBOutlet weak var cnyCell: UITableViewCell!
    @IBOutlet weak var audCell: UITableViewCell!
    @IBOutlet weak var gbpCell: UITableViewCell!
    @IBOutlet weak var rubCell: UITableViewCell!
    @IBOutlet weak var cadCell: UITableViewCell!

    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    @IBOutlet weak var krwLabel: UILabel!
    @IBOutlet weak var cnyLabel: UILabel!
    @IBOutlet weak var audLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    @IBOutlet weak var cadLabel: UILabel!

    @IBOutlet weak var usdSymbol: UILabel!
    @IBOutlet weak var jpySymbol: UILabel!
    @IBOutlet weak var eurSymbol: UILabel!
    @IBOutlet weak var krwSymbol: UILabel!
    @IBOutlet weak var cnySymbol: UILabel!
    @IBOutlet weak var audSymbol: UILabel!
    @IBOutlet weak var gbpSymbol: UILabel!
    @IBOutlet weak var rubSymbol: UILabel!
    @IBOutlet weak var cadSymbol: UILabel!
    var currentlySelectedIndex = 0

    func setSelectedCell(index: Int) {
        let cell = self.tableView.cellForRow(at: IndexPath(item: index, section: 0))
        cell?.accessoryType = .checkmark
        currentlySelectedIndex = index
    }

    func setThemedElements() {
        tableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        tableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        let themedTitleLabels = [usdLabel, usdSymbol, jpyLabel, jpySymbol, eurLabel, eurSymbol, krwLabel, krwSymbol, cnyLabel, cadLabel, cnySymbol, audLabel, audSymbol, gbpLabel, gbpSymbol, rubLabel, rubSymbol, cadSymbol]
        for label in themedTitleLabels {
            label?.theme_textColor = O3Theme.titleColorPicker
        }
        let themedCells = [usdCell, jpyCell, eurCell, krwCell, cnyCell, audCell, gbpCell, rubCell, cadCell]
        for cell in themedCells {
            cell?.theme_backgroundColor = O3Theme.backgroundColorPicker
            cell?.contentView.theme_backgroundColor = O3Theme.backgroundColorPicker
        }
    }

    override func viewDidLoad() {
        setThemedElements()
        super.viewDidLoad()
        navigationItem.title = SettingsStrings.currencyTitle
    }

    override func viewWillAppear(_ animated: Bool) {
        var selectedRow = 0
        switch UserDefaultsManager.referenceFiatCurrency {
        case .usd: selectedRow = 0
        case .jpy: selectedRow = 1
        case .eur: selectedRow = 2
        case .krw: selectedRow = 3
        case .cny: selectedRow = 4
        case .aud: selectedRow = 5
        case .gbp: selectedRow = 6
        case .rub: selectedRow = 7
        case .cad: selectedRow = 8
        default: selectedRow = 0
        }
        tableView.reloadData()
        setSelectedCell(index: selectedRow)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        switch indexPath.row {
        case 0: UserDefaultsManager.referenceFiatCurrency = Currency.usd
        case 1: UserDefaultsManager.referenceFiatCurrency = Currency.jpy
        case 2: UserDefaultsManager.referenceFiatCurrency = Currency.eur
        case 3: UserDefaultsManager.referenceFiatCurrency = Currency.krw
        case 4: UserDefaultsManager.referenceFiatCurrency = Currency.cny
        case 5: UserDefaultsManager.referenceFiatCurrency = Currency.aud
        case 6: UserDefaultsManager.referenceFiatCurrency = Currency.gbp
        case 7: UserDefaultsManager.referenceFiatCurrency = Currency.rub
        case 8: UserDefaultsManager.referenceFiatCurrency = Currency.cad
        default: return
        }
        self.tableView.cellForRow(at: IndexPath(item: currentlySelectedIndex, section: 0))?.accessoryType = .none
        setSelectedCell(index: indexPath.row)
    }
}
