//
//  ChatMessageCell.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 7/14/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var chatLogController: ChatLogController?
    var message: Message?
    
    var activityIndicatorView: UIActivityIndicatorView = {
    
      let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        
        return aiv
    
    }()
    
    lazy var playButton: UIButton = {
    
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.tintColor = UIColor.white
        button.setImage(image, for: UIControlState())
        
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
        
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    func handlePlay(){
    
        if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString){
        
            player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubbleView.bounds
            bubbleView.layer.addSublayer(playerLayer!)
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
        
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
        activityIndicatorView.stopAnimating()
    }
    
    let textView: UITextView = {
        
        let tv = UITextView()
        tv.text = "sample text"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.isEditable = false
        tv.textColor = UIColor.white
        
        return tv
        
    }()
    
    static let verySoftRed = UIColor.rgb(226, g: 142, b: 149)
    
    let bubbleView: UIView = {
    
        let view = UIView()
        view.backgroundColor = verySoftRed
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
        
    }()
    
    let profileImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    
    
    }()
    
    lazy var messageImageView: UIImageView = {
    
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        
        return imageView
    
    }()
    
    func handleZoomTap(_ tapGesture: UITapGestureRecognizer){
        if message?.videoUrl != nil{
            return
        }
        if let imageView = tapGesture.view as? UIImageView{
            
            self.chatLogController?.performZoomInForStartingImageView(imageView)
        
        }
    
    }
    
    // create refference to anchor
    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        
        bubbleView.addSubview(messageImageView)
        
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        bubbleView.addSubview(playButton)
        //x,y.w,h
        
        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        bubbleView.addSubview(activityIndicatorView)
        //x,y.w,h
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        //add constraint to profile imageview
        
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        // setting constraint between in and out message
        
        //add ios 9 constraint
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)

        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        

        
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true

//        textView.widthAnchor.constraintEqualToConstant(200).active = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }


}
