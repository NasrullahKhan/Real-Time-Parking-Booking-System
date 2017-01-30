//
//  UserMainController.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 27/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit
import RxSwift

class UserMainController: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tableView: UITableView!
    var parkings = [String: ParkingArea]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Parking Areas"
        
        ParkingServices.getParkingAreas { (error) in
            if error != nil {
                
            }else {
                
            }
        }
        
        User.sharedParkings.asObservable().subscribe { (parkingDict) in
            for data in parkingDict.element! {
                self.parkings[data.value.parkingID!] = data.value
            }
            self.tableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.parkings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "parkingCellIdentifier", for: indexPath) as! ParkingCell
        
        let parkingArea = Array(self.parkings.values)[indexPath.row]
        
        cell.areaName.text = parkingArea.areaName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let parkingArea = Array(self.parkings.values)[indexPath.row]
        self.performSegue(withIdentifier: "goToSlotVC", sender: parkingArea)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let parking = sender as? ParkingArea{
            let dest = segue.destination as! SlotsViewController
            dest.selectedParkingID = parking.parkingID!
        }
        
    }
 

}
