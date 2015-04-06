//
//  ViewController.m
//  RCLocationManager_SampleProject
//
//  Created by Ricardo Caballero Moral on 04/08/12.
//  Copyright (c) 2012 Ricardo Caballero. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"

@interface ViewController () <RCLocationManagerDelegate, MKMapViewDelegate>
{
    RCLocationManager *locationManager;
}

- (IBAction)addRegion:(id)sender;

@end

@implementation ViewController

@synthesize mapView = _mapView;
@synthesize infoBox = _infoBox;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.infoBox.layer.cornerRadius = 6;

    // Create location manager with filters set for battery efficiency.
    locationManager = [[RCLocationManager alloc] initWithUserDistanceFilter:kCLLocationAccuracyHundredMeters userDesiredAccuracy:kCLLocationAccuracyBest purpose:@"My custom purpose message" delegate:self];
    
    // Start updating location changes.
    [locationManager startUpdatingLocation];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [locationManager stopMonitoringAllRegions];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setInfoBox:nil];
    
    [locationManager stopUpdatingLocation];
    [locationManager stopMonitoringAllRegions];
    locationManager.delegate = nil;
    locationManager = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - MKMapViewDelegate

// Custom AnnotationView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if([annotation isKindOfClass:[RegionAnnotation class]]) {
		RegionAnnotation *currentAnnotation = (RegionAnnotation *)annotation;
		NSString *annotationIdentifier = [currentAnnotation title];
		RegionAnnotationView *regionView = (RegionAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
		
		if (!regionView) {
			regionView = [[RegionAnnotationView alloc] initWithAnnotation:annotation];
			regionView.map = self.mapView;
            
            // Create a button for the left callout accessory view of each annotation to remove the annotation and region being monitored.
			UIButton *removeRegionButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[removeRegionButton setFrame:CGRectMake(0., 0., 25., 25.)];
			[removeRegionButton setImage:[UIImage imageNamed:@"RemoveRegion"] forState:UIControlStateNormal];
			
			regionView.leftCalloutAccessoryView = removeRegionButton;
			
		} else {
			regionView.annotation = annotation;
			regionView.theAnnotation = annotation;
		}
		
		// Update or add the overlay displaying the radius of the region around the annotation.
		[regionView updateRadiusOverlay];
		
		return regionView;
	}
	
	return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
	if([overlay isKindOfClass:[MKCircle class]]) {
		// Create the view for the radius overlay.
		MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
		circleView.strokeColor = [UIColor purpleColor];
		circleView.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
		
		return circleView;
	}
	
	return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
	if([annotationView isKindOfClass:[RegionAnnotationView class]]) {
		RegionAnnotationView *regionView = (RegionAnnotationView *)annotationView;
		RegionAnnotation *regionAnnotation = (RegionAnnotation *)regionView.annotation;
		
		// If the annotation view is starting to be dragged, remove the overlay and stop monitoring the region.
		if (newState == MKAnnotationViewDragStateStarting) {
			[regionView removeRadiusOverlay];
			
			[locationManager stopMonitoringForRegion:regionAnnotation.region];
		}
		
		// Once the annotation view has been dragged and placed in a new location, update and add the overlay and begin monitoring the new region.
		if (oldState == MKAnnotationViewDragStateDragging && newState == MKAnnotationViewDragStateEnding) {
			[regionView updateRadiusOverlay];
			
			CLRegion *newRegion = [[CLRegion alloc] initCircularRegionWithCenter:regionAnnotation.coordinate radius:1000.0 identifier:[NSString stringWithFormat:@"%f, %f", regionAnnotation.coordinate.latitude, regionAnnotation.coordinate.longitude]];
			regionAnnotation.region = newRegion;
			
			[locationManager addRegionForMonitoring:newRegion desiredAccuracy:kCLLocationAccuracyBest];
		}
	}
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
	RegionAnnotationView *regionView = (RegionAnnotationView *)view;
	RegionAnnotation *regionAnnotation = (RegionAnnotation *)regionView.annotation;
	
	// Stop monitoring the region, remove the radius overlay, and finally remove the annotation from the map.
	[locationManager stopMonitoringForRegion:regionAnnotation.region];
	[regionView removeRadiusOverlay];
	[self.mapView removeAnnotation:regionAnnotation];
}

#pragma mark - RCLocationManagerDelegate

- (void)locationManager:(RCLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // Work around a bug in MapKit where user location is not initially zoomed to.
    if (oldLocation == nil) {
        MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 1500.0, 1500.0);
        [self.mapView setRegion:userLocation animated:YES];
    }
}

#pragma mark - IBAction's

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
        [locationManager addRegionForMonitoring:newRegion desiredAccuracy:kCLLocationAccuracyBest];
	}
	else {
		NSLog(@"Region monitoring is not available.");
	}}


@end
