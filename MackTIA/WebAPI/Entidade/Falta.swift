//
//  Faltas.swift
//  MackTIA
//
//  Created by joaquim on 04/09/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import Foundation
import CoreData

class Falta: NSManagedObject {
    
    @NSManaged var tia: String
    @NSManaged var codigo: String
    @NSManaged var disciplina: String
    @NSManaged var atualizacao: String
    @NSManaged var turma: String
    @NSManaged var permitidas20: Int32
    @NSManaged var permitidas: Int32
    @NSManaged var aulasDadas: Int32
    @NSManaged var faltas: Int32
    @NSManaged var percentual: Float
    
    func salvar() {
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    class func novaFalta()->Falta
    {
        return NSEntityDescription.insertNewObjectForEntityForName("Falta", inManagedObjectContext: CoreDataHelper.sharedInstance.managedObjectContext!) as! Falta
    }
    
    class func buscarFaltas()->Array<Falta>
    {
        
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("removerFaltasDiferentes: error, usuario nao logado")
            return Array<Falta>()
        }
        
        do {
            let fetchRequest = NSFetchRequest(entityName: "Falta")
            let predicate = NSPredicate(format: "tia = %@", tia)
            fetchRequest.predicate = predicate
            
            let fetchedResults = try CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults as? [Falta] {
                return results
            } else {
                print("Could not fetch. Error")
            }
        }catch{
            print("Falta.buscarFaltas - \(error)")
        }
        
        return Array<Falta>()
    }
    
    class func buscarFalta(codigo:String)->Falta?
    {
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("buscarFalta: error, usuario nao logado")
            return nil
        }
        
        do {
            let fetchRequest = NSFetchRequest(entityName: "Falta")
            let predicate = NSPredicate(format: "codigo = %@ AND tia = %@", codigo, tia)
            fetchRequest.predicate = predicate
            
            let fetchedResults = try CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults as? [Falta] {
                if results.count > 0 {
                    return results[0]
                }
            } else {
                print("Could not fetch. Error")
            }
        }catch{
            print("Falta.buscarFalta() - \(error)")
        }
        
        return nil
    }
    
    private class func removerFaltasDiferentes(codigos:Array<String>) {
        
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("removerFaltasDiferentes: error, usuario nao logado")
            return
        }
        
        do {
            var predicateString = ""
            for i in 0 ..< codigos.count {
                predicateString += "codigo <> '\(codigos[i])'"
                if i < codigos.count - 1 {
                    predicateString += " AND "
                }
            }
            predicateString += " AND tia = '\(tia)'"
            
            
            let fetchRequest = NSFetchRequest(entityName: "Falta")
            let predicate = NSPredicate(format: predicateString)
            fetchRequest.predicate = predicate
            
            let fetchedResults = try CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults as? [Falta] {
                for i in 0 ..< results.count {
                    CoreDataHelper.sharedInstance.managedObjectContext!.deleteObject(results[i])
                }
            }
            CoreDataHelper.sharedInstance.saveContext()
        }catch{
            print("Falta.removerFaltasDiferentes() - \(error)")
        }
    }
    
    // MARK: Metodos uteis
    class func parseJSON(faltaData:NSData) -> Array<Falta>? {
        
        guard let tia = TIAManager.sharedInstance.usuario?.tia else {
            print("parseJSON Falta: error, usuario nao logado")
            return nil
        }
        
        var faltasArray:Array<Falta>? = Array<Falta>()
        
        var resp:NSDictionary?
        do {
            resp = try NSJSONSerialization.JSONObjectWithData(faltaData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
        }catch{
            return nil
        }
        
        guard let resposta = resp else {
            return nil
        }
        
        guard let faltasJSON = resposta.objectForKey("resposta") as? Array<NSDictionary> else {
            return nil
        }
        
        var novasDisciplinas = Array<String>()
        
        for faltaDic in faltasJSON {
            
            //Verifica se todos os parametros estão corretos
            guard
                let codigo       = faltaDic["codigo"]     as? String,
                let disciplina   = faltaDic["disciplina"]   as? String,
                let turma        = faltaDic["turma"]        as? String,
                let aulasDadas   = faltaDic["dadas"]        as? Int,
                let permitidas20 = faltaDic["permit20"]     as? Int,
                let permitidas   = faltaDic["permit"]       as? Int,
                let faltas       = faltaDic["faltas"]       as? Int,
                let percentual   = faltaDic["percentual"]   as? Float,
                let atualizacao  = faltaDic["atualizacao"]  as? String else{
                    return nil
            }
            
            let falta:Falta?
            
            if let faltaExistente = Falta.buscarFalta(codigo) {
                falta = faltaExistente
            } else {
                falta = Falta.novaFalta()
            }
            falta?.codigo = codigo
            novasDisciplinas.append(codigo)
            
            falta?.tia           = tia
            falta?.disciplina    = disciplina
            falta?.turma         = turma
            falta?.aulasDadas    = Int32(aulasDadas)
            falta?.permitidas20  = Int32(permitidas20)
            falta?.permitidas    = Int32(permitidas)
            falta?.faltas        = Int32(faltas)
            falta?.percentual    = percentual
            falta?.atualizacao   = atualizacao
            
            falta?.salvar()
            faltasArray?.append(falta!)
        }
        Falta.removerFaltasDiferentes(novasDisciplinas)
        return faltasArray
    }
}