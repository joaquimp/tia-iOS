//
//  MateriaTableViewController.swift
//  MackTIA
//
//  Created by Joaquim Pessôa Filho on 8/23/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit

class FaltasTableViewController: UITableViewController {
    
    var faltas:Array<Falta> = TIAManager.sharedInstance.faltas
    @IBOutlet weak var reloadButtonItem: UIBarButtonItem!
    
    //Controle para expandir TableViewCell
    var selectedCellIndexPath:NSIndexPath?
    let selectedCellHeight:CGFloat = 150
    let unSelectedCellHeight:CGFloat = 58
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.faltas.count == 0 {
            buscarNovosDados()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.selectRowAtIndexPath(self.selectedCellIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
    }
    
    // MARK: - Atualizando dados
    func buscarNovosDados() {
        
        self.reloadButtonItem.enabled = false
        
        TIAManager.sharedInstance.atualizarFaltas{ (manager, error) -> () in
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
            self.faltas = manager.faltas
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    
    @IBAction func reloadButton(sender: AnyObject) {
        buscarNovosDados()
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        var delayInSeconds = 0.5;
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
        return self.faltas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("faltaCell", forIndexPath: indexPath) as! FaltaTableViewCell
        cell.falta = self.faltas[indexPath.row]
        return cell
    }
    
    
    // MARK: - Expandir TableViewCell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath != self.selectedCellIndexPath {
            self.selectedCellIndexPath = indexPath
        } else {
            if let selectedCell = self.selectedCellIndexPath {
                self.tableView.deselectRowAtIndexPath(self.selectedCellIndexPath!, animated: true)
            }
            self.selectedCellIndexPath = nil
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.selectedCellIndexPath == indexPath {
            return self.selectedCellHeight
        }
        
        return self.unSelectedCellHeight
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // Remove seperator inset
        if cell.respondsToSelector(Selector("setSeparatorInset:")) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        
        // Prevent the cell from inheriting the Table View's margin settings
        if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) {
            cell.preservesSuperviewLayoutMargins = false
        }
        
        // Explictly set your cell's layout margins
        if cell.respondsToSelector(Selector("setLayoutMargins:")) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
    }
}
