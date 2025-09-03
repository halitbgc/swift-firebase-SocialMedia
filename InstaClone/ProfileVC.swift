//
//  ProfileVC.swift
//  InstaClone
//
//  Created by Halit Bağcı on 23.08.2025.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var documents : [QueryDocumentSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        getDataFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell

        if let comment = documents[indexPath.row].get("post_comment") as? String {
            cell.commentLabel.text = comment
        }
        
        if let imageUrl = documents[indexPath.row].get("imageUrl") as? String {
            cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        }
        if let documentId = documents[indexPath.row].documentID as? String {
            cell.documentId.text = documentId
        }
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }

    
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        }
        catch {
            print("Logout Error: \(error)")
        }
    }

    func getDataFromFirestore() {
        let userId = Auth.auth().currentUser!.uid
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("insta").whereField("user_id", isEqualTo: userId).order(by: "createdAt", descending: true).addSnapshotListener { (snapshot, error) in
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
