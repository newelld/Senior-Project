//
//  gvsuClosestViewController.m
//  Philanthropy
//
//  Created by Thomas Peterson on 3/23/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "gvsuClosestViewController.h"

@interface gvsuClosestViewController ()
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSDictionary *building;
@end

@implementation gvsuClosestViewController
@synthesize data;
@synthesize building;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	clController = [[gvsuCLController alloc] init];
	clController.delegate = self;
    [clController.locationManager startMonitoringSignificantLocationChanges];
    
    
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"DataFile" ofType:@"plist"];
    data = [[NSArray alloc]initWithContentsOfFile:mylist];
    [self closestBuilding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)locationUpdate:(CLLocation *)location {
	//locationLabel.text = [location description];
    locationLabel.text = [building valueForKey:@"Building Name"];
}

- (void)locationError:(NSError *)error {
	locationLabel.text = [error description];
}

- (void)closestBuilding {
    CLLocationDistance shortestDistance = DBL_MAX;
    NSDictionary *closestBuilding;
    for (NSDictionary *currentBuilding in data){
        NSString *full_coords = [currentBuilding valueForKey:@"GPS Coordinates"];
        NSArray *deliminated_coords = [full_coords componentsSeparatedByString:@","];
        if([deliminated_coords count] > 1)
        {
            NSString *x = deliminated_coords[0];
            NSString *y = deliminated_coords[1];
        
            CLLocation *locA = [[CLLocation alloc] initWithLatitude:[x doubleValue] longitude:[y doubleValue]];
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:clController.locationManager.location.coordinate.latitude longitude:clController.locationManager.location.coordinate.longitude];
            CLLocationDistance distance = [locA distanceFromLocation:locB];
            if (distance < shortestDistance) {
                shortestDistance = distance;
                closestBuilding = currentBuilding;
            }
        }
    }
    building = closestBuilding;
}

@end
