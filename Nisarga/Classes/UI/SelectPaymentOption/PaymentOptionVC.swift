//
//  PaymentOptionVC.swift
//  Nisagra
//
//  Created by Apple on 26/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PaymentOptionVC: UIViewController,UITableViewDelegate,UITableViewDataSource,iCarouselDataSource, iCarouselDelegate {
   

    @IBOutlet weak var mUpiBtn: UIButton!
    @IBOutlet weak var mDebitBtn: UIButton!
    @IBOutlet weak var mNetBtn: UIButton!
    @IBOutlet weak var mCreditBtn: UIButton!
    @IBOutlet weak var mCreditLabel : UILabel!
    @IBOutlet weak var mDebitLabel : UILabel!
    @IBOutlet weak var mNetLabel : UILabel!
    @IBOutlet weak var mUpiLabel : UILabel!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    @IBOutlet weak var creditHeight: NSLayoutConstraint!
    @IBOutlet weak var creditInnerHeight: NSLayoutConstraint!
    @IBOutlet weak var mCreditCardNoTF: CustomFontTextField!
    @IBOutlet weak var mCreditCardNameTF: CustomFontTextField!
    @IBOutlet weak var mCreditCardCvvTF: CustomFontTextField!
    @IBOutlet weak var mCreditCardExpiryTF: CustomFontTextField!
    @IBOutlet weak var mCreditSaveBtn: UIButton!
    @IBOutlet weak var mCreditInnerView: UIView!
    @IBOutlet weak var debitHeight: NSLayoutConstraint!
    @IBOutlet weak var debitInnerHeight: NSLayoutConstraint!
    @IBOutlet weak var mDebitCardNoTF: CustomFontTextField!
    @IBOutlet weak var mDebitCardNameTF: CustomFontTextField!
    @IBOutlet weak var mDebitCardCvvTF: CustomFontTextField!
    @IBOutlet weak var mDebitCardExpiryTF: CustomFontTextField!
    @IBOutlet weak var mDebitSaveBtn: UIButton!
    @IBOutlet weak var mDebitInnerView: UIView!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var netHeight: NSLayoutConstraint!
    @IBOutlet weak var upiHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var mUpiInnerView: UIView!
    @IBOutlet weak var upiInnerHeight: NSLayoutConstraint!
    @IBOutlet weak var mUpiTF: CustomFontTextField!
    
    @IBOutlet weak var mCarousel: iCarousel!
    let bankArray : NSArray = ["SBI","HDFC","ICICI Bank","Axis Bank"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mCarousel.type = .coverFlow2
        self.mCarousel.delegate = self
        self.mCarousel.dataSource = self
        // Do any additional setup after loading the view.
      setUI()
    }
    func setUI()
    {
        self.mCreditBtn.layer.cornerRadius = self.mCreditBtn.frame.size.width/2
        self.mCreditBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.mCreditBtn.layer.borderWidth = 1
        self.mCreditLabel.layer.cornerRadius = self.mCreditLabel.frame.size.width/2
        self.mCreditLabel.isHidden = true
        self.mCreditBtn.isSelected = false
        self.creditHeight.constant = 40
        self.mCreditInnerView.isHidden = true
        self.creditInnerHeight.constant = 0
        
        self.mDebitBtn.layer.cornerRadius = self.mCreditBtn.frame.size.width/2
        self.mDebitBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.mDebitBtn.layer.borderWidth = 1
        self.mDebitLabel.layer.cornerRadius = self.mCreditLabel.frame.size.width/2
        self.mDebitLabel.isHidden = true
        self.debitHeight.constant = 40
        self.mDebitInnerView.isHidden = true
        self.debitInnerHeight.constant = 0
        
        self.mNetBtn.isSelected = false
        self.mNetBtn.layer.cornerRadius = self.mCreditBtn.frame.size.width/2
        self.mNetBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.mNetBtn.layer.borderWidth = 1
        self.mNetLabel.layer.cornerRadius = self.mCreditLabel.frame.size.width/2
        self.mNetLabel.isHidden = true
        self.netHeight.constant = 40
        self.tableHeight.constant = 0
        self.mTableView.isHidden = true
        
        self.mUpiBtn.isSelected = false
        self.mUpiBtn.layer.cornerRadius = self.mCreditBtn.frame.size.width/2
        self.mUpiBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.mUpiBtn.layer.borderWidth = 1
        self.mUpiLabel.layer.cornerRadius = self.mCreditLabel.frame.size.width/2
        self.mUpiLabel.isHidden = true
        self.upiHeight.constant = 40
        self.upiInnerHeight.constant = 0
        self.mUpiInnerView.isHidden = true
        
        self.mUpiInnerView.layer.cornerRadius = 5
        self.mUpiInnerView.layer.borderWidth = 1
        self.mUpiInnerView.layer.borderColor = UIColor.lightGray.cgColor
        
        self.contentHeight.constant = self.creditHeight.constant + self.debitHeight.constant + self.netHeight.constant + self.upiHeight.constant + 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as! FAQSVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func proceedBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CompletePaymentVC") as! CompletePaymentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func creditSelectBtnAction(_ sender: Any)
    {
        if(self.mCreditBtn.isSelected)
        {
            self.mCreditBtn.isSelected = false
            self.mCreditLabel.isHidden = true
            self.creditHeight.constant = 40
            self.mCreditInnerView.isHidden = true
            self.creditInnerHeight.constant = 0
        }
        else
        {
            self.mCreditBtn.isSelected = true
            self.mCreditLabel.isHidden = false
            self.creditHeight.constant = 270
            self.mCreditInnerView.isHidden = false
            self.creditInnerHeight.constant = 230
            
            self.mDebitBtn.isSelected = false
            self.mDebitLabel.isHidden = true
            self.debitHeight.constant = 40
            self.mDebitInnerView.isHidden = true
            self.debitInnerHeight.constant = 0
            
            self.mNetBtn.isSelected = false
            self.mNetLabel.isHidden = true
            self.netHeight.constant = 40
            self.tableHeight.constant = 0
            self.mTableView.isHidden = true
            
            self.mUpiBtn.isSelected = false
            self.mUpiLabel.isHidden = true
            self.mUpiInnerView.isHidden = true
            self.upiInnerHeight.constant = 0
            self.upiHeight.constant = 40
        }
        self.contentHeight.constant = self.creditHeight.constant + self.debitHeight.constant + self.netHeight.constant + self.upiHeight.constant + 50
    }
    @IBAction func debitSelectBtnAction(_ sender: Any)
    {
        if(self.mDebitBtn.isSelected)
        {
            self.mDebitBtn.isSelected = false
            self.mDebitLabel.isHidden = true
            self.debitHeight.constant = 40
            self.mDebitInnerView.isHidden = true
            self.debitInnerHeight.constant = 0
        }
        else
        {
            self.mDebitBtn.isSelected = true
            self.mDebitLabel.isHidden = false
            self.debitHeight.constant = 270
            self.mDebitInnerView.isHidden = false
            self.debitInnerHeight.constant = 230
            
            self.mCreditBtn.isSelected = false
            self.mCreditLabel.isHidden = true
            self.creditHeight.constant = 40
            self.mCreditInnerView.isHidden = true
            self.creditInnerHeight.constant = 0
            
            self.mNetBtn.isSelected = false
            self.mNetLabel.isHidden = true
            self.netHeight.constant = 40
            self.tableHeight.constant = 0
            self.mTableView.isHidden = true
            
            self.mUpiBtn.isSelected = false
            self.mUpiLabel.isHidden = true
            self.mUpiInnerView.isHidden = true
            self.upiInnerHeight.constant = 0
            self.upiHeight.constant = 40
        }
        self.contentHeight.constant = self.creditHeight.constant + self.debitHeight.constant + self.netHeight.constant + self.upiHeight.constant + 50
    }
    @IBAction func netSelctBtnAction(_ sender: Any)
    {
        if(self.mNetBtn.isSelected)
        {
            self.mNetBtn.isSelected = false
            self.mNetLabel.isHidden = true
            self.netHeight.constant = 40
            self.tableHeight.constant = 0
            self.mTableView.isHidden = true
        }
        else
        {
            self.mNetBtn.isSelected = true
            self.mNetLabel.isHidden = false
            self.tableHeight.constant = CGFloat(self.bankArray.count * 44)
            self.mTableView.isHidden = false
            self.netHeight.constant = 40 + self.tableHeight.constant
            
            self.mDebitBtn.isSelected = false
            self.mDebitLabel.isHidden = true
            self.debitHeight.constant = 40
            self.mDebitInnerView.isHidden = true
            self.debitInnerHeight.constant = 0
            
            self.mCreditBtn.isSelected = false
            self.mCreditLabel.isHidden = true
            self.creditHeight.constant = 40
            self.mCreditInnerView.isHidden = true
            self.creditInnerHeight.constant = 0
            
            self.mUpiBtn.isSelected = false
            self.mUpiLabel.isHidden = true
            self.mUpiInnerView.isHidden = true
            self.upiInnerHeight.constant = 0
            self.upiHeight.constant = 40
        }
        self.contentHeight.constant = self.creditHeight.constant + self.debitHeight.constant + self.netHeight.constant + self.upiHeight.constant + 50
    }
    @IBAction func upiSelectBtnAction(_ sender: Any)
    {
        if(self.mUpiBtn.isSelected)
        {
            self.mUpiBtn.isSelected = false
            self.mUpiLabel.isHidden = true
            self.mUpiInnerView.isHidden = true
            self.upiInnerHeight.constant = 0
            self.upiHeight.constant = 40
        }
        else
        {
            self.mUpiBtn.isSelected = true
            self.mUpiLabel.isHidden = false
            self.mUpiInnerView.isHidden = false
            self.upiInnerHeight.constant = 50
            self.upiHeight.constant = 40 + self.upiInnerHeight.constant
            
            self.mDebitBtn.isSelected = false
            self.mDebitLabel.isHidden = true
            self.debitHeight.constant = 40
            self.mDebitInnerView.isHidden = true
            self.debitInnerHeight.constant = 0
            
            self.mCreditBtn.isSelected = false
            self.mCreditLabel.isHidden = true
            self.creditHeight.constant = 40
            self.mCreditInnerView.isHidden = true
            self.creditInnerHeight.constant = 0
            
            self.mNetBtn.isSelected = false
            self.mNetLabel.isHidden = true
            self.netHeight.constant = 40
            self.tableHeight.constant = 0
            self.mTableView.isHidden = true
        }
        self.contentHeight.constant = self.creditHeight.constant + self.debitHeight.constant + self.netHeight.constant + self.upiHeight.constant + 50
    }
    @IBAction func creditSaveBtnAction(_ sender: Any)
    {
        if(self.mCreditSaveBtn.isSelected)
        {
            self.mCreditSaveBtn.isSelected = false
            self.mCreditSaveBtn .setImage(UIImage(named: "checkbox"), for: .normal)
        }
        else
        {
            self.mCreditSaveBtn.isSelected = true
            self.mCreditSaveBtn .setImage(UIImage(named: "Uncheckbox"), for: .normal)
        }
    }
    @IBAction func debitSaveBtnAction(_ sender: Any)
    {
        if(self.mDebitSaveBtn.isSelected)
        {
            self.mDebitSaveBtn.isSelected = false
            self.mDebitSaveBtn .setImage(UIImage(named: "checkbox"), for: .normal)
        }
        else
        {
            self.mDebitSaveBtn.isSelected = true
            self.mDebitSaveBtn .setImage(UIImage(named: "Uncheckbox"), for: .normal)
        }
    }
    @IBAction func verifyBtnAction(_ sender: Any)
    {
        
    }
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        cell?.textLabel?.text = self.bankArray[indexPath.row] as? String
        cell?.textLabel?.font = UIFont(name: Constants.FONTNAME as String, size: 14)!
        cell?.textLabel?.textColor = UIColor.darkGray
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    // MARK: - Carousel Delegates
    func numberOfItems(in carousel: iCarousel) -> Int
    {
        return 5
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView
    {
        
        var nameLabel: UILabel
        var cardNumberLabel: UILabel
        var itemView: UIImageView
        var bgImgeView : UIImageView
        var deleteImageView : UIImageView
        var deleteBtn : UIButton
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.SCREEN_WIDTH - 30, height: 200))
            //itemView.image = UIImage(named: "Oval + Oval Mask")
            itemView.contentMode = .center
            
            bgImgeView = UIImageView(frame: itemView.bounds)
            bgImgeView.image = UIImage(named: "Oval + Oval Mask")
            bgImgeView.contentMode = .scaleToFill
            itemView.addSubview(bgImgeView)
            
            deleteImageView = UIImageView(frame: CGRect(x: itemView.frame.size.width - 40, y: 20, width: 30, height: 30))
            deleteImageView.image = UIImage(named: "Delete")
            deleteImageView.contentMode = .scaleAspectFit
            itemView.addSubview(deleteImageView)
            
            deleteBtn = UIButton(frame: CGRect(x: itemView.frame.size.width - 60, y: 0, width: 60, height: 50))
            deleteBtn.tag = index
            deleteBtn.titleLabel?.text = ""
            itemView.addSubview(deleteBtn)
            
            cardNumberLabel = UILabel(frame: CGRect(x: 30, y: 100, width: itemView.frame.size.width - 50, height: 30))
            cardNumberLabel.font = UIFont(name: "Roboto", size: 15)
            cardNumberLabel.text = "****         ****         ****       1234"
            itemView.addSubview(cardNumberLabel)
            
            nameLabel = UILabel(frame: CGRect(x: 30, y: 150, width: itemView.frame.size.width - 50, height: 30))
            nameLabel.font = UIFont(name: "Roboto", size: 15)
            nameLabel.text = "Ankit Rajpoot       Expire    12/28"
            itemView.addSubview(nameLabel)
        }
        
        return itemView
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
