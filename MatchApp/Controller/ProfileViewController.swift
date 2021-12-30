//
//  ProfileViewController.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/06/19.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LikeSendDelegate, GetLikeCountProtocol {
    
    var userDataModel:UserDataModel?

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var likeCount = Int()
    var likeFlag = Bool()
    var loadDBModel = LoadDBModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
       
        tableView.register(ProfileImageCell.nib(), forCellReuseIdentifier: ProfileImageCell.identifier)
        tableView.register(ProfileTextCell.nib(), forCellReuseIdentifier: ProfileTextCell.identifier)
        tableView.register(ProfileDetailCell.nib(), forCellReuseIdentifier: ProfileDetailCell.identifier)
        
        loadDBModel.getLikeCountProtocol = self
        loadDBModel.loadLikeCount(uuid: (userDataModel?.uid)!)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        let sendDBModel = SendDBModel()
        sendDBModel.sendAshiato(userID: (userDataModel?.uid)!)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageCell.identifier, for: indexPath) as! ProfileImageCell
            cell.configure(profileImageString: (userDataModel?.profileImageString)!, nameLabelString: (userDataModel?.name)!, ageLabelString: (userDataModel?.age)!, prefectureLabelString: (userDataModel?.prefecture)!, quickWordLabelString: (userDataModel?.quickWord)!, likeLabelString: String(likeCount))
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTextCell.identifier, for: indexPath) as! ProfileTextCell
            cell.profileTextView.text = userDataModel?.profile
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileDetailCell.identifier, for: indexPath) as! ProfileDetailCell
            cell.configure(nameLabelString: (userDataModel?.name)!, ageLabelString: (userDataModel?.age)!, prefectureLabelString: (userDataModel?.prefecture)!, bloodLabelString: (userDataModel?.bloodType)!, genderLabelString: (userDataModel?.gender)!, heightLabelString: (userDataModel?.height)!, workLabelString: (userDataModel?.work)!)
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 440
        } else if indexPath.row == 2 {
            return 370
        } else if indexPath.row == 3 {
            return 400
        }
        return 1
    }
    
    @IBAction func likeAction(_ sender: Any) {
        // もし自分のIDでない場合
        if userDataModel?.uid != Auth.auth().currentUser?.uid {
            // Like
            let sendDBModel = SendDBModel()
            sendDBModel.likeSendDelegate = self
            
            if self.likeFlag == false {
                sendDBModel.sendToLike(likeFlag: true, thisUserID: (userDataModel?.uid)!)
            } else {
                sendDBModel.sendToLike(likeFlag: false, thisUserID: (userDataModel?.uid)!)
            }
            
        }
    }
    func like() {
        // likeが押されたときに呼ばれる
        // heartのアニメーション
        Util.startAnimation(name: "heart", view:self.view)
    }
    
    func getLikeCount(likeCount: Int, likeFlag: Bool) {
        
        self.likeFlag = likeFlag
        self.likeCount = likeCount
        if self.likeFlag == false {
            likeButton.setImage(UIImage(named: "notLike"), for: .normal)
                
            } else {
                likeButton.setImage(UIImage(named: "like"), for: .normal)
            }
        tableView.reloadData()
    }

}
