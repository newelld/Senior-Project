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
    
    CLLocationCoordinate2D coordinate;
    MKPointAnnotation *annotation;
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    
   // cell.textLabel.text = [[data objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
   // cell.detailTextLabel.text = [[data objectAtIndex:indexPath.row]objectForKey:@"Campus"];
    
    
    for(int i = 0; i < [data count]; i++)
    {
        NSString *full_coords = [[data objectAtIndex:i]objectForKey:@"GPS Coordinates"];
        NSArray *delimated_coords = [full_coords componentsSeparatedByString:@","];;
        NSString *x = delimated_coords[0];
        NSString *y = delimated_coords[1];
        
        annotation = [[MKPointAnnotation alloc] init];
        coordinate.latitude = [x doubleValue];
        coordinate.longitude = [y doubleValue];
        [annotation setCoordinate:coordinate];
        [annotation setTitle:[names objectAtIndex:i]];
    
        [locations addObject:annotation];
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
    
    //Grabbing the data from the PLIST
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"DataFile" ofType:@"plist"];
    data = [[NSArray alloc]initWithContentsOfFile:mylist];
    NSLog(@"%@", data);

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
