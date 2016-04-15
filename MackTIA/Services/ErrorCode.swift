//
//  ErrorCode.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright © 2016 Mackenzie. All rights reserved.
//

import Foundation

enum ErrorCode {
    case NoInternetConnection
    case InvalidLoginCredentials(title:String,message:String)
    case DomainNotFound
    case OtherFailure(title:String,message:String)
}