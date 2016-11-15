//
//  TermOfServiceController.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 9/21/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit

class TermOfServiceController: UIViewController {
    
    var loginController: LoginController?
    var signupController: SignupController?
    var termOfServiceController: TermOfServiceController?
    
    let termLabel: UILabel = {
        let label = UILabel()
        label.text = "Term Of Service"
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
    
    var termText: UITextView = {
        
        let tv = UITextView()
        tv.text = "chatterBox IS PROVIDED AS IS, AND TO THE MAXIMUM EXTENT ALLOWED BY APPLICABLE LAW, IT IS PROVIDED WITHOUT ANY WARRANTY, EXPRESS OR IMPLIED, NOT EVEN A WARRANTY OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. TO THE MAXIMUM EXTENT ALLOWED BY APPLICABLE LAW, THE PROVIDER OF chatterBox, AND ANY OTHER PERSON OR ENTITY ASSOCIATED WITH chatterBox  OPERATION, SHALL NOT BE HELD LIABLE FOR ANY DIRECT OR INDIRECT DAMAGES ARISING FROM THE USE OF chatterBox, OR ANY OTHER DAMAGES RELATED TO chatterBox OF ANY KIND WHATSOEVER. By using chatterBox, you accept the practices outlined in chatterBox's PRIVACY POLICY."
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tv
        
    }()
    


  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backtoLoginController))
        view.backgroundColor = .white
        
        setupTermlabelContainer()
        
        
      
        
    }
    
    func setupTermlabelContainer(){
        
  
        
        
        view.addSubview(termLabel)
        view.addSubview(termText)
        
        _ = termLabel.anchor(view.topAnchor, left: view.leftAnchor, bottom: termText.topAnchor, right: view.rightAnchor, topConstant: 60, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
        _ = termText.anchor(termLabel.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 10, rightConstant: 10, widthConstant: 0, heightConstant: 0)
        
    }
        


    func backtoLoginController(){
    
        _ = navigationController?.popViewController(animated: true)

    }
    
}
