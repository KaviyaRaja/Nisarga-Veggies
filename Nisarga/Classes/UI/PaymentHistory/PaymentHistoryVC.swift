//
//  PaymentHistoryVC.swift
//  Nisagra
//
//  Created by Apple on 26/07/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SKActivityIndicatorView

class PaymentHistoryVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    @IBOutlet weak var PaymentHistroyTableView: UITableView!
    
    var historyArray : NSArray = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       PaymentHistroyTableView.register(UINib(nibName: "PaymentHistoryCell", bundle: .main), forCellReuseIdentifier: "PaymentHistoryCell")
        getHistory()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.PaymentHistroyTableView.addSubview(refreshControl)
    }
    // MARK: - Btn Action
    @IBAction func faqBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "FAQSVC") as? FAQSVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func notificationBtnAction(_ sender: UIButton)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myVC = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as? NotificationVC
        self.navigationController?.pushViewController(myVC!, animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        getHistory()
        self.refreshControl.endRefreshing()
    }
    // MARK: - TableView Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PaymentHistoryCell =  PaymentHistroyTableView.dequeueReusableCell(withIdentifier: "PaymentHistoryCell", for: indexPath) as! PaymentHistoryCell
        
        let dict = self.historyArray[indexPath.row] as? NSDictionary
        cell.MoneySpentLabel.text = dict!["description"] as? String
       // cell.TxnIDLabel.text = String(format:"Txn ID: %@",(dict!["t_id"] as? String)!)
        cell.mAmountLabel.text = String(format:"₹%@",(dict!["amount"] as? String)!)
        cell.debitLabel.text = dict!["transaction_type"] as? String
        
//        let dateFormatterGet = DateFormatter()
//        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let dateFormatterPrint = DateFormatter()
//        dateFormatterPrint.dateFormat = "EEEE HH:mm a"
//
//        let date: NSDate? = dateFormatterGet.date(from: (dict!["date"] as? String)!)! as NSDate
//        print(dateFormatterPrint.string(from: date! as Date))
        cell.StatusLabel.text = dict!["status"] as? String
        let status =  dict!["status"] as? String
        if(status == "success")
        {
            cell.StatusLabel.isHidden = false
        }
        else{
            cell.StatusLabel.isHidden = true
        }
        return cell
    }
    
    // MARK: - API
    
    func getHistory()
    {
        SKActivityIndicator.show("Loading...")
        let Url = String(format: "%@api/customer/transactionHistory",Constants.BASEURL)
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
                            self.historyArray = (JSON["data"] as? NSArray)!
                            self.PaymentHistroyTableView.reloadData()
                            
                            //self.historyArray = (JSON["status"] as? NSArray)!
                            //self.StatusLabel.isHidden = false
                        }
                        else
                        {
                            self.view.makeToast(JSON["message"] as? String)
                            //self.StatusLabel.isHidden = true
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
