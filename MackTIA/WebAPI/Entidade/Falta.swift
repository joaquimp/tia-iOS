//
//  Falta.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit

class Falta {
    var codigo:String
    var disciplina: String
    var turma:String
    var aulasDadas:Int
    var permitidas_20:Int
    var permitidas:Int
    var faltas:Int
    var percentual:Float
    var atualizacao:String
    
    init() {
        self.codigo         = ""
        self.disciplina     = ""
        self.turma          = ""
        self.aulasDadas     = 0
        self.permitidas_20  = 0
        self.permitidas     = 0
        self.faltas         = 0
        self.percentual     = 0.0
        self.atualizacao    = "00/00/0000"
    }
   
}
