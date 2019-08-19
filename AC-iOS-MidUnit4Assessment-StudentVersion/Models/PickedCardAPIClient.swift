//
//  PickedCardAPIClient.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct PickedCardAPIClient {
    private init() {}
    static let manager = PickedCardAPIClient()
    
    func getPickedCard(from str: String,
                    completionHandler: @escaping (PickedCard) -> Void,
                    errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: str) else {return}
        let parseDataIntoCard = {(data: Data) in
            do {
                let onlineCard = try JSONDecoder().decode(PickedCard.self, from: data)
                completionHandler(onlineCard)
            }
            catch let error {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: parseDataIntoCard, errorHandler: errorHandler)
    }
}
