//
//  detailsTableViewCell.swift
//  Google Book v2.0
//
//  Created by user on 09.06.16.
//  Copyright © 2016 Roborzoid. All rights reserved.
//

import UIKit

class detailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var descrition: UILabel!
    
    @IBOutlet weak var author: UILabel!
    
    
    @IBOutlet weak var publisher: UILabel!
    
    
    @IBOutlet weak var thumImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
 

}
