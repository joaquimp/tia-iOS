//
//  HorarioTableViewCell.swift
//  MackTIA
//
//  Created by joaquim on 24/09/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

class HorarioTableViewCell: UITableViewCell {

    @IBOutlet weak var anotacoesDisciplina: UILabel!
    @IBOutlet weak var localDaAula: UILabel!
    @IBOutlet weak var horarioAula: UILabel!
    @IBOutlet weak var nomeDisciplina: UILabel!

    @IBOutlet weak var editarButton: UIButton!
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
                self.contentView.backgroundColor = UIColor(hex: "FAFAFA")
            })
        } else {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.editarButton.alpha = 0
            })
        }
    }

    @IBAction func editarAnotacoes(sender: AnyObject) {
        
    }
}
