//
//  FaltaTableViewCell.swift
//  MackTIA
//
//  Created by Joaquim Pessôa Filho on 9/5/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit

class FaltaTableViewCell: UITableViewCell {
    @IBOutlet weak var nomeDisciplina: UILabel!
    @IBOutlet weak var aulasPrevistas: UILabel!
    @IBOutlet weak var faltas: UILabel!
    @IBOutlet weak var percentual: UILabel!
    @IBOutlet weak var graficoView: CircleGraphView!
    @IBOutlet weak var permitidas: UILabel!
    @IBOutlet weak var atualizacao: UILabel!
    @IBOutlet weak var conteudoView: UIView!
    
    var falta:Falta? {
        didSet {
            if falta != nil {
                self.aulasPrevistas.text = "\(falta!.aulasDadas)"
                self.faltas.text = "\(falta!.faltas)"
                if CGFloat(falta!.percentual/25) <= 1 {
                    self.graficoView.endArc = CGFloat(falta!.percentual/25)
                } else {
                    self.graficoView.endArc = CGFloat(1)
                }
                self.percentual.text = "\(falta!.percentual)%"
                self.nomeDisciplina.text = falta!.disciplina
                self.permitidas.text = "\(falta!.permitidas)"
                self.atualizacao.text = NSLocalizedString("update.label.text", comment: "Texto padrao para atualização") + falta!.atualizacao
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.selected {
            UIView.animateWithDuration(0.3, delay: 0.3, options:[], animations: { () -> Void in
                self.conteudoView.alpha = 1
                }, completion: nil)
        } else {
            self.conteudoView.alpha = 0
        }
    }
}

//extension FaltaTableViewCell {
//    var falta:Falta?{
//        get {
//            return objc_getAssociatedObject(self, "faltaObject") as? Falta
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, "faltaObject", newValue, UInt(OBJC_ASSOCIATION_RETAIN))
//            if let falta = newValue {
//                self.aulasPrevistas.text = "\(falta.aulasDadas)"
//                self.faltas.text = "\(falta.faltas)"
//                if CGFloat(falta.percentual/25) <= 1 {
//                    self.graficoView.endArc = CGFloat(falta.percentual/25)
//                } else {
//                    self.graficoView.endArc = CGFloat(1)
//                }
//                self.percentual.text = "\(falta.percentual)%"
//                self.nomeDisciplina.text = falta.disciplina
//                self.permitidas.text = "\(falta.permitidas)"
//                self.atualizacao.text = NSLocalizedString("update.label.text", comment: "Texto padrao para atualização") + falta.atualizacao
//            }
//            
//        }
//    }
//}