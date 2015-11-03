//
//  HorariaDiaDaSemanaTableViewController.swift
//  MackTIA
//
//  Created by joaquim on 24/09/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

class HorarioDiaDaSemanaTableViewController: UITableViewController {

    var classesList:[Horario] = []
    var weekDay:String?
    var weekDayInt:Int?
    var selectedCellIndexPath:NSIndexPath?
    let selectedCellHeight:CGFloat = 200
    let unSelectedCellHeight:CGFloat = 93//58
    var vazio = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(animated: Bool) {
        getSchedule()
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.selectedCellIndexPath != nil {
            let index = self.selectedCellIndexPath
            self.tableView.beginUpdates()
            self.tableView.selectRowAtIndexPath(index, animated: false, scrollPosition: UITableViewScrollPosition.None)
            self.tableView.endUpdates()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSchedule() {
        guard let wdi = weekDayInt else {
            return
        }
        classesList = TIAManager.sharedInstance.horariosDia(wdi)
        if classesList.count == 0 {
            TIAManager.sharedInstance.atualizarHorarios({ (manager, error) -> () in
                self.classesList = TIAManager.sharedInstance.horariosDia(wdi)
                self.tableView.reloadData()
            })
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if classesList.count == 0 {
            vazio = true
            return 1
        }
        vazio = false
        return classesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if vazio {
            let cell = tableView.dequeueReusableCellWithIdentifier("semAula")
            return cell!
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("horarioCell") as! HorarioTableViewCell
        
        let currentClass = classesList[indexPath.row]
        cell.horario = currentClass
        cell.mainTableView = self
        
        return cell
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath != self.selectedCellIndexPath {
            self.selectedCellIndexPath = indexPath
        } else {
            if let _ = self.selectedCellIndexPath {
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
    
    func editarHorarioAnotacao(horario:Horario){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("horarioAnotacaoViewController") as! HorarioAnotacaoViewController
        vc.horario = horario
        vc.acaoAoConfirmar = {
            self.tableView.reloadData()
//            let index = self.selectedCellIndexPath
//            self.tableView.beginUpdates()
//            self.tableView.deselectRowAtIndexPath(self.selectedCellIndexPath!, animated: false)
//            self.tableView.selectRowAtIndexPath(index, animated: false, scrollPosition: UITableViewScrollPosition.None)
//            self.tableView.endUpdates()
        }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}