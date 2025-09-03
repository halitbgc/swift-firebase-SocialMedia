//
//  ProfileCell.swift
//  InstaClone
//
//  Created by Halit Bağcı on 3.09.2025.
//

import UIKit
import FirebaseFirestore

class ProfileCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var documentId: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteClicked(_ sender: Any) {
        let firestore = Firestore.firestore()
        
        firestore.collection("insta").document(documentId.text!).delete { err in
            if  err != nil {
                print("Error")
            }
        }
        
    }
}
