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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBAction func confirmarEdicao(sender: AnyObject) {
        self.anotacaoAula.resignFirstResponder()
        self.horario?.anotacoes = self.anotacaoAula.text
        self.horario?.salvar()
        acaoAoConfirmar()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func cancelarEdicao(sender: AnyObject) {
        self.anotacaoAula.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if horario == nil {
            self.dismissViewControllerAnimated(false, completion: nil)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HorarioAnotacaoViewController.keyboardWasShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HorarioAnotacaoViewController.keyboardWasHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWasShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    func keyboardWasHide(notification: NSNotification) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 20
        })
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
