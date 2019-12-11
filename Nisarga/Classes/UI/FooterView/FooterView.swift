//
//  FooterView.swift
//  Dhukan
//
//  Created by Suganya on 7/27/18.
//  Copyright © 2018 Suganya. All rights reserved.
//

import UIKit

class FooterView: UIView {

  
    @IBOutlet weak var mWalletImageView: UIImageView!
    @IBOutlet weak var mWishListImageView: UIImageView!
    @IBOutlet weak var mCategoryImageView: UIImageView!
    @IBOutlet weak var mHomeImageView: UIImageView!
    @IBOutlet var contentView: UIView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit()
    {
        Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        mHomeImageView.image = mHomeImageView.image!.withRenderingMode(.alwaysTemplate)
        mCategoryImageView.image = mCategoryImageView.image!.withRenderingMode(.alwaysTemplate)
        mWishListImageView.image = mWishListImageView.image!.withRenderingMode(.alwaysTemplate)
        mWalletImageView.image = mWalletImageView.image!.withRenderingMode(.alwaysTemplate)
        var selectedTab =  UserDefaults.standard.string(forKey: "SelectedTab") as? String
        
        if(selectedTab == "Home" || selectedTab == nil || selectedTab == "HomeList")
        {
            //mHomeImageView.tintColor = UIColor(red:1.00, green:0.82, blue:0.10, alpha:1.0)
            mHomeImageView.image = UIImage(named: "Home")
            mCategoryImageView.tintColor = UIColor.black
            mWishListImageView.tintColor = UIColor.black
            mWalletImageView.tintColor = UIColor.black
        }
        else if(selectedTab == "Categories")
        {
            mHomeImageView.tintColor = UIColor.darkGray
            mCategoryImageView.tintColor = UIColor(red:1.00, green:0.82, blue:0.10, alpha:1.0)
            mWishListImageView.tintColor = UIColor.darkGray
            mWalletImageView.tintColor = UIColor.darkGray
        }
        else if(selectedTab == "WishList")
        {
            mHomeImageView.tintColor = UIColor.darkGray
            mCategoryImageView.tintColor = UIColor.darkGray
            mWishListImageView.tintColor = UIColor(red:1.00, green:0.82, blue:0.10, alpha:1.0)
            mWalletImageView.tintColor = UIColor.darkGray
        }
        else if(selectedTab == "Wallet")
        {
            mHomeImageView.tintColor = UIColor.darkGray
            mCategoryImageView.tintColor = UIColor.darkGray
            mWishListImageView.tintColor = UIColor.darkGray
            mWalletImageView.tintColor = UIColor(red:1.00, green:0.82, blue:0.10, alpha:1.0)
        }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        let b = sender as? UIButton
        customButtonPressed(Int(b?.tag ?? 0))
    }
    func customButtonPressed(_ buttonTag: Int)
    {
        var selectedTab =  UserDefaults.standard.string(forKey: "SelectedTab")
        for i in 1..<5 {
            let b = viewWithTag(i) as? UIButton
            if b?.tag == buttonTag {
                if b?.tag == 1
               {
                 if(selectedTab == "Home")
                 {
                       return
                }
                UserDefaults.standard.setValue("Home", forKey: "SelectedTab")
                  if !(self.appDelegate?.mNavCtrl?.visibleViewController is HomeVC) {
                   self.appDelegate?.goToHome()
                   }
                }
            else if b?.tag == 2
               {
                if(selectedTab == "Categories")
                   {
                       return
                   }
                   UserDefaults.standard.setValue("Categories", forKey: "SelectedTab")
                   self.appDelegate?.goToCategories()
                  }
            
                else if b?.tag == 3
                {
                    if(selectedTab == "WishList")
                    {
                        return
                    }
                    UserDefaults.standard.setValue("WishList", forKey: "SelectedTab")
                    self.appDelegate?.goToWishList()
                }
                else if b?.tag == 4
                {
                    if(selectedTab == "Wallet")
                    {
                        return
                    }
                    UserDefaults.standard.setValue("Wallet", forKey: "SelectedTab")
                    self.appDelegate?.goToWallet()
                }
            }
        }
        }
    func buttonPressed(_ buttonTag: Int)
    {
        for i in 1..<5
        {
            let b = viewWithTag(i) as? UIButton
            if b?.tag != buttonTag
            {
                // b.alpha=1.0;
                b?.isUserInteractionEnabled = true
            } else
            {
                //b.alpha=0.5;
                b?.isUserInteractionEnabled = false
            }
        }
    }
    func buttonsUserInteractionEnable()
    {
        for i in 1..<5
        {
            let b = viewWithTag(i) as? UIButton
            b?.alpha = 1.0
            b?.isUserInteractionEnabled = true
        }
    }

}





