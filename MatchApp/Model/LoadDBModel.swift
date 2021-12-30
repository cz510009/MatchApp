//
//  LoadDBModel.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/06/18.
//

import Foundation
import Firebase

protocol GetProfileDataProtocol {
    func getProfileData(userDataModelArray:[UserDataModel])
}

protocol GetLikeCountProtocol {
    func getLikeCount(likeCount:Int, likeFlag:Bool)
}

protocol GetLikeDataProtocol {
    func getLikeDataProtocol(userDataModelArray:[UserDataModel])
}

protocol GetWhoIsMatchListProtocol {
    func getWhoIsMatchListProtocol(userDataModelArray:[UserDataModel])
}

protocol GetAshiatoDataProtocol {
    func getAshiatoDataProtocol(userDataModelArray:[UserDataModel])
}

class LoadDBModel {
    
    var db = Firestore.firestore()
    var profileModelArray = [UserDataModel]()
    var getProfileDataProtocol:GetProfileDataProtocol?
    var getLikeCountProtocol:GetLikeCountProtocol?
    var getLikeDataProtocol:GetLikeDataProtocol?
    var getWhoIsMatchListProtocol:GetWhoIsMatchListProtocol?
    var getAshiatoDataProtocol:GetAshiatoDataProtocol?
    
    func loadUsersProfile(gender:String) {
        // ユーザーデータを受信
        db.collection("Users").whereField("gender", isNotEqualTo: gender).addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let name = data["name"] as? String,
                       let age = data["age"] as? String,
                       let height = data["height"] as? String,
                       let bloodType = data["bloodType"] as? String,
                       let prefecture = data["prefecture"] as? String,
                       let gender = data["gender"] as? String,
                       let profile = data["profile"] as? String,
                       let profileImageString = data["profileImageString"] as? String,
                       let uid = data["uid"] as? String,
                       let quickWord = data["quickWord"] as? String,
                       let work = data["work"] as? String,
                       let onlineOrNot = data["onlineOrNot"] as? Bool {
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineOrNot: onlineOrNot)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                }
            }
            self.getProfileDataProtocol?.getProfileData(userDataModelArray: self.profileModelArray)
        }
    }
    
    // likeの数取得
    func loadLikeCount(uuid:String) {
        var likeFlag = Bool()
        db.collection("Users").document(uuid).collection("like").addSnapshotListener { snapShot, error in
            if error != nil {
                return
            }
            if let snapShotDoc = snapShot?.documents {
                for doc in snapShotDoc {
                    let data = doc.data()
                    if doc.documentID == Auth.auth().currentUser?.uid {
                        if let like = data["like"] as? Bool {
                            likeFlag = like
                            
                        }
                    }
                }
                
                let docCount = snapShotDoc.count
                self.getLikeCountProtocol?.getLikeCount(likeCount: docCount, likeFlag: likeFlag)
                
            }
        }
    }
    
    func loadLikeList() {
//        self.profileModelArray = []
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").addSnapshotListener { snapShot, error in
            if error != nil {
                print(error.debugDescription)
                return
            }
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                for doc in snapShotDoc {
                    let data = doc.data()
                    if let name = data["name"] as? String,
                       let age = data["age"] as? String,
                       let height = data["height"] as? String,
                       let bloodType = data["bloodType"] as? String,
                       let prefecture = data["prefecture"] as? String,
                       let gender = data["gender"] as? String,
                       let profile = data["profile"] as? String,
                       let profileImageString = data["profileImageString"] as? String,
                       let uid = data["uid"] as? String,
                       let quickWord = data["quickWord"] as? String,
                       let work = data["work"] as? String {
                        
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineOrNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                }
                
                self.getLikeDataProtocol?.getLikeDataProtocol(userDataModelArray: self.profileModelArray)
                }
    
            }
    }
    
    // matching以下のデータを取得する
    func loadMatchingPersonData() {
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").addSnapshotListener { snapShot, error in
            if error != nil {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                
                self.profileModelArray = []
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    if let name = data["name"] as? String,
                    let age = data["age"] as? String,
                    let height = data["height"] as? String,
                    let bloodType = data["bloodType"] as? String,
                    let prefecture = data["prefecture"] as? String,
                    let gender = data["gender"] as? String,
                    let profile = data["profile"] as? String,
                    let profileImageString = data["profileImageString"] as? String,
                    let uid = data["uid"] as? String,
                    let quickWord = data["quickWord"] as? String,
                    let work = data["work"] as? String {
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: 0, onlineOrNot: true)
                        
                        self.profileModelArray.append(userDataModel)
                    }
                }
                
                self.getWhoIsMatchListProtocol?.getWhoIsMatchListProtocol(userDataModelArray: self.profileModelArray)
            }
            
        }
        
    }
    
    func loadAshiatoData() {
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ashiato").order(by: "date").addSnapshotListener { snapShot, error in
            if error != nil {
                return
            }
            
            if let snapShotDoc = snapShot?.documents {
                self.profileModelArray = []
                for doc in snapShotDoc {
                    
                    let data = doc.data()
                    
                    if let name = data["name"] as? String,
                    let age = data["age"] as? String,
                    let height = data["height"] as? String,
                    let bloodType = data["bloodType"] as? String,
                    let prefecture = data["prefecture"] as? String,
                    let gender = data["gender"] as? String,
                    let profile = data["profile"] as? String,
                    let profileImageString = data["profileImageString"] as? String,
                    let uid = data["uid"] as? String,
                    let quickWord = data["quickWord"] as? String,
                    let work = data["work"] as? String, let date = data["date"] as? Double {
                        let userDataModel = UserDataModel(name: name, age: age, height: height, bloodType: bloodType, prefecture: prefecture, gender: gender, profile: profile, profileImageString: profileImageString, uid: uid, quickWord: quickWord, work: work, date: date, onlineOrNot: true)
                        self.profileModelArray.append(userDataModel)
                        
                    }
                }
                
                self.getAshiatoDataProtocol?.getAshiatoDataProtocol(userDataModelArray: self.profileModelArray)
                
            }
            
            
        }
        
    }
    
    
}
