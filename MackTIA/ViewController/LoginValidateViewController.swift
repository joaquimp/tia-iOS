//
//  LoginValidateViewController.swift
//  MackTIA
//
//  Created by joaquim on 18/09/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

class LoginValidateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let tia = NSUserDefaults.standardUserDefaults().stringForKey("tia") {
            if let senha = NSUserDefaults.standardUserDefaults().stringForKey("senha") {
                if let unidade = NSUserDefaults.standardUserDefaults().stringForKey("unidade") {
                    let usuario = Usuario()
                    usuario.tia = tia
                    usuario.senha = senha
                    usuario.unidade = unidade
                    TIAManager.sharedInstance.usuario = usuario
                    self.performSegueWithIdentifier("startApp", sender: self)
                    return
                }
            }
        }
        self.performSegueWithIdentifier("login", sender: self)
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
