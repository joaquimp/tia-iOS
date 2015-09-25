//
//  HorariaDiaDaSemanaTableViewController.swift
//  MackTIA
//
//  Created by joaquim on 24/09/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

class HorariaDiaDaSemanaTableViewController: UITableViewController {

    var classesList:[Horario] = []
    var weekDay:String?
    
    var selectedCellIndexPath:NSIndexPath?
    
    let selectedCellHeight:CGFloat = 200
    let unSelectedCellHeight:CGFloat = 57
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        getSchedule()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSchedule() {
        for _ in 0...4 {
            let newClass = Horario()
            newClass.disciplina = "Em construção ;)"
            newClass.local = "Prédio RW - Sala 102"
            classesList.append(newClass)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("horarioCell") as! HorarioTableViewCell
        
        let currentClass = classesList[indexPath.row]
        cell.nomeDisciplina.text = currentClass.disciplina
        cell.localDaAula.text = currentClass.local
        cell.horarioAula.text = "18h30 - 20h05"
        cell.anotacoesDisciplina.text = "Você pode editar esta anotação"
        
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}