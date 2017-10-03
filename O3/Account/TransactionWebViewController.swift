//
//  TransactionWebViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 10/1/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class TransactionWebViewController: UIViewController, WKUIDelegate {
    var transactionID: String!
    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        self.view = self.webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var urlString = ""
        if Neo.isTestnet {
            urlString = "https://neoscan-testnet.io/transaction/"
        } else {
            urlString = "https://neoscan.io/transaction/"
        }
        urlString += transactionID
        let myURL = URL(string: urlString)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
    }
}
