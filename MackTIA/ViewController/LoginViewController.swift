//
//  LoginViewController.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        var usuario = Usuario()
        usuario.tia = "41417275"
        usuario.senha = "123"
        usuario.unidade = "001"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "login", name: TIAManager.LoginSucessoNotification, object: nil)
        
        TIAManager.sharedInstance.login(usuario)
    }
    
    func login() {
        println("\0/");
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
