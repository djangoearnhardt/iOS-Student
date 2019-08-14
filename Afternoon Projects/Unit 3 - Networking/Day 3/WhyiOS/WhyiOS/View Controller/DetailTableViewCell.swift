//
//  DetailTableViewCell.swift
//  WhyiOS
//
//  Created by Sam LoBue on 8/14/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit



class DetailTableViewCell: UITableViewCell {

    var representative: Representative? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    // MARK: - Helper Function
    
    func updateViews() {
        
        guard let representativeInfo = representative else { return }

        nameLabel.text = representativeInfo.name
        stateLabel.text = representativeInfo.state
        partyLabel.text = representativeInfo.party
        districtLabel.text = representativeInfo.district
        websiteLabel.text = representativeInfo.link
        phoneLabel.text = representativeInfo.phone
    }

}

//extension DetailTableViewCell: {
//    func update(representative: Representative) {
//        nameLabel.text = representativeInfo.name
//        stateLabel.text = representativeInfo.state
//        partyLabel.text = representativeInfo.party
//        districtLabel.text = representativeInfo.district
//        websiteLabel.text = representativeInfo.link
//        phoneLabel.text = representativeInfo.phone
//    }
//}
