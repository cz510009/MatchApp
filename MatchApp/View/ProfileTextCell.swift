//
//  ProfileTextCell.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/06/19.
//

import UIKit

class ProfileTextCell: UITableViewCell {

    
    @IBOutlet weak var profileTextView: UITextView!
    
    static let identifier = "ProfileTextCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileTextCell", bundle: nil)
    }
    
    func configurer(profileTextViewString:String) {
        profileTextView.text = profileTextViewString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
