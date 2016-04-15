//
//  ProgressBarView.swift
//  MackTIA
//
//  Created by joaquim on 02/11/15.
//  Copyright © 2015 Mackenzie. All rights reserved.
//

import UIKit

@IBDesignable
class ProgressBarView: UIView {
    @IBInspectable
    var endPercent:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var maxPercent:CGFloat = 0.25{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var progressWidth:CGFloat = 10.0
    @IBInspectable
    var progressColor:UIColor = UIColor.yellowColor()
    @IBInspectable
    var progressBackgroundColor:UIColor = UIColor.blackColor()
    
    
    
    override func drawRect(rect: CGRect) {
        //Important constants for circle
        let start:CGPoint   = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))
        let end:CGPoint     = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect))
        
        var aux:CGFloat = endPercent
        if endPercent > maxPercent {
            aux = maxPercent
        }
        
        //Calculating end point of progress bar
        let space:CGFloat   = end.x - start.x
        let endProgress = CGPointMake((space * aux)/maxPercent, end.y)
        
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        
        //set line attributes
        CGContextSetLineWidth(context, progressWidth)
        CGContextSetLineCap(context, CGLineCap.Round)
        
        //make the line background
        CGContextSetStrokeColorWithColor(context, progressBackgroundColor.CGColor)
        CGContextMoveToPoint(context, start.x, start.y)
        CGContextAddLineToPoint(context, end.x, end.y)
        CGContextStrokePath(context)
        
        //make the progress
        CGContextSetStrokeColorWithColor(context, progressColor.CGColor)
        CGContextMoveToPoint(context, start.x, start.y)
        CGContextAddLineToPoint(context, endProgress.x, endProgress.y)
        CGContextStrokePath(context)
    }
    
}

