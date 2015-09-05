//
//  LoginViewController.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate {
    @IBOutlet weak var tiaTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var unidadePickerView: AKPickerView!
    
    var unidades:Array<String>!
    var unidadesCodigo:Array<String>!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.unidades = [" São Paulo "," Rio de Janeiro "," Brasília "," UATU "]
        self.unidadesCodigo = ["001","006","003","011"]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let paddingViewTia = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        let paddingViewPass = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 50))
        
        let tiaPlaceholder = NSMutableAttributedString(string: "TIA") // Localized text here!
        let rangeTia = NSMakeRange(0, count(tiaPlaceholder.string))
        tiaPlaceholder.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: rangeTia)
        
        self.tiaTextField.layer.cornerRadius = 7
        self.tiaTextField.leftView = paddingViewTia
        self.tiaTextField.leftViewMode = .Always
        self.tiaTextField.rightView = paddingViewTia
        self.tiaTextField.rightViewMode = .Always
        self.tiaTextField.attributedPlaceholder = tiaPlaceholder
        
        let passPlaceholder = NSMutableAttributedString(string: "SENHA") // Localized text here!
        let rangePass = NSMakeRange(0, count(passPlaceholder.string))
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
        self.unidadePickerView.selectItem(0, animated: false)
        self.unidadePickerView.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.25)
        self.unidadePickerView.highlightedTextColor = UIColor.whiteColor()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSucesso", name: TIAManager.LoginSucessoNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginErro:", name: TIAManager.LoginErroNotification, object: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: UIResponder
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    // MARK: Util
    func loginSucesso() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.performSegueWithIdentifier("login", sender: self)
        })
        
    }
    
    func loginErro(notification:NSNotification) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            if let let dict = notification.userInfo as? Dictionary<String,String> {
            
                let alert = UIAlertView(title: "Acesso Negado", message: dict[TIAManager.DescricaoDoErro], delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                let alert = UIAlertView(title: "Erro", message: "Não foi possível fazer login, entre em contato com o helpdesk se o erro persistir", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }
    
    // MARK: IBAction
    @IBAction func login(sender: AnyObject) {
        var usuario = Usuario()
        usuario.tia = tiaTextField.text
        usuario.senha = passTextField.text
        usuario.unidade = self.unidadesCodigo[self.unidadePickerView.selectedItem]
        TIAManager.sharedInstance.login(usuario)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
