//
//  PrivacyPolicyController.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 9/22/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit

class PrivacyPolicyController: UIViewController {
    
    var loginController: LoginController?
    var signupController: SignupController?

    var privacyPolicyController: PrivacyPolicyController?
    
    let policyLabel: UILabel = {
        let label = UILabel()
        label.text = "Privacy Policy"
        label.numberOfLines = 0
        label.font = label.font.withSize(24)
        label.textAlignment = .left
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let policyText: UITextView = {
        
        let tv = UITextView()
        tv.text = "This app is aimed at people over 13, this app collects information form you so we can improve the app over time"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tv
        
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backtoPreviousController))
        view.backgroundColor = .white
        
        
        setupPrivacyPolicyLabelContainer()
        
    }
    
    func setupPrivacyPolicyLabelContainer(){
        
        view.addSubview(policyText)
        view.addSubview(policyLabel)
        
        _ = policyLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: policyText.topAnchor, right: view.rightAnchor, topConstant: 60, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = policyText.anchor(policyLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    
    
    func backtoPreviousController(){
        
        _ = navigationController?.popViewController(animated: true)
    }
    
}
