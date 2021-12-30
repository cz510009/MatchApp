//
//  InputProfileTextController.swift
//  MatchApp
//
//  Created by j.ikegami on 2021/06/17.
//

import UIKit

class InputProfileTextController: UIViewController {

    @IBOutlet weak var profileTextView: UITextView!
    
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Util.rectButton(button: doneButton)
    }
    
    
    @IBAction func done(_ sender: Any) {
        let manager = Manager.shared
        print(manager.profile)
        manager.profile = profileTextView.text
        dismiss(animated: true, completion: nil)
    }

}
