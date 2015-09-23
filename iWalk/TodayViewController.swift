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
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var circularProgressView: KDCircularProgress!
    @IBOutlet weak var goalLabel: UITextField!
    
    
    // MARK: Constants
    let healthKitManager = HealthKitManager.instance
    let todayModel = TodayModel.instance
    let pedometer = Pedometer.instance
    
    // MARK: Variables
    var sessionMode = false
    var subscriptions = [NSObjectProtocol]()
    var timer : NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        healthKitManager.authorizeHealthKit()
        
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
        makeNavigationBar()
        if sessionMode {
            loadSessionMode()
        }
        else {
            loadTodayMode()
        }
    }
    
    func makeNavigationBar() {
        if(sessionMode) {
            let doneButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "saveSession")
            let cancelButton =  UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "changeMode")
            
            navigationBar.title = "Live Session"
            navigationBar.rightBarButtonItem = doneButton
            navigationBar.leftBarButtonItem = cancelButton
        }
        else {
            let sessionButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "changeMode")
            
            navigationBar.title = "Today"
            navigationBar.rightBarButtonItem = sessionButton
            navigationBar.leftBarButtonItem = nil
        }
    }
    
    func loadSessionMode() {
        
        
        // Notifications Subscription
        subscriptions.append(NSNotificationCenter.defaultCenter().addObserverForName(Notifications.session.stepsUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderSessionData))
        subscriptions.append(NSNotificationCenter.defaultCenter().addObserverForName(Notifications.today.stepsDistributionUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderSessionData))
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "renderSessionData", userInfo: nil, repeats: true)
        
        // Queries
        todayModel.fetchSessionValues()
        
        // Render Session Related Data
        renderSessionData()
    }
    
    func loadTodayMode() {
        
        
        // Notifications Subscription
        subscriptions.append(NSNotificationCenter.defaultCenter().addObserverForName(Notifications.today.stepsUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderTodayData))
        subscriptions.append(NSNotificationCenter.defaultCenter().addObserverForName(Notifications.today.caloriesUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderTodayData))
        subscriptions.append(NSNotificationCenter.defaultCenter().addObserverForName(Notifications.today.distanceUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderTodayData))
        subscriptions.append(NSNotificationCenter.defaultCenter().addObserverForName(Notifications.today.timeUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderTodayData))
        subscriptions.append(NSNotificationCenter.defaultCenter().addObserverForName(Notifications.today.stepsDistributionUpdated, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: renderTodayData))
        
        // Queries
        todayModel.fetchTodayValues()
        
        // Render Session Related Data
        renderTodayData()
    }
    
    // MARK: Change Mode
    func changeMode() {
        unsubscribe()
        stopQueries()
        if let _ = timer {
            timer?.invalidate()
        }
        sessionMode = !sessionMode
        loadPage()
    }
    
    func stopQueries() {
        if(sessionMode) {
            pedometer.stopAccelerometer()
        }
        else {
            todayModel.stopQueries()
        }
    }
    
    func unsubscribe() {
        for s in subscriptions {
            NSNotificationCenter.defaultCenter().removeObserver(s)
        }
        subscriptions.removeAll()
    }
    
    func saveSession() {
        pedometer.saveSession()
        changeMode()
    }
    
    
    // MARK: Rendering
    func renderData() {
        if(sessionMode) {
            renderSessionData()
        }
        else {
            renderTodayData()
        }
    }
    
    
    func renderSessionData(notification: NSNotification) {
        renderSessionData()
    }
    
    func renderSessionData() {
        stepsLabel.text = String(format: "%.0f", pedometer.steps)
        caloriesLabel.text = String(format: "%.2f", pedometer.calories)
        distanceLabel.text = String(format: "%.2f", pedometer.distance)
        timeLabel.text = stringFromTimeInterval(pedometer.timerSec)
        if let values = todayModel.values {
            setChart(todayModel.labels, values: values)
        }
        
        updateGoalText()
        setProgressBar(pedometer.steps, max: pedometer.goal)
    }
    
    func renderTodayData(notification: NSNotification) {
        renderTodayData()
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
        
        updateGoalText()
        setProgressBar(Double(todayModel.stepsCount),max: todayModel.goal)
        
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if sessionMode {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        return String(format: "%dh:%dm", hours, minutes)
    }
    
    // MARK: Progress Bar
    func setProgressBar(current: Double, max: Double) {
        if(circularProgressView.isAnimating()) {
            return
        }
        
        let percentage = current/max
        let angle = percentage < 1.0 ? Int(percentage * 360.0) : 360
        circularProgressView.animateToAngle(angle, duration: 0.5, completion: nil)
    }
    
    // MARK: Bar Chart
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
    
    @IBAction func onStartEditingGoal(sender: UITextField) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "saveGoal")
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "resetContext")
        navigationBar.rightBarButtonItem = doneButton
        navigationBar.leftBarButtonItem = cancelButton
    }
    
    func saveGoal() {
        if let goal = goalLabel.text {
            if let goalValue = Double(goal) {
                if(sessionMode) {
                    pedometer.goal = goalValue
                }
                else {
                    todayModel.goal = goalValue
                }
                resetContext()
            }
        }
    }
    
    func resetContext() {
        goalLabel.resignFirstResponder()
        updateGoalText()
        makeNavigationBar()
        renderData()
        
    }
    
    func updateGoalText() {
        if goalLabel.isFirstResponder() {
            return
        }
        var goal : Double
        if(sessionMode) {
            goal = pedometer.goal
        }
        else {
            goal = todayModel.goal
        }
        goalLabel.text = ""
        goalLabel.placeholder = "Goal: " + Int(goal).addSpaceSeparator
    }
    
    
    
    
    
    
}