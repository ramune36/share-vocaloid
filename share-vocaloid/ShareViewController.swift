//
//  ShareViewController.swift
//  share-vocaloid
//
//  Created by 木村奏斗 on 2022/11/01.
//

import UIKit
import Firebase
import FirebaseFirestore

class ShareViewController: UIViewController {
    
    
    
    @IBOutlet var URLtextField: UITextField!
    
    @IBOutlet var shareButton: UIButton!
    
    @IBOutlet var backbutton: UIButton!
    
    @IBOutlet var osusumeTextField: UITextField!
    
    @IBOutlet var vocalTextField: UITextField!
    
    
    
    @IBOutlet var sakkyokuTextField: UITextField!
    
    @IBOutlet var kyokumeiTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    let alert: UIAlertController = UIAlertController(title: "空白のタグがあります", message: "空欄の箇所に文字を入力してください", preferredStyle: .alert)
    
    let firestore = Firestore.firestore()
    
    let userUid = UserDefaults.standard.string(forKey: "userUid")

    
    @IBAction func tapShareButton() {
        
        
        
        let URL = URLtextField.text
        
        let osusume = osusumeTextField.text
        
        let vocal = vocalTextField.text
        
       let sakkyoku = sakkyokuTextField.text
        
        let kyokumei = kyokumeiTextField.text
        
        if URL == ""{
            present(alert,animated: true,completion: nil)
        }else if osusume == ""{
            present(alert,animated: true,completion: nil)
        }else if vocal == ""{
            present(alert,animated: true,completion: nil)
        }else if sakkyoku == ""{
            present(alert,animated: true,completion: nil)
        }else if kyokumei == ""{
            present(alert,animated: true,completion: nil)
            }else{
                firestore.collection("addresses").addDocument(data: ["URL": URL ?? "aaaa","osusume": osusume ?? "aaaa","vocal": vocal ?? "aaaa","sakkyoku": sakkyoku ?? "aaaa","kyokumei": kyokumei ?? "aaaa","userUid": userUid ?? "aaaa"
                                                                ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                }
            }
            
            
        }
        
        
        
        
        dismiss(animated: true, completion: nil)
        
        
        
        
        
        
    }
    
    
    
    
    @IBAction func tapbuckbutton() {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
