//
//  LoginViewController.swift
//  share-vocaloid
//
//  Created by 木村奏斗 on 2023/04/18.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController{
    
    @IBOutlet var makeButton: UIButton!
    
    @IBOutlet var loginButton: UIButton!
    
    @IBOutlet var makeEmailTextField: UITextField!
    
    @IBOutlet var makePasswordTextField: UITextField!
    
    @IBOutlet var loginEmailTextField: UITextField!
    
    @IBOutlet var loginPasswordTextField: UITextField!
    
    var saveData: UserDefaults = UserDefaults.standard
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        if saveData.object(forKey: "userUid") as? String != nil{
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBar1") as! UITabBarController
            //遷移先の画面をフルスクリーンで表示
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: nil) // 画面遷移
            
        }else{
            print("failed")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBar1") as! UITabBarController
        //遷移先の画面をフルスクリーンで表示
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil) // 画面遷移
        
    }
    
    
    
    @IBAction func makeAccount() {
        
        let makeEmail = makeEmailTextField.text!
        let makePassword = makePasswordTextField.text!
        Auth.auth().createUser(withEmail: makeEmail, password: makePassword) {authResult, error in
            if let user = authResult?.user{
                print("userId:\(user.uid)")
                self.saveData.set(user.uid,forKey:"userUid")
                print(self.saveData.object(forKey: "userUid") as? String)
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBar1") as! UITabBarController
                //遷移先の画面をフルスクリーンで表示
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil) // 画面遷移
            }else{
                print(error)
            }
            // ...
        }
       
    }
    
    @IBAction func loginAccount() {
        
        let loginEmail = loginEmailTextField.text!
        let loginPassword = loginPasswordTextField.text!
        
        Auth.auth().signIn(withEmail: loginEmail, password: loginPassword, completion: {  (result, error) in
            if let user = result?.user {
                print("login success" + user.uid)
                self.saveData.set(user.uid,forKey:"userUid")
                print(self.saveData.object(forKey: "userUid") as? String)
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "tabBar1") as! UITabBarController
                //遷移先の画面をフルスクリーンで表示
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil) // 画面遷移
            }else if let error = error{
                print("login failure" + error.localizedDescription)
                let alert: UIAlertController = UIAlertController(title: "エラー", message: "メールアドレスまたはパスワードが間違っています。再入力してください。", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert,animated: true,completion: nil)
            }
            
        })
        
        
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
        
    }
}
