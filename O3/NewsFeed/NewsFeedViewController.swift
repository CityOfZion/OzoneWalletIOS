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

class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var newsFeedTableView: UITableView!
    @IBOutlet weak var featuredCollectionView: UICollectionView!
    var feedData: FeedData?
    var featureData: FeatureFeed?
    var urlToLoad = ""

    func setThemedElements() {
        applyNavBarTheme()
        newsFeedTableView.theme_separatorColor = O3Theme.tableSeparatorColorPicker
        newsFeedTableView.theme_backgroundColor = O3Theme.backgroundColorPicker
        view.theme_backgroundColor = O3Theme.backgroundColorPicker

    }

    func loadNews() {
        O3Client.shared.getFeatures { result in
            switch result {
            case .failure:
                return
            case .success(let featureData):
                DispatchQueue.main.async {
                    self.navigationItem.largeTitleDisplayMode = .always
                    if featureData.features.count == 0 {
                        self.newsFeedTableView.tableHeaderView?.frame.size = CGSize(width: self.newsFeedTableView.frame.width, height: 0)
                    } else {
                        let headerHeight = (self.newsFeedTableView.frame.width * 9 / 16) + 45
                        self.newsFeedTableView.tableHeaderView?.frame.size = CGSize(width: self.newsFeedTableView.frame.width, height: headerHeight)
                    }
                }
                self.featureData = featureData
                O3Client.shared.getNewsFeed { result in
                    switch result {
                    case .failure:
                        return
                    case .success(let feedData):
                        self.feedData = feedData
                        DispatchQueue.main.async {
                            self.featuredCollectionView.reloadData()
                            self.newsFeedTableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setThemedElements()
        newsFeedTableView.dataSource = self
        newsFeedTableView.delegate = self
        featuredCollectionView.dataSource = self
        featuredCollectionView.delegate = self
        newsFeedTableView.tableFooterView = UIView(frame: .zero)
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.navigationController?.hideHairline()
        self.navigationItem.title = "News Feed"
        loadNews()
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return featureData?.features.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let featureItem = featureData?.features[indexPath.row] else {
            fatalError("Undefined Selection Behavior")
        }
        if let link = URL(string: featureItem.actionURL) {
            UIApplication.shared.open(link)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featuredCollectionCell", for: indexPath) as? FeaturedCollectionCell,
            let featureItem = featureData?.features[indexPath.row] else {
            fatalError("Undefined CollectionView Behavior")
        }

        cell.featuredImage.kf.setImage(with: URL(string: featureItem.imageURL))
        cell.titleLabel.text = featureItem.title
        cell.subtitleLabel.text = featureItem.subtitle
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width - 35, height: (newsFeedTableView.frame.width * 9 / 16) + 45)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? NewsItemViewController else {
            return
        }
        vc.feedURL = urlToLoad
    }
}
