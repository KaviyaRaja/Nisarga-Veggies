//
//  ListViewTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 12/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ListViewTableViewCell: UITableViewCell {

    @IBOutlet weak var listviewImage: UIImageView!
    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var listKgLabel: UILabel!
    @IBOutlet weak var listattributeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var wishListImage: UIImageView!
    @IBOutlet weak var  mWishListBtn : UIButton!
    @IBOutlet weak var mGramTF: IQDropDownTextField!
    @IBOutlet weak var mCartView : UIView!
    @IBOutlet weak var mPlusBtn: UIButton!
    @IBOutlet weak var mMinusBtn: UIButton!
    @IBOutlet weak var mCartCountLabel : UILabel!
    @IBOutlet weak var mAddView : UIView!
    @IBOutlet weak var mAddBtn : UIButton!
    @IBOutlet weak var mPlusImageView : UIImageView!
    @IBOutlet weak var mMinusImageView : UIImageView!
    @IBOutlet weak var mArrowImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mAddView.layer.cornerRadius = 5
        self.mAddView.layer.borderColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0).cgColor
        self.mAddView.layer.borderWidth = 1
        
        self.mPlusImageView.image = self.mPlusImageView.image!.withRenderingMode(.alwaysTemplate)
        self.mMinusImageView.image = self.mMinusImageView.image!.withRenderingMode(.alwaysTemplate)
        
        self.mPlusImageView.tintColor = UIColor.darkGray
        self.mMinusImageView.tintColor = UIColor.darkGray
        
    }

    
    }
    

