//
//  DynamicCollectionViewController.swift
//  DemoApp
//
//  Created by Tecordeon-14 on 18/12/18.
//  Copyright © 2018 Tecordeon. All rights reserved.
//

import UIKit

class DynamicCollectionViewController: UIViewController {

    @IBOutlet weak var dynamicCVollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SetupCollectionView()
    }
    
    
    func SetupCollectionView(){
          self.dynamicCVollectionView.register(UINib(nibName: "DynamicCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DynamicCollectionViewCell")
        
        self.dynamicCVollectionView.register(UINib(nibName: "CollectionViewHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader")
        
         self.dynamicCVollectionView.register(UINib(nibName: "CollectionViewHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CollectionViewHeader")
        
   

    }



}


extension DynamicCollectionViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return 5
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(indexPath.section == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DynamicCollectionViewCell", for: indexPath) as! DynamicCollectionViewCell
            cell.UpdateCollectionViewCell(index: indexPath)
            cell.configCell()
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DynamicCollectionViewCell", for: indexPath) as! DynamicCollectionViewCell
           cell.UpdateCollectionViewCell(index: indexPath)
            cell.configCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2-10, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
       return  CGSize(width: collectionView.frame.width-10, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
         return  CGSize(width: collectionView.frame.width-10, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeader", for: indexPath as IndexPath) as! CollectionViewHeader
            
            headerView.backgroundColor = UIColor.blue
            return headerView
            // assert(false, "Unexpected element kind")
            
        case UICollectionView.elementKindSectionFooter:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeader", for: indexPath as IndexPath) as! CollectionViewHeader
            
            headerView.backgroundColor = UIColor.blue
            return headerView
//          /  assert(false, "Unexpected element kind")
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
   
        
}
