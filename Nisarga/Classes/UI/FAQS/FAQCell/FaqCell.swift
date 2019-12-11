//
//  FaqCell.swift
//  Nisarga
//
//  Created by Suganya on 8/12/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class FaqCell: UITableViewCell {

    @IBOutlet weak var mQuestionLabel: CustomFontLabel!
    @IBOutlet weak var mDescriptionLabel: CustomFontLabel!
    @IBOutlet weak var mAnswerLabel: CustomFontLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
