//
//  OnboardingHomeViewController.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit
import NeoSwift

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionPageControl: UIPageControl!
    @IBOutlet weak var addAddressButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createNewWalletButton: UIButton!

    var features: [OnboardingCollectionCell.Data] = [OnboardingCollectionCell.Data(imageName: "chart", title: "Add-Watch Only Address", subtitle: "Safely monitor your wallet from mobile"),
                                                     OnboardingCollectionCell.Data(imageName: "lock", title: "Login using a private key", subtitle: "Open your NEO wallet with private key"),
                                                     OnboardingCollectionCell.Data(imageName: "exchange", title: "Send & Receive", subtitle: "Send & receive assets on NEO")]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,
                                                                        NSAttributedStringKey.font: UIFont(name: "Avenir-Heavy", size: 32) as Any]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardingCollectionCell", for: indexPath) as? OnboardingCollectionCell else {
            fatalError("undefined table view behavior")
        }
        let data = features[indexPath.row]
        cell.data = data
        cell.onboardingImage.image = UIImage(named: data.imageName)
        return cell
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        collectionPageControl.currentPage = currentPage
        // Do whatever with currentPage.
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO: FIX THIS TO BE RELATIVE TO SAFE AREA
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: screenSize.height * 0.6)
    }

    @IBAction func addAddressButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "segueToAddAddress", sender: nil)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "segueToLogin", sender: nil)
    }

    @IBAction func createNewWalletButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "segueToWelcome", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //NOTE: MUST DISABLE TAPS HERE POTENTIAL TO GENERATE MULTIPLE KEYS
        if segue.identifier == "segueToWelcome" {
            Authenticated.account = Account()
        }
    }
}
