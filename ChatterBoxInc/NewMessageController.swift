//
//  NewMessageController.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 7/12/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))

        fetchUser()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)

    }
    
    func fetchUser(){
    
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
            
                let user = User()
                //set uid so everytime fetching the user you get a uid
                user.id = snapshot.key
                
                //if your name key not match with firebase, the app will crash
                user.setValuesForKeys(dictionary)
                self.users.append(user)
                
                 DispatchQueue.main.async(execute: {
                    
                self.tableView.reloadData()
                    
                })
            }
            
        }, withCancel: nil)
    
    }

    func handleCancel(){
    
        dismiss(animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as!  UserCell
        
        let user = users[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        if let profileImageUrl = user.profileImageUrl{
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
            
        }
        
        return cell
    }
    //give some space on top of tablerow
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        dismiss(animated: true){
        
            let user = self.users[(indexPath as NSIndexPath).row]
            self.messagesController?.showChatControllerForUser(user)
        
        }
    }
    
    
}


