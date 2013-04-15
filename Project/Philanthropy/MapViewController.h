//
//  MyMapViewController.h
//  Philanthropy
//
//  Created by Nickolas Workman on 4/8/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface MapViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate>

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *currentLocation;

- (IBAction)getLocation;
//- (IBAction)setMap:(id)sender;
-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker;
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(id<GMSMarker>)marker;
//- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(id<GMSMarker>)marker;
@end
