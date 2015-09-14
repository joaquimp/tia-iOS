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

    @NSManaged var codigo: String
    @NSManaged var disciplina: String
    @NSManaged var atualizacao: String
    @NSManaged var turma: String
    @NSManaged var permitidas20: Int
    @NSManaged var permitidas: Int
    @NSManaged var aulasDadas: Int
    @NSManaged var faltas: Int
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
        let fetchRequest = NSFetchRequest(entityName: "Falta")
        var error:NSError?
        
        let fetchedResults = CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Falta] {
            return results
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        
        return Array<Falta>()
    }
    
    class func buscarFalta(codigo:String)->Falta?
    {
        let fetchRequest = NSFetchRequest(entityName: "Falta")
        let predicate = NSPredicate(format: "codigo = %@", codigo)
        fetchRequest.predicate = predicate
        
        var error:NSError?
        
        let fetchedResults = CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Falta] {
            if results.count > 0 {
                return results[0]
            }
        } else {
            println("Could not fetch. Error: \(error), \(error!.userInfo)")
        }
        
        return nil
    }
    
    private class func removerFaltasDiferentes(codigos:Array<String>) {
        var predicateString = ""
        for var i=0; i < codigos.count; i++ {
            predicateString += "codigo <> '\(codigos[i])'"
            if i < codigos.count - 1 {
                predicateString += " AND "
            }
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Falta")
        let predicate = NSPredicate(format: predicateString)
        fetchRequest.predicate = predicate
        
        var error:NSError?
        
        let fetchedResults = CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults as? [Falta] {
            for var i=0; i < results.count; i++ {
                CoreDataHelper.sharedInstance.managedObjectContext!.deleteObject(results[i])
            }
        }
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    class func removerTudo() {
        let fetchRequest = NSFetchRequest(entityName: "Falta")
        var error:NSError?
        
        let fetchedResults = CoreDataHelper.sharedInstance.managedObjectContext!.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        if let results = fetchedResults as? [Falta] {
            for var i=0; i < results.count; i++ {
                CoreDataHelper.sharedInstance.managedObjectContext!.deleteObject(results[i])
            }
        }
        CoreDataHelper.sharedInstance.saveContext()
    }
    
    
    // MARK: Metodos uteis
    class func parseJSON(faltaData:NSData) -> Array<Falta>? {
        var faltas:Array<Falta>? = Array<Falta>()

        var errorJson:NSError?
        if let resposta = NSJSONSerialization.JSONObjectWithData(faltaData, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as? NSDictionary {
            
            if let faltasJSON = resposta.objectForKey("resposta") as? Array<NSDictionary> {
                var novasDisciplinas = Array<String>()
                
                for faltaDic in faltasJSON {

                    let falta:Falta?
                    
                    if let codigo = faltaDic["codigo"] as? String {
                        if let faltaExistente = Falta.buscarFalta(codigo) {
                            falta = faltaExistente
                        } else {
                            falta = Falta.novaFalta()
                        }
                        falta?.codigo = codigo
                        novasDisciplinas.append(codigo)
                    } else { return nil }
                    
                    if let disciplina = faltaDic["disciplina"] as? String {
                        falta?.disciplina = disciplina
                    } else { return nil }
                    
                    if let turma = faltaDic["turma"] as? String {
                        falta?.turma = turma
                    } else { return nil }
                    
                    if let aulasDadas = faltaDic["dadas"] as? Int {
                        falta?.aulasDadas = aulasDadas
                    } else { return nil }
                    
                    if let permitidas20 = faltaDic["permit20"] as? Int {
                        falta?.permitidas20 = permitidas20
                    } else { return nil }
                    
                    if let permitidas = faltaDic["permit"] as? Int {
                        falta?.permitidas = permitidas
                    } else { return nil }
                    
                    if let faltas = faltaDic["faltas"] as? Int {
                        falta?.faltas = faltas
                    } else { return nil }
                    
                    if let percentual = faltaDic["percentual"] as? Float {
                        falta?.percentual = percentual
                    } else { return nil }
                    
                    if let atualizacao = faltaDic["atualizacao"] as? String {
                        falta?.atualizacao = atualizacao
                    } else { return nil }
                    
                    falta?.salvar()
                    faltas!.append(falta!)
                    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "faltaAtualizacao")
                }
                
                Falta.removerFaltasDiferentes(novasDisciplinas)
                return faltas
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

}
