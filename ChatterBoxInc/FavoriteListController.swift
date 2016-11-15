//
//  favoriteListControllerTableViewController.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 10/11/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class FavoriteListController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    var users = [Favorite()]
    var userName: String?
    var userId: String?
    var profileImageUrl: String?
    
    var favorite = [Favorite]()
    //   var favoriteDictionary = [String: AnyObject]()
    
    
    
    // refactor the code put all of this view in View folder
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgb(236, g: 233, b: 233)
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        
        
        return cv
    }()
    
    
    
    let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        //use autolayout instead
        collectionView.anchorToTop(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
 //       fetchUser()
        
        
    }
    
    
    
    
    
    func fetchUser(){
        
        FIRDatabase.database().reference().child("favorites").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                
                let user = Favorite()
                //set uid so everytime fetching the user you get a uid
                user.id = snapshot.key
                
                //if your name key not match with firebase, the app will crash
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
            }
            
        }, withCancel: nil)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
        
        let user = users[(indexPath as NSIndexPath).row]
        
        // got this from firebase user
        self.userName = user.name
        self.userId = user.id
        cell.nameLabel.text = user.name
        cell.ageLabel.text = user.id
        
        
        if let profileImageUrl = user.profileImageUrl{
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            
        }
        self.profileImageUrl = user.profileImageUrl
        
        cell.favoriteButton.addTarget(self, action: #selector(addToFavorite), for: UIControlEvents.touchUpInside)
        // i want to addChild "favorite"
        cell.flagButton.addTarget(self, action: #selector(reportAccount), for: UIControlEvents.touchUpInside)
        
        cell.startChatButton.tag = indexPath.row
        cell.startChatButton.addTarget(self, action: #selector(startChat), for: UIControlEvents.touchUpInside)
        
        return cell
    }
    var messageController: MessagesController?
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        dismiss(animated: true){
            
            let user = self.users[(indexPath as NSIndexPath).row]
   //         self.messageController?.showChatControllerForUser(user)
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    
    
    
    func addToFavorite() {
        
        let ref = FIRDatabase.database().reference().child("favorites")
        let childRef = ref.childByAutoId()
        let toId = self.userId!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        let values: [String: AnyObject] = ["id": self.userId! as AnyObject, "toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        
        //        childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            let userFavoritesRef = FIRDatabase.database().reference().child("user-favorites").child(fromId)
            
            let favoriteId = childRef.key
            userFavoritesRef.updateChildValues([favoriteId: 1])
            
        }
        print("added to favorite")
        SweetAlert().showAlert("This feature is temporary unavailable", subTitle: "We are working on it", style: AlertStyle.success)
        
        
    }
    
    
    func reportAccount(){
        
        let ref = FIRDatabase.database().reference().child("reportImage")
        let childRef = ref.childByAutoId()
        let toId = self.userId!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        let values: [String: AnyObject] = ["id": self.userId! as AnyObject, "toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        
        //        childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, ref) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            let userFavoritesRef = FIRDatabase.database().reference().child("user-reportImage").child(fromId)
            
            let favoriteId = childRef.key
            userFavoritesRef.updateChildValues([favoriteId: 1])
            
        }
        
        print("report account")
    }
    
    func startChat(){
        
        //   let user = users[(indexPath as NSIndexPath).row]
        let user = self.userId
        
        guard let favoritePartnerId = user else {
            return
        }
        
        let ref = FIRDatabase.database().reference().child("users").child(favoritePartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }
            
            let user = User()
            user.id = favoritePartnerId
            user.setValuesForKeys(dictionary)
            self.showChatControllerForUser(user)
            
        }, withCancel: nil)
        
        
    }
    
    func showChatControllerForUser(_ user: User) {
        
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
        
    }    
    
    
}
