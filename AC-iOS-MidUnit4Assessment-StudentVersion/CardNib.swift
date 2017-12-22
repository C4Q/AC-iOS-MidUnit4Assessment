//
//  CardNib.swift
//  AC-iOS-MidUnit4Assessment-StudentVersion
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CardNib: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) { // Storyboard init
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("CardNib", owner: self, options: nil) // looks for a xib file name, not an identifier name
        addSubview(contentView)
        contentView.frame = self.bounds
    }
    
    
}
