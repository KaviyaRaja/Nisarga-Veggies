//
//  OrderItemsVC.swift
//  ECommerce
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
class OrderItemsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mDateTF: IQDropDownTextField!
    @IBOutlet var mPopupView: UIView!
    @IBOutlet weak var orderItemsTableview: UITableView!
    @IBOutlet weak var mCountLabel : CustomFontLabel!
    @IBOutlet weak var mTotalLabel : CustomFontLabel!
    @IBOutlet var mEmptyView: UIView!
    
    var orderID : String!
      var orderitemsArray : NSArray = []
    var count : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderItemsTableview.register(UINib(nibName: "OrderItemsCell", bundle: .main), forCellReuseIdentifier: "OrderItemsCell")
         self.mDateTF.addBorder()
        self.mDateTF.setLeftPaddingPoints(10)
        self.mEmptyView.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    // MARK: - Btn Action
    
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkOutBtnAction(_ sender: UIButton)
    {
        if(count == 0)
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
        else
        {
            reorderAddcartApi()
        }
        
    }
    @IBAction func deliveryBtnAction(_ sender: UIButton)
    {
        
    }
   @IBAction func schedulBtnAction(_ sender: Any) {
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
    count = 1
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "ShippingVC") as! ShippingVC
//        vc.deliveryDate = self.mDateTF.selectedItem
//        self.navigationController?.pushViewController(vc, animated: true)
          // reorderAddcartApi()
    }
    func getData()
    {
        SKActivityIndicator.show("Loading...")
        let userID =  UserDefaults.standard.string(forKey: "customer_id")
        let parameters: Parameters =
        [
            "customer_id" : userID ?? "",
            "order_id" : self.orderID ?? ""
        ]
        
        print (parameters)
        let Url = String(format: "%@api/order/MyorderProductList",Constants.BASEURL)
        print(Url)
        let headers: HTTPHeaders =
        [
            "Content-Type": "application/json"
        ]
        Alamofire.request(Url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            SKActivityIndicator.dismiss()
            print(response)
            switch(response.result) {
                
            case .success:
                if let json = response.result.value
                {
                    let JSON = json as! NSDictionary
                    print(JSON)
                    if(JSON["status"] as? String == "success")
                    {
                    self.orderitemsArray  = (JSON["result"] as? NSArray)!
                    self.orderItemsTableview.reloadData()
                    self.mCountLabel.text = String(format: "%d items",self.orderitemsArray.count)
                    let priceSting = String(format : "%d",JSON["totalMoney"] as? Int ?? "")
                    self.mTotalLabel.text = String(format : "₹%@",priceSting)
                    }
                    else
                    {
                        self.mEmptyView.isHidden = false
                    }
                }
                break
                
            case .failure(let error):
                print(error)
                break
                
            }
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderitemsArray.count;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderItemsCell =  orderItemsTableview.dequeueReusableCell(withIdentifier: "OrderItemsCell", for: indexPath) as! OrderItemsCell
        cell.selectionStyle = .none
        cell.mBgView.layer.shadowColor = UIColor.gray.cgColor
        cell.mBgView.layer.shadowOffset = CGSize (width: 0, height: 3)
        cell.mBgView.layer.shadowOpacity = 0.6
        cell.mBgView.layer.shadowRadius = 3.0
        cell.mBgView.layer.cornerRadius = 5.0
        let dict = self.orderitemsArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.orderitemsImage.sd_setImage(with: URL(string: image ?? ""), placeholderImage:nil)
        cell.orderItemsName.text = dict![ "name"] as? String
        cell.orderitemsKg.text = dict![ "weight_classes"] as? String
        cell.orderItemsQuantity.text = String(format:"Quantity : %@",(dict!["quantity"] as? String)!)
        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
        let priceDouble =  Double (priceSting)
        cell.orderitemsPrice.text = String(format : "₹%.2f",priceDouble!)
        var discount = String(format : "%@",dict!["discount_price"] as? String ?? "")
        if(discount == "null")
        {
            
        }
        else
        {
            let discountSting = String(format : "%@",dict!["discount_price"] as? String ?? "")
            let discountDouble =  Double (discountSting)
            if((discountDouble) != nil)
            {
                discount = String(format : "₹%.2f",discountDouble!)
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discount)
                attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                cell.orderitemsAttribute.attributedText = attributeString
            }
            
        }
        var revisedPriceSting = String(format : "%@",dict!["revised_price"] as? String ?? "")
        if(revisedPriceSting == "null")
        {
            
        }
        else
        {
            let revisedPriceDouble =  Double (revisedPriceSting)
            cell.orderItemsRevisedPrice.text = String(format : "₹%.2f",revisedPriceDouble!)
        }
        
        return cell
    }
    func reorderAddcartApi()
    {
        
        SKActivityIndicator.show("Loading...")
         let Url = String(format: "%@api/cart/reorderItems&api_token=%@",Constants.BASEURL,UserDefaults.standard.string(forKey: "api_token")!)
        print(Url)
        let date =  UserDefaults.standard.string(forKey: "DeliveryDay")
        let parameters: Parameters =
            [
            "order_id" : self.orderID ?? "",
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
                          
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "ShippingVC") as! ShippingVC
                            vc.deliveryDate = self.mDateTF.selectedItem
                            self.navigationController?.pushViewController(vc, animated: true)
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
    
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


}

