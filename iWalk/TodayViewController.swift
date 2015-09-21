//
//  TodayViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 04/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//

import UIKit
import Charts

class TodayViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var barChartView: BarChartView!
    
    // MARK: Constants
    let healthKitManager = HealthKitManager.instance
    let todayModel = TodayModel.instance
    
    // MARK: Variables
    var sessionMode = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loadPage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Deinit
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: Inizialization
    func loadPage() {
        if sessionMode {
            loadSessionMode()
        }
        else {
            loadTodayMode()
        }
    }
    
    func loadSessionMode() {
        // Notifications Subscription
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderSessionData", name:  Notifications.session.stepsUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderSessionData", name:  Notifications.session.caloriesUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderSessionData", name:  Notifications.session.distanceUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderSessionData", name:  Notifications.session.timeUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderSessionData", name:  Notifications.session.stepsDistributionUpdated, object: nil)
        

        // Queries
        todayModel.fetchSessionValues()
        
        // Render Session Related Data
        renderSessionData()
    }
    
    func loadTodayMode() {
        // Notifications Subscription
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderTodayData", name:  Notifications.today.stepsUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderTodayData", name:  Notifications.today.caloriesUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderTodayData", name:  Notifications.today.distanceUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderTodayData", name: Notifications.today.timeUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "renderTodayData", name: Notifications.today.stepsDistributionUpdated, object: nil)
        
        // Queries
        todayModel.fetchTodayValues()
        
        // Render Session Related Data
        renderTodayData()
    }
    
    // MARK: Change Mode
    func changeMode() {
        stopQueries()
        todayModel.resetCounters()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        sessionMode = !sessionMode
        loadPage()
    }
    
    func stopQueries() {
        // TODO:
    }
    
    
    // MARK: Rendering
    func renderSessionData() {
        // TODO:
    }
    
    func renderTodayData() {
        stepsLabel.text = "\(todayModel.stepsCount)"
        caloriesLabel.text = String(format: "%.2f", todayModel.caloriesCount)
        distanceLabel.text = String(format: "%.2f",todayModel.distanceCount)
        if let time = todayModel.timeCount {
            timeLabel.text = stringFromTimeInterval(time)
        }
        
        if let values = todayModel.values {
            setChart(todayModel.labels, values: values)
        }
        
        
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d", hours, minutes)
    }
    
    
    // Bar Chart
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Units Sold")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        barChartView.data = chartData
        
        // Configuration
        chartDataSet.colors = [UIColor(hex:Colors.BlueColor)]
        chartDataSet.valueTextColor = UIColor.whiteColor()
        chartDataSet.drawValuesEnabled = false
        chartDataSet.highlightEnabled = false
        
        // Set rounding for values on bars
        let numberFormatter = NSNumberFormatter()
        numberFormatter.generatesDecimalNumbers = false
        chartDataSet.valueFormatter = numberFormatter
        
        
        barChartView.descriptionText = ""
        barChartView.xAxis.labelPosition = .Bottom
        barChartView.xAxis.setLabelsToSkip(10)
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.avoidFirstLastClippingEnabled = true
        
        
        barChartView.leftAxis.enabled = false
        barChartView.rightAxis.enabled = false
        barChartView.leftAxis.labelCount = 3
        
        
        barChartView.legend.enabled = false
        barChartView.drawValueAboveBarEnabled = false
        barChartView.gridBackgroundColor = UIColor.whiteColor()
        barChartView.drawGridBackgroundEnabled = false
        barChartView.setScaleEnabled(false)
    }
    
    
    
    
}