//
//  MyBodyViewController.swift
//  iWalk
//
//  Created by Andrea Piscitello on 09/09/15.
//  Copyright © 2015 Giadrea. All rights reserved.
//
import UIKit

class MyBodyViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var rightButton : UIBarButtonItem?
    var leftButton : UIBarButtonItem?
    var pickerViewList : [UIPickerView?] = []
    var datePickerView = UIDatePicker()
    let userInfo = UserInfo.instance
    let healthKitManager = HealthKitManager.instance
    
    var textFields : [ClickableLabel] = []
    
    // MARK: Inizialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        // Subscribe to Notification Center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable", name: Notifications.weightUpdated, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable", name: Notifications.heightUpdated, object: nil)
        
        // Retrieve data to visualize
        fetchUserInfo()
        
        // Save left and right bar buttons for back them up after Done click
        rightButton = navigationBar.rightBarButtonItem
        leftButton = navigationBar.leftBarButtonItem
        
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.addTarget(self, action: "datePickerChanged", forControlEvents: UIControlEvents.ValueChanged)
        
        // Create pickerViews according to data in UserInfo skipping Birthday
        pickerViewList = [UIPickerView?](count: UserInfo.Attribute._count.rawValue, repeatedValue: nil)
        
        for i in 1..<UserInfo.Attribute._count.rawValue {
            let pickerView = UIPickerView()
            
            pickerView.delegate = self
            pickerView.tag = i
            pickerViewList[i] = pickerView
        }
        
        
    }
    
    // MARK: Deinizialitaion
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func fetchUserInfo() {
        userInfo!.fetchAllInfo()
        reloadTable()
    }
    
    
    
    // MARK: Actions
    @IBAction func onEditClick(sender: UIBarButtonItem) {
        // Change Navigation bar buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "saveChanges")
        
        let cancelButton =  UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "discardChanges")
        navigationBar.rightBarButtonItem = doneButton
        navigationBar.leftBarButtonItem = cancelButton
        
        textFieldsEnabled(true)
        
    }
    
    func saveChanges() {
        // Save Birthday
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let birthdayAndAge = textFields[UserInfo.Attribute.Birthday.rawValue].text
        let birthday = birthdayAndAge!.substringWithRange(Range<String.Index>(start: birthdayAndAge!.startIndex, end: advance((birthdayAndAge?.startIndex)!,10)))
        
        let birthdayDate = dateFormatter.dateFromString(birthday)
        if(!(birthdayDate == userInfo!.birthday)) {
            userInfo!.birthday = birthdayDate
            userInfo!.persistBirthday()
        }
        
        // Save Gender
        let gender = textFields[UserInfo.Attribute.Gender.rawValue].text
        if(gender != userInfo!.gender) {
            userInfo!.gender = gender
            userInfo!.persistGender()
        }
        
        // Save Height
        let heightString = textFields[UserInfo.Attribute.Height.rawValue].text
        let height = heightString!.substringWithRange(Range<String.Index>(start: heightString!.startIndex, end: advance((heightString?.endIndex)!,-3)))
        let heightDouble = (height as NSString).doubleValue
        let currentHeight = healthKitManager.heightDoubleFromSample(userInfo!.height!.value!)
        
        if(heightDouble != currentHeight) {
            let heightSample = healthKitManager.heightSampleFromDouble(heightDouble, date: NSDate())
            userInfo!.height = UpdatableInformation(value: heightSample, latestUpdate: heightSample.endDate)
            userInfo!.persistHeight()
        }
        
        // Save Weight
        let weightString = textFields[UserInfo.Attribute.Weight.rawValue].text
        let weight = weightString!.substringWithRange(Range<String.Index>(start: weightString!.startIndex, end: advance((weightString?.endIndex)!,-3)))
        let weightDouble = (weight as NSString).doubleValue
        let currentWeight = healthKitManager.weightDoubleFromSample(userInfo!.weight!.value!)
        
        if(weightDouble != currentWeight) {
            let weightSample = healthKitManager.weightSampleFromDouble(weightDouble, date: NSDate())
            userInfo!.weight = UpdatableInformation(value: weightSample, latestUpdate: weightSample.endDate)
            userInfo!.persistWeight()
        }

        
        
        exitEditMode()
    }
    
    func discardChanges() {
        reloadTable()
        exitEditMode()
    }
    
    func restoreNavigationBar() {
        navigationBar.rightBarButtonItem = rightButton
        navigationBar.leftBarButtonItem = leftButton
    }
    
    func exitEditMode() {
        textFieldsEnabled(false)
        restoreNavigationBar()
    }
    
    // MARK: TableView controls
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserInfo.instance?.tableView = tableView
        return UserInfo.Attribute._count.rawValue
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MeTableViewCell
        
        let index = indexPath.row
        
        let currentKey = UserInfo.Attribute(rawValue: index)?.description
        let currentValue = userInfo?.attributeString(index)
        
        
        // Fill the cell components
        cell.keyLabel.text = currentKey
        cell.valueLabel.text = currentValue != nil ? currentValue : "Not Set"
        
        // Set correct pickerView as input method for the valueLabel
        if(index == UserInfo.Attribute.Birthday.rawValue) {
            cell.valueLabel.inputView = datePickerView
        }
        else {
            cell.valueLabel.inputView = pickerViewList[index]
        }
        textFields.insert(cell.valueLabel, atIndex:index)
        
        
        return cell
    }
    
    func reloadTable() {
        self.tableView.reloadData()
        print("Reload Table")
    }
    
    
    // MARK: UIPickerView controls
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userInfo!.ranges[pickerView.tag].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return userInfo!.ranges[pickerView.tag][row]
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let field = textFields[pickerView.tag]
        field.text = userInfo!.ranges[pickerView.tag][row]
    }
    
    func textFieldsEnabled(enabled: Bool) {
        for textField in textFields {
            textField.enabled = enabled
            textField.userInteractionEnabled = enabled
        }
        
    }
    
    func datePickerChanged() {
        textFields[UserInfo.Attribute.Birthday.rawValue].text = datePickerView.date.toDateAndAgeString()
    }
    
    
    
    //        func getPeriodicData(dataType: Int, period: Int) {
    //            switch dataType {
    //            case 0: {
    //
    //                }
    //            }
    //        }
    
}
