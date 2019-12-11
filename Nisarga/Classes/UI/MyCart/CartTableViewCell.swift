//
//  CartTableViewCell.swift
//  ECommerce
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var cartnameLabel: UILabel!
    @IBOutlet weak var cartprice: UILabel!
    @IBOutlet weak var cartAttributeLabel: UILabel!
    @IBOutlet weak var  mWishListBtn : UIButton!
    @IBOutlet weak var mGramTF: UITextField!
    @IBOutlet weak var mCartView : UIView!
    @IBOutlet weak var mPlusBtn: UIButton!
    @IBOutlet weak var mMinusBtn: UIButton!
    @IBOutlet weak var mCartCountLabel : UILabel!
    @IBOutlet weak var mAddView : UIView!
    @IBOutlet weak var mAddBtn : UIButton!
    @IBOutlet weak var mPlusImageView : UIImageView!
    @IBOutlet weak var mMinusImageView : UIImageView!
    @IBOutlet weak var wishListImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.mAddView.layer.cornerRadius = 5
        self.mAddView.layer.borderColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0).cgColor
        self.mAddView.layer.borderWidth = 1
        
        self.mPlusImageView.image = self.mPlusImageView.image!.withRenderingMode(.alwaysTemplate)
        self.mMinusImageView.image = self.mMinusImageView.image!.withRenderingMode(.alwaysTemplate)
        
        self.mPlusImageView.tintColor = UIColor.white
        self.mMinusImageView.tintColor = UIColor.white
    }
    
    @IBAction func cartsegmentControl(_ sender: UISegmentedControl) {
    }
}
