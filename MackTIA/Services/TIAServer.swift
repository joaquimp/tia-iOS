//
//  TIAServer.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation
import Alamofire


enum ServiceURL:String {
    case Login          = "https://www3.mackenzie.com.br/tia/tia_mobile/ping.php"
    case Grades         = "https://www3.mackenzie.com.br/tia/tia_mobile/notas.php"
    case Absence        = "https://www3.mackenzie.com.br/tia/tia_mobile/faltas.php"
    case ClassSchedule  = "https://www3.mackenzie.com.br/tia/tia_mobile/horarios.php"
}

private enum Token:String {
    case parte1 = "aNw3476Bi4ok33T987nQ"
    case parte2 = "wc8oc669GE738m8uMA77"
}

class TIAServer {
    
    // MARK: Singleton Methods
    static let sharedInstance = TIAServer()
    
    // MARK: Security Parameters and Methods
    var credentials:(tia:String,password:String,campus:String)?
    
    private func makeToken() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
        let day = components.day < 10 ? "0\(components.day)" : "\(components.day)"
        let month = components.month < 10 ? "0\(components.month)" : "\(components.month)"
        let token = "\(Token.parte1)\(month)\(components.year)\(day)\(Token.parte2)"
        return token.md5
    }
    
    
    // MARK: Server Communication
    
    private func getRequestParameters() -> [String:String] {
        let parameters = [
            "mat": self.credentials?.tia ?? " ",
            "pass": self.credentials?.password ?? " ",
            "token": self.makeToken()
        ]
        return parameters
    }
    
    func sendRequet(service:ServiceURL, completionHandler:(jsonData:AnyObject?, error: ErrorCode?) -> Void) {
        
        if Reachability.isConnectedToNetwork() == false {
            completionHandler(jsonData: nil, error: ErrorCode.NoInternetConnection)
        }
        
        Alamofire.request(.POST, service.rawValue, parameters: self.getRequestParameters()).responseJSON { response in
            print(#function, response)
            
            if response.result.error != nil {
                print(#function, response.result.error)
                // TODO: Validar que este erro só acontecerá caso o dominio esteja errado
                completionHandler(jsonData: nil, error: ErrorCode.DomainNotFound)
            } else {
                completionHandler(jsonData: response.result.value, error: nil)
            }
        }
    }
}
