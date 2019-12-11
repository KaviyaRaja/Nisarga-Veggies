//
//  CheckOutListVC.swift
//  ECommerce
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
class CheckOutListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var CheckoutListtableview: UITableView!
    
    var itemsArray : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CheckoutListtableview.register(UINib(nibName: "CheckOutItemsCell", bundle: .main), forCellReuseIdentifier: "CheckOutItemsCell")
    }
    // MARK: - Btn Action
    
    @IBAction func backBtnAction(_ sender: Any)
    {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func faqBtnAction(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return self.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:CheckOutItemsCell =  CheckoutListtableview.dequeueReusableCell(withIdentifier: "CheckOutItemsCell", for: indexPath) as! CheckOutItemsCell
        
        let dict = self.itemsArray[indexPath.row] as? NSDictionary
        cell.productsName.text = dict!["name"] as? String
        cell.productskglabel.text = dict!["weight_classes"] as? String
        cell.productsQuantityLabel.text = String(format:"Qty : %@",(dict!["quantity"] as? String)!)
        let priceSting = String(format : "%@",dict!["price"] as? String ?? "")
        let priceDouble =  Double (priceSting)
        cell.productsPriceLabel.text = String(format : "₹%.2f",priceDouble!)
        
        let revisedPriceSting = String(format : "%@",dict!["revised_price"] as? String ?? "")
        let revisedPriceDouble =  Double (revisedPriceSting)
        cell.updatedpricelabel.text = String(format : "₹%.2f",revisedPriceDouble!)
        
        return cell;
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
