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
}
