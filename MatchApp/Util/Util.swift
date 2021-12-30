//
//  Util.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/06/17.
//

import Foundation
import UIKit
import Hex
import Lottie
import ImpressiveNotifications

class Util {
    static func prefectures()->[String]{
            return ["北海道","青森県","岩手県","宮城県","秋田県","山形県","福島県","茨城県","栃木県","群馬県","埼玉県","千葉県","東京都","神奈川県","新潟県","富山県","石川県","福井県","山梨県","長野県","岐阜県","静岡県","愛知県","三重県","滋賀県","京都府","大阪府","兵庫県","奈良県","和歌山県","鳥取県","島根県","岡山県","広島県","山口県","徳島県","香川県","愛媛県","高知県","福岡県","佐賀県","長崎県","熊本県","大分県","宮崎県","鹿児島県","沖縄県"]
        }
    
    static func rectButton(button:UIButton) {
        
        // ボタンの色統一
        button.layer.cornerRadius = 5.0
        button.backgroundColor = UIColor(hex:"#42c4cc")
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.blue.cgColor
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    static func startAnimation(name:String, view:UIView) {
        
        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.frame = view.bounds
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        view.addSubview(animationView)
        animationView.play { finished in
            if finished {
                animationView.removeFromSuperview()
            }
        }
        
    }
    
    // マッチしたときの通知
    static func matchNotification(name:String, id:String) {
        INNotifications.show(type: .success, data: INNotificationData(title: "\(name)さんとマッチングしました！", description: "さっそくメッセージをしてみましょう", image: UIImage(named: "match"), delay: 3, completionHandler: nil), customStyle: INNotificationStyle(cornerRadius: 20.0, backgroundColor: .cyan, titleColor: .white, descriptionColor: .purple, imageSize: CGSize(width: 100.0, height: 100.0)))
    }
    
    
}
