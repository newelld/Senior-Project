//
//  gvsuCLController.m
//  Philanthropy
//
//  Created by Thomas Peterson on 3/23/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "gvsuCLController.h"

@implementation gvsuCLController

@synthesize locationManager;
@synthesize  delegate;

- (id) init {
	self = [super init];
	if (self != nil) {
		self.locationManager = [[CLLocationManager alloc] init];
		self.locationManager.delegate = self; // send loc updates to myself
	}
	return self;
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	[self.delegate locationUpdate:newLocation];
}


- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[self.delegate locationError:error];
}

- (void)dealloc {

}

@end