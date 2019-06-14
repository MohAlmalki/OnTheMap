//
//  Alert.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 08/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
