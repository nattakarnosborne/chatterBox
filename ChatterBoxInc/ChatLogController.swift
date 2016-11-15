//
//  ChatLogController.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 7/12/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import MobileCoreServices
import AVFoundation

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    var user: User? {
        
        didSet{
            
            navigationItem.title = user?.name
            
            observeMessages()
        }
        
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid, let toId = user?.id else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                 self.messages.append(Message(dictionary: dictionary))
                
//                //potential of crashing if keys don't match
//                message.setValuesForKeysWithDictionary(dictionary)
//                
//                //do we need to attempt filtering anymore?
//                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
                
                }, withCancel: nil)
            
            }, withCancel: nil)
    }
    

    
    
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)

        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .interactive

//        setupKeyboardObservers()
    }
    

    lazy var inputContainerView: ChatInputContainerView = {
        
        let chatInputContainerView = ChatInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        chatInputContainerView.chatLogController = self
        chatInputContainerView.backgroundColor = .white
        
        return chatInputContainerView

    
    }()
    
    
    
    func camera()
    {
        let picker = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    func photoLibrary()
    {
        
        let picker = UIImagePickerController()
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func handleUploadTap(){
        
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(picker, animated: true, completion: nil)
        
    }
    
    
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.handleUploadTap()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        dismiss(animated: true, completion: nil)
    }
    
    

    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        ///find out how to send picture message somehow??
        
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
        
            handleVideoSelectedForUrl(videoUrl)
            
        }else{
        
            handleImageSelectedForInfo(info as [String : AnyObject])
            
        }
            dismiss(animated: true, completion: nil)
        
    }
    
    fileprivate func handleVideoSelectedForUrl(_ url: URL){
        
        
        let filename = UUID().uuidString + ".mov"
        
        let uploadTask = FIRStorage.storage().reference().child("message_movies").child(filename).putFile(url, metadata: nil, completion: { (metadata, error) in
            
            
            if error != nil {
                
                print("Failed upload of vdo:", error as Any)
                
                return
                
            }
            
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
                
                if let thumbnailImage = self.thumbnailImageForFileUrl(url){
                    
                    self.uploadToFirebaseStorageUsingImage(thumbnailImage, completion: {(imageUrl)
                        in
                    
                        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": thumbnailImage.size.width as AnyObject, "imageHeight": thumbnailImage.size.height as AnyObject, "videoUrl": videoUrl as AnyObject]
                        self.sendMessageWithProperties(properties)
                        
                    })
                    
                }
                
            }
        })
        
        uploadTask.observe(.progress) { (snapshot) in
            
            if let completedUnitCount = snapshot.progress?.completedUnitCount{
            
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot) in
            
            self.navigationItem.title = self.user?.name
            
        }
        
    }
    
    fileprivate func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        
        let asset = AVAsset(url: fileUrl)
    
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        //give the first frame of vdo
        
        do {
        
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            
            
            return UIImage(cgImage: thumbnailCGImage)

        } catch let err {
         
            print(err)

        }
        
        return nil
        
    }
    
    
    
    
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
    
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            
            selectedImageFromPicker = editedImage
        }
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            //upload imagewith info to firebase
            
            uploadToFirebaseStorageUsingImage(selectedImage, completion: {(imageUrl) in
            
                self.sendMessageWithImageUrl(imageUrl, image: selectedImage)
            
            })
            
        }

    
    }
    
    
    
    fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        
        let imageName = UUID().uuidString
        let ref = FIRStorage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error as Any)
                    return
                }
                
                if let imageUrl = metadata?.downloadURL()?.absoluteString {
                    completion(imageUrl)
                  //  self.sendMessageWithImageUrl(imageUrl, image: image)
                }
                
            })
        }
    }
    
    


    override var inputAccessoryView: UIView?{
    
        get{
   
            return inputContainerView
        }
        
    }
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setupKeyboardObservers(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    
    }
    
    //dealing with memory leak
    
    override func viewDidDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        print(keyboardFrame?.height as Any)
        //move the input area up

        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        //call this after modified constrain
        UIView.animate(withDuration: keyboardDuration!, animations: {
        
            self.view.layoutIfNeeded()
        })
        
    }
    
    func handleKeyboardWillHide(_ notification: Notification){
    
        containerViewBottomAnchor?.constant = 0
        
        let keyboardDuration = ((notification as NSNotification).userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        //call this after modified constrain
        UIView.animate(withDuration: keyboardDuration!, animations: {
            
            self.view.layoutIfNeeded()
        })

        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self
        
        let message = messages[(indexPath as NSIndexPath).item]
        cell.message = message
        
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        
        //modify bubbleView
        if let text = message.text{
            
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
            cell.textView.isHidden = false
        
        }else if message.imageUrl != nil{
        
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }

//        if message.videoUrl != nil{
//        
//            cell.playButton.hidden = false
//        }else{
//        
//            cell.playButton.hidden = true
//        }
        cell.playButton.isHidden = message.videoUrl == nil
        
        return cell
    }
    
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message){
        
        if let profileImageUrl = self.user?.profileImageUrl{
            
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)

        }
        
        if let messageImageUrl = message.imageUrl{
        
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
            
        }else{
        
            cell.messageImageView.isHidden = true
        }
    //otherwise fire off firebase download

        if message.fromId == FIRAuth.auth()?.currentUser?.uid{
            //out going message blue
            cell.bubbleView.backgroundColor = ChatMessageCell.verySoftRed
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        }else{
            //incoming message lime green #8ee2b1
            cell.bubbleView.backgroundColor = UIColor.rgb(146, g: 226, b: 117)
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = false

            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[(indexPath as NSIndexPath).item]
        
        if let text = message.text{
        
            height = estimateFrameForText(text).height + 20
            
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue{
        
            // h1 / w1 = h2/ w2
            //slove for h1
            //h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        
        let width = UIScreen.main.bounds.width
        
        return CGSize(width: width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect{
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func handleSend(){
        
        let properties = ["text": inputContainerView.inputTextField.text!]
        sendMessageWithProperties(properties as [String : AnyObject])
    }
    
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
    }
    
    fileprivate func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        
        let ref = FIRDatabase.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = user!.id!
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "fromId": fromId as AnyObject, "timestamp": timestamp as AnyObject]
        
        //append properties dictionary onto values somehow??
        //key $0, value $1
        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error as Any)
                return
            }
            
            self.inputContainerView.inputTextField.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
    

    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    
    //custom zooming logic
    
    func performZoomInForStartingImageView(_ startingImageView: UIImageView){
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            
        if let keyWindow = UIApplication.shared.keyWindow{
        
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity:  1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
                
                }, completion: {(completed: Bool) in
                    
                    //zoomOutImageView.removeFromSuperview()
                    
            })
            
            }
    }
    
    func handleZoomOut(_ tapGesture: UITapGestureRecognizer){
        
        if let zoomOutImageView = tapGesture.view{
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity:  1, options: .curveEaseOut, animations: {
            
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
                }, completion: {(completed: Bool) in
                    
                    zoomOutImageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
                   
            
            })  
        }
    }
}   


