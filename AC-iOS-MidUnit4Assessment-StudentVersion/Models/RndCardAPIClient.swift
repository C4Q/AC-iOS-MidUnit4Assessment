//
//  RndCardAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct RndCardAPIClient {
    private init() {}
    static let manager = RndCardAPIClient()
    
    
    func getBooks(from str: String,
                  completionHandler: @escaping (RndCard) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: str) else {return}
        let parseDataIntoImageArr = {(data: Data) in
            do {
                let onlineCard = try JSONDecoder().decode(RndCard.self, from: data)
                completionHandler(onlineCard)
            }
            catch let error {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: parseDataIntoImageArr, errorHandler: errorHandler)
    }
}
