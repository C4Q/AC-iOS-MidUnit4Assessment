//
//  CardView.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

//Who has the answers for how this should be configured?
class CardView: UIView {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var valueLabel: UILabel!
 
    //REQUIRED:  load nib file, so when app is loading, load the xib. file, you will see what views I have so you can set up my outlets appropriately
    required init?(coder aDecoder: NSCoder) { //Storyboard init
        super.init(coder: aDecoder)
        //Setting this view to load where view is located
        //Display UIView to whatever view it's supposed to be in and add UIView to whatever dpot it should be in, in the Hierarchy
        //Bundle.main.loadNibNamed(<#T##name: String##String#>, owner: <#T##Any?#>, options: <#T##[AnyHashable : Any]?#>)
        
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        // Tell it to display the view: add the content view as a subview
        addSubview(contentView)
        //set the contentView to be the same size as the UIView
        contentView.frame = self.bounds
    }
    
//    func configureImage(from card: CardInfo) {
//        ImageAPIClient.manager.loadImage(from: card.images.png,
//                                         completionHandler: {
//                                            self.imageView.image = $0
//                                            self.imageView.setNeedsLayout()
//                                            self.valueLabel.text = "\(card.value)"
//                                            //is hidden until you click on draw a new card
//                                            self.isHidden = false
//        },
//                                         errorHandler: {print($0)})
//    }

    //    override init(frame: CGRect) { //programmatic init
    //        <#code#>
    //    }
    //

}
