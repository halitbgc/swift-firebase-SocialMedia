//
//  UploadVC.swift
//  InstaClone
//
//  Created by Halit Bağcı on 23.08.2025.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commandTextField: UITextField!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @IBAction func shareClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference() // referans ile hangi klasor ile nereye kaydetcez
        
        let mediaFolder = storageRef.child("media")
        let uuid = UUID().uuidString
        let imageRef = mediaFolder.child("\(uuid).jpeg")
        
        //resmi veriye cevirvez
        if let data = imageView.image?.jpegData(compressionQuality: 0.8) {
            imageRef.putData(data, metadata: nil) { metaData, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "An error occurred")
                }
                else{
                    imageRef.downloadURL { url, error in
                        if  error == nil {
                            let imageUrlString = url?.absoluteString
                            
                            //DATABASE
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreRef: DocumentReference? = nil
                            let firestorePost = ["user_id": Auth.auth().currentUser!.uid, "imageUrl": imageUrlString!, "user_email": Auth.auth().currentUser!.email!, "createdAt": FieldValue.serverTimestamp(), "post_comment": self.commandTextField.text ?? "", "likes": 0] as [String : Any]
                            
                            firestoreRef = firestoreDatabase.collection("insta").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: "")
                                }
                                else {
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commandTextField.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func chooseImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
