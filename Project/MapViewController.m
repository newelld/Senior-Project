//
//  MapViewController.m
//  Philanthropy
//
//  Created by Nickolas Workman on 2/25/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "MapViewController.h"

@implementation MapViewController
NSArray *data;

- (IBAction)getLocation{
    mapView.showsUserLocation = YES;
    //mapView.delegate = self;
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated: YES ];
    
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"DataFile" ofType:@"plist"];
    data = [[NSArray alloc]initWithContentsOfFile:mylist];
    NSInteger count = [data count];
    NSLog(@"%@", data);
    
    CLLocationCoordinate2D coordinate;
    MKPointAnnotation *annotation;
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    
    for(int i = 0; i < count; i++)
    {
        NSString *full_coords = [[data objectAtIndex:i]objectForKey:@"GPS Coordinates"];
        NSArray *deliminated_coords = [full_coords componentsSeparatedByString:@","];
        
        if([deliminated_coords count] > 1)
        {        
            NSString *x = deliminated_coords[0];
            NSString *y = deliminated_coords[1];
            
            annotation = [[MKPointAnnotation alloc] init];
            coordinate.latitude = [x doubleValue];
            coordinate.longitude = [y doubleValue];
            [annotation setCoordinate:coordinate];
            [annotation setTitle:[[data objectAtIndex:i]objectForKey:@"Building Name"]];
        
            [locations addObject:annotation];
        }
    }
    
    [self.mapView addAnnotations:locations];
}

- (IBAction)setMap:(id)sender{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapView.mapType = MKMapTypeHybrid;
            break;
            
    }
}

@synthesize mapView;

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
    [self getLocation];
    mapView.showsUserLocation = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end