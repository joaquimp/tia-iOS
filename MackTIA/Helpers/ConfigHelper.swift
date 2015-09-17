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
    
    class var sharedInstance : ConfigHelper {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ConfigHelper? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ConfigHelper()
        }
        return Static.instance!
    }
    
    var faltasURL:String!
    var notasURL:String!
    var loginURL:String!
    
    
    private init() {
        
        // Verifica se o arquivo config.plist existe
        guard let path = NSBundle.mainBundle().pathForResource("config", ofType: "plist") else {
            self.faltasURL = ""
            self.notasURL  = ""
            self.loginURL  = ""
            return
        }
        
        let config = NSDictionary(contentsOfFile: path)!
        
        // Verifica se existem as configurações de URL necessárias
        guard let faltasURL = config.objectForKey("faltasURL") as? String ,
              let notasURL  = config.objectForKey("notasURL")  as? String ,
              let loginURL  = config.objectForKey("loginURL")  as? String else {
            self.faltasURL = ""
            self.notasURL  = ""
            self.loginURL  = ""
            return
        }
        
        self.faltasURL = faltasURL
        self.notasURL  = notasURL
        self.loginURL  = loginURL

    }
}
