//
//  FavoriteCell.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 10/15/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FavoriteCell: UICollectionViewCell {
    
    var favorite: Favorite? {
        didSet {
            
            guard let favorite = favorite else {
                return
            }
            
            profileImageView.image = UIImage(named: favorite.profileImageUrl!)
            
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .white
        iv.image = UIImage(named: "page1")
        iv.clipsToBounds = true
        return iv
    }()
    
    let nameView: UIView = {
        
        let view = UIView()
        
        return view
        
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Firstname Lastname" + ", "
        
        return label
    }()
    
    let ageLabel: UILabel = {
        
        let label = UILabel()
        label.text = "User Age"
        
        
        return label
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "heart-death")
        button.tintColor = UIColor.rgb(211, g: 81, b: 91)
        button.setImage(image, for: UIControlState())
        
        // button.addTarget(self, action: #selector(notInterested), for: .touchUpInside)
        
        return button
    }()
    
    lazy var flagButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "account-flag")
        button.tintColor = UIColor.rgb(206, g: 123, b: 61)
        button.setImage(image, for: UIControlState())
        
        // button.addTarget(self, action: #selector(reportAccount), for: .touchUpInside)
        
        return button
    }()
    
    lazy var chatButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "bubble-chat-add")
        button.tintColor = UIColor.rgb(61, g: 206, b: 123)
        button.setImage(image, for: UIControlState())
        
        // button.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        
        return button
    }()
    
    func setupButton(){
        
        _ = deleteButton.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 35, bottomConstant: 15, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        _ = flagButton.anchor(nil, left: nil, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 15, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        flagButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        _ = chatButton.anchor(nil, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 15, rightConstant: 35, widthConstant: 50, heightConstant: 50)
        
    }
    
    func setupViews() {
        addSubview(profileImageView)
        addSubview(nameView)
        addSubview(nameLabel)
        addSubview(ageLabel)
        addSubview(lineSeparatorView)
        addSubview(deleteButton)
        addSubview(flagButton)
        addSubview(chatButton)
        
        profileImageView.anchorToTop(topAnchor, left: leftAnchor, bottom: nameView.topAnchor, right: rightAnchor)
        nameView.anchorWithConstantsToTop(profileImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 20, leftConstant: 20, bottomConstant: 0, rightConstant: 16)
        
        nameView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2).isActive = true
        
        nameLabel.anchorWithConstantsToTop(nameView.topAnchor, left: nameView.leftAnchor, bottom: nil, right: nil,  topConstant: 20, leftConstant: 10, bottomConstant: 0, rightConstant: 16)
        
        ageLabel.anchorWithConstantsToTop(nameView.topAnchor, left: nameLabel.rightAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 16, bottomConstant: 0, rightConstant: 0 )
        lineSeparatorView.anchorToTop(nil, left: leftAnchor, bottom: nameView.topAnchor, right: rightAnchor)
        lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        setupButton()
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



