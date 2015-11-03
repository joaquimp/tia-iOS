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
    @IBOutlet weak var progressBarView: ProgressBarView!
    @IBOutlet weak var progressBarLabel: UILabel!
    
    var falta:Falta? {
        didSet {
            guard let novaFalta = falta else {
                return
            }
                self.aulasPrevistas.text = "\(novaFalta.aulasDadas)"
                self.faltas.text = "\(novaFalta.faltas)"
                let percentual = CGFloat(novaFalta.percentual/25)
                if CGFloat(novaFalta.percentual/25) <= 1 {
                    self.graficoView.endArc = percentual
                    self.progressBarView.endPercent = percentual
                } else {
                    self.graficoView.endArc = CGFloat(1)
                    self.progressBarView.endPercent = CGFloat(1)
                }
                self.progressBarLabel.text = "\(novaFalta.percentual)%"
                self.percentual.text = "\(novaFalta.percentual)%"
                self.nomeDisciplina.text = novaFalta.disciplina
                self.permitidas.text = "\(novaFalta.permitidas)"
                self.atualizacao.text = NSLocalizedString("update.label.text", comment: "Texto padrao para atualização") + novaFalta.atualizacao
                self.atualizacao.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.selected {
            UIView.animateWithDuration(0.3, delay: 0.0, options:[], animations: { () -> Void in
                self.contentView.backgroundColor = UIColor(hex: "FAFAFA")
                self.progressBarLabel.hidden = true
                self.progressBarView.hidden = true
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.3, delay: 0.0, options:[], animations: { () -> Void in
                self.contentView.backgroundColor = UIColor.whiteColor()
                self.progressBarLabel.hidden = false
                self.progressBarView.hidden = false
                }, completion: nil)
        }
    }
}