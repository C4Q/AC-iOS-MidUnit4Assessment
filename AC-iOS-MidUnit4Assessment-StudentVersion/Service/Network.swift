//  Network.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//  Created by Winston Maragh on 12/22/17.
//  Copyright © 2017 Winston Maragh. All rights reserved.

import Foundation
import UIKit

//HTTP
enum HTTPVerb: String {
	case GET //Read
	case POST //Create
	case DELETE //Delete
	case PUT //Update/Replace
	case PATCH //Update/Modify
}

//AppError for Errorhandling
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

//NetworkHelper - turns URL/URLRequest into Data
struct NetworkHelper {
	//Singleton
	private init(){}
	static let manager = NetworkHelper()

	//Create an instance of a URLSession
	private let session = URLSession(configuration: .default)

	//use URL to get Data
	func performDataTask(withURL url: URL,
											 completionHandler: @escaping (Data)->Void,
											 errorHandler: @escaping (AppError)->Void){
		//parse data
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
	//use URLRequest to get Data
	func performDataTask(withURLRequest urlRequest: URLRequest,
											 completionHandler: @escaping (Data) -> Void,
											 errorHandler: @escaping (Error) -> Void) {
		//parse data
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

//Image Helper - get images from online
struct ImageHelper {
	//Singleton
	private init() {}
	static let manager = ImageHelper()

	//Method to get Image from online
	func getImage(from urlStr: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (AppError) -> Void) {
		guard let url = URL(string: urlStr) else { errorHandler(.badURL); return}
		let completion: (Data) -> Void = {(data: Data) in
			guard let onlineImage = UIImage(data: data) else {return}
			completionHandler(onlineImage) //call completionHandler
		}
		//call NetworkHelper
		NetworkHelper.manager.performDataTask(withURL: url, completionHandler: completion, errorHandler: errorHandler)
	}
}





