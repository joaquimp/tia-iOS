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

class MaisTableViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        ///////
        let socialSection   = 0
        let fbMack      = 0
        let fbTVMack    = 1
        let fbRadio     = 2
        let twitter     = 3
        let email       = 4
        let appStore    = 5
        ///////
        
        ///////
        let equipeSection   = 1
        ///////
        
        ///////
        let apoioSection    = 2
        let paginaFCI   = 0
        let paginaDTI   = 2
        ///////
        
        if indexPath.section == equipeSection {
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
                    let safariURL = NSURL(string: "https://www.facebook.com/TvMackenzie")
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
                compose.setToRecipients(["npda@mackenzie.br", "moodleadmin@mackenzie.br"])
                self.presentViewController(compose, animated: true, completion: nil)
            case appStore:
                // Avaliar na AppStores
                let url = NSURL(string: "itms-apps://itunes.apple.com/app/1022024177")
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
            default:
                return
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        switch(result.rawValue){
        case MFMailComposeResultSent.rawValue:
            UIAlertView(title: "Obrigado", message: "Seu e-mail foi enviado e ficamos gratos pela sua(s) critica(s) e/ou sugestão(ões) :)", delegate: self, cancelButtonTitle: "OK").show()
        case MFMailComposeResultFailed.rawValue:
            UIAlertView(title: "Ops", message: "Ocorreu algum problema ao tentar enviar o e-mail. Se não estiver conseguindo enviar por aqui, envie um e-mail para moodleadmin@mackenzie.br. Obrigado!", delegate: self, cancelButtonTitle: "OK").show()
        default:
            return
        }
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        let alertController = UIAlertController(title: "Sair", message: "Deseja realmente sair?", preferredStyle: UIAlertControllerStyle.Alert)
        let actionSair = UIAlertAction(title: "Sair", style: UIAlertActionStyle.Default) { (alertAction) -> Void in
            NSUserDefaults.standardUserDefaults().removeObjectForKey("tia")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("senha")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("unidade")
            Nota.removerTudo()
            Falta.removerTudo()
            Horario.removerTudo()
            self.performSegueWithIdentifier("logoutSegue", sender: self)
        }
        let actionCancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.Cancel) { (alertAction) -> Void in
        }
        
        alertController.addAction(actionSair)
        alertController.addAction(actionCancelar)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
