//
//  PieChartView.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/15.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import Charts
import ChartsRealm

class PieChartsView: PieChartView {
    
    func setupChart() {
        let legend = self.legend
        legend.textColor = UIColor.darkGray
        legend.font = UIFont.systemFont(ofSize: 14)
        legend.formToTextSpace = 1
        legend.horizontalAlignment = .center
        legend.horizontalAlignment = Legend.HorizontalAlignment.center
        legend.verticalAlignment = Legend.VerticalAlignment.bottom 
        legend.orientation = Legend.Orientation.horizontal //水平布局
        legend.formSize = 12
        self.setExtraOffsets(left: 5, top: 5, right: 5, bottom: 0)
        self.backgroundColor = UIColor.clear
        self.holeColor = UIColor.white
        self.drawCenterTextEnabled = true
      
        self.holeRadiusPercent = 0.8
        self.transparentCircleRadiusPercent = 0.8
        self.frame.size = CGSize(width: 300, height: 300)
        let description = Description()
        description.text = ""
        self.chartDescription = description
    }
    
    let pieChartModel = PieChartModel()
    let datePickerView = DatePickerView()
    var values = [String : [Amount]]()
    
    func loadChartData() {
        let values = self.values
        
        var dataValues = [PieChartDataEntry]()
        var colours = [UIColor]()
        
        for value in values {
            dataValues.append(PieChartDataEntry(value: Double(value.value.reduce(0.0) { $0 + $1.amount }), label: value.key.description))
            colours.append((UIImage(named: value.key)?.getPixelColor(pos: CGPoint(x: 25.0, y: 19.0)))!)
    
        }
        
        let dataSet = PieChartDataSet(values: dataValues, label: "")
        dataSet.xValuePosition = .insideSlice
        dataSet.yValuePosition = .outsideSlice
        dataSet.valueTextColor = .darkGray
        dataSet.valueFont = UIFont.systemFont(ofSize: 10)
        
        dataSet.colors = colours
        
        let data = PieChartData(dataSet: dataSet)
        self.data = data
        self.drawEntryLabelsEnabled = false
        self.animate(yAxisDuration: 1, easingOption: .easeOutQuad)
        
    }
}
