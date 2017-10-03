//
//  OnboardingCollectionCell.swift
//  O3
//
//  Created by Andrei Terentiev on 9/16/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

class OnboardingCollectionCell: UICollectionViewCell {
    struct Data {
        var imageName: String
        var title: String
        var subtitle: String
    }

    @IBOutlet weak var onboardingImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    var data: OnboardingCollectionCell.Data? {
        didSet {
            titleLabel.text = data?.title
            subtitleLabel.text = data?.subtitle
        }
    }

    override func prepareForReuse() {
        onboardingImage.image = nil
    }
}
