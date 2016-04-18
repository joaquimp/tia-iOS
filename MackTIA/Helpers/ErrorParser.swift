//
//  ErrorParser.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 18/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import UIKit

class ErrorParser: NSObject {
    class func parse(error:ErrorCode) -> (title:String,message:String) {
        var errorTitle:String = ""
        var errorMessage:String = ""
        
        switch error {
        case let .InvalidLoginCredentials(title,message):
            errorTitle = title
            errorMessage = message
        case .NoInternetConnection:
            errorTitle = NSLocalizedString("error_noInternetConnection_title", comment: "Internet problem")
            errorMessage = NSLocalizedString("error_noInternetConnection_message", comment: "Internet problem")
        case .DomainNotFound:
            errorTitle = NSLocalizedString("error_domainNotFound_title", comment: "Domain problem")
            errorMessage = NSLocalizedString("error_domainNotFound_message", comment: "Domain problem")
        case let .OtherFailure(title, message):
            errorTitle = title
            errorMessage = message
        }
        
        return (title:errorTitle, message:errorMessage)
    }
}
