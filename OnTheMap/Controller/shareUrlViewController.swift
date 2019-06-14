//
//  shareURLViewController.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 07/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class shareUrlViewController: UIViewController {
    
    var locationName: String!
    var locationCoordinate: CLLocationCoordinate2D!
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let anntation = MKPointAnnotation()
        anntation.coordinate = locationCoordinate!
        mapView.addAnnotation(anntation)
        let viewRegion = MKCoordinateRegion(center: locationCoordinate!, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(viewRegion, animated: false)
    }
    
    @IBAction func submit(_ sender: Any){
        self.configureUIforSubmit(submiting: true)
        API.postStudentLocation(link: urlTextField.text ?? "", locationCoordinate: locationCoordinate, location: locationName) { (error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                self.configureUIforSubmit(submiting: false)
                return
            }
            UserDefaults.standard.set(self.locationName, forKey: "studentLocation")
            DispatchQueue.main.async {
                self.configureUIforSubmit(submiting: false)
                self.parent!.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
}

extension shareUrlViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseId = "pinId"
        if let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView {
            pinView.annotation = annotation
            return pinView
        } else {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView.canShowCallout = true
            pinView.pinTintColor = .red
            pinView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return pinView
        }
    }
    
    func configureUIforSubmit(submiting: Bool){
        DispatchQueue.main.async {
            if submiting {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
            self.submitButton.isEnabled = !submiting
        }
    }
}
