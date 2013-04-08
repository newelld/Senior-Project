//
//  gvsuCLController.h
//  Philanthropy
//
//  Created by Thomas Peterson on 3/23/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@protocol gvsuCLControllerDelegate <NSObject>
@required
- (void)locationDisplay:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end

@interface gvsuCLController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	__unsafe_unretained id delegate;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, assign) id <gvsuCLControllerDelegate> delegate;

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error;

@end