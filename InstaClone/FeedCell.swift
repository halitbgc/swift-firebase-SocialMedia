//
//  FeedCell.swift
//  InstaClone
//
//  Created by Halit Bağcı on 24.08.2025.
//

import UIKit
import Firebase
import FirebaseFirestore
class FeedCell: UITableViewCell {

    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var imageFeed: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeClicked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        
        if let documentId = documentIdLabel.text {
            if let likesCount = Int(likesLabel.text!) {
                let likeStore = ["likes": likesCount + 1]
                
                firestoreDatabase.collection("insta").document(documentId).updateData(likeStore)
            }
            
        }
    }
    
}
