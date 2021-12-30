//
//  ProfileDetailCell.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/06/19.
//

import UIKit

class ProfileDetailCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var prefectureLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var bloodLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var workLabel: UILabel!
    
    
    static let identifier = "ProfileDetailCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ProfileDetailCell", bundle: nil)
    }
    
    func configure(nameLabelString:String,ageLabelString:String,prefectureLabelString:String, bloodLabelString:String, genderLabelString:String, heightLabelString:String, workLabelString:String) {
        
        nameLabel.text = nameLabelString
        ageLabel.text = ageLabelString
        prefectureLabel.text = prefectureLabelString
        bloodLabel.text = bloodLabelString
        genderLabel.text = genderLabelString
        heightLabel.text = heightLabelString
        workLabel.text = workLabelString
        
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
