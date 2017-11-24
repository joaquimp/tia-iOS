//
//  ConfigHelper.swift
//  MackTIA
//
//  Created by joaquim on 17/09/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import Foundation

/** ConfigHelper Class
 
 */
class ConfigHelper {
    
    class var sharedInstance: ConfigHelper {
        struct Static {
            static var instance: ConfigHelper?
            static var doOnce: () {
                Static.instance = ConfigHelper()
            }
        }
        Static.doOnce
        return Static.instance!
    }
    
    var faltasURL:String!
    var notasURL:String!
    var loginURL:String!
    var horariosURL:String!
    
    
    fileprivate init() {
        
        // Verifica se o arquivo config.plist existe
        guard let path = Bundle.main.path(forResource: "config", ofType: "plist") else {
            self.faltasURL      = ""
            self.notasURL       = ""
            self.loginURL       = ""
            self.horariosURL    = ""
            return
        }
        
        let config = NSDictionary(contentsOfFile: path)!
        
        // Verifica se existem as configurações de URL necessárias
        guard let faltasURL = config.object(forKey: "faltasURL") as? String ,
            let notasURL  = config.object(forKey: "notasURL")  as? String ,
            let loginURL  = config.object(forKey: "loginURL")  as? String ,
            let horariosURL  = config.object(forKey: "horariosURL")  as? String else {
                self.faltasURL      = ""
                self.notasURL       = ""
                self.loginURL       = ""
                self.horariosURL    = ""
                return
        }
        
        self.faltasURL      = faltasURL
        self.notasURL       = notasURL
        self.loginURL       = loginURL
        self.horariosURL    = horariosURL
        
    }
}
