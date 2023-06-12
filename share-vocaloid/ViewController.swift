//
//  ViewController.swift
//  share-vocaloid
//
//  Created by 木村奏斗 on 2022/11/01.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var shareStartButton: UIButton!

    @IBOutlet var table: UITableView!
    
    var URLdataArray: [String] = []
    
    var vocalArray: [String] = []
    
    var sakkyokuArray: [String] = []
    
    var osusumeArray: [String] = []
    
    var kyokumeiArray: [String] = []
    
    let firestore = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    var saveData: UserDefaults = UserDefaults.standard
    
    let inuser = Auth.auth().currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
      
        
        
        
       
        
        
        table.dataSource = self
        
        table.delegate = self
        
        // Do any additional setup after loading the view.
        firestore.collection("addresses").getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print(querySnapshot!.documents.count)
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.URLdataArray.append(document.data()["URL"]as! String)
                    self.vocalArray.append(document.data()["vocal"]as! String)
                    self.sakkyokuArray.append(document.data()["sakkyoku"]as! String)
                    self.osusumeArray.append(document.data()["osusume"]as! String)
                    self.kyokumeiArray.append(document.data()["kyokumei"]as! String)
                    table.reloadData()
                }
            }
        }
        
        table.rowHeight = 275
        
        table.register(UINib(nibName: "TableViewCell", bundle:nil),forCellReuseIdentifier:"Cell")
    
    }
    func table(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 2;
        }
        
    func table(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
            return cell
        }
    
  

    @IBAction func tapShareStartButton() {
        
    }
    
    
    
    
    
   
    
    internal func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(URLdataArray[indexPath.row])が選ばれました")
        guard let url = URL(string: "\(URLdataArray[indexPath.row])") else { return }
        UIApplication.shared.open(url)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return URLdataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        cell.URLLabel.text = URLdataArray[indexPath.row]
        cell.sakkyokuLabel.text = sakkyokuArray[indexPath.row]
        cell.vocalLabel.text = vocalArray[indexPath.row]
        cell.osusumeLabel.text = osusumeArray[indexPath.row]
        cell.kyokumeiLavel.text = kyokumeiArray[indexPath.row]
        
        
        
        return cell
    }
   
}

