//
//  HorarioSemanalViewController.swift
//  MackTIA
//
//  Created by joaquim on 24/09/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

class HorarioSemanalViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leftButton: UIBarButtonItem!
    @IBOutlet weak var rightButton: UIBarButtonItem!
    let weekDays:[String] = ["SEGUNDA-FEIRA", "TERÇA-FEIRA", "QUARTA-FEIRA", "QUINTA-FEIRA", "SEXTA-FEIRA", "SÁBADO"]
    let weekDaysInt:[Int] = [2,3,4,5,6,7]
    var currentWeekDay:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        instantiateWeekdays()
        
        //Swipe Config
        let swipeGRLeft = UISwipeGestureRecognizer(target: self, action: "navigateLeft:")
        swipeGRLeft.direction = UISwipeGestureRecognizerDirection.Right
        self.scrollView.addGestureRecognizer(swipeGRLeft)
        
        let swipeGRRight = UISwipeGestureRecognizer(target: self, action: "navigateRight:")
        swipeGRRight.direction = UISwipeGestureRecognizerDirection.Left
        self.scrollView.addGestureRecognizer(swipeGRRight)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func instantiateWeekdays() {
        
        var scrollContentViews:[UIView] = []
        for i in 0...weekDays.count-1 {
            let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("HorarioDiaDaSemanaTableViewController") as! HorarioDiaDaSemanaTableViewController
            self.addChildViewController(viewController)
            
            viewController.weekDay = weekDays[i]
            viewController.weekDayInt = weekDaysInt[i]
            
            let theSubview = viewController.view
            theSubview.translatesAutoresizingMaskIntoConstraints = false
            
            scrollView.addSubview(viewController.view)
            
            let we =  NSLayoutConstraint(item: theSubview, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1.0, constant: 0)
            let he =  NSLayoutConstraint(item: theSubview, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1.0, constant: 0)
            let td =  NSLayoutConstraint(item: theSubview, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1.0, constant: 0)
            view.addConstraints([we, he])
            scrollView.addConstraint(td)
            
            if i > 0 {
                let ld = NSLayoutConstraint(item: theSubview, attribute: .Left, relatedBy: .Equal, toItem: scrollContentViews[i-1], attribute: .Right, multiplier: 1.0, constant: 0)
                scrollView.addConstraint(ld)
            }
            
            scrollContentViews.append(theSubview)
        }
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: true)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        currentWeekDay = Int(floor(scrollView.contentOffset.x / scrollView.frame.width))
        if currentWeekDay < 0 { return }
        self.navigationItem.title = weekDays[currentWeekDay]
    }
    
    @IBAction func navigateLeft(sender: AnyObject) {
        if currentWeekDay > 0 {
            let contentOffsetX = scrollView.contentOffset.x - scrollView.frame.width
            self.rightButton.enabled = false
            self.leftButton.enabled = false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: false)
                }, completion: { (_) -> Void in
                    self.rightButton.enabled = true
                    self.leftButton.enabled = true
            })
        }
    }
    
    
    @IBAction func navigateRight(sender: AnyObject) {
        if currentWeekDay < weekDays.count - 1 {
            let contentOffsetX = scrollView.contentOffset.x + scrollView.frame.width
            self.rightButton.enabled = false
            self.leftButton.enabled = false
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: false)
                }, completion: { (_) -> Void in
                    self.rightButton.enabled = true
                    self.leftButton.enabled = true
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
