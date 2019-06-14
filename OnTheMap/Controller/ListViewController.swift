//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 06/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import UIKit
import MapKit

class ListViewController: UITableViewController {
    
    var studentsLocations: [StudentInformation]! {
        return SharedData.shared.studentInfo
    }
    let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (studentsLocations == nil){
            refreshStudentLocation(self)
        } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
          }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
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
                self.tableView.reloadData()
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocations?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        if cell.detailTextLabel == nil {
            cell.detailTextLabel?.text = studentsLocations[indexPath.row].mediaURL
                cell = UITableViewCell(style:UITableViewCell.CellStyle(rawValue:3)!,reuseIdentifier:cellId)
        }
        cell.imageView?.image = UIImage(named: "pin")
        cell.textLabel?.text = studentsLocations[indexPath.row].firstName
        cell.detailTextLabel?.text = studentsLocations[indexPath.row].mediaURL
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = studentsLocations[indexPath.row]
        guard let link = studentLocation.mediaURL , let url = URL(string: link) else {return }
        UIApplication.shared.open(url)
    }
}
