//
//  VitalSignsViewController.swift
//  VetCare
//
//  Created by Raquel Ramos on 13/05/2018.
//  Copyright © 2018 raquelramos. All rights reserved.
//

import UIKit
import Charts

class VitalSignsViewController: UIViewController {
    
    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Vital Signs"
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor.white

        chartView.delegate = self as? ChartViewDelegate
        
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        let l = chartView.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = .black
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = .black
        xAxis.drawAxisLineEnabled = false
        xAxis.axisMaximum = 24
        xAxis.axisMinimum = 0
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor.black
        leftAxis.axisMaximum = 110
        leftAxis.axisMinimum = 10
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = false
        
        chartView.animate(xAxisDuration: 1.5)
        
        chartView.backgroundColor = UIColor.white
        
        self.setDataCount(Int(25), range: UInt32(30))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        //Heart beatings
        let yVals1 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(100-60) + 60)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        //Temperature
        let yVals2 = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(40-20) + 20)
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(values: yVals1, label: "Heart Beatings (per minute)")
        set1.axisDependency = .left
        set1.setColor(UIColor.red)
        set1.setCircleColor(.black)
        set1.lineWidth = 2
        set1.circleRadius = 3
        set1.fillAlpha = 65/255
        set1.fillColor = UIColor.red
        set1.highlightColor = UIColor.red
        set1.drawCircleHoleEnabled = false
        
        let set2 = LineChartDataSet(values: yVals2, label: "Temperature (ºC)")
        set2.axisDependency = .left
        set2.setColor(UIColor.init(red: 0/255, green: 102/255, blue: 204/255, alpha: 1))
        set2.setCircleColor(.black)
        set2.lineWidth = 2
        set2.circleRadius = 3
        set2.fillAlpha = 65/255
        set2.fillColor = UIColor.blue
        set2.highlightColor = UIColor.blue
        set2.drawCircleHoleEnabled = false
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueTextColor(.black)
        data.setValueFont(.systemFont(ofSize: 9))
        
        chartView.data = data
    }
    
    @IBAction func goBackVitalSigns(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
