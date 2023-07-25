//
//  ViewController.swift
//  share-vocaloid
//
//  Created by 木村奏斗 on 2022/11/01.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var shareStartButton: UIButton!

    @IBOutlet var table: UITableView!
    
    var URLdataArray: [String] = []
    
    var vocalArray: [String] = []
    
    var sakkyokuArray: [String] = []
    
    var osusumeArray: [String] = []
    
    var kyokumeiArray: [String] = []
    
    var displayNameArray: [String] = []
    
    var userUidArray: [String] = []
    
    var photoURLArray: [String] = []
    
    let firestore = Firestore.firestore()
    
    let user = Auth.auth().currentUser
    
    var saveData: UserDefaults = UserDefaults.standard
    
    let inuser = Auth.auth().currentUser
    
    @IBOutlet var reloadData: UIButton!
    
    
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
                    let docRef = firestore.collection("user").document(document.data()["userUid"]as! String)
                    docRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let dataDescription = document.data()?["userName"] as? String
                            let dataPhoto = document.data()?["photo"] as? String
                            self.userUidArray.append(dataDescription!)
                            self.photoURLArray.append(dataPhoto!)
                            print(photoURLArray)
                            table.reloadData()
                        }
                    }
//                    let docRef2 = firestore.collection("user").document(document.data()["userUid"]as! String)
//                    docRef2.getDocument { (document, error) in
//                        if let document = document, document.exists {
//                            let dataDescription = document.data()?["photo"] as? String
//                            print("Document data: \(dataDescription)")
//                            self.photoURLArray.append(dataDescription!)
//                            print(photoURLArray)
//                            table.reloadData()
//                        } else {
//                            print("Document does not exist")
//                        }
//                    }
//                    table.reloadData()
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
    
    @IBAction func reloadDataButton() {
        table.reloadData()
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
        cell.userNameLavel.text = userUidArray[indexPath.row]
        
        
        
        return cell
    }
   
}

