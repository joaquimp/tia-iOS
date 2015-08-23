//
//  LoginViewController.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var tia: UITextField!
    @IBOutlet weak var unidade: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSucesso", name: TIAManager.LoginSucessoNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginErro:", name: TIAManager.LoginErroNotification, object: nil)
    }
    
    
    func loginSucesso() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.activityIndicator.stopAnimating()
            self.performSegueWithIdentifier("login", sender: self)
        })
        
    }
    
    func loginErro(notification:NSNotification) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.activityIndicator.stopAnimating()
            if let let dict = notification.userInfo as? Dictionary<String,String> {
            
                let alert = UIAlertView(title: "Acesso Negado", message: dict[TIAManager.DescricaoDoErro], delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                let alert = UIAlertView(title: "Erro", message: "Não foi possível fazer login, entre em contato com o helpdesk se o erro persistir", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }
    
    @IBAction func login(sender: AnyObject) {
        self.activityIndicator.startAnimating()
        var usuario = Usuario()
        usuario.tia = tia.text
        usuario.senha = senha.text
        usuario.unidade = unidade.text
        TIAManager.sharedInstance.login(usuario)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
