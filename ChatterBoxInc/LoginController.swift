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
import FirebaseDatabase


class LoginController: UIViewController, UITextFieldDelegate {
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
 



    
    var messagesController: MessagesController?
    var termOfServiceController: TermOfServiceController?
    var privacyPolicyController: PrivacyPolicyController?
    var profileSettingController: ProfileSettingController?
    var loginController: LoginController?
    var customTabBarController: CustomTabBarController?
    var favoriteListController: FavoriteListController?
    
    
  //  var signupController: SignupController?
    
    var loginEmailTextFieldValue: String?
    var loginPasswordTextFieldValue: String?
    
    lazy var loginEmailTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.whileEditing
        tf.delegate = self
        return tf
        
        
    }()
    

  
    lazy var loginPasswordTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.isSecureTextEntry = true
        tf.delegate = self
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.whileEditing
        
        return tf
    }()
    
    
    lazy var forgotPasswordButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControlState())
        
        button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 9)
        button.addTarget(self, action: #selector(forgotPassword), for: .touchUpInside)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        button.sizeToFit()
        
        
        return button
        
    }()
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor.rgb(0, g: 96, b: 100)
        button.setTitle("Log In", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.red, for: .highlighted)
        // Set the button Background Color
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        var btnGradient = CAGradientLayer()
        btnGradient.frame = button.bounds
        btnGradient.colors = [(UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0).cgColor as Any), (UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0).cgColor as Any)]
        button.layer.insertSublayer(btnGradient, at: 0)
        
        var btnLayer = button.layer
        btnLayer.masksToBounds = true
        btnLayer.cornerRadius = 5.0
        
        // Apply a 1 pixel, black border
        btnLayer.borderWidth = 1.0
        btnLayer.borderColor = UIColor.white.cgColor

        
        
        
        
        return button
    }()
    
    lazy var anonymousLoginButton: UIButton = {
        
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor.rgb(0, g: 96, b: 100)
        button.setTitle("Anonymous Log In", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.red, for: .highlighted)
        // Set the button Background Color
        
        button.addTarget(self, action: #selector(handleLoginAnonymous), for: .touchUpInside)
        
        var btnGradient = CAGradientLayer()
        btnGradient.frame = button.bounds
        btnGradient.colors = [(UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0).cgColor as Any), (UIColor(red: 51.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0).cgColor as Any)]
        button.layer.insertSublayer(btnGradient, at: 0)
        
        var btnLayer = button.layer
        btnLayer.masksToBounds = true
        btnLayer.cornerRadius = 5.0
        
        // Apply a 1 pixel, black border
        btnLayer.borderWidth = 1.0
        btnLayer.borderColor = UIColor.white.cgColor
        
        return button
        
    }()
    

    
    let termStackView: UIStackView = {
        
        let stackView = UIStackView()
        stackView.axis  = UILayoutConstraintAxis.horizontal
        stackView.distribution  = UIStackViewDistribution.fillProportionally
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 2.0
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        
        return stackView
        
        
    }()
    
    let termLabel: UILabel = {
        let label = UILabel()
        label.text = "Don't have an account? Create one "
        label.font = label.font.withSize(10)
        label.textColor = .white
        label.textAlignment = .center
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    lazy var signUpVCButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControlState())

        button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 9)
        button.addTarget(self, action: #selector(showSignupController), for: .touchUpInside)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        button.sizeToFit()
        
        
        return button
        
    }()
    
    let andLabel: UILabel = {
        let label = UILabel()
        label.text = " or "
        label.font = label.font.withSize(10)
        label.textColor = .white
        label.textAlignment = .center
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    

    
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chatterBoxLogoTiltLine1")?.withRenderingMode(.alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    

    let aivLoadingSpinner: UIActivityIndicatorView = {
    
        let aiv = UIActivityIndicatorView()
        aiv.color = .white
        aiv.translatesAutoresizingMaskIntoConstraints = false

        
        return aiv
    
    }()

    
    func handleLoginRegister() {
        
        if loginEmailTextFieldValue != nil{
            
            loginEmailTextField.text = loginEmailTextFieldValue!
            
        }
        
        if loginPasswordTextFieldValue != nil{
            
            loginPasswordTextField.text = loginPasswordTextFieldValue
        }
        
        
            handleLogin()
        
    }
    
    
    func handleLogin() {
        
        guard let email = loginEmailTextField.text, let password = loginPasswordTextField.text else {

            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if (error != nil) {
                if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
                    
                    switch errCode {
                        
                    case .errorCodeWrongPassword:
                        
                        SweetAlert().showAlert("Error!", subTitle: "Wrong password", style: AlertStyle.error)
                        
                    case .errorCodeInvalidEmail:
                        
                        SweetAlert().showAlert("Error!", subTitle: "Invalid Email", style: AlertStyle.error)

                        
                    default:
                        
                        SweetAlert().showAlert("Error!", subTitle: "User not found please register!", style: AlertStyle.error)

                        
                    }
                }
            }else{
            
                self.aivLoadingSpinner.startAnimating()
                self.messagesController?.fetchUserAndSetupNavBarTitle()
                
                //successfully logged in our user
                
                let customTabBarController = CustomTabBarController()
                customTabBarController.loginController = self
                
                self.present(customTabBarController, animated: true, completion: nil)
            }
            
           
            
        })
        
        
    }
    

    func handleLoginAnonymous(){
        
        FIRAuth.auth()?.signInAnonymously() { (user, error) in
            if let error = error {
                
                SweetAlert().showAlert(error as! String)
                
            }
        }
        self.aivLoadingSpinner.startAnimating()
        self.messagesController?.fetchUserAndSetupNavBarTitle()
    
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // view.backgroundColor =  UIColor.rgb(211, g: 81, b: 91)
        view.addSubview(logoImageView)
        view.addSubview(loginEmailTextField)
        view.addSubview(loginPasswordTextField)
        view.addSubview(aivLoadingSpinner)

        view.addSubview(loginButton)
//        view.addSubview(anonymousLoginButton)

        view.addSubview(termStackView)
        
        setupLogoImageView()
        setupLoginEmailTextField()
        setupLoginPasswordTextField()
        setupLoginButton()
//        setupAnonymousButton()
        setUptermStackView()
        
        observeKeyboardNotifications()
        setupAivLoadingSpinner()
        addGradientBackground()
//        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
//
//            SweetAlert().showAlert("Error!", subTitle: "Device has no camera", style: AlertStyle.success)
//
//        }
   
        
    }
    
    func addGradientBackground() {
        var arrayOfColors: [AnyObject] = []
        let colorTop: AnyObject = UIColor.rgb(215, g: 97, b: 106).cgColor
        let colorBottom: AnyObject = UIColor.rgb(211, g: 81, b: 91).cgColor
        arrayOfColors = [colorTop, colorBottom]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = arrayOfColors
        gradientLayer.locations = [0.0, 1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    func setupAivLoadingSpinner(){
    
        aivLoadingSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        aivLoadingSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        aivLoadingSpinner.widthAnchor.constraint(equalToConstant: 35).isActive = true
        aivLoadingSpinner.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    
    }


    override func viewDidLayoutSubviews() {
        
        let loginEmailTextFieldBorder = CALayer()
        let loginEmailTextFieldWidth = CGFloat(2.0)
        loginEmailTextFieldBorder.borderColor = UIColor.white.cgColor
        loginEmailTextFieldBorder.borderWidth = loginEmailTextFieldWidth
        
        loginEmailTextFieldBorder.frame = CGRect(x: 0, y: loginEmailTextField.frame.size.height - loginEmailTextFieldWidth, width:  loginEmailTextField.frame.size.width, height: loginEmailTextField.frame.size.height)
        
        loginEmailTextField.layer.addSublayer(loginEmailTextFieldBorder)
        loginEmailTextField.layer.masksToBounds = true
        
        
        let loginPasswordTextFieldBorder = CALayer()
        let loginPasswordTextFieldWidth = CGFloat(2.0)
        loginPasswordTextFieldBorder.borderColor = UIColor.white.cgColor
        loginPasswordTextFieldBorder.borderWidth = loginPasswordTextFieldWidth
        
        loginPasswordTextFieldBorder.frame = CGRect(x: 0, y: loginPasswordTextField.frame.size.height - loginPasswordTextFieldWidth, width:  loginPasswordTextField.frame.size.width, height: loginPasswordTextField.frame.size.height)
        
        loginPasswordTextField.layer.addSublayer(loginPasswordTextFieldBorder)
        loginPasswordTextField.layer.masksToBounds = true
        
        
    }
    
    func setupLogoImageView() {
        //need x, y, width, height constraints
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    
    
    var loginEmailTextFieldHeightAnchor: NSLayoutConstraint?
    var loginPasswordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    func setupLoginEmailTextField() {
        //need x, y, width, height constraints
        
        loginEmailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginEmailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30).isActive = true
        loginEmailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        loginEmailTextFieldHeightAnchor = loginEmailTextField.heightAnchor.constraint(equalToConstant: 40)
        loginEmailTextFieldHeightAnchor?.isActive = true
        
       
    }
    
    func setupLoginPasswordTextField(){
    
        loginPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginPasswordTextField.topAnchor.constraint(equalTo: loginEmailTextField.bottomAnchor, constant: 20).isActive = true
        loginPasswordTextField.widthAnchor.constraint(equalTo: loginEmailTextField.widthAnchor).isActive = true
        loginPasswordTextFieldHeightAnchor = loginPasswordTextField.heightAnchor.constraint(equalToConstant: 40)
        loginPasswordTextFieldHeightAnchor?.isActive = true
    
    }
    
    func setupLoginButton() {
        //need x, y, width, height constraints
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: loginPasswordTextField.bottomAnchor, constant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalTo: loginPasswordTextField.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupAnonymousButton(){
    
      
        
        anonymousLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        anonymousLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
        anonymousLoginButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        anonymousLoginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    
    }
    func setUptermStackView(){
        
        termStackView.addArrangedSubview(termLabel)
        termStackView.addArrangedSubview(signUpVCButton)
        termStackView.addArrangedSubview(andLabel)
        termStackView.addArrangedSubview(forgotPasswordButton)
        
        termStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        termStackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        termStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
        termStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        termStackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    func showSignupController(){
        
        let signupController = SignupController()
        signupController.loginController = self

        present(signupController, animated: true, completion: nil)
        
    }
    
    func forgotPassword(){
        
        guard let email = loginEmailTextField.text else {
            return
        }
    
      
            FIRAuth.auth()?.sendPasswordReset(withEmail: loginEmailTextField.text!) { error in
                
                if error != nil {
                    
                    SweetAlert().showAlert("Error", subTitle: "Please enter your associate email account", style: AlertStyle.none)
                
                } else {
                    SweetAlert().showAlert("Reset Password", subTitle: "Send a link to \(email) to reset a password?", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, reset it", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                        if isOtherButton == true {
                            
                            SweetAlert().showAlert("Cancelled!", subTitle: "Please enter your password", style: AlertStyle.error)
                        }
                        else {
                            SweetAlert().showAlert("Reset Password", subTitle: "Link to reset password was send to \(email)", style: AlertStyle.success)
                        }
                    }


                }
            }
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
            
            self.view.frame = CGRect(x: 0, y: -40, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }
    

    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
//    func sentVerifiedEmail() {
//        if let user = FIRAuth.auth()?.currentUser {
//            user.sendEmailVerification() { error in
//                if let error = error {
//                    AppDelegate.showAlertMsg(withViewController: self, message: error.localizedDescription)
//                } else {
//                    AppDelegate.showAlertMsg(withViewController: self, message: "Email verification has been sent to [\(user.email!)]. Please check your email and verify it. Then login again.")
//                    self.logout()
//                }
//            }
//        }
//    }

}




