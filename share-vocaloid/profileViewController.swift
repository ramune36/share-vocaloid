//
//  profileViewController.swift
//  share-vocaloid
//
//  Created by 木村奏斗 on 2023/05/30.
//

import UIKit
import FirebaseStorage

class profileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var profileImageButton: UIButton!
    
    var downloadURL: URL?
    


    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 枠線の幅の設定
        profileImageView.layer.borderWidth = 3.0
        // 枠線の色の設定
        profileImageView.layer.borderColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 1.0).cgColor
        // 角丸の設定
        profileImageView.layer.cornerRadius = 50.0
        // 境界矩形外は描画なし
        profileImageView.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func selectProfileImage() {
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        self.present(imagePickerController, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
        
        let profileImage = info[.originalImage] as! UIImage
        
        profileImageView.image = profileImage
        
        self.dismiss(animated: true,completion: nil)
        
        let storage = Storage.storage()
        let reference = storage.reference()
        
        let path = "gs://share-vocaloid.appspot.com/test/test.png"
        let imageRef = reference.child(path)
        guard let data = profileImage.pngData() else {
            return
        }
        let uploadTask = imageRef.putData(data)
        
        
        uploadTask.observe(.success) { _ in
            imageRef.downloadURL { url, error in
                if let url = url {
                    self.downloadURL = url
                    do {
                        let data = try Data(contentsOf: url)
                        return profileImageView(data: data)!
                    } catch let error {
                        print("Error : \(error.localizedDescription)")
                    }
                }
            }
        }
        
        
        uploadTask.observe(.failure) { snapshot in
            if let message = snapshot.error?.localizedDescription {
                print(message)
                
               
            }
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

}
