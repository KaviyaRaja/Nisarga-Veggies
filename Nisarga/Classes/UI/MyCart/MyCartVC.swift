//
//  MyCartVC.swift
//  ECommerce
//
//  Created by Apple on 22/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class MyCartVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
   
    @IBOutlet weak var cartTableview: UITableView!
    @IBOutlet weak var mCartEmptyView : UIView!
    @IBOutlet weak var mCountLabel : CustomFontLabel!
    @IBOutlet weak var mNameLabel : CustomFontLabel!
    @IBOutlet weak var mTotalLabel : CustomFontLabel!
    
    @IBOutlet weak var mDateTF: IQDropDownTextField!
    @IBOutlet var mPopupView: UIView!
    var cartArray : NSArray = []
    var refreshControl = UIRefreshControl()
    var orderID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartTableview.register(UINib(nibName: "CartTableViewCell", bundle: .main), forCellReuseIdentifier: "CartTableViewCell")
        mCartEmptyView.isHidden = true
        self.mDateTF.addBorder()
        self.mDateTF.setLeftPaddingPoints(10)
      
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getCart()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.cartTableview.addSubview(refreshControl)
    }
    
    // MARK: - Btn Action
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func checkOutBtnAction(_ sender: UIButton)
    {
        self.mPopupView.frame = self.view.frame
        self.view.addSubview(self.mPopupView)
        
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: NSDate() as Date)
        var arrDates = [String]()
        for i in 1 ... 3 {
            
            date = cal.date(byAdding: .day, value: 1, to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        self.mDateTF.itemList = arrDates
        
    }
    @IBAction func deliveryBtnAction(_ sender: UIButton)
    {
        self.mPopupView.frame = self.view.frame
        self.view.addSubview(self.mPopupView)
        
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: NSDate() as Date)
        var arrDates = [String]()
        for i in 1 ... 3 {
            
            date = cal.date(byAdding: .day, value: 1, to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        self.mDateTF.itemList = arrDates
    }
    @IBAction func shopNowBtnAction(_ sender: UIButton)
    {
        Constants.appDelegate?.goToHome()
    }
  
    @IBAction func closeBtnAction(_ sender: Any)
    {
        self.mPopupView.removeFromSuperview()
    }
    @IBAction func scheduleBtnAction(_ sender: Any)
    {
        self.mPopupView.removeFromSuperview()
        if(self.mDateTF.selectedItem == "" || self.mDateTF.selectedItem == nil)
        {
            self.view.makeToast("Please Choose Delivery Date")
            return
        }
        
        let selectedRow = self.mDateTF.selectedRow
        let cal = NSCalendar.current
        var date = cal.startOfDay(for: NSDate() as Date)
        var arrDates = [String]()
        for i in 1 ... 3 {
            
            date = cal.date(byAdding: .day, value: 1, to: date)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-YYYY"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        print(arrDates)
        UserDefaults.standard.setValue(arrDates[selectedRow] as? String, forKey: "DeliveryDay")
        UserDefaults.standard.setValue(self.mDateTF.selectedItem, forKey: "DeliveryDate")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShippingVC") as! ShippingVC
        vc.deliveryDate = self.mDateTF.selectedItem
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func faqBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        getCart()
        self.refreshControl.endRefreshing()
    }
    
    
    // MARK: - API
    func getCart()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/cart/products&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
           // "order_id" : orderID ?? ""
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
                            self.cartArray = (JSON[ "products"] as? NSArray)!
                            self.cartTableview.reloadData()
                        if(self.cartArray.count > 0)
                        {
                            self.mCartEmptyView.isHidden = true
                        }
                        else
                        {
                            self.mCartEmptyView.isHidden = false
                        }
                         self.mCountLabel.text = String(format: "%d items",self.cartArray.count)
                            
                            let totalArray = JSON["totals"] as? NSArray
                            let totalDict = totalArray![0] as? NSDictionary
                            self.mTotalLabel.text = String(format : "₹%@",totalDict!["text"] as? AnyObject as! CVarArg)
                            
                       }
                        else
                        {
                            self.mCartEmptyView.isHidden = false
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
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CartTableViewCell =   cartTableview.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.selectionStyle = .none
        let dict = self.cartArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.cartImageView.sd_setImage(with: URL(string: image ?? "" ), placeholderImage:nil)
        cell.cartnameLabel.text = dict!["name"] as? String
        //let option = dict!["option"] as? AnyObject
        if(dict!["quantity"] as? Int == 0 || dict!["quantity"] as? String == "0")
        {
            cell.mAddView.isHidden = false
            cell.mCartView.isHidden = true
        }
        else
        {
            cell.mAddView.isHidden = true
            cell.mCartView.isHidden = false
            cell.mCartCountLabel.text = String(format : "%@",(dict!["quantity"] as? String)!)
        }
        let priceSting = String(format : "₹%@",dict!["total"] as? String ?? "")
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: priceSting)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.cartAttributeLabel.attributedText = attributeString
       
        cell.cartprice.text = priceSting
        var optionName = String(format : "%@",dict!["option_name"] as? String ?? "")
        if(optionName == "null")
        {
             cell.mGramTF.text = "1 Piece"
        }
        else{
            cell.mGramTF.text = String(format : "%@",dict!["option_name"] as? String ?? "")
        }
      
       // let discountSting = String(format : "%d",dict!["discount_price"] as? Int ?? "")
     
        let discount = String(format : "₹%d",(dict!["discount_price"] as? Int)!)
//        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
//        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
       cell.cartprice.text = discount
        
    
        if(dict!["wishlist"] as? String == "1")
        {
            cell.wishListImage.image = UIImage(named: "Like")
        }
        else
        {
            cell.wishListImage.image = UIImage(named: "AddWishlist")
        }
        
        cell.mWishListBtn.tag = indexPath.row
        cell.mWishListBtn.addTarget(self, action:#selector(wishListBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mAddBtn.tag = indexPath.row
        cell.mAddBtn.addTarget(self, action:#selector(cartBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mPlusBtn.tag = indexPath.row
        cell.mPlusBtn.addTarget(self, action:#selector(plusBtnAction(_:)), for: UIControlEvents.touchUpInside)
        cell.mMinusBtn.tag = indexPath.row
        cell.mMinusBtn.addTarget(self, action:#selector(minusBtnAction(_:)), for: UIControlEvents.touchUpInside)
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let dict = self.cartArray[indexPath.row] as? NSDictionary
        let productID = dict![ "product_id"] as? String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as? ProductDetailVC
        myVC?.productID = productID! as NSString
        self.navigationController?.pushViewController(myVC!, animated: false)
    }
    @objc func cartBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.cartArray[tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.cartTableview.cellForRow(at: path) as! CartTableViewCell?
        cell?.mAddView.isHidden = true
        cell?.mCartView.isHidden = false
        cell?.mCartCountLabel.text = "1"
        let selectedRow = 0
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let options = dict!["option"] as? AnyObject
        if(options == nil || options as? String == "null")
        {
        }
        else
        {
            var optArray = dict!["option"] as? NSArray
            if((optArray?.count)! > 0)
            {
                var optDict = optArray![selectedRow] as? NSDictionary
                optionID = optDict!["product_option_id"] as? String
                optionValueID = optDict!["product_option_value_id"] as? String
                isOPtionsAvailable = true
            }
        }
        
        
        SKActivityIndicator.show("Loading...")
        let Url =  String(format: "%@api/cart/add&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "quantity" : "1",
                "product_option_id" : optionID ?? "",
                "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters = [
                "customer_id" : userID ?? "",
                "product_id" : productID,
                "quantity" : "1",
            ]
        }
        print (parameters)
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
         self.view.makeToast(JSON["message"] as? String)
         self.getCart()
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
    @objc func plusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.cartArray[tag] as? NSDictionary
        let cartID = dict!["cart_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.cartTableview.cellForRow(at: path) as! CartTableViewCell?
        cell?.mAddView.isHidden = true
        cell?.mCartView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count + 1
        cell?.mCartCountLabel.text = String(format:"%d",count)
        let selectedRow = 0 //cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        let productID = dict!["product_id"] as! String
        var isOPtionsAvailable : Bool = false
        
        let options = dict!["option"] as? AnyObject
        if(options == nil || options as? String == "null")
        {
        }
        else
        {
            var optArray = dict!["option"] as? NSArray
            if((optArray?.count)! > 0)
            {
                var optDict = optArray![selectedRow] as? NSDictionary
                optionID = optDict!["product_option_id"] as? String
                optionValueID = optDict!["product_option_value_id"] as? String
                isOPtionsAvailable = true
            }
        }
        SKActivityIndicator.show("Loading...")
        let Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters =
                [
                    "customer_id" : userID ?? "",
                    "product_id" : productID,
                    "quantity" : count,
                    "product_option_id" : optionID ?? "",
                    "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters =
                [ "customer_id" : userID ?? "",
                  "product_id" : productID,
                  "quantity" : count,
            ]
        }
        
        
         
         print (parameters)
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
         self.view.makeToast(JSON["message"] as? String)
         self.getCart()
         }
         else
         {
           // self.view.makeToast(JSON["message"] as? String)
            }
         }
         break
         
         case .failure(let error):
         print(error)
         break
         
         }
         }
        
    }
    @objc func minusBtnAction(_ sender: UIButton)
    {
        let tag = sender.tag
        let dict = self.cartArray[tag] as? NSDictionary
        let cartID = dict!["cart_id"] as! String
        let productID = dict!["product_id"] as! String
        let path = IndexPath(row: tag, section: 0)
        let cell = self.cartTableview.cellForRow(at: path) as! CartTableViewCell?
        cell?.mAddView.isHidden = false
        //cell?.mCartCountLabel.text = "1"
        let countStr = cell?.mCartCountLabel.text
        var count : Int = 0
        count = Int(countStr!)!
        count = count - 1
        cell?.mCartCountLabel.text = String(format:"%d",count)
        var Url = ""
        if(count == 1)
        {
            cell?.mAddView.isHidden = true
            //return
            Url = String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        }
        else
        {
        Url =  String(format: "%@api/cart/edit_new&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        }
        print(Url)
  
        let selectedRow = 0 //cell?.mGramTF.selectedRow
        var optionID : String!
        var optionValueID : String!
        var isOPtionsAvailable : Bool = false
        
        let options = dict!["option"] as? AnyObject
        if(options == nil || options as? String == "null")
        {
        }
        else
        {
            var optArray = dict!["option"] as? NSArray
            if((optArray?.count)! > 0)
            {
                var optDict = optArray![selectedRow] as? NSDictionary
                optionID = optDict!["product_option_id"] as? String
                optionValueID = optDict!["product_option_value_id"] as? String
                isOPtionsAvailable = true
            }
        }
        
        SKActivityIndicator.show("Loading...")
       
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        var parameters: Parameters = [:]
        if(isOPtionsAvailable)
        {
            parameters =
                [
                    //"customer_id" : userID ?? "",
                    "product_id" : productID,
                    "quantity" : count,
                    "product_option_id" : optionID ?? "",
                    "product_option_value_id" : optionValueID ?? ""
            ]
        }
        else{
            parameters =
                [ //"customer_id" : userID ?? "",
                  "product_id" : productID,
                  "quantity" : count,
            ]
        }
    print (parameters)
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
                            self.view.makeToast(JSON["message"] as? String)
                            self.getCart()
                        }
                        else
                        {
                            //self.view.makeToast(JSON["message"] as? String)
                        }
                    }
                    break
                    
                case .failure(let error):
                    print(error)
                    break
                    
                }
        }
        
    }
    @objc func wishListBtnAction(_ sender: UIButton)
    {
        let dict = self.cartArray[sender.tag] as? NSDictionary
        let productID = dict!["product_id"] as! String
        SKActivityIndicator.show("Loading...")
        var Url =  ""
        if(dict!["wishlist_status"] as? String == "1")
        {
            Url = String(format: "%@account/wishlist/removeWishList",Constants.BASEURL)
        }
        else
        {
            Url = String(format: "%@account/wishlist/insertWishList",Constants.BASEURL)
        }
        print(Url)
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
            [
                "customer_id" : userID ?? "",
                "product_id" : productID
        ]
        
        print (parameters)
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
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
                            self.getCart()
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
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
