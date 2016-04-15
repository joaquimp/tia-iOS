//
//  ListGradeTableViewCell.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 15/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class ListGradeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var formulaLabel: UILabel!
    @IBOutlet weak var ni1CollectionView: UICollectionView!
    @IBOutlet weak var ni2CollectionView: UICollectionView!
    @IBOutlet weak var otherGradesCollectionView: UICollectionView!
    
    let ni1ComponentsKey = ["NI 1","A","B","C","D","E"]
    let ni2ComponentsKey = ["NI 2","F","G","H","I","J"]
    let otherComponentsKey = ["SUB","Partic","MI","PF","MF"]
    var grades:[String:String] = [:]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ni1CollectionView.delegate = self
        self.ni1CollectionView.dataSource = self
        self.ni2CollectionView.delegate = self
        self.ni2CollectionView.dataSource = self
        self.otherGradesCollectionView.delegate = self
        self.otherGradesCollectionView.dataSource = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.selected {
            UIView.animateWithDuration(0.3, delay: 0.0, options:[], animations: { () -> Void in
                self.contentView.backgroundColor = UIColor(hex: "FAFAFA")
                }, completion: nil)
        }
    }
    
    func config(grade:Grade) {
        self.classNameLabel.text = grade.className
        self.formulaLabel.text = grade.formula
        self.grades = grade.grades
    }

}

extension ListGradeTableViewCell: UICollectionViewDelegate {
    
}

extension ListGradeTableViewCell: UICollectionViewDataSource {
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == ni1CollectionView || collectionView == ni2CollectionView {
            return 6
        }
        
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == ni1CollectionView {
            let key = ni1ComponentsKey[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gradeCell", forIndexPath: indexPath) as! ListGradeCollectionViewCell
            cell.title.text = key
            cell.value.text = grades[key] ?? "-"
            return cell
        } else if collectionView == ni2CollectionView {
            let key = ni2ComponentsKey[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gradeCell", forIndexPath: indexPath) as! ListGradeCollectionViewCell
            cell.title.text = key
            cell.value.text = grades[key] ?? "-"
            return cell
        } else if collectionView == otherGradesCollectionView {
            let key = otherComponentsKey[indexPath.row]
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gradeCell", forIndexPath: indexPath) as! ListGradeCollectionViewCell
            cell.title.text = key
            cell.value.text = grades[key] ?? "-"
            return cell
        }
        
        return UICollectionViewCell()
    }
}
