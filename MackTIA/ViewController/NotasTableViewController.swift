//
//  NotasTableViewController.swift
//  MackTIA
//
//  Created by Joaquim Pessôa Filho on 9/5/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//


import UIKit

class NotasTableViewController: UITableViewController {
    
    var notas:Array<Nota> = TIAManager.sharedInstance.notas
    @IBOutlet weak var reloadButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl!.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        if self.notas.count == 0 {
            self.buscarNovosDados()
        }
    }
    
    // MARK: - Atualizando dados
    func buscarNovosDados() {
        self.reloadButtonItem.enabled = false
        TIAManager.sharedInstance.atualizarNotas { (manager, error) -> () in
            if error != nil {
                var mensagem = "Erro desconhecido. Se persistir contact o helpdesk"
                if let info = error?.userInfo as? [String:String] {
                    if info["mensagem"] != nil {
                        mensagem = info["mensagem"]!
                        let descricao = info["descricao"]
                        println("Descricao do erro: \(descricao)")
                    }
                }
                let alert = UIAlertView(title: "Acesso Negado", message: mensagem, delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
            self.reloadButtonItem.enabled = true
            self.notas = manager.notas
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func reloadButton(sender: AnyObject) {
        self.buscarNovosDados()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        var delayInSeconds = 1.0;
        var popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.buscarNovosDados()
        }
    }
    
    // MARK: - Memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notas.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notaCell", forIndexPath: indexPath) as! NotaTableViewCell
        cell.nota = self.notas[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 218
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let date = NSUserDefaults.standardUserDefaults().objectForKey("notaAtualizacao") as? NSDate {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy - HH:mm"
            return NSLocalizedString("atualizacao.data", comment: "Não existe informação sobre atualização") + dateFormatter.stringFromDate(date)
        }
        
        return NSLocalizedString("atualizacaoNaoInformada", comment: "Não existe informação sobre atualização")
        
    }
        
}
