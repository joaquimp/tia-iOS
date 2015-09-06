//
//  NotasTableViewController.swift
//  MackTIA
//
//  Created by Joaquim Pessôa Filho on 9/5/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//


import UIKit

class NotasTableViewController: UITableViewController {
    
    var notas:Array<Nota> = TIAManager.sharedInstance.todasNotas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notasErro:", name: TIAManager.NotasErroNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "novasNotas", name: TIAManager.NotasRecuperadasNotification, object: nil)
        TIAManager.sharedInstance.atualizarNotas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Metodos da Notificacao
    
    func novasNotas() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.notas = TIAManager.sharedInstance.todasNotas()
            self.tableView.reloadData()
        })
    }
    
    func notasErro(notification:NSNotification){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let let dict = notification.userInfo as? Dictionary<String,String> {
                let alert = UIAlertView(title: "Acesso Negado", message: dict[TIAManager.DescricaoDoErro], delegate: self, cancelButtonTitle: "OK")
                alert.show()
            } else {
                let alert = UIAlertView(title: "Erro", message: "Não foi possível carregar as notas, entre em contato com o helpdesk se o erro persistir", delegate: self, cancelButtonTitle: "OK")
                alert.show()
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.notas.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notaCell", forIndexPath: indexPath) as! NotaTableViewCell
        cell.nota = self.notas[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
    }
        
}
