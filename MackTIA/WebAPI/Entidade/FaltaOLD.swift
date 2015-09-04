//
//  Falta.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit
import SwiftyJSON

class FaltaOLD {
    var codigo:String
    var disciplina: String
    var turma:String
    var aulasDadas:Int
    var permitidas20:Float
    var permitidas:Float
    var faltas:Int
    var percentual:Float
    var atualizacao:String
    
    init() {
        self.codigo         = ""
        self.disciplina     = ""
        self.turma          = ""
        self.aulasDadas     = 0
        self.permitidas20   = 0
        self.permitidas     = 0
        self.faltas         = 0
        self.percentual     = 0.0
        self.atualizacao    = "00/00/0000"
    }
    
//    class func parseJSON(faltaData:NSData) -> Array<Falta>? {
//        let json = JSON(data:faltaData)
//        var faltas:Array<Falta>? = Array<Falta>()
//        
//        if json["resposta"].count == 0 {
//            return nil
//        }
//        
//        for pos in 0...json["resposta"].count-1 {
//            let falta = Falta()
//            
//            if let codigo = json["resposta"][pos]["codigo"].string {
//                falta.codigo = codigo
//            } else { return nil }
//            
//            if let disciplina = json["resposta"][pos]["disciplina"].string {
//                falta.disciplina = disciplina
//            } else { return nil }
//            
//            if let turma = json["resposta"][pos]["turma"].string {
//                falta.turma = turma
//            } else { return nil }
//
//            if let aulasDadas = json["resposta"][pos]["dadas"].int {
//                falta.aulasDadas = aulasDadas
//            } else { return nil }
//            
//            if let permitidas20 = json["resposta"][pos]["permit20"].float {
//                falta.permitidas20 = permitidas20
//            } else { return nil }
//            
//            if let permitidas = json["resposta"][pos]["permit"].float {
//                falta.permitidas = permitidas
//            } else { return nil }
//            
//            if let faltas = json["resposta"][pos]["faltas"].int {
//                falta.faltas = faltas
//            } else { return nil }
//            
//            if let percentual = json["resposta"][pos]["percentual"].float {
//                falta.percentual = percentual
//            } else { return nil }
//            
//            if let atualizacao = json["resposta"][pos]["atualizacao"].string {
//                falta.atualizacao = atualizacao
//            } else { return nil }
//
//            faltas!.append(falta)
//        }
//        return faltas
//    }
   
}
