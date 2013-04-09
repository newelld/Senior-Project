//
//  MyMapViewController.h
//  Philanthropy
//
//  Created by Nickolas Workman on 4/8/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
@interface MyMapViewController : UIViewController

- (IBAction)getLocation;
- (IBAction)setMap:(id)sender;
- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(id<GMSMarker>)marker;
@end
