//
//  AppError.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
enum AppError: Error {
    case unauthenticated
    case invalidJSONResponse
    case couldNotParseJSON
    case noInternetConnection
    case badURL
    case badStatusCode
    case noDataReceived
    case other(rawError: Error)
    case notAnImage
}
