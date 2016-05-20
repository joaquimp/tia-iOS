//
//  MoreViewController.swift
//  MackNews
//
//  Created by Joaquim Pessôa Filho on 7/24/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import Foundation
import UIKit
import Social
import MessageUI

// TODO: Colocar todo o texto no Localizable.string

class AboutTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tiaLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        userLabel.text = TIAServer.sharedInstance.user?.name ?? TIAServer.sharedInstance.user?.tia
        
        let tia = TIAServer.sharedInstance.user?.tia ?? "tia não encontrado"
        tiaLabel.text = "TIA: \(tia)"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let userSection = 0
        
        ///////
        let socialSection   = 2
        let fbMack      = 0
        let fbTVMack    = 1
        let fbRadio     = 2
        let twitter     = 3
        let email       = 4
        let appStore    = 5
        ///////
        
        ///////
        let equipeSection   = 3
        ///////
        
        ///////
        let apoioSection        = 4
        let paginaFCI           = 0
        let paginaMackMobile    = 1
        let paginaDTI           = 2
        ///////
        
        if indexPath.section == equipeSection || indexPath.section == userSection {
            tableView.deselectRowAtIndexPath(indexPath, animated: false)
            return
            
        } else if indexPath.section == socialSection {
            switch(indexPath.row){
            case fbTVMack:
                // Curtir pagina da TV Mackenzie
                var url = NSURL(string: "fb://profile/200809299999744")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    let safariURL = NSURL(string: "https://www.facebook.com/TvMackenzie")
                    if safariURL == nil {
                        print("Não conseguiu abrir facebook")
                        return
                    }
                    url = safariURL
                }
                UIApplication.sharedApplication().openURL(url!)
            case fbRadio:
                // Curtir pagina da Radio Mackenzie
                var url = NSURL(string: "fb://profile/795338763868734")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    let safariURL = NSURL(string: "https://www.facebook.com/radiomackenzie")
                    if safariURL == nil {
                        print("Não conseguiu abrir facebook")
                        return
                    }
                    url = safariURL
                }
                UIApplication.sharedApplication().openURL(url!)
            case fbMack:
                // Curtir pagina da Mackenzie
                var url = NSURL(string: "fb://profile/132887713419861")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    let safariURL = NSURL(string: "https://www.facebook.com/mackenzie1870")
                    if safariURL == nil {
                        print("Não conseguiu abrir facebook")
                        return
                    }
                    url = safariURL
                }
                UIApplication.sharedApplication().openURL(url!)
            case twitter:
                // Twittar sobre o aplicativo
                let compose = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                compose.setInitialText("#mackenzie1870 #mackmobile #macktia o terminal informativo acadêmico da Universidade Presbiteriana Mackenzie, baixa já na AppStore!")
                self.presentViewController(compose, animated: true, completion: nil)
            case email:
                // Envio de e-mail
                let compose = MFMailComposeViewController()
                compose.mailComposeDelegate = self
                compose.setToRecipients(["aplicativos@mackenzie.br"])
                self.presentViewController(compose, animated: true, completion: nil)
            case appStore:
                // Avaliar na AppStores
                let url = NSURL(string: "itms-apps://itunes.apple.com/app/id1022024177")
                if url != nil {
                    UIApplication.sharedApplication().openURL(url!)
                } else {
                    print("Erro ao tentar abrir AppStore")
                }
            default:
                return
            }
        } else if indexPath.section == apoioSection {
            switch(indexPath.row) {
            case paginaFCI:
                // Curtir pagina da Mackenzie
                let url = NSURL(string: "http://www.mackenzie.br/fci.html")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    print("Não conseguiu abrir pagina da fci")
                    return
                }
                UIApplication.sharedApplication().openURL(url!)
            case paginaDTI:
                // Curtir pagina da DTI
                let url = NSURL(string: "http://www.mackenzie.br/dti.html")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    print("Não conseguiu abrir pagina da dti")
                    return
                }
                UIApplication.sharedApplication().openURL(url!)
            case paginaMackMobile:
                // Pagina do MackMobile
                let url = NSURL(string: "http://www.mackmobile.com.br")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    print("Não conseguiu abrir pagina do MackMobile")
                    return
                }
                UIApplication.sharedApplication().openURL(url!)
            default:
                return
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        switch(result.rawValue){
        case MFMailComposeResultSent.rawValue:
            let alert = UIAlertController(title: NSLocalizedString("e-mail_successMessageSentTitle", comment: "Envio com sucesso"), message: NSLocalizedString("e-mail_successMessageSentMessage", comment: "Envio com sucesso"), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        case MFMailComposeResultFailed.rawValue:
            let alert = UIAlertController(title: NSLocalizedString("e-mail_errorMessageSentTitle", comment: "Envio com sucesso"), message: NSLocalizedString("e-mail_errorMessageSentMessage", comment: "Envio com sucesso"), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        default:
            return
        }
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        // TODO: Colocar mensagem no Localizable.strings
        let alertController = UIAlertController(title: "Sair da sua conta", message: "Caso você saida, será necessário informar seu tia e senha para acessar sua conta novamente", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let actionSair = UIAlertAction(title: "Sair", style: .Destructive) { (alertAction) -> Void in
            TIAServer.sharedInstance.logoff()
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        }
        let actionCancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
        }
        
        alertController.addAction(actionSair)
        alertController.addAction(actionCancelar)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
