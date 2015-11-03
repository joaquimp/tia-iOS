//
//  HorarioAnotacaoViewController.swift
//  MackTIA
//
//  Created by joaquim on 02/11/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

class HorarioAnotacaoViewController: UIViewController {

    @IBOutlet weak var anotacaoAula: UITextView!
    var horario:Horario?
    var acaoAoConfirmar:()->() = {}
    
    @IBAction func confirmarEdicao(sender: AnyObject) {
        self.horario?.anotacoes = self.anotacaoAula.text
        self.horario?.salvar()
        acaoAoConfirmar()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelarEdicao(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if horario == nil {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.anotacaoAula.text = horario?.anotacoes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.anotacaoAula.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
