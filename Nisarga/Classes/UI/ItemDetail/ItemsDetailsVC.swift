//
//  ItemsDetailsVC.swift
//  ECommerce
//
//  Created by Apple on 24/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView
class ItemsDetailsVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var orderItemsTableview: UITableView!
    var OrderItemsArray : NSArray = []
    @IBOutlet weak var mCountLabel : CustomFontLabel!
    var orderID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        orderItemsTableview.register(UINib(nibName: "OrderDetailsCell", bundle: .main), forCellReuseIdentifier: "OrderDetailsCell")
        
        getDetail()
    }
    @IBAction func backBtnAction(_ sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func getDetail()
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
                        self.OrderItemsArray = (JSON["result"] as? NSArray)!
                        self.orderItemsTableview.reloadData()
                        self.mCountLabel.text = String(format: "%d items",self.OrderItemsArray.count)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderItemsArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderDetailsCell =  orderItemsTableview.dequeueReusableCell(withIdentifier: "OrderDetailsCell", for: indexPath) as! OrderDetailsCell
        
        cell.mBgView.layer.shadowColor = UIColor.gray.cgColor
        cell.mBgView.layer.shadowOffset = CGSize (width: 0, height: 3)
        cell.mBgView.layer.shadowOpacity = 0.6
        cell.mBgView.layer.shadowRadius = 3.0
        cell.mBgView.layer.cornerRadius = 5.0
        let dict = self.OrderItemsArray[indexPath.row] as? NSDictionary
        var image = dict!["image"] as? String
        image = image?.replacingOccurrences(of: " ", with: "%20")
        cell.OrderDetailsImage.sd_setImage(with: URL(string: image ?? ""), placeholderImage:nil)
        cell.detailsname.text = dict![ "name"] as? String
        cell.Orderdetailkg.text = dict![ "quantity"] as? String
        cell.orderDetailsQuantiy.text = String(format:"Quantity : %@",(dict!["quantity"] as? String)!)
        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
        let priceDouble =  Double (priceSting)
        cell.orderdetailsPrice.text = String(format : "₹%.2f",priceDouble!)
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
                cell.orderattributePrice.attributedText = attributeString
            }
            
        }
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
