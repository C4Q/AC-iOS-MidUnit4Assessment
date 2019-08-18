//
//  ImageAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by Richard Crichlow on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

class ImageAPIClient {
    private init() {}
    
    static let manager = ImageAPIClient()
    
    let imageCache = NSCache<NSString, UIImage>()
    
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage) -> Void,
                  errorHandler: @escaping (AppError) -> Void) {
        
        guard let url = URL(string: urlStr) else {
            errorHandler(.invalidImage)
            return
        }
        
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completionHandler(cachedImage)
            print("Loaded Image from cache")
            
        } else {
            
            let urlRequest = URLRequest(url: url)
            let completion: (Data) -> Void = {(data: Data) in
                guard let onlineImage = UIImage(data: data) else {
                    return
                }
                completionHandler(onlineImage)
                self.imageCache.setObject(onlineImage, forKey: url.absoluteString as NSString)
                print("Saved Image to cache")
            }
            NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: completion, errorHandler: errorHandler)
        }
    }
}
