//
//  FilterVC.swift
//  Nisagra
//
//  Created by Hari Krish on 30/07/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit
import RangeSeekSlider
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class FilterVC: UIViewController,RangeSeekSliderDelegate {

    @IBOutlet weak var mSortTF: CustomFontTextField!
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var mBackImageView : UIImageView!
    
    @IBOutlet weak var mPopularityBtn: UIButton!
    @IBOutlet weak var mNewBtn: UIButton!
    @IBOutlet weak var mHighBtn: UIButton!
    @IBOutlet weak var mLowBtn: UIButton!
    @IBOutlet weak var mNewSelect: UIImageView!
    @IBOutlet weak var mPopularitySelect: UIImageView!
    @IBOutlet weak var mHighSelect: UIImageView!
    @IBOutlet weak var mLowSelect: UIImageView!
    @IBOutlet weak var mSortView: UIView!
    var minDouble : CGFloat!
    var maxDouble : CGFloat!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mBackImageView.image = self.mBackImageView.image!.withRenderingMode(.alwaysTemplate)
        self.mBackImageView.tintColor = UIColor.black
        
        self.rangeSlider.delegate = self 
        self.rangeSlider.minValue = 0
        self.rangeSlider.maxValue = 1000
        self.minDouble = 0
        self.maxDouble = 100
        self.mLowBtn.isSelected = false
        self.mLowSelect.image = UIImage(named: "Uncheckbox")
        self.mHighBtn.isSelected = false
        self.mHighSelect.image = UIImage(named: "Uncheckbox")
        self.mNewBtn.isSelected = false
        self.mNewSelect.image = UIImage(named: "Uncheckbox")
        self.mPopularityBtn.isSelected = false
        self.mPopularitySelect.image = UIImage(named: "Uncheckbox")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
     // MARK: - Btn Actions
    @IBAction func newBtnAction(_ sender: Any)
    {
        if(self.mNewBtn.isSelected)
        {
            self.mNewBtn.isSelected = false
            self.mNewSelect.image = UIImage(named: "Uncheckbox")
        }
        else
        {
            self.mNewBtn.isSelected = true
            self.mNewSelect.image = UIImage(named: "checkbox")
        }
    }
    @IBAction func popularityBtnAction(_ sender: Any)
    {
        if(self.mPopularityBtn.isSelected)
        {
            self.mPopularityBtn.isSelected = false
            self.mPopularitySelect.image = UIImage(named: "Uncheckbox")
        }
        else
        {
            self.mPopularityBtn.isSelected = true
            self.mPopularitySelect.image = UIImage(named: "checkbox")
        }
    }
    @IBAction func lowBtnAction(_ sender: Any)
    {
        if(self.mLowBtn.isSelected)
        {
            self.mLowBtn.isSelected = false
            self.mLowSelect.image = UIImage(named: "Uncheckbox")
        }
        else
        {
            self.mLowBtn.isSelected = true
            self.mLowSelect.image = UIImage(named: "checkbox")
        }
    }
    @IBAction func highBtnAction(_ sender: Any)
    {
        if(self.mHighBtn.isSelected)
        {
            self.mHighBtn.isSelected = false
            self.mHighSelect.image = UIImage(named: "Uncheckbox")
        }
        else
        {
            self.mHighBtn.isSelected = true
            self.mHighSelect.image = UIImage(named: "checkbox")
        }
    }
    
    @IBAction func sortBtnAction(_ sender: Any)
    {
        self.mSortView.isHidden = false
    }
    @IBAction func doneBtnAction(_ sender: Any)
    {
        self.mSortView.isHidden = true
    }
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func clearBtnAction(_ sender: Any)
    {
        reloadViewFromNib()
    }
    @IBAction func applyBtnAction(_ sender: Any)
    {
        var lowtoHigh = "0"
        var hightoLow = "0"
        var newest = "0"
        var popular = "0"
        if(self.mLowBtn.isSelected == true)
        {
            lowtoHigh = "1"
        }
        if(self.mHighBtn.isSelected == true)
        {
            hightoLow = "1"
        }
        if(self.mNewBtn.isSelected == true)
        {
            newest = "1"
        }
        if(self.mPopularityBtn.isSelected == true)
        {
            popular = "1"
        }
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/myprofile/FilterProduct",Constants.BASEURL)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "filter_low_to_high" : lowtoHigh,
            "filter_high_to_low" : hightoLow,
            "filter_newest" : newest,
            "filter_popularity" : popular,
            "min_price" : String(format : "%.2f",minDouble),
            "max_price" : String(format : "%.2f",maxDouble),
             "customer_id" : userID ?? "",
        ]
        print(parameters)
        let headers: HTTPHeaders =
            [
                "Content-Type": "application/json"
        ]
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
                            let responseArray =  JSON["result"] as? NSArray
                            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: responseArray!), forKey: "FilterData")
                            NotificationCenter.default.post(name: NSNotification.Name("FilteredData"), object: nil)
                            self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Slider
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSlider {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            self.minDouble = minValue
            self.maxDouble = maxValue
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
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
