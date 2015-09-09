//
//  MaisContainerViewController.swift
//  MackTIA
//
//  Created by joaquim on 08/09/15.
//  Copyright (c) 2015 Mackenzie. All rights reserved.
//

import UIKit

class MaisContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("tia")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("senha")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("unidade")
        self.performSegueWithIdentifier("logoutSegue", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
