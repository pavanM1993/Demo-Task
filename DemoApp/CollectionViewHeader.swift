//
//  CollectionViewHeader.swift
//  DemoApp
//
//  Created by Tecordeon-14 on 18/12/18.
//  Copyright © 2018 Tecordeon. All rights reserved.
//

import UIKit

class CollectionViewHeader: UICollectionReusableView {

    @IBOutlet weak var headerTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func UpdateHeaderView(index: IndexPath){
         headerTitle.text = "\(index.section) \(index.item)"
    }
    
}
