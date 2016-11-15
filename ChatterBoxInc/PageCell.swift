//
//  PageCell.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 10/4/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseDatabase


class PageCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            
            guard let user = user else {
                return
            }
            
            profileImageView.image = UIImage(named: user.profileImageUrl!)
            

            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContainerView()
    
    }

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .white
        iv.image = UIImage(named: "page1")
        iv.clipsToBounds = true
        return iv
    }()
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Firstname Lastname"
        label.translatesAutoresizingMaskIntoConstraints = false

        label.textColor = UIColor.rgb(108, g: 95, b: 95)

        return label
    }()
    
    let commaLabel: UILabel = {
        let label = UILabel()
        label.text =  ", "
        label.textColor = UIColor.rgb(108, g: 95, b: 95)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let ageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "User Age"
        label.textColor = UIColor.rgb(108, g: 95, b: 95)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "basket-favorite-heart")
        button.tintColor = UIColor.rgb(211, g: 81, b: 91)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.rgb(211, g: 81, b: 91).cgColor
        button.layer.borderWidth = 1

        button.setImage(image, for: UIControlState())
        
       // button.addTarget(self, action: #selector(notInterested), for: .touchUpInside)
        
        return button
    }()
    
    lazy var flagButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "account-flag")
        button.tintColor = UIColor.rgb(206, g: 123, b: 61)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.rgb(206, g: 123, b: 61).cgColor
        button.layer.borderWidth = 1
        
        button.setImage(image, for: UIControlState())
        
       // button.addTarget(self, action: #selector(reportAccount), for: .touchUpInside)
        
        return button
    }()
    
    lazy var startChatButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bubble-chat-add")
        button.tintColor = UIColor.rgb(61, g: 206, b: 123)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.rgb(61, g: 206, b: 123).cgColor
        button.layer.borderWidth = 1

        button.setImage(image, for: UIControlState())
        
       // button.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        
        return button
    }()
    
    
    
    func setupButton(){
        
        _ = favoriteButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 35, bottomConstant: 15, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        _ = flagButton.anchor(nil, left: nil, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 15, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        flagButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        _ = startChatButton.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 15, rightConstant: 35, widthConstant: 50, heightConstant: 50)
        
    }
    
    func setupContainerView(){
    
    
        addSubview(containerView)
        
        containerView.addSubview(profileImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(commaLabel)
        containerView.addSubview(ageLabel)
        containerView.addSubview(favoriteButton)
        containerView.addSubview(flagButton)
        containerView.addSubview(startChatButton)
        
        _ = containerView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 100, leftConstant: 50, bottomConstant: 100, rightConstant: 50, widthConstant: 0, heightConstant: 0)
        
        _ = profileImageView.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: nameLabel.topAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = nameLabel.anchor(profileImageView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 20, leftConstant: 10, bottomConstant: 90, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        _ = commaLabel.anchor(profileImageView.bottomAnchor, left: nameLabel.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 90, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = ageLabel.anchor(profileImageView.bottomAnchor, left: commaLabel.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 5, bottomConstant: 90, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = favoriteButton.anchor(nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 35, bottomConstant: 20, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        
        _ = flagButton.anchor(nil, left: nil, bottom: containerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        flagButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        
        _ = startChatButton.anchor(nil, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 35, widthConstant: 40, heightConstant: 40)

    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


