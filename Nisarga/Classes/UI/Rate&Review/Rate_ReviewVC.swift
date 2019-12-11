//
//  Rate&ReviewVC.swift
//  Nisarga
//
//  Created by Hari Krish on 11/09/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class Rate_ReviewVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var mRatingnumLabel : CustomFontLabel!
    @IBOutlet weak var mRatingpercentLabel : CustomFontLabel!
    @IBOutlet weak var mUserNameLabel : CustomFontLabel!
    @IBOutlet weak var mReviewTextview: UITextView!
    @IBOutlet weak var mWriteReviewBtn: CustomFontButton!
    @IBOutlet weak var mSubmitReviewBtn: CustomFontButton!
    @IBOutlet weak var mlikeBtn: CustomFontButton!
    @IBOutlet weak var mUnlikeBtn: CustomFontButton!
    @IBOutlet weak var mLikeImage : UIImageView!
    @IBOutlet weak var mUnLikeImage : UIImageView!
    @IBOutlet weak var mWriteView : UIView!
    @IBOutlet weak var writeViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var mRateTableView : UITableView!
    var reviewArray : NSArray = []
    var rate : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        self.mWriteView.isHidden = true
        self.writeViewHeight.constant = 0
        self.mWriteReviewBtn.alpha = 1
        self.mReviewTextview.layer.cornerRadius = 5
        self.mReviewTextview.layer.borderColor = UIColor.lightGray.cgColor
        self.mReviewTextview.layer.borderWidth = 1
        self.mRateTableView.register(UINib(nibName: "rate_reviewTableCell", bundle: nil), forCellReuseIdentifier: "rate_reviewTableCell")
        self.mlikeBtn.isSelected = false
        self.mUnlikeBtn.isSelected = false
        getData()
        
//        var dataDict : NSDictionary = [:]
//        var data = UserDefaults.standard.object(forKey: "UserData") as? Data
//        if let aData = data {
//            dataDict = NSKeyedUnarchiver.unarchiveObject(with: aData) as! NSDictionary
//            print(dataDict)
//            self.mUserNameLabel.text =  String(format:"%@ %@",(dataDict["firstname"] as? String)!,(dataDict["lastname"] as? String)!)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Mark: - Btn Action
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func writeReviewBtnAction(_ sender: Any)
    {
        self.mWriteView.isHidden = false
        self.writeViewHeight.constant = 250
        self.mWriteReviewBtn.alpha = 0.8
    }
    @IBAction func mlikeBtn(_ sender: Any)
    {
        if(self.mlikeBtn.isSelected)
        {
            self.mlikeBtn.isSelected = false
            self.mLikeImage.image = UIImage(named: "Ratelike")
            
        }
        else
        {
            self.mlikeBtn.isSelected = true
            self.mLikeImage.image = UIImage(named: "Ratelike(green)")
            self.mUnlikeBtn.isSelected = false
            self.mUnLikeImage.image = UIImage(named: "Rateunlike")
            
        }
    }
    @IBAction func mUnlikeBtn(_ sender: Any)
    {
        if(self.mUnlikeBtn.isSelected)
        {
            self.mUnlikeBtn.isSelected = false
            self.mUnLikeImage.image = UIImage(named: "Rateunlike")
        }
        else
        {
            self.mUnlikeBtn.isSelected = true
            self.mUnLikeImage.image = UIImage(named: "Rateunlike(green)")
            self.mlikeBtn.isSelected = false
            self.mLikeImage.image = UIImage(named: "Ratelike")
            
        }
    }
    @IBAction func mSubmitReviewBtn(_ sender: Any)
    {
        if(self.mReviewTextview.text == "")
        {
            self.view.makeToast("Give Your Comments")
            return
        }
        submitReview()
    }
    // MARK: - API
    func getData()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/rateus/ret_us",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                ]
        print(parameters)
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                SKActivityIndicator.dismiss()
                switch(response.result) {
                    
                case .success:
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        if(JSON["status"] as? String == "success")
                        {
                            self.reviewArray = (JSON["result"] as? NSArray)!
                            self.mRateTableView.reloadData()
                            self.tableHeight.constant = CGFloat(self.reviewArray.count * 80);
                            
                            self.mRatingpercentLabel.text = String(format:"%@",(JSON["like_rate_in_percent"] as? String)!)
                            self.mRatingnumLabel.text = String(format:"%d Rating & %d Reviews",(JSON["nuber_of_users_rating"] as? Int)!,self.reviewArray.count)
                            self.mReviewTextview.text = String(format:"%@",(JSON["feedback"] as? String)!)
                            if(self.mReviewTextview.text == "")
                            {
                                
                            }
                            else
                            {
                                self.mWriteView.isHidden = false
                                self.writeViewHeight.constant = 250
                                self.mWriteReviewBtn.alpha = 0.8
                            }
                            let rate = String(format:"%@",(JSON["rated"] as? String)!)
                            if(rate == "0")
                            {
                                self.mUnlikeBtn.isSelected = true
                                self.mUnLikeImage.image = UIImage(named: "Rateunlike(green)")
                            }
                            else
                            {
                                self.mlikeBtn.isSelected = true
                                self.mLikeImage.image = UIImage(named: "Ratelike(green)")
                            }
                        }
                       
                        
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                        }
                        
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
    }

    func submitReview()
    {
        
        var rate :  String = ""
        if(self.mlikeBtn.isSelected)
        {
            rate = "1"
        }
        else if(self.mUnlikeBtn.isSelected)
        {
            rate = "0"
        }
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/rateus/giveRateUs",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "feedback" : self.mReviewTextview.text,
                "rate" : rate,
                ]
        print(parameters)
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                print(response)
                SKActivityIndicator.dismiss()
                switch(response.result) {
                    
                case .success:
                    if let json = response.result.value
                    {
                        let JSON = json as! NSDictionary
                        print(JSON)
                        self.view.makeToast(JSON["message"] as? String)
                        self.mReviewTextview.text = ""
                        self.mlikeBtn.isSelected = false
                        self.mLikeImage.image = UIImage(named: "Ratelike")
                        self.mUnlikeBtn.isSelected = false
                        self.mUnLikeImage.image = UIImage(named: "Rateunlike")
                        self.getData()
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
    }
    
    // MARK: - TableView Delegates
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return self.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rate_reviewTableCell", for: indexPath) as! rate_reviewTableCell
        cell.selectionStyle = .none
        let dict = self.reviewArray[indexPath.section] as? NSDictionary
        cell.mNameLabel.text = String(format:"%@ %@",(dict!["firstname"] as? String)!,(dict!["firstname"] as? String)!)
        cell.mDescriptionLabel.text = dict!["feedback"] as? String
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE yyyy"
        
        let date: NSDate? = dateFormatterGet.date(from: (dict![ "date_added"] as? String)!)! as NSDate
        print(dateFormatterPrint.string(from: date! as Date))
        cell.mDateLabel.text = String(format :"%@",dateFormatterPrint.string(from: date! as Date))
        return cell;
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
