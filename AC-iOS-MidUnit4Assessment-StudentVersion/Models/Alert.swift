//
//  Alert.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class Alert {
    static func createAlertController(withTitle title: String, andMessage message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
    }
    
    static func createErrorAlert(withError error: Error) -> UIAlertController {
        let message: String
        
        switch error {
        case AppError.badURL(let url):
            message = "Bad URL:\n\(url)"
        case AppError.badImageURL(let url):
            message = "Bad Image URL:\n\(url)"
        case AppError.badData:
            message = "Bad Data"
        case AppError.badImageData:
            message = "Bad Image Data"
        case AppError.badResponseCode(let code):
            message = "Bad Response Code:\n\(code)"
        case AppError.cannotParseJSON(let rawError):
            message = "Cannot Parse JSON:\n\(rawError)"
        case AppError.noInternet:
            message = "No Internet Connection."
        case AppError.other(let rawError):
            message = "\(rawError)"
        default:
            message = "\(error)"
        }
        
        let alertController = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
    }
    
    static func createGameOverAlert(withGameStatus gameStatus: CardGame.GameStatus, completionHandler: @escaping () -> Void) -> UIAlertController? {
        let title: String
        let message: String
        
        switch gameStatus {
        case .ongoing:
            return nil
        case .defeat:
            title = "LOOOOLLLLLLLL"
            message = "😂😂😂\nYOU LOST!!!!!\n🔥🔥🔥 GET CGRECT YA LOSER 🔥🔥🔥\n😂😂😂"
        case .victory:
            title = "😒 Wooooooowww... 😒"
            message = "😒 So I guess you won >_> 😒"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "New Game", style: .default) { _ in
            completionHandler()
        }
        
        alertController.addAction(alertAction)

        return alertController
    }
    
    static func createStoppedGameAlert(withScore score: Int, andTargetScore targetScore: Int, completionHandler: @escaping () -> Void) -> UIAlertController {
        let distanceFromTarget = targetScore - score
        
        let alertController = UIAlertController(title: "GAME OVER LOL 😂", message: "😂 You were \(distanceFromTarget) points away from \(targetScore) 😂", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Aww man... 😭", style: .default) { _ in
            completionHandler()
        }
        
        alertController.addAction(alertAction)
        
        return alertController
    }
}
