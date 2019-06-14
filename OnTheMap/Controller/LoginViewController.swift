//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 04/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func signupAction(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://udacity.com")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func loginAction(_ sender: Any) {
       configureUIforLogin(true)
        let userEmail = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        let userPassword = passwordTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if (userEmail!.isEmpty) || (userPassword!.isEmpty)  {
            self.alert(title: "Empty Field", message: "Plese enter your email and password")
            self.configureUIforLogin(false)
            return
        }
        API.login(with: userEmail!, password: userPassword!) { (data, error) in
            if error != nil {
                self.alert(title: "Error"  , message : error!.localizedDescription)
                self.configureUIforLogin(false)
                return
            } else {
                if let data = data,
                    let errorMessage = data["error"] as? String {
                    self.configureUIforLogin(false)
                    self.alert(title: "Error Login", message: errorMessage)
                } else {
                    DispatchQueue.main.async {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.configureUIforLogin(false)
                        API.getUserName{ (_ , error) in
                            if let error = error { self.alert(title: "Error" , message : error.localizedDescription )
                                return
                            }
                        }
                        self.performSegue(withIdentifier: "completeLogin", sender: self)
                    }
                }
            }
        }
        
    }
    
    func configureUIforLogin(_ login: Bool) {
        if login {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !login
        passwordTextField.isEnabled = !login
        loginButton.isEnabled = !login
        signupButton.isEnabled = !login
    }
}
