//
//  MapOverlayView.m
//  MACK
//
//  Created by Lucas Salton Cardinali on 2/7/14.
//  Copyright (c) 2014 Lucas Salton Cardinali. All rights reserved.
//

#import "MapOverlayView.h"
#import "MapOverlay.h"

@implementation MapOverlayView

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx
{
    
    UIImage *image = [UIImage imageNamed:@"MapaOverlay"];
    CGImageRef imageReference = image.CGImage;
    
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
    
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -theRect.size.height);
    CGContextRotateCTM (ctx, 0.52);
    CGContextDrawImage(ctx, theRect, imageReference);
 
}

@end
