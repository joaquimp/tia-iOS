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
    // Sera nulo caso usuario nao estiver autenticado ou caso ocorra erro de autenticacao
    var usuario:Usuario?{
        didSet{
            if usuario != nil {
                NSUserDefaults.standardUserDefaults().setObject(usuario!.tia, forKey: "tia")
                NSUserDefaults.standardUserDefaults().setObject(usuario!.senha, forKey: "senha")
                NSUserDefaults.standardUserDefaults().setObject(usuario!.unidade, forKey: "unidade")
            }
        }
    }
    
    // Cache do banco
    //    private(set) var faltas:Array<Falta>
    //    private(set) var notas:Array<Nota>
    
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
            let tokenDict = NSDictionary(contentsOfFile: path)
            self.token_parte1 = tokenDict!.valueForKey("parte 1") as! String
            self.token_parte2 = tokenDict!.valueForKey("parte 2") as! String
        } else {
            print("There are a problem in token.plist")
            self.token_parte1 = ""
            self.token_parte2 = ""
        }
    }
    
    // MARK: Metodos uteis
    private func gerarToken() -> String {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: date)
        
        var day = "\(components.day)"
        var month = "\(components.month)"
        let year = "\(components.year)"
        
        if (components.day < 10) {
            day = "0\(day)"
        }
        
        if (components.month < 10) {
            month = "0\(month)"
        }
        
        let token = "\(self.token_parte1)\(month)\(year)\(day)\(self.token_parte2)"
        
        return token.md5
    }
    
    
    private func criarRequisicao(stringURL:String, usuario:Usuario) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: stringURL)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        let postString = "mat=\(usuario.tia)&pass=\(usuario.senha)&unidade=\(usuario.unidade)&token=\(self.gerarToken())"
        print("Enviando requisição")
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
    // MARK: Autenticacao externa
    /**
    Metodo responsavel por realizar uma verificacao inicial dos dados do aluno e atividade do servidor
    Este metodo eh assincrono, por isso faz uso de notificacoes assim que processa a requisicao
    
    - parameter usuario: Dados de autenticacao do aluno que esta realizando o login
    */
    func login(usuario:Usuario, completionHandler:(TIAManager,NSError?)->()) {
        
        //Dispach para rodar requisição em paralelo e evitar travar interface do usuário
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            //Garante que todos os dados de usuarios foram informados
            guard usuario.tia != "" || usuario.senha != "" || usuario.unidade != "" else {
                let mensagem = NSLocalizedString("errorLoginValidate.text", comment: "Erro ao validar os dados")
                let descricao = NSLocalizedString("errorLoginValidate.description", comment: "Erro ao validar os dados")
                let erro = NSError(domain: "TIAManager.login", code: 1, userInfo: ["mensagem":mensagem,"descricao":descricao])
                //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
                return
            }
            
            let request = self.criarRequisicao(ConfigHelper.sharedInstance.loginURL, usuario: usuario)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                print("Erro: \(error)")
                
                //Verifica se ocorreu erro
                guard error == nil else {
                    let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro na requisição")
                    let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro na requisição") + error!.description
                    let erro = NSError(domain: "TIAManager.login", code: 2, userInfo: ["mensagem":mensagem,"descricao":descricao])
                    //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(self,erro)
                    })
                    return
                }
                
                var resp:NSDictionary?
                do {
                    resp = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                } catch {
                    print(error)
                }
                
                //Servidor respondeu mas em um formato não esperado
                guard let resposta = resp else {
                    let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro no retorno da requisição")
                    let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro no retorno da requisição")
                    let erro = NSError(domain: "TIAManager.login", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                    //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(self,erro)
                    })
                    return
                }
                
                //O servidor indicou um erro nos parâmetros da requisição
                guard let _ = resposta.objectForKey("sucesso") as? String else {
                    guard let erroAPI = resposta.objectForKey("erro") as? String else {
                        //O conteudo retornado não está no formato esperado
                        let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro no retorno da requisição")
                        let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro no retorno da requisição")
                        let erro = NSError(domain: "TIAManager.login", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }
                    
                    let mensagem = NSLocalizedString("errorLoginAccess.text", comment: "Erro ao validar os dados no servidor")
                    let descricao = NSLocalizedString("errorLoginAccess.description", comment: "Erro ao validar os dados no servidor") + erroAPI
                    let erro = NSError(domain: "TIAManager.login", code: 3, userInfo: ["mensagem":mensagem,"descricao":descricao])
                    //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(self,erro)
                    })
                    return
                }
                
                
                //Sucesso na requisição
                //Registra usuario logado
                self.usuario = usuario
                //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,nil)
                })
                
            })
            task.resume()
        })
    }
    
    
    
    // MARK: Metodos de manipulacao de FALTAS
    /**
    Busca as faltas do aluno autenticado no servidor e salva no banco de dados interno.
    Esta funcao eh assincrona, por isso realiza o envio de notificacoes assim que processa a requisicao
    */
    func atualizarFaltas(completionHandler:(TIAManager,NSError?)->()) {
        
        //Dispach para rodar requisição em paralelo e evitar travar interface do usuário
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            //Garante que o ping ja foi testado no servidor
            guard let usuarioOK = self.usuario else {
                let mensagem = NSLocalizedString("errorLoginValidate.text", comment: "Erro ao validar os dados")
                let descricao = NSLocalizedString("errorLoginValidate.description", comment: "Erro ao validar os dados")
                let erro = NSError(domain: "TIAManager.atualizarFaltas", code: 1, userInfo: ["mensagem":mensagem,"descricao":descricao])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
                return
            }
            
            let request = self.criarRequisicao(ConfigHelper.sharedInstance.faltasURL, usuario: usuarioOK)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                print("Erro: \(error)")
                
                //Verifica se ocorreu erro
                guard error == nil else {
                    let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro na requisição")
                    let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro na requisição") + error!.description
                    let erro = NSError(domain: "TIAManager.atualizarFaltas", code: 2, userInfo: ["mensagem":mensagem,"descricao":descricao])
                    //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(self,erro)
                    })
                    return
                }
                
                guard let _ = Falta.parseJSON(data!) else {
                    
                    var resp:NSDictionary?
                    do {
                        resp = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    } catch {
                        print(error)
                    }
                    
                    //Servidor respondeu mas em um formato não esperado
                    guard let resposta = resp else {
                        let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro no retorno da requisição")
                        let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro no retorno da requisição")
                        let erro = NSError(domain: "TIAManager.atualizarFaltas", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }
                    
                    //O servidor indicou um erro nos parâmetros da requisição
                    guard let erroAPI = resposta.objectForKey("erro") as? String else {
                        //O conteudo retornado não está no formato esperado
                        let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro no retorno da requisição")
                        let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro no retorno da requisição")
                        let erro = NSError(domain: "TIAManager.atualizarFaltas", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }
                    
                    let mensagem = NSLocalizedString("errorLoginAccess.text", comment: "Erro ao validar os dados no servidor")
                    let descricao = NSLocalizedString("errorLoginAccess.description", comment: "Erro ao validar os dados no servidor") + erroAPI
                    let erro = NSError(domain: "TIAManager.atualizarFaltas", code: 3, userInfo: ["mensagem":mensagem,"descricao":descricao])
                    //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(self,erro)
                    })
                    return
                }
                
                //Sucesso na requisição
                //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,nil)
                })
                
            })
            task.resume()
        })
    }
    
    
    
    
    // MARK: Metodos de manipulacao de NOTAS
    /**
    Busca as notas do aluno autenticado no servidor e salva no banco de dados interno.
    Esta funcao eh assincrona, por isso realiza o envio de notificacoes assim que processa a requisicao
    */
    func atualizarNotas(completionHandler:(TIAManager,NSError?) -> ()) {
        
        //Dispach para rodar requisição em paralelo e evitar travar interface do usuário
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            
            //Garante que o ping ja foi testado no servidor
            guard let usuarioOK = self.usuario else {
                let mensagem = NSLocalizedString("errorLoginValidate.text", comment: "Erro ao validar os dados")
                let descricao = NSLocalizedString("errorLoginValidate.description", comment: "Erro ao validar os dados")
                let erro = NSError(domain: "TIAManager.atualizarNotas", code: 1, userInfo: ["mensagem":mensagem,"descricao":descricao])
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,erro)
                })
                return
            }
            
            let request = self.criarRequisicao(ConfigHelper.sharedInstance.notasURL, usuario: usuarioOK)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                print("Erro: \(error)")
                
                //Verifica se ocorreu erro
                guard error == nil else {
                    let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro na requisição")
                    let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro na requisição") + error!.description
                    let erro = NSError(domain: "TIAManager.atualizarNotas", code: 2, userInfo: ["mensagem":mensagem,"descricao":descricao])
                    //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(self,erro)
                    })
                    return
                }
                
                guard let _ = Nota.parseJSON(data!) else {
                    var resp:NSDictionary?
                    do {
                        resp = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    } catch {
                        print(error)
                    }
                    
                    //Servidor respondeu mas em um formato não esperado
                    guard let resposta = resp else {
                        let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro no retorno da requisição")
                        let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro no retorno da requisição")
                        let erro = NSError(domain: "TIAManager.atualizarNotas", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }
                    
                    //O servidor indicou um erro nos parâmetros da requisição
                    guard let erroAPI = resposta.objectForKey("erro") as? String else {
                        //O conteudo retornado não está no formato esperado
                        let mensagem = NSLocalizedString("errorLoginServer.text", comment: "Erro no retorno da requisição")
                        let descricao = NSLocalizedString("errorLoginServer.description", comment: "Erro no retorno da requisição")
                        let erro = NSError(domain: "TIAManager.atualizarNotas", code: 4, userInfo: ["mensagem":mensagem,"descricao":descricao])
                        //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(self,erro)
                        })
                        return
                    }
                    
                    let mensagem = NSLocalizedString("errorLoginAccess.text", comment: "Erro ao validar os dados no servidor")
                    let descricao = NSLocalizedString("errorLoginAccess.description", comment: "Erro ao validar os dados no servidor") + erroAPI
                    let erro = NSError(domain: "TIAManager.atualizarNotas", code: 3, userInfo: ["mensagem":mensagem,"descricao":descricao])
                    //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completionHandler(self,erro)
                    })
                    return
                }
                
                //Sucesso da Requisição
                //Executa o completionHandler na thread principal para não ter problema com atualizações em interface gráfica
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(self,nil)
                })
                
            })
            task.resume()
        })
    }
    
    // Obter dados do banco
    func faltas() -> [Falta] {
        return Falta.buscarFaltas()
    }
    
    func notas() -> [Nota] {
        return Nota.buscarNotas()
    }
}
