//
//  MyOrderVC.swift
//  ECommerce
//
//  Created by Apple on 25/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import Toast_Swift
import SKActivityIndicatorView
class MyOrderVC:UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var myOrdertableview: UITableView!
    @IBOutlet weak var reOrderPopUpView : UIView!
    @IBOutlet var cancelPopUpView: UIView!
    var orderArray : NSArray = []
    @IBOutlet weak var mCancelBtn : CustomFontButton!
    @IBOutlet weak var mReorderCancelBtn : CustomFontButton!
    
    var cancelIndex : Int?
    var mOrderID : String!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Do any additional setup after loading the view.
        myOrdertableview.register(UINib(nibName: "MyOrderTableViewCell", bundle: .main), forCellReuseIdentifier: "MyOrderTableViewCell")
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.myOrdertableview.addSubview(refreshControl)
        getMyOrders()
    }
    // MARK: - API
    
func getMyOrders()
    {
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? ""
            //"customer_id" : "1"
        ]
        print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        let Url = String(format: "%@api/order/cusOrder",Constants.BASEURL)
        print(Url)
        SKActivityIndicator.show("Loading...")
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
                        self.orderArray = (JSON["result"] as? NSArray)!
                        self.myOrdertableview.reloadData()
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
    
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MyOrderTableViewCell =  myOrdertableview.dequeueReusableCell(withIdentifier: "MyOrderTableViewCell", for: indexPath) as!MyOrderTableViewCell
        
        cell.mBgView.layer.shadowColor = UIColor.gray.cgColor
        cell.mBgView.layer.shadowOffset = CGSize (width: 0, height: 3)
        cell.mBgView.layer.shadowOpacity = 0.6
        cell.mBgView.layer.shadowRadius = 3.0
        cell.mBgView.layer.cornerRadius = 5.0
        
        let dict = self.orderArray [indexPath.row] as? NSDictionary
        cell.OrderNumberlabel.text = String(format : "Order Id : %@",(dict![ "order_id"] as? String)!)
        
        cell.OrderStatuslabel.text = dict!["status"] as? String
        let todayDate = Date()
        let deliveryDateString = dict!["delivery_date"] as? String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let deliveryDate = dateFormatter.date(from:deliveryDateString!)
        
        let cancel =  dict!["cancel"] as? String
        if(cancel == "0")
        {
            cell.mCancelBtn.isHidden = true
        }
        else{
            cell.mCancelBtn.isHidden = false
            let calendar = Calendar.current
            if(calendar.isDateInTomorrow(deliveryDate!))
            {
                NSLog("Yes Tomorrow")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm"
                let currentTime: String = dateFormatter.string(from: todayDate)
                print("My Current Time is \(currentTime)")
                if(currentTime >= "04:00")
                {
                    cell.mCancelBtn.isHidden = true
                }
            }
    }
//        let cancel =  dict!["cancel"] as? String
//        if(cancel == "0")
//        {
//            cell.mCancelBtn.isHidden = true
//        }
//        else{
//            cell.mCancelBtn.isHidden = false
//        }
        let paynow =  dict!["payment_status"] as? String
        if(paynow == "0")
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let DateInFormat = dateFormatter.string(from: todayDate)
            let convertedTodayDate = dateFormatter.date(from:DateInFormat)
            if(convertedTodayDate == deliveryDate)
            {
                cell.mPayNowBtn.isHidden = false
            }
            else
            {
                cell.mPayNowBtn.isHidden = true
            }
        }
        else{
            cell.mPayNowBtn.isHidden = true
        }
        if(dict!["status"] as? String == "Pending")
        {
            cell.OrderStatuslabel.textColor = UIColor(red:0.99, green:0.47, blue:0.21, alpha:1.0)
        }
        else if(dict!["status"] as? String == "Canceled")
        {
            cell.OrderStatuslabel.textColor = UIColor.red
        }
        else if(dict!["status"] as? String == "Processed")
        {
            cell.OrderStatuslabel.text = "Delivered"
            cell.OrderStatuslabel.textColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0)
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEE,MMM d,yy"
        
        let date: NSDate? = dateFormatterGet.date(from: (dict![ "delivery_date"] as? String)!)! as NSDate
        print(dateFormatterPrint.string(from: date! as Date))
        cell.OrderDatelabel.text = String(format :"Delivered on %@",dateFormatterPrint.string(from: date! as Date))
        if(dict!["status"] as? String == "Canceled")
        {
            cell.OrderDatelabel.text = "Order Canceled"
        }
        print(dateFormatterPrint.string(from: date! as Date))
        cell.mCancelBtn.tag = indexPath.row
        cell.mCancelBtn.addTarget(self, action:#selector(cancelBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mReorderBtn.tag = indexPath.row
        cell.mReorderBtn.addTarget(self, action:#selector(reOrderBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mDetailsBtn.tag = indexPath.row
        cell.mDetailsBtn.addTarget(self, action:#selector(detailsBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mPayNowBtn.tag = indexPath.row
        cell.mPayNowBtn.addTarget(self, action:#selector(payNowBtnAction(_:)), for: UIControlEvents.touchUpInside)
        
        return cell
        
    }
    // MARK: - Btn Action
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @IBAction func faqBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @objc func cancelBtnAction (_ sender: UIButton)
    {
        cancelIndex = sender.tag
        self.mCancelBtn.layer.cornerRadius = 5
        self.mCancelBtn.layer.borderWidth = 1
        self.mCancelBtn.layer.borderColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0).cgColor
        self.cancelPopUpView.frame = self.view.frame
        self.view .addSubview(self.cancelPopUpView)
    }
    @objc func reOrderBtnAction (_ sender: UIButton)
    {
        let dict = self.orderArray [sender.tag] as? NSDictionary
        let orderID = dict![ "order_id"] as? String
        mOrderID = orderID
        self.mReorderCancelBtn.layer.cornerRadius = 5
        self.mReorderCancelBtn.layer.borderWidth = 1
        self.mReorderCancelBtn.layer.borderColor = UIColor(red:0.20, green:0.47, blue:0.24, alpha:1.0).cgColor
        self.reOrderPopUpView.frame = self.view.frame
        self.view .addSubview(self.reOrderPopUpView)
    }
    @objc func detailsBtnAction (_ sender: UIButton)
    {
        let dict = self.orderArray [sender.tag] as? NSDictionary
        let orderID = dict![ "order_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ItemsDetailsVC") as? ItemsDetailsVC
        myVC?.orderID = orderID
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @objc func payNowBtnAction (_ sender: UIButton)
    {
        let dict = self.orderArray [sender.tag] as? NSDictionary
        let orderID = dict![ "order_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "CheckOutPayNowVC") as? CheckOutPayNowVC
        myVC?.orderID = orderID
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @IBAction func closeBtnAction(_ sender: UIButton)
    {
        self.reOrderPopUpView.removeFromSuperview()
        self.cancelPopUpView.removeFromSuperview()
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        getMyOrders()
        self.refreshControl.endRefreshing()
    }
    @IBAction func confirmBtnAction(_ sender: UIButton)
    {
        self.cancelPopUpView.removeFromSuperview()
        let dict = self.orderArray [cancelIndex!] as? NSDictionary
        let orderID = dict![ "order_id"] as? String
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let Url = String(format: "%@api/custom/CancelOrder",Constants.BASEURL)
        print(Url)
        let parameters: Parameters =
        [
            "order_id" : orderID ?? "",
            "customer_id" : userID ?? ""
        ]
        print (parameters)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        SKActivityIndicator.show("Loading...")
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
                            self.view.makeToast(JSON["message"] as? String)
                            self.getMyOrders()
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
    @IBAction func checkBtnAction(_ sender: UIButton)
    {
        self.reOrderPopUpView.removeFromSuperview()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "OrderItemsVC") as? OrderItemsVC
        myVC?.orderID = mOrderID
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

