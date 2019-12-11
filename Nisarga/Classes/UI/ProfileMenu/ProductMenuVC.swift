//
//  ProductMenuVC.swift
//  
//
//  Created by Apple on 21/06/19.
//

import UIKit

class ProductMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var profilelabel: UILabel!
    @IBOutlet weak var profiledetailslabel: UILabel!
    @IBOutlet weak var profiletableview: UITableView!
   
    var menuArray : NSArray = ["","My Order","MY Address","MY Wallet","Offer","Refer & Earn","Rate Us","About & Contact Us","FAQs","Terms & Condition","Google Feedback","Policy"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         var menuArray = [[String:AnyObject]]()
        
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = menuArray[indexPath.row] as? String
       
    return (cell)
}
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath){
        if(indexPath.row == 0)
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let myVC = storyboard.instantiateViewController(withIdentifier: "MyOrderVC") as? MyOrderVC
           self.navigationController?.pushViewController(myVC!, animated: false)
        }
        else if(indexPath.row == 1)
        {
           
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

    @IBAction func profilebackbutton(_ sender: UIButton) {
    }
        @IBAction func profilelogout(_ sender: UIButton) {
        
    }
@IBAction func profilenotificationbutton(_ sender: UIButton) {
    }
    @IBAction func editprofilebutton(_ sender: UIButton) {
    }
    @IBAction func menulistButton(_ sender: UIButton) {
        
    }
}

