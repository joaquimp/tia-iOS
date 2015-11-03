//
//  HorarioTableViewCell.swift
//  MackTIA
//
//  Created by joaquim on 24/09/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

class HorarioTableViewCell: UITableViewCell {
    
    @IBOutlet weak var anotacoesAula: UITextView!
    @IBOutlet weak var localDaAula: UILabel!
    @IBOutlet weak var horarioAula: UILabel!
    @IBOutlet weak var nomeDisciplina: UILabel!
    @IBOutlet weak var editarButton: UIButton!
    @IBOutlet weak var confirmarEdicaoButton: UIButton!
    @IBOutlet weak var cancelarEdicaoButton: UIButton!

    var mainTableView:HorarioDiaDaSemanaTableViewController?
    
    var horario:Horario? {
        didSet{
            guard let novoHorario = horario else {
                return
            }
            self.nomeDisciplina.text = novoHorario.disciplina
            self.localDaAula.text = "Prédio: \(novoHorario.predio) - Sala: \(novoHorario.sala)\nEscola: \(novoHorario.escola) - Turma: \(novoHorario.turma)"
            self.horarioAula.text = novoHorario.hora
            self.anotacoesAula.text = novoHorario.anotacoes
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        editarButton.alpha = 0
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.selected {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.editarButton.alpha = 1
                self.editarButton.enabled = true
                self.contentView.backgroundColor = UIColor(hex: "FAFAFA")
            })
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.editarButton.alpha = 0
            })
        }
    }
    
       
    @IBAction func editarAnotacoes(sender: AnyObject) {
        guard let parent = self.mainTableView, let h = self.horario else {
            return
        }
        self.editarButton.enabled = false
        parent.editarHorarioAnotacao(h)
    }
}
