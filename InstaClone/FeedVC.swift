//
// FeedVC.swift
// InstaClone
//
// Created by Halit Bağcı on 23.08.2025.
//
import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var documents: [QueryDocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        getDataFromFirestore( )
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableView count : \(documents.count)")
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        
        if let comment = self.documents[indexPath.row].get("post_comment") as? String {
            cell.commentLabel.text = comment
        }
        
        if let email = self.documents[indexPath.row].get("user_email") as? String {
            cell.emailLabel.text = email
        }
        
        if let like = self.documents[indexPath.row].get("likes") as? Int {
            cell.likesLabel.text = String(like)
        }
        
        if let imageUrl = self.documents[indexPath.row].get("imageUrl") as? String {
            cell.imageFeed.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
        if let documentId = self.documents[indexPath.row].documentID as? String {
            cell.documentIdLabel.text = documentId
        }
        
        return cell
    }
    
    func getDataFromFirestore() {
       
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("insta").order(by: "createdAt", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            else {
                if snapshot != nil {
                    self.documents.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        //gelen document dir
                        self.documents.append(document)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
