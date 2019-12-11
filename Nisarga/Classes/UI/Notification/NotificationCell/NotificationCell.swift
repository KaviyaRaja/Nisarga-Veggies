//
//  NotificationCell.swift
//  Nisarga
//
//  Created by Hari Krish on 05/08/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var mWarningImage: UIImageView!
    @IBOutlet weak var mDateLabel: CustomFontLabel!
    @IBOutlet weak var mDescriptionLabel: CustomFontLabel!
    @IBOutlet weak var mTimeLabel: CustomFontLabel!
    @IBOutlet weak var mDayLabel: CustomFontLabel!
    @IBOutlet weak var mBgView : UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.mDescriptionLabel.sizeToFit()
        // Configure the view for the selected state
    }
    
}
