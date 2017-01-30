//
//  UserRequestsCell.swift
//  RealTimeParkingBookingSystem
//
//  Created by Nasrullah Khan on 28/01/2017.
//  Copyright © 2017 Nasrullah Khan. All rights reserved.
//

import UIKit

class UserRequestsCell: UITableViewCell {

    @IBOutlet weak var parkingName: UILabel!
    @IBOutlet weak var slotNo: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var totalHours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
