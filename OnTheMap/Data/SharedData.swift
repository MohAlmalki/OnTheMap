//
//  SharedData.swift
//  OnTheMap
//
//  Created by Mohammed Almalki on 06/06/2019.
//  Copyright © 2019 Mohowsa. All rights reserved.
//

import Foundation

class SharedData {
    static let shared = SharedData()
    var userInfo: UserInformation?
    var userName: UserName?
    var studentInfo: [StudentInformation]?
}
