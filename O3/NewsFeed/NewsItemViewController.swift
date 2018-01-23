//
//  NewsItemViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 1/8/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class NewsItemViewController: UIViewController, WKUIDelegate {
    var feedURL: String!
    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        self.view = self.webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: feedURL)
        let myRequest = URLRequest(url: myURL!)
        self.webView.load(myRequest)
    }
}
