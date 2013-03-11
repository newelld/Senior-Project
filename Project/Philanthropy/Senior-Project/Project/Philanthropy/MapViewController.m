//
//  MapViewController.m
//  Philanthropy
//
//  Created by Nickolas Workman on 2/25/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//
 
#import "MapViewController.h"

@implementation MapViewController

- (IBAction)getLocation{
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated: YES ];
    
    NSArray *names = {[NSArray arrayWithObjects:
        @"Pew Campus",
        @"Cook-DeVos Center",
        @"L.V. Eberhard Center",
        @"Kennedy Hall of Engineering",
        @"Calder Fine Arts Center",
        @"Kliner Commons",
        @"Niemeyer Honors Hall",
        @"Seidman House",
        @"Zumberge Library",
        @"Henry Hall",
        nil]
    };
    
    NSArray *cords = {[NSArray arrayWithObjects:
        @"42.963589", @"-85.674575", /* Pew */
        @"42.97069996517887", @"-85.66144645214081", /* Cook DeVos */
        @"42.96407001707781", @"-85.67709445953369", /* L.V. Eberhard Center */
        @"42.96397580307465", @"-85.67788034677505", /* Kennendy Hall of Engineering */
        @"42.961329900896835", @"-85.88285207748413", /* Calder Fine Arts Center */
        @"42.96885118827063", @"-85.88569521903991", /* Kliner Commons */
        @"42.95986950259231", @"-85.88581323623657", /* Niemeyer Honors Hall */
        @"42.96217000679583", @"-85.88569521903991", /* Seidman House */
        @"42.96288840601213", @"-85.88691294193268", /* Zumberge Library */
        @"42.96469418120448", @"-85.88830232620239", /* Henery Hall */
        nil]
    };
    
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    CLLocationCoordinate2D coordinate;
    MKPointAnnotation *annotation;
    
    for(int i = 0; i< 10; i++)
    {
        annotation = [[MKPointAnnotation alloc] init];
        coordinate.latitude = [[cords objectAtIndex:i] doubleValue];
        coordinate.longitude = [[cords objectAtIndex:(i+1)] doubleValue];
        [annotation setCoordinate:coordinate];
        [annotation setTitle:[names objectAtIndex:i]];
    
        [locations addObject:annotation];
    }
    
    [self.mapView addAnnotations:locations];
    
    //CLLocationCoordinate2D coordinate;
    //coordinate.latitude = 42.963589;
    //coordinate.longitude = -85.674575;
    //Create Pin
    //MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    //[annotation setCoordinate:coordinate];
    //[annotation setTitle:@"MY HOUSE"];
    
    
    
    
    // ADD YOUR PIN TO THE MAP VIEW
    //[self.mapView addAnnotation:annotation];
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
