//
//  API.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 06/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class API{
    static func login(with email: String, password: String, completion: @escaping ([String:Any]?, Error?) -> ()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            let result = try! JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            if result["status"] == nil {
                let userInfo = try! JSONDecoder().decode(UserInformation.self, from: newData!)
                SharedData.shared.userInfo = userInfo
                print("\nYour uniqueKey is: \(SharedData.shared.userInfo?.account.key ?? "0")\n")
            }
            completion(result, nil)
        }
        task.resume()
    }
    
    static func logout(completion: @escaping (Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        if let sharedCookieStorage = HTTPCookieStorage.shared.cookies {
            for cookie in sharedCookieStorage {
                if cookie.name == "XSRF-TOKEN" {
                    xsrfCookie = cookie
                }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error…
                    completion(error)
                    return
                }else{
                    let range = 5..<data!.count
                    let newData = data?.subdata(in: range)
                    print(String(data: newData!, encoding: .utf8)!)
                    completion(nil)
                    return
                }
            }
            task.resume()
        }
    }
    
    static func getStudentLocation(completion: @escaping ([StudentInformation]?, Error?) -> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt&limit=100")!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error == nil {
                if let dictionary = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String:Any] {
                    guard let results = dictionary["results"] as? [[String:Any]] else {return}
                    let resultsData = try! JSONSerialization.data(withJSONObject: results, options: .prettyPrinted)
                    let studentInfo = try! JSONDecoder().decode([StudentInformation].self, from: resultsData)
                    SharedData.shared.studentInfo = studentInfo
                    completion(studentInfo,nil)
                } else {
                    completion(nil, error?.localizedDescription as? Error)
                }
            } else {
                completion(nil,error)
                return
            }
        }
        task.resume()
    }
    
    static func postStudentLocation(link: String, locationCoordinate: CLLocationCoordinate2D, location: String, completion: @escaping (Error?) -> ()){
        let firstName = SharedData.shared.userName?.firstname
        let lastName = SharedData.shared.userName?.lastname
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(SharedData.shared.userInfo?.account.key ?? "0")\", \"firstName\": \"\(firstName ?? "First Name")\", \"lastName\": \"\(lastName ?? "Last Name")\", \"mapString\": \"\(location)\", \"mediaURL\": \"\(link)\", \"latitude\": \(locationCoordinate.latitude), \"longitude\": \(locationCoordinate.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error == nil {
                //print(String(data: data!, encoding: .utf8)!)
                completion(nil)
            } else {
                completion(error)
                return
            }
        }
        task.resume()
    }
    
    static func getUserName(completion: @escaping ([String:Any]?, Error?) -> ()) {
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(SharedData.shared.userInfo?.account.key ?? "0")")!)
        let session = URLSession.shared
        var userName: UserName?
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            let resultsData = try! JSONSerialization.jsonObject(with: newData!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
            if resultsData["first_name"] != nil{
                 userName = UserName(firstname: resultsData["first_name"] as! String , lastname: resultsData["last_name"]as! String )
            SharedData.shared.userName = userName
            completion(resultsData, nil)
            }
        }
        task.resume()
    }
}
