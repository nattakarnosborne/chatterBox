//
//  SignupController.swift
//  ChatterBox
//
//  Created by Nattakarn Osborne on 10/14/16.
//  Copyright © 2016 Nattakarn Osborne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol EmailPasswordDelegate {
    
    func handleAutoLogin(emailDelegate: String, passwordDelegate: String)
}

class SignupController: UIViewController, UITextFieldDelegate {
    

    var delegate: EmailPasswordDelegate? = nil


    var messagesController: MessagesController?
    var termOfServiceController: TermOfServiceController?
    var privacyPolicyController: PrivacyPolicyController?
    var profileSettingController: ProfileSettingController?
    var registeredAndLogin: LoginController?
    var loginController: LoginController?
    

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chatterBoxSignupCam")?.withRenderingMode(.alwaysTemplate)
//        imageView.tintColor = UIColor.rgb(206, g: 61, b: 72)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        // adding gesture
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var nameTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.whileEditing;
        tf.delegate = self


        return tf
        
        
    }()
    
    lazy var signupEmailTextField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.autocorrectionType = UITextAutocorrectionType.no
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.whileEditing;

        return tf
        
        
    }()
    
    
    
    lazy var signupPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.textColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.returnKeyType = UIReturnKeyType.done
        tf.clearButtonMode = UITextFieldViewMode.whileEditing;
        tf.isSecureTextEntry = true
        return tf
    }()


    
    
    lazy var backtoLoginController: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Have an account Log In", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.rgb(252, g: 252, b: 252), for: UIControlState())
        
        button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 10)
        button.addTarget(self, action: #selector(backToLoginController), for: .touchUpInside)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        button.sizeToFit()
        
        
        return button
        
    }()
    
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor.rgb(0, g: 96, b: 100)
        button.setTitle("Sign Up", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(UIColor.red, for: .highlighted)
        // Set the button Background Color        
        
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        
        
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
        label.text = "By Sign up you accept the "
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        label.textColor = .white
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    lazy var termButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Term Of Service", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControlState())

        button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 9)
        button.addTarget(self, action: #selector(showTermOfService), for: .touchUpInside)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        button.sizeToFit()
        
        
        return button
        
    }()
    
    let andLabel: UILabel = {
        let label = UILabel()
        label.text = "and "
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
    
    lazy var privacyPolicy: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Privacy Policy", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControlState())
        button.titleLabel!.font = UIFont(name: "HelveticaNeue-Thin", size: 9)
        button.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .horizontal)
        button.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        button.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .vertical)
        button.sizeToFit()
        
        return button
        
    }()
    
    

    override func viewWillAppear(_ animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func backToLoginController(){
    
        dismiss(animated: true, completion: nil)
        
    
    
    }
    
    
    func handleAutoLogin(_sender: AnyObject) {
        
        
        handleRegister()
        
        
        if delegate != nil{
            
            if signupEmailTextField.text != nil{
                
                let emailTextFieldValue = signupEmailTextField.text
                let passwordTextFieldValue = signupPasswordTextField.text
                
                delegate?.handleAutoLogin(emailDelegate: emailTextFieldValue!, passwordDelegate:passwordTextFieldValue!)
                
            }
            
        }
        
        
        
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(backtoLoginController)
        
        view.addSubview(profileImageView)
        view.addSubview(nameTextField)
        view.addSubview(signupEmailTextField)
        view.addSubview(signupPasswordTextField)
        view.addSubview(registerButton)

        view.addSubview(termStackView)
        

        setupbacktoLoginController()
        
        setupProfileImageView()
        setupProfileImageView()
        setupNameTextField()
        setupSignupEmailTextField()
        setupSignupPasswordTextField()
        setupRegisterButton()
        setUpSignuptermStackView()
        observeKeyboardNotifications()
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            SweetAlert().showAlert("Error!", subTitle: "Device has no camera", style: AlertStyle.success)
            
        }
        addGradientBackground()
        
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
    
    override func viewDidLayoutSubviews() {
        
        
        let nameTextFieldBorder = CALayer()
        let nameTextFieldWidth = CGFloat(2.0)
        nameTextFieldBorder.borderColor = UIColor.rgb(252, g: 252, b: 252).cgColor
        nameTextFieldBorder.borderWidth = nameTextFieldWidth
        
        nameTextFieldBorder.frame = CGRect(x: 0, y: nameTextField.frame.size.height - nameTextFieldWidth, width:  nameTextField.frame.size.width, height: nameTextField.frame.size.height)
        
        nameTextField.layer.addSublayer(nameTextFieldBorder)
        nameTextField.layer.masksToBounds = true
        
        let signupEmailTextFieldBorder = CALayer()
        let signupEmailTextFieldWidth = CGFloat(2.0)
        signupEmailTextFieldBorder.borderColor = UIColor.rgb(252, g: 252, b: 252).cgColor
        signupEmailTextFieldBorder.borderWidth = signupEmailTextFieldWidth
        
        signupEmailTextFieldBorder.frame = CGRect(x: 0, y: signupEmailTextField.frame.size.height - signupEmailTextFieldWidth, width:  signupEmailTextField.frame.size.width, height: signupEmailTextField.frame.size.height)
        
        signupEmailTextField.layer.addSublayer(signupEmailTextFieldBorder)
        signupEmailTextField.layer.masksToBounds = true
        
        let signupPasswordTextFieldBorder = CALayer()
        let signupPasswordTextFieldWidth = CGFloat(2.0)
        signupPasswordTextFieldBorder.borderColor = UIColor.rgb(252, g: 252, b: 252).cgColor
        signupPasswordTextFieldBorder.borderWidth = signupPasswordTextFieldWidth
        
        signupPasswordTextFieldBorder.frame = CGRect(x: 0, y: signupEmailTextField.frame.size.height - signupPasswordTextFieldWidth, width:  signupPasswordTextField.frame.size.width, height: signupPasswordTextField.frame.size.height)
        
        signupPasswordTextField.layer.addSublayer(signupPasswordTextFieldBorder)
        signupPasswordTextField.layer.masksToBounds = true
        
    }
    
    func setupbacktoLoginController() {
        //need x, y, width, height constraints
        backtoLoginController.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        backtoLoginController.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backtoLoginController.widthAnchor.constraint(equalToConstant: 100).isActive = true
        backtoLoginController.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true    }
    
    

    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var signupEmailTextFieldHeightAnchor: NSLayoutConstraint?
    var signupPasswordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    func setupNameTextField() {
        //need x, y, width, height constraints
        
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -80).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalToConstant: 40)
        nameTextFieldHeightAnchor?.isActive = true
        
        
    }
    
    func setupSignupEmailTextField() {
        //need x, y, width, height constraints
        
        signupEmailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupEmailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        signupEmailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        signupEmailTextFieldHeightAnchor = signupEmailTextField.heightAnchor.constraint(equalToConstant: 40)
        signupEmailTextFieldHeightAnchor?.isActive = true
        
        
    }

    func setupSignupPasswordTextField(){
        
        signupPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupPasswordTextField.topAnchor.constraint(equalTo: signupEmailTextField.bottomAnchor, constant: 20).isActive = true
        signupPasswordTextField.widthAnchor.constraint(equalTo: signupEmailTextField.widthAnchor).isActive = true
        signupPasswordTextFieldHeightAnchor = signupPasswordTextField.heightAnchor.constraint(equalToConstant: 40)
        signupPasswordTextFieldHeightAnchor?.isActive = true
        
    }
    

    func setupRegisterButton(){
        //need x, y, width, height constraints
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.topAnchor.constraint(equalTo: signupPasswordTextField.bottomAnchor, constant: 30).isActive = true
        registerButton.widthAnchor.constraint(equalTo: signupPasswordTextField.widthAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    func setUpSignuptermStackView(){
        
        termStackView.addArrangedSubview(termLabel)
        termStackView.addArrangedSubview(termButton)
        termStackView.addArrangedSubview(andLabel)
        termStackView.addArrangedSubview(privacyPolicy)
        
        termStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        termStackView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        termStackView.topAnchor.constraint(equalTo: registerButton.bottomAnchor).isActive = true
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
            
            self.view.frame = CGRect(x: 0, y: -100, width: self.view.frame.width, height: self.view.frame.height)
            
            }, completion: nil)
    }

    
    func showTermOfService(){
        
        let termOfServiceController = TermOfServiceController()
        termOfServiceController.signupController = self
        termOfServiceController.modalTransitionStyle = .partialCurl
        
        
        present(termOfServiceController, animated: true, completion: nil)
        
    }
    
    func showPrivacyPolicy(){
        
        let privacyPolicyController = PrivacyPolicyController()
        privacyPolicyController.signupController = self
        privacyPolicyController.modalTransitionStyle = .partialCurl
        
        
        present(privacyPolicyController, animated: true, completion: nil)
        print("button tapped")
        
    }
    
    


    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
