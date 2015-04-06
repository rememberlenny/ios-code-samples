//
//  ViewController.h
//  RCLocationManager_SampleProject
//
//  Created by Ricardo Caballero Moral on 04/08/12.
//  Copyright (c) 2012 Ricardo Caballero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "RegionAnnotation.h"
#import "RegionAnnotationView.h"

#import "RCLocationManager.h"

@interface ViewController : UIViewController

@property (nonatomic, assign) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *infoBox;;

@end
