//
//  LoginViewController.swift
//  roomCronies
//
//  Created by Paul on 2017-10-24.
//  Copyright © 2017 Paul. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginPicture: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    var imageArray: [UIImage] = [
        UIImage(named: "loginpic1.png")!,
        UIImage(named: "loginpic2.png")!,
        UIImage(named: "loginpic3.png")!,
        UIImage(named: "loginpic4.png")!
    ]
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.hideKeyboardWhenTappedAround() 
        
        self.view.bringSubview(toFront: loginPicture)
        
        self.blurView.layer.cornerRadius = 35
        self.blurView.clipsToBounds = true
        
        checkLoginState()
        self.navigationController?.isNavigationBarHidden = true
        
        
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.isUserInteractionEnabled = false
        let htmlPath = Bundle.main.path(forResource: "WebViewContent", ofType: "html")
        let htmlURL = URL(fileURLWithPath: htmlPath!)
        let html = try? Data(contentsOf: htmlURL)

        webViewBG.load(html!, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: htmlURL.deletingLastPathComponent())

        view.addSubview(webViewBG)
        self.view.sendSubview(toBack: webViewBG)
        
        
        self.loginPicture.animationImages = imageArray;
        self.loginPicture.animationDuration = 3.0
        self.loginPicture.startAnimating()
        
        
        userNameTextField.underlined()
        passwordTextField.underlined()
        
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username",
                                                               attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                     attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        
        
//        UIView.animateKeyframes(withDuration: 4.0, delay: 0.0, options: [.repeat, .calculationModeCubic], animations: {
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5, animations: {
//                self.loginPicture.image = UIImage(named: "loginpic1.png")
//                self.loginPicture.alpha = 1.0
//            })
//            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
//                //image1
//                self.loginPicture.image = UIImage(named: "loginpic1.png")
//                self.loginPicture.alpha = 0.0
//            })
//            UIView.addKeyframe(withRelativeStartTime: 1.0, relativeDuration: 0.5, animations: {
//                //image1
//                self.loginPicture.image = UIImage(named: "loginpic2.png")
//                self.loginPicture.alpha = 1.0
//            })
//            UIView.addKeyframe(withRelativeStartTime: 1.5, relativeDuration: 0.5, animations: {
//                //image1
//                self.loginPicture.image = UIImage(named: "loginpic2.png")
//                self.loginPicture.alpha = 0.0
//            })
//            UIView.addKeyframe(withRelativeStartTime: 2.0, relativeDuration: 0.5, animations: {
//                //image1
//                self.loginPicture.image = UIImage(named: "loginpic3.png")
//                self.loginPicture.alpha = 1.0
//            })
//            UIView.addKeyframe(withRelativeStartTime: 2.5, relativeDuration: 0.5, animations: {
//                //image1
//                self.loginPicture.image = UIImage(named: "loginpic3.png")
//                self.loginPicture.alpha = 0.0
//            })
//        }, completion: nil)

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    private func checkLoginState() {
        DataManager.checkUserLoginState { (success: Bool) in
            print(#line, success ? "": "not ", "auto logged in")
            if success {
                self.segue()
            }
        }
    }
    
    
    //MARK: IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = userNameTextField.text,
            let password = passwordTextField.text,
            username.isEmpty == false,
            password.isEmpty == false else {
             let error = R.error(with: "Username and Password fields cannot be empty. Please enter and try again!")
                showErrorView(error)
                return
        }
        DataManager.login(with: username, and: password) { (success: Bool, error: Error?) in
            
            if let error = error {
              let error = R.error(with: error.localizedDescription)
                self.showErrorView(error)
            }
            
            guard error == nil, success == true else {
                print(#line, "not logged in")
                return
            }
            self.segue()
        }
    }
    
    private func segue(){
        // TaskViewControllerSegue
        performSegue(withIdentifier: "TaskViewControllerSegue", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue , sender: sender)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        switch (segue.identifier ?? "") {
            //dont need to pass anything through segue. taskVC does a query for existing user and fetches the tasks.
        case "TaskViewControllerSegue":
            guard let _ = segue.destination as? RoomViewController else {
                print(#line, "unexpected destination:\(segue.destination)")
                return
            }
            
        case "userRegisterSegue":
            guard let registerController = segue.destination as? RegisterViewController else {
                fatalError("unexpected destination:\(segue.destination)")
            }
        case "createNewRoomSegue":
            guard let createNewRoomController = segue.destination as? ExistingRoomViewController else {
                 fatalError("unexpected destination:\(segue.destination)")
            }
            
        default:
            fatalError("unexpected segue identifier \(String(describing: segue.identifier))")
            
        }
        
    }
 
}

// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
