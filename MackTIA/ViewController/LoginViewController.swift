//
//  LoginViewController.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit
//import Fabric
import Crashlytics

class LoginViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var tiaTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var unidadePickerView: AKPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var bloqueiView: UIVisualEffectView!
    
    var unidades:Array<String>!
    var unidadesCodigo:Array<String>!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.unidades = [" Rio de Janeiro "," São Paulo "," Brasília "," UATU "]
        self.unidadesCodigo = ["006","001","003","011"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let paddingViewTia = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        let paddingViewPass = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        
        let tiaPlaceholder = NSMutableAttributedString(string: "TIA") // Localized text here!
        let rangeTia = NSMakeRange(0, tiaPlaceholder.string.characters.count)
        tiaPlaceholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: rangeTia)
        
        self.tiaTextField.layer.cornerRadius = 7
        self.tiaTextField.leftView = paddingViewTia
        self.tiaTextField.leftViewMode = .Always
        self.tiaTextField.rightView = paddingViewTia
        self.tiaTextField.rightViewMode = .Always
        self.tiaTextField.attributedPlaceholder = tiaPlaceholder
        
        let passPlaceholder = NSMutableAttributedString(string: "SENHA") // Localized text here!
        let rangePass = NSMakeRange(0, passPlaceholder.string.characters.count)
        passPlaceholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: rangePass)
        
        self.passTextField.layer.cornerRadius = 7
        self.passTextField.leftView = paddingViewPass
        self.passTextField.leftViewMode = .Always
        self.passTextField.rightView = paddingViewPass
        self.passTextField.rightViewMode = .Always
        self.passTextField.attributedPlaceholder = passPlaceholder
        
        self.loginButton.layer.cornerRadius = 7
        
        self.unidadePickerView.delegate = self
        self.unidadePickerView.dataSource = self
        self.unidadePickerView.layer.cornerRadius = 7
        self.unidadePickerView.selectItem(1, animated: false)
        self.unidadePickerView.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        self.unidadePickerView.highlightedTextColor = UIColor.whiteColor()
        
        // este codigo existe para que na storyboard a view e o activityIndicator possam ficar de fundo sem atrapalhar o trabalho do desgin
        self.view.bringSubviewToFront(self.bloqueiView)
        self.view.bringSubviewToFront(self.activityIndicator)
        self.activityIndicator.hidden = true
        self.bloqueiView.hidden = true
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
                    self.performSegueWithIdentifier("login", sender: self)
                }
            }
        }
        
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: UIResponder
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: IBAction
    @IBAction func login(sender: AnyObject) {
        let usuario = Usuario()
        usuario.tia = tiaTextField.text!
        usuario.senha = passTextField.text!
        usuario.unidade = self.unidadesCodigo[self.unidadePickerView.selectedItem]

        
        self.bloqueiView.hidden = false
        
        self.activityIndicator.startAnimating()
        
        TIAManager.sharedInstance.login(usuario, completionHandler: { (manager, error) -> () in
            self.activityIndicator?.stopAnimating()
            self.bloqueiView.hidden = true
            
            if error != nil {
                var mensagem = "Erro desconhecido. Se persistir contact o helpdesk"
                if let info = error?.userInfo as? [String:String] {
                    if info["mensagem"] != nil {
                        mensagem = info["mensagem"]!
                    }
                }
                let alert = UIAlertView(title: "Acesso Negado", message: mensagem, delegate: self, cancelButtonTitle: "OK")
                alert.show()
                //----------------------------------------------------------------------
                //FABRIC - Informa que o usuário fez login
                Answers.logLoginWithMethod("Digits",
                    success: false,
                    customAttributes: ["metodo":"login no servidor"])
                //----------------------------------------------------------------------
                return
            }
            //----------------------------------------------------------------------
            //FABRIC - Informa que o usuário fez login
            Answers.logLoginWithMethod("Digits",
                success: true,
                customAttributes: ["metodo":"login no servidor"])
            //----------------------------------------------------------------------
            self.performSegueWithIdentifier("login", sender: self)
        })
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - AKPickerView
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.unidades.count
    }
    
    // MARK: - Memory Management
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.unidades[item]
    }
    
    // MARK: - TextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let tag = textField.tag + 1
        if let superview = textField.superview {
            let nextTextField = superview.viewWithTag(tag)
            if nextTextField != nil {
                nextTextField?.becomeFirstResponder()
                return false
            }
        }
        textField.resignFirstResponder()
        return false
        
    }
    
    // MARK: Rotation Support
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func shouldAutorotate() -> Bool {
        return false
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
