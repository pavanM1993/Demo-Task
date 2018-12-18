//
//  DynamicCollectionViewCell.swift
//  DemoApp
//
//  Created by Tecordeon-14 on 17/12/18.
//  Copyright © 2018 Tecordeon. All rights reserved.
//

import UIKit

class DynamicCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailTF: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(){
        self.contentView.setNeedsLayout()
    }
    
    func UpdateCollectionViewCell(index:IndexPath){
        titleLbl.text = "\(index.section) \(index.item)"
        detailTF.placeholder = "\(index.section) \(index.item)"
    }
    
    

}
