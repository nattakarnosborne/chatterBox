//
//  ChatInputContainerView.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 8/19/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit

class ChatInputContainerView: UIView, UITextFieldDelegate{

    var chatLogController: ChatLogController?{
        
        didSet{
            
            sendButton.addTarget(chatLogController, action: #selector(ChatLogController.handleSend), for: .touchUpInside)
        
            cameraButton.addTarget(chatLogController, action: #selector(ChatLogController.showActionSheet), for: .touchUpInside)

        }
    }
    
    lazy var inputTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        
        return textField
    }()
    
    let sendButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.tintColor = UIColor.rgb(226, g: 142, b: 149)
        
        return button
    
    }()
    
    
    let cameraButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom) as UIButton
        button.tintColor = UIColor.rgb(226, g: 142, b: 149)
        
        return button
        
    }()
    
    
    let cameraImage: UIImage = {
        
        let image = UIImage(named: "camera")
        
        return image!
        
        
    }()
    

    
    override init(frame: CGRect){
    
        super.init(frame: frame)
        
               
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        //constraint
        
        addSubview(sendButton)
        
        cameraButton.setImage(self.cameraImage, for: UIControlState())
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(cameraButton)
        
        cameraButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        
        sendButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(inputTextField)
        
        //constraint
        
        inputTextField.leftAnchor.constraint(equalTo: cameraButton.rightAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.rgb(220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separatorLineView)
        
        //constraint
        
        separatorLineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        chatLogController?.handleSend()
        return true
    }
    
    required init?(coder aDecoder: NSCoder){
    
    
        fatalError("init(coder:) has not been implemented")
    }


    
    
}
