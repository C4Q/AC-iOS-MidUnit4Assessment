//  Network.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by Winston Maragh on 12/22/17.
//  Copyright © 2017 Winston Maragh. All rights reserved.

import Foundation
import UIKit

enum HTTPVerb: String {
	case GET
	case POST
	case DELETE
	case PUT
	case PATCH
}

enum AppError: Error {
	case badData
	case badURL
	case unauthenticated
	case codingError(rawError: Error)
	case invalidJSONResponse
	case couldNotParseJSON(rawError: Error)
	case noInternetConnection
	case badStatusCode
	case noDataReceived
	case notAnImage
	case other(rawError: Error)
}

struct NetworkHelper {
	private init(){}
	static let manager = NetworkHelper()
	private let session = URLSession(configuration: .default)
	func performDataTask(withURL url: URL,
											 completionHandler: @escaping (Data)->Void,
											 errorHandler: @escaping (AppError)->Void){
		let task =	session.dataTask(with: url) {(data, response, error) in
			DispatchQueue.main.async {
				guard let data = data else {errorHandler(AppError.badData); return}
				if let error = error {
					errorHandler(AppError.other(rawError: error))
				}
				completionHandler(data)
			}
		}
		task.resume()
	}
	func performDataTask(withURLRequest urlRequest: URLRequest,
											 completionHandler: @escaping (Data) -> Void,
											 errorHandler: @escaping (Error) -> Void) {
		let task = session.dataTask(with: urlRequest){(data, response, error) in
			DispatchQueue.main.async {
				guard let data = data else {errorHandler(AppError.badData); return}
				if let error = error {
					errorHandler(AppError.other(rawError: error))
				}
				completionHandler(data)
			}
		}
		task.resume()
	}
}

struct ImageHelper {
	private init() {}
	static let manager = ImageHelper()
	func getImage(from urlStr: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (AppError) -> Void) {
		guard let url = URL(string: urlStr) else { errorHandler(.badURL); return}
		let completion: (Data) -> Void = {(data: Data) in
			guard let onlineImage = UIImage(data: data) else {return}
			completionHandler(onlineImage) //call completionHandler
		}
		NetworkHelper.manager.performDataTask(withURL: url, completionHandler: completion, errorHandler: errorHandler)
	}
}






