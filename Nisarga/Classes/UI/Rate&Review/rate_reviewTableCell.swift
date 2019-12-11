//
//  rate&reviewTableCell.swift
//  Nisarga
//
//  Created by Hari Krish on 11/09/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class rate_reviewTableCell: UITableViewCell {
    
    @IBOutlet weak var mDateLabel : CustomFontLabel!
    @IBOutlet weak var mDescriptionLabel : CustomFontLabel!
    @IBOutlet weak var mNameLabel : CustomFontLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
