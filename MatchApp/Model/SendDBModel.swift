//
//  SendDBModel.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/06/18.
//

import Foundation
import Firebase

protocol ProfileSendDone {
    func profileSendDone()
}

protocol LikeSendDelegate {
    func like()
}

protocol GetAttachProtocol {
    func getAttachProtocol(attachImageString:String)
}

class SendDBModel {
    
    let db = Firestore.firestore()
    
    var profileSendDone:ProfileSendDone?
    var likeSendDelegate:LikeSendDelegate?
    var getAttachProtocol:GetAttachProtocol?
    
    // プロフィールをfirestoreに送信
    func sendProfileData(userData:UserDataModel, profileImageData:Data) {
        
        let imageRef = Storage.storage().reference().child("ProfileImage").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(profileImageData, metadata: nil) { metaData, error in
            if error != nil {
                return
            }
            
            imageRef.downloadURL{ url, error in
                if error != nil {
                    return
                }
                
                if url != nil {
                    self.db.collection("Users").document(Auth.auth().currentUser!.uid).setData(
                        ["name":userData.name as Any,
                         "age":userData.age as Any,
                         "height":userData.height as Any,
                         "bloodType":userData.bloodType as Any,
                         "prefecture":userData.prefecture as Any,
                         "gender":userData.gender as Any,
                         "profile":userData.profile as Any,
                         "profileImageString":url?.absoluteString as Any,
                         "uid":Auth.auth().currentUser!.uid as Any,
                         "quickWord":userData.quickWord as Any,
                         "work":userData.work as Any,
                         "onlineOrNot":userData.onlineOrNot as Any,
                        ]
                    )
                    
                    KeyChainConfig.setKeyData(value: ["name":userData.name as Any,
                                                      "age":userData.age as Any,
                                                      "height":userData.height as Any,
                                                      "bloodType":userData.bloodType as Any,
                                                      "prefecture":userData.prefecture as Any,
                                                      "gender":userData.gender as Any,
                                                      "profile":userData.profile as Any,
                                                      "profileImageString":url?.absoluteString as Any,
                                                      "uid":Auth.auth().currentUser!.uid as Any,
                                                      "quickWord":userData.quickWord as Any,
                                                      "work":userData.work as Any], key: "userData")
                    
                    self.profileSendDone?.profileSendDone()
                }
            }
            
        }
        
    }
    func sendToLike(likeFlag:Bool, thisUserID:String) {
        
        // まだLikeをしていない状態、再びLikeをする前の状態
        if likeFlag == false {
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":false])
            
            // 消す
            deleteToLike(thisUserID: thisUserID)
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            // 自分がLikeした人たちのID一覧
            print(ownLikeListArray.debugDescription)
            
        } else if likeFlag == true {
            
            let userData = KeyChainConfig.getKeyArrayData(key: "userData")
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":true, "gender":userData["gender"] as Any, "uid":userData["uid"] as Any, "age":userData["age"] as Any, "height":userData["height"] as Any, "profileImageString":userData["profileImageString"] as Any, "prefecture":userData["prefecture"] as Any, "name":userData["name"] as Any, "quickWord":userData["quickWord"] as Any, "profile":userData["profile"] as Any, "bloodType":userData["bloodType"] as Any, "work":userData["work"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLike").document(Auth.auth().currentUser!.uid).setData(["like":true, "gender":userData["gender"] as Any, "uid":userData["uid"] as Any, "age":userData["age"] as Any, "height":userData["height"] as Any, "profileImageString":userData["profileImageString"] as Any, "prefecture":userData["prefecture"] as Any, "name":userData["name"] as Any, "quickWord":userData["quickWord"] as Any, "profile":userData["profile"] as Any, "bloodType":userData["bloodType"] as Any, "work":userData["work"] as Any])
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            // Likeが終わったことをProfileViewControllerに通知
            self.likeSendDelegate?.like()
            
        }
    }
    
    func deleteToLike(thisUserID:String) {
        
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(Auth.auth().currentUser!.uid).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLike").document(Auth.auth().currentUser!.uid).delete()
    }
    
    // いいねをされたリストからのいいねをする場合のメソッド
    func sendToLikeFromLike(likeFlag:Bool, thisUserID:String, matchName:String, matchID:String) {
        
        if likeFlag == false {
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":false])
            deleteToLike(thisUserID: thisUserID)
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.removeAll(where: {$0 == thisUserID})
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
        } else if likeFlag == true {
            let userData = KeyChainConfig.getKeyArrayListData(key: "userData")
            self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).setData(["like":true, "gender":userData["gender"] as Any, "uid":userData["uid"] as Any, "age":userData["age"] as Any, "height":userData["height"] as Any, "profileImageString":userData["profileImageString"] as Any, "prefecture":userData["prefecture"] as Any, "name":userData["name"] as Any, "quickWord":userData["quickWord"] as Any, "profile":userData["profile"], "bloodType":userData["bloodType"] as Any, "work":userData["word"] as Any])
            
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("ownLike").document(thisUserID).setData(["like":true, "gender":userData["gender"] as Any, "uid":userData["uid"] as Any, "age":userData["age"] as Any, "height":userData["height"] as Any, "profileImageString":userData["profileImageString"] as Any, "prefecture":userData["prefecture"] as Any, "name":userData["name"] as Any, "quickWord":userData["quickWord"] as Any, "profile":userData["profile"] as Any, "bloodType":userData["bloodType"] as Any, "work":userData["work"] as Any])
            
            var ownLikeListArray = KeyChainConfig.getKeyArrayListData(key: "ownLikeList")
            ownLikeListArray.append(thisUserID)
            KeyChainConfig.setKeyArrayData(value: ownLikeListArray, key: "ownLikeList")
            
            // マッチング成立
            Util.matchNotification(name: matchName, id: matchID)
            
            // 自分が相手にしたLikeを消す
            deleteToLike(thisUserID: Auth.auth().currentUser!.uid)
            // 相手の自分に対するlikeも消す
            deleteToLike(thisUserID: matchID)
            self.likeSendDelegate?.like()
            
        }
        
    }
    
    //　引数モデル化してもいい
    func sendToMatchingList(thisUserID:String, name:String, age:String, height:String, bloodType:String, prefecture:String, gender:String, profile:String, profileImageString:String, uid:String, quickWord:String, work:String, userData:[String:Any]) {
        
        if thisUserID != uid {
            self.db.collection("Users").document(thisUserID).collection("matching").document(Auth.auth().currentUser!.uid).setData(
                ["gender":gender as Any, "uid":uid as Any, "age":age as Any, "height":height as Any, "profileImageString":profileImageString as Any, "prefecture":prefecture as Any, "name":name as Any, "quickWord":quickWord as Any, "profile":profile as Any, "bloodType":bloodType as Any, "work":work as Any]
            )
        } else {
            self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("matching").document(thisUserID).setData(
                ["gender":gender as Any, "uid":uid as Any, "age":age as Any, "height":height as Any, "profileImageString":profileImageString as Any, "prefecture":prefecture as Any, "name":name as Any, "quickWord":quickWord as Any, "profile":profile as Any, "bloodType":bloodType as Any, "work":work as Any]
            )
        }
        self.db.collection("Users").document(thisUserID).collection("like").document(Auth.auth().currentUser!.uid).delete()
        self.db.collection("Users").document(Auth.auth().currentUser!.uid).collection("like").document(thisUserID).delete()
        
    }
    
    func sendAshiato(userID:String) {
        
        let userData = KeyChainConfig.getKeyArrayData(key: "userData")
        
        
        self.db.collection("Users").document(userID).collection("ashiato").document(Auth.auth().currentUser!.uid).setData([ "gender":userData["gender"] as Any, "uid":userData["uid"] as Any, "age":userData["age"] as Any, "height":userData["height"] as Any, "profileImageString":userData["profileImageString"] as Any, "prefecture":userData["prefecture"] as Any, "name":userData["name"] as Any, "quickWord":userData["quickWord"] as Any, "profile":userData["profile"] as Any, "bloodType":userData["bloodType"] as Any, "work":userData["work"] as Any, "date":Date().timeIntervalSince1970])
        
    }
    
    func sendImageData(image:UIImage, senderID:String, toID:String) {
        
        let userData = KeyChainConfig.getKeyArrayData(key: "userData")
        
        let imageRef = Storage.storage().reference().child("ChatImages").child("\(UUID().uuidString + String(Date().timeIntervalSince1970)).jpeg")
        
        imageRef.putData(image.jpegData(compressionQuality: 0.3)!, metadata: nil) { metaData, error in
            if error != nil {
                return
            }
            
            imageRef.downloadURL{ url, error in
                if error != nil {
                    return
                }
                
                if url != nil {
                    self.db.collection("Users").document(senderID).collection("matching").document(toID).collection("chat").document().setData(
                        ["senderID":Auth.auth().currentUser!.uid, "displayName":userData["name"] as Any,
                         "imageURLString":userData["profileImageString"] as Any,
                         "date":Date().timeIntervalSince1970,
                         "attachImageString":url?.absoluteString as Any
                        ]
                    )
                    
                    self.db.collection("Users").document(toID).collection("matching").document(senderID).collection("chat").document().setData(
                        ["senderID":Auth.auth().currentUser!.uid, "displayName":userData["name"] as Any,
                         "imageURLString":userData["profileImageString"] as Any,
                         "date":Date().timeIntervalSince1970,
                         "attachImageString":url?.absoluteString as Any
                        ]
                    )
                    self.getAttachProtocol?.getAttachProtocol(attachImageString: url?.absoluteString)
                    
            }
            
        }
        
    }
    
    
}
}
