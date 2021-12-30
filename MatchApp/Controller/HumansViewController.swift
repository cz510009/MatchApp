//
//  HumansViewController.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/06/18.
//

import UIKit
import Firebase
import SDWebImage

class HumansViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GetProfileDataProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var ashiatoButton: UIButton!
    
    var searchOrNot = Bool()
    
    let sectionInsets = UIEdgeInsets(top:10.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    let itemsPerRow:CGFloat = 2
    
    var userDataModelArray = [UserDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if Auth.auth().currentUser?.uid != nil && searchOrNot == false {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            // 自分のユーザーデータを取り出す
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            
            // 受信
            let loadDBModel = LoadDBModel()
            loadDBModel.getProfileDataProtocol = self
            loadDBModel.loadUsersProfile(gender: userData["gender"] as! String)
            
        } else if Auth.auth().currentUser?.uid != nil && searchOrNot == true {
            collectionView.reloadData()
        } else {
            performSegue(withIdentifier: "inputVC", sender: nil)
        }
    }
    
    func getProfileData(userDataModelArray: [UserDataModel]) {
        
        self.userDataModelArray = userDataModelArray
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userDataModelArray.count
    }
    
    // 画面のサイズに応じてセルのサイズを変える
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    // セルの行間
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルを構築して返す
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        // セルに効果　影
        cell.layer.cornerRadius = cell.frame.width / 2
        cell.layer.borderWidth = 0.0
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = true
        
        let imageView = cell.contentView.viewWithTag(1) as! UIImageView
        imageView.sd_setImage(with: URL(string: userDataModelArray[indexPath.row].profileImageString!), completed: nil)
        imageView.layer.cornerRadius = imageView.frame.width / 2
        let ageLabel = cell.contentView.viewWithTag(2) as! UILabel
        ageLabel.text = userDataModelArray[indexPath.row].age
        
        let prefectureLabel = cell.contentView.viewWithTag(3) as! UILabel
        prefectureLabel.text = userDataModelArray[indexPath.row].prefecture
        
        let onlineMarkImageView = cell.contentView.viewWithTag(4) as! UIImageView
        onlineMarkImageView.layer.cornerRadius = onlineMarkImageView.frame.width / 2
        
        if userDataModelArray[indexPath.row].onlineOrNot == true {
            
            onlineMarkImageView.image = UIImage(named: "online")
        } else {
            onlineMarkImageView.image = UIImage(named: "offline")
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profileVC = self.storyboard?.instantiateViewController(identifier: "profileVC") as! ProfileViewController
        profileVC.userDataModel = userDataModelArray[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

}
