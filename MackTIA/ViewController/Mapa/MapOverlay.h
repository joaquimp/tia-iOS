//
//  MapOverlay.h
//  MACK
//
//  Created by Lucas Salton Cardinali on 2/7/14.
//  Copyright (c) 2014 Lucas Salton Cardinali. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapOverlay : NSObject <MKOverlay>

- (MKMapRect)boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@end
