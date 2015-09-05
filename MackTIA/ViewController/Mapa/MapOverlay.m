//
//  MapOverlay.m
//  MACK
//
//  Created by Lucas Salton Cardinali on 2/7/14.
//  Copyright (c) 2014 Lucas Salton Cardinali. All rights reserved.
//

#import "MapOverlay.h"

@implementation MapOverlay


-(CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(-23.549369,-46.652294);
}

- (MKMapRect)boundingMapRect
{
    
    MKMapPoint upperLeft   = MKMapPointForCoordinate(CLLocationCoordinate2DMake(-23.546050  ,-46.652250));
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, 3750, 3200);
    return bounds;
}


@end
