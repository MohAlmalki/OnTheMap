//
//  newLocationViewController.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 07/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import UIKit
import CoreLocation

class newLocationViewController: UIViewController {
    
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName: String!
    
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shareURL" {
            let viewController = segue.destination as! shareUrlViewController
            viewController.locationCoordinate = locationCoordinate
            viewController.locationName = locationName
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findButton(_ sender: UIButton){
        configureUIforNewLocation(finding: true)
        guard let locationName = locationTextField.text?.trimmingCharacters(in: .whitespaces), !locationName.isEmpty else {
            alert(title: "Error", message: "Please enter your location")
            return
        }
        CLGeocoder().geocodeAddressString(locationName) { (placemarks, error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                self.configureUIforNewLocation(finding: false)
            } else {
                if let firstPlacemark = placemarks?[0],
                    let firstLocation = firstPlacemark.location {
                    self.locationCoordinate = firstLocation.coordinate
                    self.locationName = firstPlacemark.name
                    self.configureUIforNewLocation(finding: false)
                    self.performSegue(withIdentifier: "shareURL", sender: self)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func configureUIforNewLocation(finding: Bool){
        DispatchQueue.main.async {
            if finding {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            self.findButton.isEnabled = !finding
        }
    }
}

