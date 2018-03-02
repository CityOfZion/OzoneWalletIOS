//
//  NewsFeedViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 1/8/18.
//  Copyright © 2018 drei. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var newsFeedTableView: UITableView!
    var feedData: FeedData?
    var urlToLoad = ""

    func setThemedElements() {
        applyNavBarTheme()
        newsFeedTableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        newsFeedTableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setThemedElements()
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        newsFeedTableView.tableFooterView = UIView(frame: .zero)

        self.navigationController?.hideHairline()
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationItem.title = "News Feed"
        O3Client.shared.getNewsFeed { result in
            switch result {
            case .failure:
                return
            case .success(let feedData):
                self.feedData = feedData
                DispatchQueue.main.async {
                    self.newsFeedTableView.reloadData()
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedData?.items.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let newsRowCell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell") as? NewsFeedCell else {
            return UITableViewCell()
        }
        let item = feedData?.items[indexPath.row]
        newsRowCell.newsRowImageView.kf.setImage(with: URL(string: item?.images[0].url ?? ""))
        newsRowCell.newsDateLabel.text = item?.published.shortDateString() ?? ""
        newsRowCell.newsTitleLabel.text = item?.title ?? ""
        return newsRowCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = feedData?.items[indexPath.row]
        urlToLoad = item?.link ?? ""
        self.performSegue(withIdentifier: "segueToNewsItem", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? NewsItemViewController else {
            return
        }
        vc.feedURL = urlToLoad
    }
}
