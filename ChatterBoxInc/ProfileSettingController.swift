//
//  ProfileSettingController.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 9/27/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileSettingController: UIViewController, UITextFieldDelegate {
    
    var profileSettingController: ProfileSettingController?
    
    let topView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.rgb(211, g: 81, b: 91)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        return view
        
    }()
    

    
    let middleView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = true
        
        return view
        
    }()
    
    
    let bottomView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = true
        
        return view
        
    }()
    
    
    
    let profileView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor.rgb(206, g: 61, b: 72)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        
        return view
        
    }()
    

    
    var usernameLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Firstname Lastname"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = label.font.withSize(14)
        
        
        
        return label
        
        
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
    
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "camera-circle")?.withRenderingMode(.alwaysOriginal)
        imageView.tintColor = UIColor.rgb(252, g: 252, b: 252)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // adding gesture
        
        // adding gesture
        //imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector()))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var selfieButton: UIButton = {
        
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "file-picture-edit")
        button.tintColor = .white
        button.setImage(image, for: UIControlState())
        button.layer.cornerRadius = 13
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        
        button.addTarget(self, action: #selector(updateUserSelfie), for: .touchUpInside)
        
        return button
        
    }()
    
    
    let displaynameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = UIColor.rgb(211, g: 81, b: 91)
        label.font = label.font.withSize(9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var displaynameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Display Name"
        tf.textColor = .lightGray
        tf.font = tf.font?.withSize(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.always
        tf.delegate = self
        return tf
        
    }()
    
    lazy var updateUserNameButton: UIButton = {
        
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "cloud-add")
        button.tintColor = UIColor.rgb(206, g: 123, b: 61)
        button.setImage(image, for: UIControlState())
        button.layer.cornerRadius = 13
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        
        button.addTarget(self, action: #selector(updateUserName), for: .touchUpInside)
        
        return button
        
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.font = label.font.withSize(9)
        label.textColor = UIColor.rgb(211, g: 81, b: 91)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter email"
        tf.textColor = .lightGray
        tf.keyboardType = .emailAddress
        tf.font = tf.font?.withSize(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.always
        tf.delegate = self

        
        
        return tf
    }()
    
    lazy var updateUserEmailButton: UIButton = {
        
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "cloud-add")
        button.tintColor = UIColor.rgb(206, g: 123, b: 61)
        button.setImage(image, for: UIControlState())
        button.layer.cornerRadius = 13
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        
        button.addTarget(self, action: #selector(updateUserEmail), for: .touchUpInside)
        
        return button
        
    }()
    
    let passwordLabel: UILabel = {
        
        let label = UILabel()
        label.text = "Password"
        label.font = label.font.withSize(9)
        label.textColor = UIColor.rgb(211, g: 81, b: 91)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Change your password"
        tf.textColor = .lightGray
        tf.isSecureTextEntry = true
        tf.font = tf.font?.withSize(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.always
        tf.isSecureTextEntry = true
        tf.delegate = self

        
        
        return tf
    }()
    
    lazy var updateUserPasswordButton: UIButton = {
        
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "cloud-add")
        button.tintColor = UIColor.rgb(206, g: 123, b: 61)
        button.setImage(image, for: UIControlState())
        button.layer.cornerRadius = 13
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        
        button.addTarget(self, action: #selector(updateUserPassword), for: .touchUpInside)
        
        return button
        
    }()
    
    let ageLabel: UILabel = {
        let label = UILabel()
        label.text = "Age"
        label.textColor = UIColor.rgb(211, g: 81, b: 91)
        label.font = label.font.withSize(9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    lazy var ageTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "age"
        tf.textColor = .lightGray
        tf.font = tf.font?.withSize(16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.always


        return tf
        
    }()
    
    lazy var updateUserAgeButton: UIButton = {
        
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "cloud-add")
        button.tintColor = UIColor.rgb(206, g: 123, b: 61)
        button.setImage(image, for: UIControlState())
        button.layer.cornerRadius = 13
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        
        button.addTarget(self, action: #selector(updateUserAge), for: .touchUpInside)
        
        return button
        
    }()

    

    
    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "logout-3")
        button.tintColor = UIColor.rgb(211, g: 81, b: 91)
        button.setImage(image, for: UIControlState())
        
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        
        return button
    }()
    
    lazy var deleteAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("DELETE ACCOUNT", for: .normal)
        button.tintColor = UIColor.rgb(211, g: 81, b: 91)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.rgb(211, g: 81, b: 91).cgColor
        button.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        
        return button
    }()
    

    
    func updateUserSelfie(){
    
    
        
    
    }
    
    func updateUserName(){
        
        
        if let user = FIRAuth.auth()?.currentUser {
            let changeRequest = user.profileChangeRequest()
            
            changeRequest.displayName = displaynameTextField.text
            // changeRequest.photoURL = NSURL(string: profileImageView.text!) as? URL
            changeRequest.commitChanges { error in
                if let error = error {

                SweetAlert().showAlert("Name Changed!", subTitle: error.localizedDescription, style: AlertStyle.success)
                
                } else {
                
                SweetAlert().showAlert("Your name was updated")
                    
                    // AppDelegate.showAlertMsg(withViewController: self, message: "Your profile was updated")
                //self.setUserDataToView(withFIRUser: user)
                }
            }
        }
    }
    
    func updateUserEmail(){
        
        let user = FIRAuth.auth()?.currentUser
        user?.updateEmail(emailTextField.text!) { error in
            if let error = error {
                SweetAlert().showAlert("Email Changed!", subTitle: error.localizedDescription, style: AlertStyle.success)
                
            } else {
                
                SweetAlert().showAlert("Email was updated", subTitle: "Please log in with your new email", style: AlertStyle.success)
                self.logout()
            }
        }
    }
    
    
    
    
    func updateUserPassword(){
        
        let user = FIRAuth.auth()?.currentUser
        user?.updatePassword(passwordTextField.text!) { error in
            if let error = error {
                
                SweetAlert().showAlert("Update Password?", subTitle: error.localizedDescription, style: AlertStyle.error)
                
            } else {
                SweetAlert().showAlert("Password was updated")
                self.logout()

            }
        }
        
    }
    
    
    func updateUserAge(){
    
    
    
    
    }
    

    
    
    
    
    func deleteAccount(){
        
        
        if let user = FIRAuth.auth()?.currentUser {
            
            SweetAlert().showAlert("Are you sure?", subTitle: "You account [\(user.email!)] will permanently delete!", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                
                if isOtherButton == true {
                    
                    print("Cancel Button  Pressed", terminator: "")
                }
                else {
                    SweetAlert().showAlert("Deleted!", subTitle: "Your email [\(user.email!)] has been deleted!", style: AlertStyle.success)
                    user.delete(completion: nil)
                    self.logout()
                }
            }
        }
        
    }
    
    
    func sentVerifiedEmail() {
        if let user = FIRAuth.auth()?.currentUser {
            user.sendEmailVerification() { error in
                if let error = error {
                    
                    SweetAlert().showAlert("Error", subTitle: error.localizedDescription, style: AlertStyle.error)

                } else {
                    SweetAlert().showAlert("Account Verification", subTitle: "Email verification has been sent to [\(user.email!)]. Please check your email and verify it. Then login again.", style: AlertStyle.success)


                    self.logout()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        setupTopView()
        setupMiddleView()
        setupBottomView()

        
        view.backgroundColor = .white

        checkIfUserIsLoggedIn()
      
        observeKeyboardNotifications()
        
        if let user = FIRAuth.auth()?.currentUser, !user.isEmailVerified {

            let when = DispatchTime.now() + 2 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                SweetAlert().showAlert("Verify Account", subTitle: "Please verify your email account", style: AlertStyle.none)
                self.sentVerifiedEmail()
            }
            
            
        
        }
        
        
    }
    
    func setupTopView(){
        
        view.addSubview(topView)
        topView.addSubview(selfieButton)
        topView.addSubview(profileImageView)
        topView.addSubview(usernameLabel)
        view.addSubview(bottomView)
        
        _ = topView.anchor(view.topAnchor, left: view.leftAnchor,bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: view.frame.width, heightConstant: view.frame.height / 4)
        
     _ = profileImageView.anchor(topView.topAnchor, left: topView.leftAnchor ,bottom: nil, right: nil, topConstant: 100, leftConstant: 30, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 120)
        
        _ = selfieButton.anchor(nil, left: profileImageView.rightAnchor,bottom: topView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 2, bottomConstant: 20, rightConstant: 0, widthConstant: 26, heightConstant: 26)
        
        
     _ = usernameLabel.anchor(nil, left: profileImageView.rightAnchor ,bottom: topView.bottomAnchor, right: nil, topConstant: 100, leftConstant: 15, bottomConstant: 0, rightConstant: 0, widthConstant: 150, heightConstant: 25)
        
  
        
        _ = bottomView.anchor(nil, left: view.leftAnchor,bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 20, leftConstant: 5, bottomConstant: 0, rightConstant: 5, widthConstant: view.frame.width, heightConstant: view.frame.height / 5)
        
        
        
    }

    
    
    func setupMiddleView(){
    
        view.addSubview(middleView)
        
        view.sendSubview(toBack: middleView)
        view.addSubview(displaynameLabel)
        view.addSubview(displaynameTextField)
        view.addSubview(updateUserNameButton)
        
        view.addSubview(emailLabel)
        view.addSubview(emailTextField)
        view.addSubview(updateUserEmailButton)

        
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(updateUserPasswordButton)

        
 //       view.addSubview(ageLabel)
//        view.addSubview(ageTextField)
//        view.addSubview(updateUserAgeButton)

        
         _ = middleView.anchor(topView.bottomAnchor, left: view.leftAnchor,bottom: bottomView.topAnchor, right: view.rightAnchor, topConstant: 5, leftConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: view.frame.width, heightConstant: 0)
        
         _ = displaynameLabel.anchor(middleView.topAnchor, left: middleView.leftAnchor ,bottom: nil, right: nil, topConstant: 50, leftConstant: 30, bottomConstant: 0, rightConstant: -30, widthConstant: 0, heightConstant: 0)
        _ = displaynameTextField.anchor(middleView.topAnchor, left: middleView.leftAnchor ,bottom: nil, right: nil, topConstant: 60, leftConstant: 30, bottomConstant: 0, rightConstant: -30, widthConstant: 0, heightConstant: 30)
        
        _ = updateUserNameButton.anchor(middleView.topAnchor, left: displaynameTextField.rightAnchor ,bottom: nil, right: nil, topConstant: 62, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        
        
        _ = emailLabel.anchor(middleView.topAnchor, left: middleView.leftAnchor ,bottom: nil, right: nil, topConstant: 100, leftConstant: 30, bottomConstant: 0, rightConstant: -30, widthConstant: 0, heightConstant: 0)
        _ = emailTextField.anchor(middleView.topAnchor, left: middleView.leftAnchor ,bottom: nil, right: nil, topConstant: 110, leftConstant: 30, bottomConstant: 0, rightConstant: -30, widthConstant: 0, heightConstant: 30)
        _ = updateUserEmailButton.anchor(middleView.topAnchor, left: emailTextField.rightAnchor ,bottom: nil, right: nil, topConstant: 112, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
        
        _ = passwordLabel.anchor(middleView.topAnchor, left: middleView.leftAnchor ,bottom: nil, right: nil, topConstant: 150, leftConstant: 30, bottomConstant: 0, rightConstant: -30, widthConstant: 0, heightConstant: 0)
        _ = passwordTextField.anchor(middleView.topAnchor, left: middleView.leftAnchor ,bottom: nil, right: nil, topConstant: 160, leftConstant: 30, bottomConstant: 0, rightConstant: -30, widthConstant: 0, heightConstant: 30)
          _ = updateUserPasswordButton.anchor(middleView.topAnchor, left: passwordTextField.rightAnchor ,bottom: nil, right: nil, topConstant: 162, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        
//        _ = ageLabel.anchor(middleView.topAnchor, left: middleView.leftAnchor ,bottom: nil, right: nil, topConstant: 200, leftConstant: 30, bottomConstant: 0, rightConstant: -30, widthConstant: 0, heightConstant: 0)
//        _ = ageTextField.anchor(middleView.topAnchor, left: middleView.leftAnchor ,bottom: nil, right: nil, topConstant: 210, leftConstant: 30, bottomConstant: 0, rightConstant: -30, widthConstant: 0, heightConstant: 30)
////        _ = updateUserAgeButton.anchor(middleView.topAnchor, left: ageTextField.rightAnchor ,bottom: nil, right: nil, topConstant: 212, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
    
    }
    
    
    func setupBottomView(){
        
        bottomView.addSubview(deleteAccountButton)
        bottomView.addSubview(logoutButton)
        
        
        _ = logoutButton.anchor(nil, left: bottomView.centerXAnchor , bottom: deleteAccountButton.topAnchor, right: nil, topConstant: 0, leftConstant: -20, bottomConstant: 15, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        
        _ = deleteAccountButton.anchor(nil, left: bottomView.centerXAnchor ,bottom: bottomView.bottomAnchor, right: nil, topConstant: 20, leftConstant: -75, bottomConstant: 20, rightConstant: 0, widthConstant: 150, heightConstant: 30)
        
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: -150, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
        let displaynameBorder = CALayer()
        let displaynameWidth = CGFloat(2.0)
        
        displaynameBorder.borderColor = UIColor.rgb(211, g: 81, b: 91).cgColor
        displaynameBorder.borderWidth = displaynameWidth
        
        displaynameBorder.frame = CGRect(x: 0, y: displaynameTextField.frame.size.height - displaynameWidth, width:  displaynameTextField.frame.size.width, height: displaynameTextField.frame.size.height)
        
        displaynameTextField.layer.addSublayer(displaynameBorder)
        displaynameTextField.layer.masksToBounds = true
        
        let emailBorder = CALayer()
        let emailWidth = CGFloat(2.0)
        emailBorder.borderColor = UIColor.rgb(211, g: 81, b: 91).cgColor
        emailBorder.borderWidth = emailWidth
        
        emailBorder.frame = CGRect(x: 0, y: emailTextField.frame.size.height - emailWidth, width:  emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        
        emailTextField.layer.addSublayer(emailBorder)
        emailTextField.layer.masksToBounds = true
        
        let passwordBorder = CALayer()
        let passwordWidth = CGFloat(2.0)
        passwordBorder.borderColor = UIColor.rgb(211, g: 81, b: 91).cgColor
        passwordBorder.borderWidth = passwordWidth
        
        passwordBorder.frame = CGRect(x: 0, y: passwordTextField.frame.size.height - passwordWidth, width:  passwordTextField.frame.size.width, height: passwordTextField.frame.size.height)
        
        passwordTextField.layer.addSublayer(passwordBorder)
        passwordTextField.layer.masksToBounds = true
        
        let ageBorder = CALayer()
        let ageWidth = CGFloat(2.0)
        ageBorder.borderColor = UIColor.rgb(211, g: 81, b: 91).cgColor
        ageBorder.borderWidth = ageWidth
        
        ageBorder.frame = CGRect(x: 0, y: ageTextField.frame.size.height - ageWidth, width:  ageTextField.frame.size.width, height: ageTextField.frame.size.height)
        
        ageTextField.layer.addSublayer(ageBorder)
        ageTextField.layer.masksToBounds = true
        
        
        
    }
    
    
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(logout), with: nil, afterDelay: 0)
            
        } else {
            fetchUserAndSetupUsernameLabel()
            print("user is logged in")
        }
    }
    
    func fetchUserAndSetupUsernameLabel() {
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }

        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                user.setValuesForKeys(dictionary)
                //self.setupNavBarWithUser(user)
                //self.setupUsernameLabel(user)
                
                
                self.displaynameTextField.text = user.name
                self.usernameLabel.text = user.name
                self.emailTextField.text = user.email
                
                if let profileImageUrl = dictionary["profileImageUrl"] as? String{
                    
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
                
            }
            
            }, withCancel: nil)
    }
    

    func logout() {
        
        
        do {
            try FIRAuth.auth()?.signOut()
            
            let loginController = LoginController()
            loginController.profileSettingController = self
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginController
            
            
        } catch let logoutError {
            
            print(logoutError)
        }
        
        
    }
    

    

    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}

