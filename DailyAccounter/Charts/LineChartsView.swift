//
//  LineChartsView.swift
//  DailyAccounter
//
//  Created by wangchi on 2019/5/21.
//  Copyright © 2019 Zhu xiaojin. All rights reserved.
//

import Foundation
import Charts
import ChartsRealm

class LineChartsView: LineChartView {
    
    var yCost = [(key: String, value: [Amount?])]()
    var yIncome = [(key: String, value: [Amount?])]()

    func addLineChart(){
        self.backgroundColor = UIColor.white
        self.frame.size = CGSize.init(width: 300, height: 300)
           //刷新按钮响应
//        refreshrBtn.addTarget(self, action: #selector(updataData), for: UIControlEvents.touchUpInside)
    }
    
    func interactionStyle(){
        self.scaleYEnabled = false //取消Y轴缩放
        self.doubleTapToZoomEnabled = true //双击缩放
        self.dragEnabled = true //启用拖动手势
        self.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        self.dragDecelerationFrictionCoef = 0.9 //拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
    }
    
    func chartDescription(){
        self.noDataText = "暂无数据" //如果没有数据会显示这个
        self.chartDescription?.text = "收入支出折线图"
        self.chartDescription?.position = CGPoint.init(x: self.frame.width - 10, y:self.frame.height - 20)//位置（及在lineChartView的中心点）
        self.chartDescription?.font = UIFont.systemFont(ofSize: 14)//大小
        self.chartDescription?.textColor = UIColor.darkGray
        self.legend.textColor = UIColor.purple //描述文字颜色
        self.legend.formSize = 12 //（图例大小）默认是8
        self.legend.form = Legend.Form.line//图例头部样式
        //矩形：.square（默认值） 圆形：.circle   横线：.line  无：.none 空：.empty（与 .none 一样都不显示头部，但不同的是 empty 头部仍然会占一个位置)
    }
    
//    func setBackgroundBorder(){
//        //        lineChartView.drawGridBackgroundEnabled = true  //绘制图形区域背景
//        //        lineChartView.gridBackgroundColor = ZHFColor.yellow //背景改成黄色(默认为浅灰色)
//        self.drawBordersEnabled = false  //绘制图形区域边框
//        self.borderColor = UIColor.red  //边框为红色
//        self.borderLineWidth = 2  //边框线条大小为2
//    }
    
    //设置x轴的样式属性
    func setXAxisStyle(){
        //轴线宽、颜色、刻度、间隔
        self.xAxis.axisLineWidth = 2 //x轴宽度
        self.xAxis.axisLineColor = .black //x轴颜色
        self.xAxis.axisMinimum = 0 //最小刻度值
        self.xAxis.axisMaximum = 12 //最大刻度值
        self.xAxis.granularity = 1 //最小间隔
        
        //文字属性
        self.xAxis.labelPosition = .bottom //x轴上的数字显示在下方（默认显示在上方 .top .bottom .bothSided .topInside .bottomInside）
        self.xAxis.labelTextColor = .red //刻度文字颜色
        self.xAxis.labelFont = .systemFont(ofSize: 13) //刻度文字大小
        self.xAxis.labelRotationAngle = -20 //刻度文字倾斜角度
        
        //文字格式
//        let formatter = NumberFormatter()  //自定义格式
//        formatter.positivePrefix = "#"  //数字前缀positivePrefix、 后缀positiveSuffix
//        self.xAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
        //自定义刻度标签文字
        let xValues = ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"]
        self.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        //网格线
        self.xAxis.drawGridLinesEnabled = false //制网格线
//        self.xAxis.gridColor = .orange //x轴对应网格线的颜色
//        self.xAxis.gridLineWidth = 2 //x轴对应网格线的大小
//        self.xAxis.gridLineDashLengths = [4,2]  //虚线各段长度
    }
    
    //设置y轴的样式属性(分左、右侧)
    func setYAxisStyle(){
        //右侧(默认显示)
        self.rightAxis.drawLabelsEnabled = false //不绘制右侧Y轴文字
        self.rightAxis.drawAxisLineEnabled = false //不显示右侧Y轴
        self.rightAxis.enabled = false //禁用右侧的Y轴
//        //左侧
//        self.leftAxis.inverted = true //刻度值反向排列（默认正向）
//        self.leftAxis.labelPosition = .insideChart  //文字显示在内侧
        //0刻度线
        self.leftAxis.drawZeroLineEnabled = true //绘制0刻度线
        self.leftAxis.zeroLineColor = .red  //0刻度线颜色
        self.leftAxis.zeroLineWidth = 2 //0刻度线线宽
        self.leftAxis.zeroLineDashLengths = [4, 2] //0刻度线使用虚线样式
        //（1.轴线宽、颜色、刻度、间隔 2.文字属性 3.文字格式、4.网格线）和 func setXAxisStyle()方法一样
    }
    
    //设置限制线（可设置多根）
//    func setlimitLine(){
//        //界限1
//        let limitLine1 = ChartLimitLine(limit: 85, label: "优秀")
//        
//        limitLine1.lineColor = UIColor.green
//        limitLine1.lineWidth = 2 //线宽
//        limitLine1.lineDashLengths = [4, 2] //虚线样式
//        //limitLine1.drawLabelEnabled = false //不绘制文字
//        limitLine1.valueTextColor = UIColor.blue  //文字颜色
//        limitLine1.valueFont = UIFont.systemFont(ofSize: 13)  //文字大小
//        limitLine1.labelPosition = .leftTop //文字位置
//        /*.leftTop：左上
//         .leftBottom：左下
//         .rightTop：右上（默认）
//         .rightBottom：右下
//         */
//        self.leftAxis.addLimitLine(limitLine1)
//        
//        //界限2
//        let limitLine2 = ChartLimitLine(limit: 60, label: "合格")
//        limitLine1.lineColor = UIColor.purple
//        self.leftAxis.addLimitLine(limitLine2)
//        self.leftAxis.drawLimitLinesBehindDataEnabled = true//将限制线绘制在折线后面
//    }
     let lineChartsModel = LineChartsModel()
}

//MARK:-    数据加载和刷新
extension LineChartsView{
    
    @objc func updataData(){
        //1.第一条折线(收入)
        var dataEntries1 = [ChartDataEntry]()
        var circleColors = [UIColor]()
        let y = self.yIncome
        for i in 0..<12 {
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y[i].value.reduce(0.0) { $0 + ($1?.amount ?? 0.0) }))
            dataEntries1.append(entry)
            circleColors.append(UIColor.randomColor())
        }
        //设置折线
        let chartDataSet1 = LineChartDataSet(values: dataEntries1, label: "收入")
        chartDataSet1.setColors(UIColor.randomColor(),UIColor.randomColor())//设置折线颜色(是一个循环，例如：你设置5个颜色，你设置8条折线，后三个对应的颜色是该设置中的前三个，依次类推)
        //  chartDataSet1.setColors(ChartColorTemplates.material(), alpha: 1)
        //chartDataSet1.setColor(ZHFColor.gray)//颜色一致
        chartDataSet1.lineWidth = 3 //线条宽度
        chartDataSet1.lineDashLengths = [4,2] //设置折线为虚线各段长度
        chartDataSet1.mode = .horizontalBezier  //贝塞尔曲线（默认是折线 .linear .stepped .cubicBezier .horizontalBezier）
        //设置折点
        // chartDataSet1.drawCirclesEnabled = false //不绘制转折点
        // chartDataSet1.drawCircleHoleEnabled = false  //不绘制转折点内圆
        chartDataSet1.circleColors = circleColors  //外圆颜色
        chartDataSet1.circleHoleColor = UIColor.yellow  //内圆颜色
        chartDataSet1.circleRadius = 6 //外圆半径
        chartDataSet1.circleHoleRadius = 4 //内圆半径
        //设置折线上的文字
        chartDataSet1.drawValuesEnabled = false //绘制拐点上的文字(默认绘制)
//        chartDataSet1.valueColors = [.blue] //拐点上的文字颜色
//        chartDataSet1.valueFont = .systemFont(ofSize: 12) //拐点上的文字大小
        //文字格式
//        let formatter = NumberFormatter()  //自定义格式
//        formatter.positiveSuffix = ""  //数字后缀单位
//        chartDataSet1.valueFormatter = DefaultValueFormatter(formatter: formatter)
        //绘制填充色背景
        //*半透明的填充色
        chartDataSet1.drawFilledEnabled = true //开启填充色绘制
        chartDataSet1.fillColor = .orange  //设置填充色
        chartDataSet1.fillAlpha = 0.5 //设置填充色透明度
        //*渐变色填充
        //开启填充色绘制
        chartDataSet1.drawFilledEnabled = true
        //渐变颜色数组
        let gradientColors = [UIColor.orange.cgColor, UIColor.white.cgColor] as CFArray
        //每组颜色所在位置（范围0~1)
        let colorLocations:[CGFloat] = [1.0, 0.0]
        //生成渐变色
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: gradientColors, locations: colorLocations)
        //将渐变色作为填充对象s
        chartDataSet1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        //1.第二条折线（支出）
        var dataEntries2 = [ChartDataEntry]()
        for i in 0..<12 {
            
            let y = self.yCost
          
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y[i].value.reduce(0.0){$0 + ($1?.amount ?? 0.0)}))
            dataEntries2.append(entry)
            
        }
        let chartDataSet2 = LineChartDataSet(values: dataEntries2, label: "支出")
        //chartDataSet2.setColors(ZHFColor.gray,ZHFColor.green,ZHFColor.yellow,ZHFColor.zhf_randomColor(),ZHFColor.zhf_randomColor())//设置折线颜色(是一个循环，例如：你设置5个颜色，你设置8条折线，后三个对应的颜色是该设置中的前三个，依次类推)
        //  chartDataSet2.setColors(ChartColorTemplates.material(), alpha: 1)
        chartDataSet2.setColor(UIColor.gray)//颜色一致
        chartDataSet2.lineWidth = 3
        chartDataSet2.drawValuesEnabled = false
        chartDataSet2.circleRadius = 6 //外圆半径
        chartDataSet2.circleHoleRadius = 4 //内圆半径
        
        //绘制填充色背景
        //*半透明的填充色
        chartDataSet2.drawFilledEnabled = true //开启填充色绘制
        chartDataSet2.fillColor = .green  //设置填充色
        chartDataSet2.fillAlpha = 0.5 //设置填充色透明度
        //*渐变色填充
        //开启填充色绘制
        chartDataSet2.drawFilledEnabled = true
        //渐变颜色数组
        let gradientColors2 = [UIColor.green.cgColor, UIColor.white.cgColor] as CFArray
        //每组颜色所在位置（范围0~1)
        let colorLocations2:[CGFloat] = [1.0, 0.0]
        //生成渐变色
        let gradient2 = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: gradientColors2, locations: colorLocations2)
        //将渐变色作为填充对象s
        chartDataSet2.fill = Fill.fillWithLinearGradient(gradient2!, angle: 90.0)
       
        let chartData = LineChartData(dataSets: [chartDataSet1,chartDataSet2])
        //设置折现图数据
        self.data = chartData
        self.animate(xAxisDuration: 2)//展示方式xAxisDuration 和 yAxisDuration两种
    }
}
