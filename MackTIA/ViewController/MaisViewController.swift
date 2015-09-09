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

class MaisViewController: UITableViewController, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.setContentOffset(CGPointMake(0, -230), animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)

        ///////
        let socialSection   = 0
        let fbMack      = 0
//        let fbTVMack    = 1
        let fbRadio     = 1
        let twitter     = 2
        let email       = 3
        let appStore    = 4
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
//            case fbTVMack:
//                // Curtir pagina da TV Mackenzie
//                var url = NSURL(string: "fb://profile/200809299999744")
//                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
//                    var safariURL = NSURL(string: "https://www.facebook.com/TvMackenzie")
//                    if safariURL == nil {
//                        println("Não conseguiu abrir facebook")
//                        return
//                    }
//                    url = safariURL
//                }
//                UIApplication.sharedApplication().openURL(url!)
            case fbRadio:
                // Curtir pagina da Radio Mackenzie
                var url = NSURL(string: "fb://profile/795338763868734")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    var safariURL = NSURL(string: "https://www.facebook.com/TvMackenzie")
                    if safariURL == nil {
                        println("Não conseguiu abrir facebook")
                        return
                    }
                    url = safariURL
                }
                UIApplication.sharedApplication().openURL(url!)
            case fbMack:
                // Curtir pagina da Mackenzie
                var url = NSURL(string: "fb://profile/132887713419861")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    var safariURL = NSURL(string: "https://www.facebook.com/mackenzie1870")
                    if safariURL == nil {
                        println("Não conseguiu abrir facebook")
                        return
                    }
                    url = safariURL
                }
                UIApplication.sharedApplication().openURL(url!)
            case twitter:
                // Twittar sobre o aplicativo
                var compose = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                compose.setInitialText("#mackenzie1870 #mackmobile #macktia o terminal informativo acadêmico da Universidade Presbiteriana Mackenzie, baixa já na AppStore!")
                self.presentViewController(compose, animated: true, completion: nil)
            case email:
                // Envio de e-mail
                var compose = MFMailComposeViewController()
                compose.mailComposeDelegate = self
                compose.setToRecipients(["npda@mackenzie.br", "moodleadmin@mackenzie.br"])
                self.presentViewController(compose, animated: true, completion: nil)
            case appStore:
                // Avaliar na AppStores
                var url = NSURL(string: "itms-apps://itunes.apple.com/app/1022024177")
                if url != nil {
                    UIApplication.sharedApplication().openURL(url!)
                } else {
                    println("Erro ao tentar abrir AppStore")
                }
            default:
                return
            }
        } else if indexPath.section == apoioSection {
            switch(indexPath.row) {
            case paginaFCI:
                // Curtir pagina da Mackenzie
                var url = NSURL(string: "http://www.mackenzie.br/fci.html")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    println("Não conseguiu abrir pagina da fci")
                    return
                }
                UIApplication.sharedApplication().openURL(url!)
            case paginaDTI:
                // Curtir pagina da DTI
                var url = NSURL(string: "http://www.mackenzie.br/dti.html")
                if url == nil || !UIApplication.sharedApplication().canOpenURL(url!) {
                    println("Não conseguiu abrir pagina da dti")
                    return
                }
                UIApplication.sharedApplication().openURL(url!)
            default:
                return
            }
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        switch(result.value){
        case MFMailComposeResultSent.value:
            UIAlertView(title: "Obrigado", message: "Seu e-mail foi enviado e ficamos gratos pela sua(s) critica(s) e/ou sugestão(ões) :)", delegate: self, cancelButtonTitle: "OK").show()
        case MFMailComposeResultFailed.value:
            UIAlertView(title: "Ops", message: "Ocorreu algum problema ao tentar enviar o e-mail. Se não estiver conseguindo enviar por aqui, envie um e-mail para moodleadmin@mackenzie.br. Obrigado!", delegate: self, cancelButtonTitle: "OK").show()
        default:
            return
        }
    }
    
}
