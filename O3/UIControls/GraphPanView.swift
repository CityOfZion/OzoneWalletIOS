//
//  GraphPanView.swift
//  O3
//
//  Created by Andrei Terentiev on 9/18/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import UIKit

@objc protocol GraphPanDelegate: class {
    func panDataIndexUpdated(index: Int, timeLabel: UILabel)
    @objc optional func panEnded()
    @objc optional func panBegan()
}

class GraphPanView: UIView {
    var verticalLineView: UIView!
    var timeLabel: UILabel!
    var peakPriceLabel: UILabel!
    var dateMargin = 50
    var data: [PriceData]?
    weak var delegate: GraphPanDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        verticalLineView = UIView(frame: CGRect(x: 0, y: 20, width: 1, height: self.frame.height))
        timeLabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.frame.width, height: 25))
        timeLabel.text = ""
        timeLabel.textAlignment = .center
        timeLabel.textColor = UserDefaultsManager.theme.lightTextColor
        timeLabel.font = ThemeManager.smallText
        timeLabel.center  = CGPoint(x: verticalLineView.center.x, y: 5)
        self.addSubview(verticalLineView)
        self.addSubview(timeLabel)
        verticalLineView.backgroundColor = UserDefaultsManager.theme.lightTextColor
        verticalLineView.isHidden = true

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.graphPanned(_:)))
        self.addGestureRecognizer(panGesture)
    }

    func xPosForLabel(currPos: CGFloat) -> CGFloat {
        //left side
        if currPos <= UIScreen.main.bounds.width / 2 {
            return max(currPos, CGFloat(dateMargin))
        } else {
            return min(currPos, UIScreen.main.bounds.width - CGFloat(dateMargin))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        var verticalFrame = verticalLineView.frame
        verticalFrame.size.height = self.frame.size.height
        verticalLineView.frame = verticalFrame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func graphPanned(_ gesture: UIPanGestureRecognizer) {
        //TODO: MAKE THIS A DELEGATE PROPERTYs
        if let homeViewController = delegate as? HomeViewController {
            dateMargin = homeViewController.selectedInterval.minuteValue() < 60 ? 25 : 55
        } else if let detailViewController = delegate as? AssetDetailViewController {
            dateMargin = detailViewController.selectedInterval.minuteValue() < 60 ? 25 : 55
        }

        //TODO: Handle date margin more elegantly
        switch gesture.state {
        case .began:
            delegate?.panBegan?()
            verticalLineView.isHidden = false
            timeLabel.isHidden = false
            verticalLineView.center = CGPoint(x: gesture.location(in: self).x, y: verticalLineView.center.y)
            timeLabel.center = CGPoint(x: xPosForLabel(currPos: verticalLineView.center.x), y: 7)
            self.setNeedsDisplay()
        case .changed:
            let index = Int((71  / self.frame.width) * gesture.location(in: self).x)
            delegate?.panDataIndexUpdated(index: index, timeLabel: timeLabel)

            verticalLineView.center = CGPoint(x: gesture.location(in: self).x, y: verticalLineView.center.y)
            timeLabel.center = CGPoint(x: xPosForLabel(currPos: verticalLineView.center.x), y: 7)
            self.setNeedsDisplay()
        case .ended:
            delegate?.panEnded?()
            verticalLineView.isHidden = true
            timeLabel.isHidden = true
        default: return
        }
    }
}
