//
//  SearchCell.swift
//  Nisagra
//
//  Created by Hari Krish on 28/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var mImageView : UIImageView!
    @IBOutlet weak var mTitleLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
