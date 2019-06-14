//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 06/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var locations: [StudentInformation]! {
        return SharedData.shared.studentInfo
    }
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        if (locations == nil) {
            refreshStudentLocation(self)
        } else {
            DispatchQueue.main.async {
                self.updateAnnotations()
            }
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
    }
    
    @IBAction func addPin(_ sender: Any) {
        if UserDefaults.standard.value(forKey: "studentLocation") != nil {
            let alert = UIAlertController(title : "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", message : nil , preferredStyle : .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Overwrite", style: .destructive, handler: {
                (action) in
                self.performSegue(withIdentifier: "addNewLocation", sender: self)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.performSegue(withIdentifier: "addNewLocation", sender: self)
        }
    }
    
    @IBAction func refreshStudentLocation(_ sender: Any) {
        API.getStudentLocation { (_ , error) in
            if let error = error { self.alert(title: "Error" , message : error.localizedDescription )
                return
            }
            DispatchQueue.main.async {
                self.updateAnnotations()
            }
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem){
        API.logout { (error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func updateAnnotations() {
        var annotaions = [MKPointAnnotation]()
        for location in locations {
            if let lat = location.latitude,
                let long = location.longitude,
                let firstName = location.firstName,
                let lastName = location.lastName,
                let mediaURL = location.mediaURL {
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                let annotaion = MKPointAnnotation()
                annotaion.coordinate = coordinate
                annotaion.title = "\(firstName) \(lastName)"
                annotaion.subtitle = mediaURL
                if !mapView.annotations.contains(where: {$0.title == annotaion.title}) {
                    annotaions.append(annotaion)
                }
            }
        }
        mapView.addAnnotations(annotaions)
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle! , let url = URL(string: subtitle) else {
                alert(title: "Error", message: "Error in URL")
                return
            }
            print("Should Open")
            UIApplication.shared.open(url)
        }
    }
}
