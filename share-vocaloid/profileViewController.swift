//
//  profileViewController.swift
//  share-vocaloid
//
//  Created by 木村奏斗 on 2023/05/30.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class profileViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var profileImageButton: UIButton!
    
    @IBOutlet var displayNameField: UITextField!
    
    @IBOutlet var displayNameButton: UIButton!
    
    let firestore = Firestore.firestore()
    
    var userNameArray:[String] = []
    
    var downloadURL: URL?
    
    struct StorageMetaData {
        var contentType: String
    }
    
    func handleError(error: Error, msg: String) {
        print("\(msg) Error: \(error.localizedDescription)")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func getImageByUrl(url: String, completion: @escaping (UIImage?) -> Void) {
            guard let imageUrl = URL(string: url) else {
                print("Invalid URL: \(url)")
                completion(nil)
                return
            }

            let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data = data, let image = UIImage(data: data) else {
                    print("Invalid image data")
                    completion(nil)
                    return
                }

                completion(image)
            }
            task.resume()
        }

        
        if let user = Auth.auth().currentUser {
                    let photoURL = user.photoURL?.absoluteString ?? ""
                    getImageByUrl(url: photoURL) { [weak self] image in
                        DispatchQueue.main.async {
                            self?.profileImageView.image = image
                        }
                    }
                }
        
        firestore.collection("user").getDocuments() { [self] (querySnapshot, err) in
                    if let err = err {
                print("Error getting documents: \(err)")
                    } else {
                        print(querySnapshot!.documents.count)
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            if let userName = document.data()["userName"] as? String {
                                print(userName)
                                self.userNameArray.append(userName)
                                print(self.userNameArray)
                                if !userNameArray.isEmpty {
                                displayNameField.text = userNameArray[0]
                                    print(userNameArray)
                                }else{
                                    print(userNameArray)
                                }
                            }
                        }
                    }
                }
        
       
        
        
        
        
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
    
    
    
    
    
    
    
        func selectProfileImage() {
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
        
        // 1：画像をデータに変換
        guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else{return}
        
        // 2：ストレージイメージ参照を作成->保存するFirestorageの場所
        let fileName = NSUUID().uuidString
        print("aaaaaaaa")
        print(fileName)
        let imageRef = Storage.storage().reference().child("gs://share-vocaloid.appspot.com")
        
        // 3：メタデータを設定
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        
        
        // 4：データをアップロード
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                self.handleError(error: error, msg: "Unable to upload image.")
                return
            }
            
            // 5：画像がアップロードされたら、ダウンロードURLを取得
            imageRef.downloadURL { (url, error) in
                if let error = error {
                    self.handleError(error: error, msg: "Unable to download URL.")
                    return
                }
                guard let url = url else { return }
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.photoURL = url
                changeRequest?.commitChanges { error in
                    // ...
                }
                
                let user = Auth.auth().currentUser
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                    let email = user.email
                    let photoURL = user.photoURL?.absoluteString ?? ""
                    var multiFactorString = "MultiFactor: "
                    for info in user.multiFactor.enrolledFactors {
                        multiFactorString += info.displayName ?? "[DispayName]"
                        multiFactorString += " "
                    }
                    // ...
                    let docData = [
                        "email": email,
                        "userID": uid,
                        "photo": photoURL
                    ] as [String : Any]
                    Firestore.firestore().collection("user").document(uid).setData(docData) {(err) in
                        if let err = err {
                            print("manager情報の保存に失敗しました\(err)")
                            return
                        }
                        print("manager情報の保存に成功しました")
                    }
                }
                
                
                
                //MARK: 過去の取り組み
                //        let storage = Storage.storage()
                //        let reference = storage.reference()
                //
                //        let path = "gs://share-vocaloid.appspot.com/test/test.png"
                //        let imageRef = reference.child(path)
                //        guard let data = profileImage.pngData() else {
                //            return
                //        }
                //        let uploadTask = imageRef.putData(data)
                //
                //
                //        uploadTask.observe(.success) { _ in
                //            imageRef.downloadURL { (url, error) in
                //                if let url = url {
                //                    self.downloadURL = url
                //                    do {
                //                        let data = try Data(contentsOf: url)
                //                        return profileImageView(data: data)!
                //                    } catch let error {
                //                        print("Error : \(error.localizedDescription)")
                //                    }
                //                }
                //            }
                //        }
                //
                //
                //        uploadTask.observe(.failure) { snapshot in
                //            if let message = snapshot.error?.localizedDescription {
                //                print(message)
                //
                //
                //            }
                //        }
                
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
    }
    @IBAction func decideUserName() {
        let userName = displayNameField.text
        
        let user = Auth.auth().currentUser
        if let user = user {
            // The user's ID, unique to the Firebase project.
            // Do NOT use this value to authenticate with your backend server,
            // if you have one. Use getTokenWithCompletion:completion: instead.
            let uid = user.uid
            let email = user.email
            let photoURL = user.photoURL?.absoluteString ?? ""
            var multiFactorString = "MultiFactor: "
            for info in user.multiFactor.enrolledFactors {
                multiFactorString += info.displayName ?? "[DispayName]"
                multiFactorString += " "
            }
            
            let docData = [
                "email": email,
                "userID": uid,
                "photo": photoURL,
                "userName": userName
                
            ] as [String : Any]
            Firestore.firestore().collection("user").document(uid).setData(docData) {(err) in
                if let err = err {
                    print("manager情報の保存に失敗しました\(err)")
                    return
                }
                print("manager情報の保存に成功しました")
            }
        }
    }
}
