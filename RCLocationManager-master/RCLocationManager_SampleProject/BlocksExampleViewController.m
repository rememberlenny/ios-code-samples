//
//  BlocksExampleViewController.m
//  RCLocationManager_SampleProject
//
//  Created by Alejandro Martinez on 27/08/12.
//  Copyright (c) 2012 Ricardo Caballero. All rights reserved.
//

#import "BlocksExampleViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BlocksExampleViewController ()

@end

@implementation BlocksExampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.infoBox.layer.cornerRadius = 6;
    
    // Create location manager with filters set for battery efficiency.
    RCLocationManager *locationManager = [RCLocationManager sharedManager];
    [locationManager setPurpose:@"My custom purpose message"];
    [locationManager setUserDistanceFilter:kCLLocationAccuracyHundredMeters];
    [locationManager setUserDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Start updating location changes.
    [locationManager startUpdatingLocationWithBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
        MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 10000.0, 10000.0);
        [self.mapView setRegion:userLocation animated:YES];
        
        NSLog(@"Updated location using block.");
    } errorBlock:^(CLLocationManager *manager, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[RCLocationManager sharedManager] stopMonitoringAllRegions];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setInfoBox:nil];
    
    [[RCLocationManager sharedManager] stopUpdatingLocation];
    [[RCLocationManager sharedManager] stopMonitoringAllRegions];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)addRegion:(id)sender
{
    if ([RCLocationManager regionMonitoringAvailable]) {
		// Create a new region based on the center of the map view.
		CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude);
		CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:coord
																	  radius:1000.0
																  identifier:[NSString stringWithFormat:@"%f, %f", self.mapView.centerCoordinate.latitude, self.mapView.centerCoordinate.longitude]];
		
		// Create an annotation to show where the region is located on the map.
		RegionAnnotation *myRegionAnnotation = [[RegionAnnotation alloc] initWithCLRegion:newRegion];
		myRegionAnnotation.coordinate = newRegion.center;
		myRegionAnnotation.radius = newRegion.radius;
		
		[self.mapView addAnnotation:myRegionAnnotation];
		
		
		// Start monitoring the newly created region.
        [[RCLocationManager sharedManager] addRegionForMonitoring:newRegion desiredAccuracy:kCLLocationAccuracyBest updateBlock:^(CLLocationManager *manager, CLRegion *region, BOOL enter) {
            if (enter) {
                NSLog(@"Enter to region %@", region);
            } else {
                NSLog(@"Exit from region %@", region);
            }
        } errorBlock:^(CLLocationManager *manager, CLRegion *region, NSError *error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }];
	}
	else {
		NSLog(@"Region monitoring is not available.");
	}
}


@end
