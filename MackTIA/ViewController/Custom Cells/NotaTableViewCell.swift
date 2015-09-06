//
//  NotaTableViewCell.swift
//  MackTIA
//
//  Created by Joaquim Pessôa Filho on 9/5/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit



class NotaTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var nomeDisciplina: UILabel!
    
    @IBOutlet weak var notasFinaisCollectionView: UICollectionView!
    @IBOutlet weak var notasIntermediariasCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.notasFinaisCollectionView.delegate = self
        self.notasFinaisCollectionView.dataSource = self
        self.notasIntermediariasCollectionView.delegate = self
        self.notasIntermediariasCollectionView.dataSource = self
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: UICollectionVeiw DataSource and Delegate Methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == notasIntermediariasCollectionView {
            return 10
        } else {
            return 5
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("notaCell", forIndexPath: indexPath) as! NotaCollectionViewCell
        
        if collectionView == notasIntermediariasCollectionView {
            switch indexPath.row {
            case 0:
                cell.titulo.text = "A"
                cell.nota.text = self.nota?.a
            case 1:
                cell.titulo.text = "B"
                cell.nota.text = self.nota?.b
            case 2:
                cell.titulo.text = "C"
                cell.nota.text = self.nota?.c
            case 3:
                cell.titulo.text = "D"
                cell.nota.text = self.nota?.d
            case 4:
                cell.titulo.text = "E"
                cell.nota.text = self.nota?.e
            case 5:
                cell.titulo.text = "F"
                cell.nota.text = self.nota?.f
            case 6:
                cell.titulo.text = "G"
                cell.nota.text = self.nota?.g
            case 7:
                cell.titulo.text = "H"
                cell.nota.text = self.nota?.h
            case 8:
                cell.titulo.text = "I"
                cell.nota.text = self.nota?.i
            case 9:
                cell.titulo.text = "J"
                cell.nota.text = self.nota?.j
            default:
                cell.titulo.text = "-"
                cell.nota.text = "-"
            }
            if cell.titulo.text?.lowercaseString == nota?.substituida {
                cell.nota.text = "\(cell.nota.text)(SUB)"
            }
        } else {
            switch indexPath.row {
            //Nota Sub
            case 0:
                cell.titulo.text = "SUB"
                cell.nota.text = self.nota?.sub
            case 1:
                cell.titulo.text = "PARTIC"
                cell.nota.text = self.nota?.partic
            case 2:
                cell.titulo.text = "MI"
                cell.nota.text = self.nota?.mi
            case 3:
                cell.titulo.text = "PF"
                cell.nota.text = self.nota?.pf
            case 4:
                cell.titulo.text = "MF"
                cell.nota.text = self.nota?.mf
            default:
                cell.titulo.text = "-"
                cell.nota.text = "-"
            }
        }
        
        return cell
    }
    
}

extension NotaTableViewCell {
    var nota:Nota?{
        get {
            return objc_getAssociatedObject(self, "notaObject") as? Nota
        }
        set(newValue) {
            objc_setAssociatedObject(self, "notaObject", newValue, UInt(OBJC_ASSOCIATION_RETAIN))
            if let nota = newValue {
                self.nomeDisciplina.text = nota.disciplina
                self.notasIntermediariasCollectionView.reloadData()
                self.notasFinaisCollectionView.reloadData()
            }
        }
    }
}