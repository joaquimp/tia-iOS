//
//  TIAManager.swift
//  MackTIA
//
//  Created by joaquim on 21/08/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import Foundation


/** TIAManager Class

*/
class TIAManager {
    
    static let LoginSucessoNotification = "LoginSucessoNotification"
    static let LoginErroNotification = "LoginErroNotification"
    static let FaltasRecuperadasNotification = "FaltasRecuperadasNotification"
    static let FaltasErroNotification = "FaltasErroNotification"
    static let NotasRecuperadasNotification = "NotasRecuperadasNotification"
    static let NotasErroNotification = "NotasErroNotification"
    
    static let DescricaoDoErro = "descricao"
    
    
    private var token_parte1:String
    private var token_parte2:String
    private var config:NSDictionary
    // Sera nulo caso usuario nao estiver autenticado ou caso ocorra erro de autenticacao
    private var usuario:Usuario?
    
    // Sera substituido por CoreData
    private var faltas:Array<Falta>
    
    class var sharedInstance : TIAManager {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : TIAManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TIAManager()
        }
        return Static.instance!
    }
    
    private init(){
        if let path = NSBundle.mainBundle().pathForResource("token", ofType: "plist") {
            var tokenDict = NSDictionary(contentsOfFile: path)
            self.token_parte1 = tokenDict!.valueForKey("parte 1") as! String
            self.token_parte2 = tokenDict!.valueForKey("parte 2") as! String
        } else {
            println("There are a problem in token.plist")
            self.token_parte1 = ""
            self.token_parte2 = ""
        }
        
        if let path = NSBundle.mainBundle().pathForResource("config", ofType: "plist") {
            self.config = NSDictionary(contentsOfFile: path)!
        } else {
            self.config = NSDictionary()
        }
        
        self.faltas = Array<Falta>()
    }
    
    private func gerarToken() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: date)
        
        var day = "\(components.day)"
        var month = "\(components.month)"
        var year = "\(components.year)"
        
        if (components.day < 10) {
            day = "0\(day)"
        }
        
        if (components.month < 10) {
            month = "0\(month)"
        }
        
        var token = "\(self.token_parte1)\(month)\(year)\(day)\(self.token_parte2)"
        
        return token.md5
    }
    
    private func criarRequisicao(stringURL:String, usuario:Usuario) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: stringURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        let postString = "mat=\(usuario.tia)&pass=\(usuario.senha)&unidade=\(usuario.unidade)&token=\(self.gerarToken())"
        println(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
    /**
    Metodo responsavel por realizar uma verificacao inicial dos dados do aluno e atividade do servidor
    Este metodo eh assincrono, por isso faz uso de notificacoes assim que processa a requisicao
    
    :param: usuario Dados de autenticacao do aluno que esta realizando o login
    */
    func login(usuario:Usuario) {
        
        if usuario.tia == "" || usuario.senha == "" || usuario.unidade == "" {
            NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.LoginErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Erro ao informar os dados do aluno"])
            return
        }
        
        if let stringURL = self.config.objectForKey("loginURL") as? String {
            
            let request = self.criarRequisicao(stringURL, usuario: usuario)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.LoginErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"])
                    return
                }
                
                var errorJson:NSError?
                if let resposta = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as? NSDictionary {
                    
                    if let ping = resposta.objectForKey("sucesso") as? String {
                        println("Login: \(ping)")
                        //Registra usuario logado
                        self.usuario = usuario
                        NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.LoginSucessoNotification, object: self)
                        return
                    } else if let erro = resposta.objectForKey("erro") as? String {
                        println("Login: \(erro)")
                        NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.LoginErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Verifique se informou os dados corretamente"])
                        return
                    }
                }
                
                NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.LoginErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"])
            })
            task.resume()
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.LoginErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Erro interno no aplicativo. Provavelmente a culpa não é usa, por algum motivo desconhecido o aplicativo não está funcionando. Tente apagar ele do seu dispositivo e instalar novamente. Caso não funcione não deixe de entrar em contato reportando o problema."])
        }
    }
    
    /**
    Busca as faltas do aluno autenticado no servidor e salva no banco de dados interno.
    Esta funcao eh assincrona, por isso realiza o envio de notificacoes assim que processa a requisicao
    */
    func atualizarFaltas() {
        if self.usuario == nil {
            NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.FaltasErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Erro de autenticação no servidor. Acesso negado!"])
            return
        }
        
        if let stringURL = self.config.objectForKey("faltasURL") as? String {
            
            let request = self.criarRequisicao(stringURL, usuario: self.usuario!)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.FaltasErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"])
                    return
                }
                
                var errorJson:NSError?
                if let resposta = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as? NSDictionary {
                    
                    if let faltas = resposta.objectForKey("resposta") as? Array<NSDictionary> {
                        
                        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        // Lendo dados do JSON e criando
                        // objeto, depois precisa salvar
                        // no banco de dados local
                        
//                        41417275 1995ferd
                        //!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        var novasFaltas = Array<Falta>()
                        for faltaDic in faltas {
                            var falta = Falta()
                            falta.codigo = faltaDic["codigo"] as! String
                            falta.disciplina = faltaDic["disciplina"] as! String
                            falta.turma = faltaDic["turma"] as! String
                            falta.aulasDadas = (faltaDic["dadas"] as! String).toInt()!
                            falta.permitidas_20 = (faltaDic["permit20"] as! NSNumber).floatValue
                            falta.permitidas = (faltaDic["permit"] as! NSString).floatValue
                            falta.faltas = (faltaDic["faltas"] as! String).toInt()!
                            falta.percentual = (faltaDic["percentual"] as! NSString).floatValue
                            falta.atualizacao = faltaDic["atualizacao"] as! String
                            novasFaltas.append(falta)
                        }
                        self.faltas = novasFaltas
                        
                        
                        NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.FaltasRecuperadasNotification, object: self)
                        return
                    } else if let erro = resposta.objectForKey("erro") as? String {
                        println("Login: \(erro)")
                        NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.FaltasErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Verifique se informou os dados corretamente"])
                        return
                    }
                } else {
                
                    NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.FaltasErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"])
                }
            })
            task.resume()
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(TIAManager.FaltasErroNotification, object: self, userInfo: [TIAManager.DescricaoDoErro : "Erro interno no aplicativo. Provavelmente a culpa não é usa, por algum motivo desconhecido o aplicativo não está funcionando. Tente apagar ele do seu dispositivo e instalar novamente. Caso não funcione não deixe de entrar em contato reportando o problema."])
        }
    }
    
    
    /**
    Busca no banco de dados as faltas atuais
    
    :returns: Um vetor com as faltas persistidas no banco de dados
    */
    func todasFaltas()->Array<Falta> {
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //Precisa reimplementar com CoreData!!!!
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        return self.faltas
    }
}
