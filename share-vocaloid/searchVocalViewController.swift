//
//  searchVocalViewController.swift
//  share-vocaloid
//
//  Created by 木村奏斗 on 2023/01/31.
//

import UIKit
import Firebase

class searchVocalViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
    
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var searchTextField2:UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var searchTable: UITableView!
    
    var searchURLdataArray: [String] = []
    
    var searchVocalArray: [String] = []
    
    var searchSakkyokuArray: [String] = []
    
    var searchKyokutyouArray: [String] = []
    
    var searchOsusumeArray: [String] = []
    
    var searchKyokumeiArray: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTable.dataSource = self
        
        searchTable.delegate = self
        
        searchTable.rowHeight = 275
        
        searchTable.register(UINib(nibName: "TableViewCell", bundle:nil),forCellReuseIdentifier:"Cell")
        
        
        
        // Do any additional setup after loading the view.
    }
    
    let firestore = Firestore.firestore()
    
    @IBAction func vocalSearch() {
        searchURLdataArray = []
        searchVocalArray = []
        searchSakkyokuArray = []
        searchOsusumeArray = []
        searchKyokutyouArray = []
        searchKyokumeiArray = []
        let vocalName = searchTextField.text
        let composer = searchTextField2.text
        let vocalCollection = firestore.collection("addresses")
        var query:Query? = nil
        if vocalName != ""{
            query = vocalCollection.whereField("vocal", isEqualTo: vocalName)
        }else if composer != ""{
            query = vocalCollection.whereField("sakkyoku", isEqualTo: composer)
        }else if composer != "" && vocalName != "" {
            query = vocalCollection
                .whereField("vocal", isEqualTo: vocalName)
                .whereField("sakkyoku", isEqualTo: composer)
            
        }
        if let query = query{
            query.getDocuments(){(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        self.searchURLdataArray.append(document.data()["URL"]as! String)
                        self.searchVocalArray.append(document.data()["vocal"]as! String)
                        self.searchSakkyokuArray.append(document.data()["sakkyoku"]as! String)
                        self.searchOsusumeArray.append(document.data()["osusume"]as! String)
                        self.searchKyokumeiArray.append(document.data()["kyokumei"]as! String)
                        self.searchTable.reloadData()
                    }
                }
            }
        }
    }

    
    
    internal func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(searchURLdataArray[indexPath.row])が選ばれました")
        guard let url = URL(string: "\(searchURLdataArray[indexPath.row])") else { return }
        UIApplication.shared.open(url)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchURLdataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        
        cell.URLLabel.text = searchURLdataArray[indexPath.row]
        cell.sakkyokuLabel.text = searchSakkyokuArray[indexPath.row]
        cell.vocalLabel.text = searchVocalArray[indexPath.row]
        cell.osusumeLabel.text = searchOsusumeArray[indexPath.row]
        cell.kyokumeiLavel.text = searchKyokumeiArray[indexPath.row]
        
        
        
        return cell
    }
    
  
   
}


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


