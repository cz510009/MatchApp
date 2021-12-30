//
//  CreateNewUserViewController.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/07/04.
//

import UIKit
import Firebase

class CreateNewUserViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ProfileSendDone {

    

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var textField5: UITextField!
    @IBOutlet weak var textField6: UITextField!
    @IBOutlet weak var quickWordTextField: UITextField!
    
    @IBOutlet weak var toProfileButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    
    var agePicker = UIPickerView()
       var heightPicker = UIPickerView()
       var bloodPicker = UIPickerView()
       var prefecturePicker = UIPickerView()
       var dataStringArray = [String]()
       var dataIntArray = [Int]()
       
       var gender = String()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           textField2.inputView = agePicker
           textField3.inputView = heightPicker
           textField4.inputView = bloodPicker
           textField5.inputView = prefecturePicker
           
           
           agePicker.delegate = self
           agePicker.dataSource = self
           heightPicker.delegate = self
           heightPicker.dataSource = self
           bloodPicker.delegate = self
           bloodPicker.dataSource = self
           prefecturePicker.delegate = self
           prefecturePicker.dataSource = self
           
           agePicker.tag = 1
           heightPicker.tag = 2
           bloodPicker.tag = 3
           prefecturePicker.tag = 4
           
           gender = "男性"
           
           Util.rectButton(button: toProfileButton)
           Util.rectButton(button: doneButton)
           
           // Do any additional setup after loading the view.
       }
       
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           
           switch pickerView.tag {
           case 1:
               dataIntArray = ([Int])(18...80)
               return dataIntArray.count
           case 2:
               dataIntArray = ([Int])(130...220)
               return dataIntArray.count
           case 3:
               dataStringArray = ["A", "B", "AB", "O"]
               return dataStringArray.count
           case 4:
               dataStringArray = Util.prefectures()
               return dataStringArray.count
           default:
               return 0
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           switch pickerView.tag {
           case 1:
               textField2.text = String(dataIntArray[row]) + "歳"
               textField2.resignFirstResponder()
               break
           case 2:
               textField3.text = String(dataIntArray[row]) + "cm"
               textField3.resignFirstResponder()
               break
           case 3:
               textField4.text = dataStringArray[row] + "型"
               textField4.resignFirstResponder()
               break
           case 4:
               textField5.text = dataStringArray[row]
               textField5.resignFirstResponder()
               break
           default:
               break
           }
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           switch pickerView.tag {
           case 1:
               return String(dataIntArray[row]) + "歳"
           case 2:
               return String(dataIntArray[row]) + "cm"
           case 3:
               return dataStringArray[row] + "型"
           case 4:
               return dataStringArray[row]
           default:
               return ""
           }
       }
       
       
       @IBAction func genderSwitch(_ sender: UISegmentedControl) {
           if sender.selectedSegmentIndex == 0 {
               gender = "男性"
           }else {
               gender = "女性"
           }
       }
       
       @IBAction func done(_ sender: Any) {
           // firestoreに値を送信
        let manager = Manager.shared.profile
           
           Auth.auth().signInAnonymously {result, error in
               if error != nil {
                   print(error.debugDescription)
                   return
               }
               if let range1 = self.textField2.text?.range(of: "歳") {
                   self.textField2.text?.replaceSubrange(range1, with: "")
               }
               if let range2 = self.textField3.text?.range(of: "cm") {
                   self.textField3.text?.replaceSubrange(range2, with: "")
               }
               
               let userdata = UserDataModel(name: self.textField1.text, age: self.textField2.text, height: self.textField3.text, bloodType: self.textField4.text, prefecture: self.textField5.text, gender: self.gender, profile: manager, profileImageString:"", uid: Auth.auth().currentUser?.uid, quickWord: self.quickWordTextField.text, work: self.textField6.text, date: Date().timeIntervalSince1970, onlineOrNot: true)
               
               let sendDBModel = SendDBModel()
               sendDBModel.profileSendDone = self
               sendDBModel.sendProfileData(userData: userdata, profileImageData: (self.imageView.image?.jpegData(compressionQuality: 0.4))!)
           }
       }
       func profileSendDone() {
           dismiss(animated: true, completion: nil)
           
       }
       
       @IBAction func tap(_ sender: Any) {
           // カメラ or アルバム起動
           openCamera()
           
       }
       
       func openCamera(){
           let sourceType:UIImagePickerController.SourceType = .photoLibrary
           // カメラが利用可能かチェック
           if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
               // インスタンスの作成
               let cameraPicker = UIImagePickerController()
               cameraPicker.sourceType = sourceType
               cameraPicker.delegate = self
               cameraPicker.allowsEditing = true
   //            cameraPicker.showsCameraControls = true
               present(cameraPicker, animated: true, completion: nil)
               
           }else{
               
           }
           
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           
           if let pickedImage = info[.editedImage] as? UIImage
           {
               imageView.image = pickedImage
               //閉じる処理
               picker.dismiss(animated: true, completion: nil)
            }
    
       }
    
       // 撮影がキャンセルされた時に呼ばれる
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
       }

}
