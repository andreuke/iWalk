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
    var info = [String:String]()
    var ranges = [String:[String]]()
    var pickerViewList : [UIPickerView] = []


    var textFields : [UITextField] = []

    // MARK: Inizialization
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func fetchUserInfo() {
        let user = UserInfo()
        info = user!.info
        ranges = user!.ranges
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
        return info.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MeTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MeTableViewCell
        
        let index = indexPath.row
        
        let currentKey = Array(info.keys)[index]
        let currentValue = Array(info.values)[index]
        
        
        // Fill the cell components
        cell.keyLabel.text = currentKey
        cell.valueLabel.text = currentValue
        
        // Set correct pickerView as input method for the valueLabel
        cell.valueLabel.inputView = pickerViewList[index]
        textFields.insert(cell.valueLabel, atIndex:index)

        
        return cell
    }

    
    // MARK: UIPickerView controls
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Array(ranges.values)[pickerView.tag].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array(ranges.values)[pickerView.tag][row]

    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let field = textFields[pickerView.tag]
        field.text = Array(ranges.values)[pickerView.tag][row]
        field.resignFirstResponder()
    }
    
    func disableTextFields() {
        for textField in textFields {
            textField.enabled = false
        }

    }

    
    
    
    }
