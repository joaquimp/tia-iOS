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
    
    // MARK: Seguranca
    private var token_parte1:String
    private var token_parte2:String
    private var config:NSDictionary
    // Sera nulo caso usuario nao estiver autenticado ou caso ocorra erro de autenticacao
    private var usuario:Usuario?
    
    // Cache do banco
    private var faltas:Array<Falta>
    private var notas:Array<Nota>
    
    // MARK: Singleton Methods
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
        self.notas = Array<Nota>()
    }
    
    // MARK: Metodos uteis
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
        println("Enviando requisição")
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
    // MARK: Autenticacao externa
    /**
    Metodo responsavel por realizar uma verificacao inicial dos dados do aluno e atividade do servidor
    Este metodo eh assincrono, por isso faz uso de notificacoes assim que processa a requisicao
    
    :param: usuario Dados de autenticacao do aluno que esta realizando o login
    */
    func login(usuario:Usuario, completionHandler:(TIAManager,NSError?)->()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            
            var erro:NSError?
            
            if usuario.tia == "" || usuario.senha == "" || usuario.unidade == "" {
                let mensagem = "Erro ao informar os dados do aluno"
                let descricao = "Alguns dos parametros do usuario nao foi informado"
                erro = NSError(domain: "TIAManager.login", code: 1, userInfo: ["mensagem":mensagem,"descricao":descricao])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
                return
            }
            
            if let stringURL = self.config.objectForKey("loginURL") as? String {
                
                let request = self.criarRequisicao(stringURL, usuario: usuario)
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    println("Erro: \(error)")
                    if error != nil {
                        let mensagem = "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"
                        let descricao = "Erro ao fazer a requisicao ao servidor do Mackenzie: \(error.description)"
                        erro = NSError(domain: "TIAManager.login", code: 2, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }//{"erro":"acesso negado"}{"sucesso":"acesso liberado"}
                    
                    var errorJson:NSError?
                    if let resposta = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as? NSDictionary {
                        
                        if let ping = resposta.objectForKey("sucesso") as? String {
                            println("Login: \(ping)")
                            //Registra usuario logado
                            self.usuario = usuario
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(self,erro)
                            })
                            return
                        } else if let erroAPI = resposta.objectForKey("erro") as? String {
                            let mensagem = "Verifique se informou os dados corretamente"
                            let descricao = "Dados incorretos, acesso negado ao servico: \(erroAPI)"
                            erro = NSError(domain: "TIAManager.login", code: 3, userInfo: ["mensagem":mensagem,"descricao":descricao])
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(self,erro)
                            })
                            return
                        }
                    } else {
                        let mensagem = "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"
                        let descricao = "A mensagem retornada do servidor estar em um formato nao esperado"
                        erro = NSError(domain: "TIAManager.login", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }
                })
                task.resume()
            } else {
                let mensagem = "Erro interno no aplicativo. Provavelmente a culpa não é usa, por algum motivo desconhecido o aplicativo não está funcionando. Tente apagar ele do seu dispositivo e instalar novamente. Caso não funcione não deixe de entrar em contato reportando o problema."
                let descricao = "Erro interno. Nao encontrou parametro faltasURL no arquivo de configuracao config.plist"
                erro = NSError(domain: "TIAManager.login", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
            }
        })
    }
    
    
    
    // MARK: Metodos de manipulacao de FALTAS
    /**
    Busca as faltas do aluno autenticado no servidor e salva no banco de dados interno.
    Esta funcao eh assincrona, por isso realiza o envio de notificacoes assim que processa a requisicao
    */
    func atualizarFaltas(completionHandler:(TIAManager,NSError?)->()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            var erro:NSError?
            
            if self.usuario == nil {
                let mensagem = "Erro de autenticação no servidor. Acesso negado!"
                let descricao = "Objeto usuario eh nulo, nao deve ter passado corretamente pela fase de atuenticacao"
                erro = NSError(domain: "TIAManager.atualizarFaltas", code: 1, userInfo: ["mensagem":mensagem,"descricao":descricao])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
                return
            }
            
            if let stringURL = self.config.objectForKey("faltasURL") as? String {
                
                let request = self.criarRequisicao(stringURL, usuario: self.usuario!)
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        let mensagem = "Erro de conexão ao servidor. Verifique sua internet e tente novamente ;)"
                        let descricao = "Erro ao fazer a requisicao ao servidor do Mackenzie: \(error.description)"
                        erro = NSError(domain: "TIAManager.atualizarFaltas", code: 2, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }
                    
                    var errorJson:NSError?
                    
                    if let novasFaltas = Falta.parseJSON(data) {
                        self.faltas = novasFaltas
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    } else {
                        var errorJson:NSError?
                        if let resposta = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as? NSDictionary {
                            
                            if let erroAPI = resposta.objectForKey("erro") as? String {
                                let mensagem = "Problema na autenticação. Deslogue do aplicativo e entre novamente"
                                let descricao = "Dados incorretos, acesso negado ao servico: \(erroAPI)"
                                erro = NSError(domain: "TIAManager.atualizarFaltas", code: 3, userInfo: ["mensagem":mensagem,"descricao":descricao])
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completionHandler(self,erro)
                                })
                                return
                            } else {
                                let mensagem = "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"
                                let descricao = "A mensagem desenvolvida pela API do Mackenzie-TIA nao eh esperada ou nao esta no formato esperado"
                                erro = NSError(domain: "TIAManager.atualizarFaltas", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completionHandler(self,erro)
                                })
                                return
                            }
                        } else {
                            let mensagem = "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"
                            let descricao = "A mensagem desenvolvida pela API do Mackenzie-TIA nao esta no formato esperado"
                            erro = NSError(domain: "TIAManager.atualizarFaltas", code: 5, userInfo: ["mensagem":mensagem,"descricao":descricao])
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(self,erro)
                            })
                            return
                        }
                    }
                })
                task.resume()
            } else {
                let mensagem = "Erro interno no aplicativo. Provavelmente a culpa não é usa, por algum motivo desconhecido o aplicativo não está funcionando. Tente apagar ele do seu dispositivo e instalar novamente. Caso não funcione não deixe de entrar em contato reportando o problema."
                let descricao = "Erro interno. Nao encontrou parametro notasURL no arquivo de configuracao config.plist"
                erro = NSError(domain: "TIAManager.atualizarFaltas", code: 6, userInfo: ["mensagem":mensagem,"descricao":descricao])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
            }
        })
    }
    
    
    /**
    Busca no banco de dados as faltas atuais
    
    :returns: Um vetor com as faltas persistidas no banco de dados
    */
    func todasFaltas()->Array<Falta> {
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //Precisa reimplementar com CoreData!!!!
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        //        if self.faltas.count == 0 {
        //            let faltas = Falta.buscarFaltas()
        //        }
        
        return self.faltas
    }
    
    
    // MARK: Metodos de manipulacao de NOTAS
    /**
    Busca as notas do aluno autenticado no servidor e salva no banco de dados interno.
    Esta funcao eh assincrona, por isso realiza o envio de notificacoes assim que processa a requisicao
    */
    func atualizarNotas(completionHandler:(TIAManager,NSError?) -> ()) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            var erro:NSError?
            
            if self.usuario == nil {
                let mensagem = "Erro de autenticação no servidor. Acesso negado!"
                let descricao = "Objeto usuario eh nulo, nao deve ter passado corretamente pela fase de atuenticacao"
                erro = NSError(domain: "TIAManager.atualizarNotas", code: 1, userInfo: ["mensagem":mensagem,"descricao":descricao])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
                return
            }
            
            if let stringURL = self.config.objectForKey("notasURL") as? String {
                
                let request = self.criarRequisicao(stringURL, usuario: self.usuario!)
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        let mensagem = "Erro de conexão ao servidor. Verifique sua internet e tente novamente ;)"
                        let descricao = "Erro ao fazer a requisicao ao servidor do Mackenzie: \(error.description)"
                        erro = NSError(domain: "TIAManager.atualizarNotas", code: 2, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }
                    
                    var errorJson:NSError?
                    
                    if let novasNotas = Nota.parseJSON(data) {
                        self.notas = novasNotas
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    } else {
                        var errorJson:NSError?
                        if let resposta = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &errorJson) as? NSDictionary {
                            
                            if let erroAPI = resposta.objectForKey("erro") as? String {
                                let mensagem = "Problema na autenticação. Deslogue do aplicativo e entre novamente. Se o problema persistir contacte o helpdesk"
                                let descricao = "A API Mackenzie-TIA retornou mensagem de erro: \(erroAPI)"
                                erro = NSError(domain: "TIAManager.atualizarNotas", code: 3, userInfo: ["mensagem":mensagem,"descricao":descricao])
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completionHandler(self,erro)
                                })
                                return
                            } else {
                                let mensagem = "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"
                                let descricao = "A mensagem desenvolvida pela API do Mackenzie-TIA nao eh esperada ou nao esta no formato esperado"
                                erro = NSError(domain: "TIAManager.atualizarNotas", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    completionHandler(self,erro)
                                })
                                return
                            }
                        } else {
                            let mensagem = "Erro ao acessar o serviço do Mackenzie. Provavelmente a culpa não é usa, por favor verifique se sua internet está funcionando. Se o problema persistir entre em contato com o helpdesk"
                            let descricao = "A mensagem desenvolvida pela API do Mackenzie-TIA nao esta no formato esperado"
                            erro = NSError(domain: "TIAManager.atualizarNotas", code: 5, userInfo: ["mensagem":mensagem,"descricao":descricao])
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                completionHandler(self,erro)
                            })
                            return
                        }
                    }
                })
                task.resume()
            } else {
                let mensagem = "Erro interno no aplicativo. Provavelmente a culpa não é usa, por algum motivo desconhecido o aplicativo não está funcionando. Tente apagar ele do seu dispositivo e instalar novamente. Caso não funcione não deixe de entrar em contato reportando o problema."
                let descricao = "Erro interno. Nao encontrou parametro notasURL no arquivo de configuracao config.plist"
                erro = NSError(domain: "TIAManager.atualizarNotas", code: 6, userInfo: ["mensagem":mensagem,"descricao":descricao])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
            }
        })
        
    }
    
    
    /**
    Busca no banco de dados as notas atuais
    
    :returns: Um vetor com as notas persistidas no banco de dados
    */
    func todasNotas()->Array<Nota> {
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        //Precisa reimplementar com CoreData!!!!
        // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
        //        if self.faltas.count == 0 {
        //            let faltas = Falta.buscarFaltas()
        //        }
        
        return self.notas
    }
}
