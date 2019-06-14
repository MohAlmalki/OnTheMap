//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 06/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
}
