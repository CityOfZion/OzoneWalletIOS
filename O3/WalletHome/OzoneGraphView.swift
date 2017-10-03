//
//  OzoneGraphView.swift
//  O3
//
//  Created by Andrei Terentiev on 9/24/17.
//  Copyright © 2017 drei. All rights reserved.
//

import Foundation
import ScrollableGraphView

extension ScrollableGraphView {
    static func ozoneTheme(frame: CGRect, dataSource: ScrollableGraphViewDataSource) -> ScrollableGraphView {
        let graphView = ScrollableGraphView(frame: frame, dataSource: dataSource)

        let linePlot = LinePlot(identifier: "darkLine")
        linePlot.lineWidth = 1
        linePlot.lineColor = Theme.Light.primary
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        linePlot.shouldFill = false
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.clear
        linePlot.fillGradientEndColor = UIColor.clear
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic

        graphView.backgroundFillColor = UIColor(hexString: "#FFFFFFFF")!
        graphView.dataPointSpacing = UIScreen.main.bounds.size.width / 71
        graphView.rightmostPointPadding = 0
        graphView.leftmostPointPadding = 0
        graphView.shouldAnimateOnStartup = false
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = false
        graphView.addPlot(plot: linePlot)

        return graphView
    }
}
