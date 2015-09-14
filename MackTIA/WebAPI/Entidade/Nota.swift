//
//  Nota.swift
//  MackTIA
//
//  Created by Joaquim Pessôa Filho on 9/5/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import Foundation
import CoreData

class Nota: NSManagedObject {
    
    @NSManaged var codigo: String
    @NSManaged var disciplina: String
    @NSManaged var a: String
    @NSManaged var b: String
    @NSManaged var c: String
    @NSManaged var d: String
    @NSManaged var e: String
    @NSManaged var f: String
    @NSManaged var g: String
    @NSManaged var h: String
    @NSManaged var i: String
    @NSManaged var j: String
    @NSManaged var sub: String
    @NSManaged var substituida: String
    @NSManaged var partic: String
    @NSManaged var mi: String
    @NSManaged var pf: String
    @NSManaged var mf: String
    @NSManaged var formula: String
    
    func salvar() {
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    class func novaNota()->Nota
    {
        return NSEntityDescription.insertNewObjectForEntityForName("Nota", inManagedObjectContext: CoreDataHelper.sharedInstance.managedObjectContext!) as! Nota
    }
    
    class func buscarNotas()->Array<Nota>
    {
        let fetchRequest = NSFetchRequest(entityName: "Nota")
        var error:NSError?
        
        let fetchedResults = CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Nota] {
            return results
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        
        return Array<Nota>()
    }
    
    class func buscarNota(codigo:String)->Nota?
    {
        let fetchRequest = NSFetchRequest(entityName: "Nota")
        let predicate = NSPredicate(format: "codigo = %@", codigo)
        fetchRequest.predicate = predicate
        
        var error:NSError?
        
        let fetchedResults = CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Nota] {
            if results.count > 0 {
                return results[0]
            }
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        
        return nil
    }
    
    private class func removerNotasDiferentes(codigos:Array<String>) {
        var predicateString = ""
        for var i=0; i < codigos.count; i++ {
            predicateString += "codigo <> '\(codigos[i])'"
            if i < codigos.count - 1 {
                predicateString += " AND "
            }
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Nota")
        let predicate = NSPredicate(format: predicateString)
        fetchRequest.predicate = predicate
        
        var error:NSError?
        
        let fetchedResults = CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Nota] {
            for var i=0; i < results.count; i++ {
                CoreDataHelper.sharedInstance.managedObjectContext!.deleteObject(results[i])
            }
        }
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    class func removerTudo() {
        let fetchRequest = NSFetchRequest(entityName: "Nota")
        var error:NSError?
        
        let fetchedResults = CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        if let results = fetchedResults as? [Nota] {
            for var i=0; i < results.count; i++ {
                CoreDataHelper.sharedInstance.managedObjectContext!.deleteObject(results[i])
            }
        }
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    // MARK: Metodos uteis
    class func parseJSON(notaData:NSData) -> Array<Nota>? {
        var notas:Array<Nota>? = Array<Nota>()
        
        var errorJson:NSError?
        if let resposta = NSJSONSerialization.JSONObjectWithData(notaData, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as? NSDictionary {
            
            if let notasJSON = resposta.objectForKey("resposta") as? Array<NSDictionary> {
                var novasDisciplinas = Array<String>()
                
                for notaDic in notasJSON {
                    
                    var nota:Nota?
                    let notaVazia = "-"
                    
                    if let codigo = notaDic["codigo"] as? String {
                        if let notaExistente = self.buscarNota(codigo) {
                            nota = notaExistente
                        } else {
                            nota = Nota.novaNota()
                        }
                        nota?.codigo = codigo
                        novasDisciplinas.append(codigo)
                    } else { return nil }
                    
                    if let disciplina = notaDic["disciplina"] as? String {
                        nota?.disciplina = disciplina
                    } else { return nil }
                    
                    if let a = notaDic["a"] as? String {
                        nota?.a = a
                    } else {
                        nota?.a = notaVazia
                    }
                    
                    if let b = notaDic["b"] as? String {
                        nota?.b = b
                    } else {
                        nota?.b = notaVazia
                    }
                    
                    if let c = notaDic["c"] as? String {
                        nota?.c = c
                    } else {
                        nota?.c = notaVazia
                    }
                    
                    if let d = notaDic["d"] as? String {
                        nota?.d = d
                    } else {
                        nota?.d = notaVazia
                    }
                    
                    if let e = notaDic["e"] as? String {
                        nota?.e = e
                    } else {
                        nota?.e = notaVazia
                    }
                    
                    if let f = notaDic["f"] as? String {
                        nota?.f = f
                    } else {
                        nota?.f = notaVazia
                    }
                    
                    if let g = notaDic["g"] as? String {
                        nota?.g = g
                    } else {
                        nota?.g = notaVazia
                    }
                    
                    if let h = notaDic["h"] as? String {
                        nota?.h = h
                    } else {
                        nota?.h = notaVazia
                    }
                    
                    if let i = notaDic["i"] as? String {
                        nota?.i = i
                    } else {
                        nota?.i = notaVazia
                    }
                    
                    if let j = notaDic["j"] as? String {
                        nota?.j = j
                    } else {
                        nota?.j = notaVazia
                    }
                    
                    if let sub = notaDic["sub"] as? String {
                        nota?.sub = sub
                    } else {
                        nota?.sub = notaVazia
                    }
                    
                    if let substituida = notaDic["substituida"] as? String {
                        nota?.substituida = substituida
                    } else {
                        nota?.substituida = notaVazia
                    }
                    
                    if let partic = notaDic["partic"] as? String {
                        nota?.partic = partic
                    } else {
                        nota?.partic = notaVazia
                    }
                    
                    if var mi = notaDic["mi"] as? String {
                        if mi == "." || mi == "" {
                            mi = "0"
                        }
                        nota?.mi = mi
                    } else { return nil }
                    
                    if let pf = notaDic["pf"] as? String {
                        nota?.pf = pf
                    } else {
                        nota?.pf = notaVazia
                    }
                    
                    if var mf = notaDic["mf"] as? String {
                        if mf == "." || mf == "" {
                            mf = "0"
                        }
                        nota?.mf = mf
                    } else { return nil }
                    
                    if let formula = notaDic["formula"] as? String {
                        nota?.formula = formula
                    } else { return nil }
                    

                    nota?.salvar()
                    notas!.append(nota!)
                    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "notaAtualizacao")
                }
                
                Nota.removerNotasDiferentes(novasDisciplinas)
                
                return notas
            }
        }
        return nil
    }
}
