//
//  Helpers.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Luis Calle on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

enum AppError: Error {
    case noData
    case notAnImage
    case couldNotParseJSON(rawError: Error)
    case badURL(str: String)
    case urlError(rawError: URLError)
    case otherError(rawError: Error)
}

class NetworkHelper {
    private init() {}
    static let manager = NetworkHelper()
    
    private let urlSession = URLSession(configuration: .default)
    
    func performDataTask(with request: URLRequest, completionHandler: @escaping (Data) -> Void, errorHandler: @escaping (Error) -> Void) {
        self.urlSession.dataTask(with: request){ (data: Data?, response: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                guard let data = data else {
                    errorHandler(AppError.noData)
                    return
                }
                if let error = error {
                    errorHandler(error)
                }
                completionHandler(data)
            }
            }.resume()
    }
}


struct ImageFetchHelper {
    private init() { }
    static let manager = ImageFetchHelper()
    
    func getImage(from urlStr: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { (data: Data) in
            guard let onlineImage = UIImage(data: data) else {
                errorHandler(AppError.notAnImage)
                return
            }
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
