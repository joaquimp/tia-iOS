//
//  MapaViewController.h
//  MACK
//
//  Created by Lucas Salton Cardinali on 2/7/14.
//  Copyright (c) 2014 Lucas Salton Cardinali. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface MapaViewController : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate> {
    CLLocationCoordinate2D myNorthEast, mySouthWest;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
