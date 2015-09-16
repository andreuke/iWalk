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
    var info = [UpdatableInformation?]()
    var ranges = [[String]]()
    var pickerViewList : [UIPickerView] = []
    let userInfo = UserInfo.instance


    var textFields : [UITextField] = []

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
        
        // Create pickerViews according to data in UserInfo
        for i in 0..<info.count {
            let pickerView = UIPickerView()
            pickerView.delegate = self
            pickerView.tag = i
            pickerViewList.insert(pickerView, atIndex: pickerView.tag)
        }


    }
    
    // MARK: Deinizialitaion
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func fetchUserInfo() {
        userInfo!.fetchAllInfo()
        info = userInfo!.info
        ranges = userInfo!.ranges
    }
    
    
    
    // MARK: Actions
    @IBAction func onEditClick(sender: UIBarButtonItem) {
        // Change Navigation bar buttons
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "saveChanges")
        
        let cancelButton =  UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "discardChanges")
        navigationBar.rightBarButtonItem = doneButton
        navigationBar.leftBarButtonItem = cancelButton
        for textField in textFields {
            textField.enabled = true
        }
        
    }
    
    func saveChanges() {
        // TODO: save data
        exitEditMode()
    }
    
    func discardChanges() {
        // TODO: discard changes
        exitEditMode()
    }
    
    func restoreNavigationBar() {
        navigationBar.rightBarButtonItem = rightButton
        navigationBar.leftBarButtonItem = leftButton
    }
    
    func exitEditMode() {
        disableTextFields()
        restoreNavigationBar()
    }
    
    // MARK: TableView controls
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UserInfo.instance?.tableView = tableView
        return info.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MeTableViewCell
        
        let index = indexPath.row
        
        let currentKey = UserInfo.Attribute(rawValue: index)?.description
        let currentValue = info[index]?.value
        
        
        // Fill the cell components
        cell.keyLabel.text = currentKey
        cell.valueLabel.text = currentValue != nil ? currentValue : "Not Set"
        
        // Set correct pickerView as input method for the valueLabel
        cell.valueLabel.inputView = pickerViewList[index]
        textFields.insert(cell.valueLabel, atIndex:index)

        
        return cell
    }
    
    func reloadTable() {
        info = userInfo!.info
        self.tableView.reloadData()
    }

    
    // MARK: UIPickerView controls
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ranges[pickerView.tag].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ranges[pickerView.tag][row]

    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let field = textFields[pickerView.tag]
        field.text = ranges[pickerView.tag][row]
        field.resignFirstResponder()
    }
    
    func disableTextFields() {
        for textField in textFields {
            textField.enabled = false
        }

    }

    
    
    
    }
