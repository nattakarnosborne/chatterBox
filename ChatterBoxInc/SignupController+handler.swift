//
//  LoginController.swift
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


extension SignupController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

   
    func handleRegister() {
        
        guard let email = signupEmailTextField.text, let password = signupPasswordTextField.text, let name = nameTextField.text else {
            
            SweetAlert().showAlert("Error!", subTitle: "Form is not valid Please check", style: AlertStyle.success)
         
            return
        }
        
        if delegate != nil{
            
            if signupEmailTextField.text != nil{
                
                let emailTextFieldValue = signupEmailTextField.text
                let passwordTextFieldValue = signupPasswordTextField.text
                
                delegate?.handleAutoLogin(emailDelegate: emailTextFieldValue!, passwordDelegate:passwordTextFieldValue!)
                
            }
            
        }
        
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
                
                if (error != nil) {
                    // an error occurred while attempting login
                    
                    if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                        
                        switch errCode {
                        
                        case .errorCodeWeakPassword:
                            
                            SweetAlert().showAlert("Error!", subTitle: "Weak password", style: AlertStyle.success)

                        case .errorCodeEmailAlreadyInUse:
                           
                            SweetAlert().showAlert("Error!", subTitle: "Email is aleready in use", style: AlertStyle.success)

                        case .errorCodeInvalidEmail:

                            SweetAlert().showAlert("Error!", subTitle: "Invalid Email", style: AlertStyle.success)

                        
                            
                        default:
                            
                            SweetAlert().showAlert("Error!", subTitle: "Successfully registered!", style: AlertStyle.success)


                        }
                    }
                }
                
                
                
                
                guard let uid = user?.uid else {
                    return
                }
                
                
                //create uid for userimage
                let imageName = UUID().uuidString
                //successfully authenticated user
                let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).jpg")
                
                if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1){
                    
                    //            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil{
                            
                            print(error as Any)
                            return
                        }
                        
         
                        
                        if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                            
                            let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                            
                            self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                        }
                        
//                        self.loginController?.loginEmailTextFieldValue = self.signupEmailTextField.text
//                        self.loginController?.loginPasswordTextFieldValue = self.signupPasswordTextField.text
//                        
//                        self.dismiss(animated: true, completion: nil)


                    })
                }
            })

        }
        
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]){
    
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: {(err, ref) in
            if err != nil{
            
                print(err as Any)
                return
            }
            
           // self.messagesController?.fetchUserAndSetupNavBarTitle()
           // self.messagesController?.navigationItem.title = values["name"] as? String
            
            let user = User()
            
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user)
            self.dismiss(animated: true, completion: nil)
        })
    }

    
    func handleSelectProfileImageView(){
        
        showActionSheet()
    
    }
    
    

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
    
    func showActionSheet() {
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
        
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
        
            selectedImageFromPicker = editedImage
        }
        if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
    
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
