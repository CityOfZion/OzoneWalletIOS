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
import SwiftTheme
import LocalAuthentication

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionPageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createNewWalletButton: UIButton!
    @IBOutlet weak var newToO3Label: UILabel!
    var features: [OnboardingCollectionCell.Data]!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalizedStrings()
        self.navigationController?.hideHairline()
        ThemeManager.setTheme(index: 2)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(hexString: "#0069D9FF")!
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
        cell.backgroundColor = UIColor(hexString: "#0069D9FF")!
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
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width, height: screenSize.height * 0.6)
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        if !LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            OzoneAlert.alertDialog(message: OnboardingStrings.loginNoPassCodeError, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
            return
        }
        performSegue(withIdentifier: "segueToLogin", sender: nil)
    }

    @IBAction func createNewWalletButtonTapped(_ sender: Any) {
        //if user doesn't have wallet we then create one
        if !LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            OzoneAlert.alertDialog(message: OnboardingStrings.createWalletNoPassCodeError, dismissTitle: OzoneAlert.okPositiveConfirmString) {}
            return
        }
        if UserDefaultsManager.o3WalletAddress == nil {
            Authenticated.account = Account()
            performSegue(withIdentifier: "segueToWelcome", sender: nil)
            return
        }
        performSegue(withIdentifier: "preCreateWallet", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWelcome" {
            //create a new wallet
            Authenticated.account = Account()
        }
    }

    func setLocalizedStrings() {

        features = [
            OnboardingCollectionCell.Data(imageName: "chart", title: OnboardingStrings.landingTitleOne,
                                          subtitle: OnboardingStrings.landingSubtitleOne),
            OnboardingCollectionCell.Data(imageName: "lock", title: OnboardingStrings.landingTitleTwo,
                                          subtitle: OnboardingStrings.landingSubtitleTwo),
            OnboardingCollectionCell.Data(imageName: "exchange", title: OnboardingStrings.landingTitleThree,
                                          subtitle: OnboardingStrings.landingSubtitleThree)
        ]

        loginButton.setTitle(OnboardingStrings.loginTitle, for: UIControlState())
    createNewWalletButton.setTitle(OnboardingStrings.createNewWalletTitle, for: UIControlState())
        newToO3Label.text = OnboardingStrings.newToO3
    }
}
