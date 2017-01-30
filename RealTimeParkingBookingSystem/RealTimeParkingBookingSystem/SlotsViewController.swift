//
//  SlotsViewController.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 27/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit
import SwiftMoment
import RxSwift

class SlotsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var data: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    
    var slots = [String: Slot]()
    var bookedSlots = [String:[Int]]()
    
    var datePicker = UIDatePicker()
    var startPicker = UIDatePicker()
    var endPicker = UIDatePicker()
    
    var selectedParkingID: String?
    var userSelectedSlotID: String = ""
    var totalNumber: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.borderColor = UIColor.black.cgColor
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        self.data.text = dateFormatter.string(from: Date())
        
        let startFormatter = DateFormatter()
        startFormatter.dateFormat = "HH"
        self.startTime.text = startFormatter.string(from: Date())
        
        self.totalNumber = Int(self.startTime.text!)! + Int(self.endTime.text!)!
        
        self.data.inputView = self.datePicker
        self.datePicker.datePickerMode = .date
        self.startTime.inputView = self.startPicker
        self.startPicker.datePickerMode = .time
        self.datePicker.addTarget(self, action: #selector(SlotsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        self.startPicker.addTarget(self, action: #selector(SlotsViewController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        _ = User.sharedParkings.asObservable().subscribe { (parkingDict) in
           
            if let parkingArea = parkingDict.element![self.selectedParkingID!]{
                for slot in  parkingArea.slots! {
                    self.slots[slot.slotID!] = slot
                }
                
                if self.slots.count == 4 {
                    
                    for slotKey in self.slots.keys {
                        ParkingServices.checkAbvailiblity(pID: self.selectedParkingID!, sID: slotKey, startTime: Int(self.startTime.text!)!, hours: Int(self.endTime.text!)!, date: self.data.text!, comletion: { (error) in
                            
                        })
                    }
                }
                self.tableView.reloadData()
            }
            
        }
        
        _ = User.bookedSlots.asObservable().subscribe({ (data) in
            self.bookedSlots = User.bookedSlots.value
            self.tableView.reloadData()
        })
        
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        switch sender {
        case self.datePicker:
           
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            self.data.text = dateFormatter.string(from: sender.date)
            
            cRef.child("parking-availablity/\(self.selectedParkingID!)").removeAllObservers()
            User.bookedSlots.value = [:]
            
            for slotKey in self.slots.keys {
                ParkingServices.checkAbvailiblity(pID: self.selectedParkingID!, sID: slotKey, startTime: Int(self.startTime.text!)!, hours: Int(self.endTime.text!)!, date: self.data.text!, comletion: { (error) in
                    
                })
            }
            
        case self.startPicker:
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            self.startTime.text = dateFormatter.string(from: sender.date)
       
            self.totalNumber = Int(self.startTime.text!)! + Int(self.endTime.text!)!
            
            self.tableView.reloadData()
        default:
            break
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == self.endTime {
            self.totalNumber = Int(self.startTime.text!)! + Int(self.endTime.text!)!
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func bookingTapped(_ sender: Any) {
        
        if self.userSelectedSlotID == ""{ self.showAlert(title: "Hint", msg: "Select Any Available Slot"); return }
        
        ParkingServices.allocateSlot(uID: User.sharedUser.value!.uID! , pID: self.selectedParkingID!, sID: self.userSelectedSlotID, startTime: Int(self.startTime.text!)!, hours: Int(self.endTime.text!)!, date: self.data.text!) { (error) in
            if error != nil {
                self.showAlert(title: "ERROR", msg: error!)
            }else {
                self.userSelectedSlotID = ""
                self.showAlert(title: "Success", msg: "Slot is booked")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.slots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "slotCellIdentifier", for: indexPath) as! SlotCell
        
        let slot = Array(self.slots.values)[indexPath.row]
        
        cell.backgroundColor = UIColor.green
        cell.isUserInteractionEnabled = true
        
        if self.bookedSlots[slot.slotID!] != nil {
            
                for number in Int(self.startTime.text!)!..<totalNumber {
                    if self.bookedSlots[slot.slotID!]!.contains(number){
                        
                        cell.backgroundColor = UIColor.yellow
                        cell.isUserInteractionEnabled = false
                        break
                    }else {
                        cell.isUserInteractionEnabled = true
                        cell.backgroundColor = UIColor.green
                    }
                }
        }
        
        cell.slotNo.text = slot.slotNo
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let slot = Array(self.slots.values)[indexPath.row]
        self.userSelectedSlotID = slot.slotID!
    }
}
