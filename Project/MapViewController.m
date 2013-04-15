//
//  MyMapViewController.m
//  Philanthropy
//
//  Created by Nickolas Workman on 4/8/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "MapViewController.h"
#import "ClosestDetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation MapViewController{
    GMSMapView *mapView;
    id<GMSMarker> marker;
}
NSArray *data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Map";
        self.tabBarItem.title = @"Map";
        self.tabBarItem.image = [UIImage imageNamed:@"map.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self getLocation];
    mapView.myLocationEnabled = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getLocation{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.961329900896835 longitude:-85.88285207748413 zoom:15];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //mapView.delegate = self;
    self.view = mapView;
    //[mapView animateToCameraPosition:camera];
    //[mapView setUserTrackingMode:MKUserTrackingModeFollow animated: YES ];
    
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"Senior Project Data" ofType:@"plist"];
    data = [[NSArray alloc]initWithContentsOfFile:mylist];
    NSInteger count = [data count];
    NSLog(@"%@", data);
    
    GMSMarkerOptions *locations = [[GMSMarkerOptions alloc] init];
    
    for(int i = 0; i < count; i++)
    {
        NSString *full_coords = [[data objectAtIndex:i]objectForKey:@"GPS Coordinates"];
        NSArray *deliminated_coords = [full_coords componentsSeparatedByString:@","];
        
        if([deliminated_coords count] > 1)
        {
            NSString *x = deliminated_coords[0];
            NSString *y = deliminated_coords[1];
            locations.position = CLLocationCoordinate2DMake([x doubleValue], [y doubleValue]);
            locations.title = [[data objectAtIndex:i]objectForKey:@"Building Name"];
            [mapView addMarkerWithOptions:locations];
        }
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker {
    NSString *title = marker.title;
    if (title != nil) {
        //NSLog(@"%@", title);
    }
    return NO;
}

-(void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(id<GMSMarker>)marker
{
    NSString* title = marker.title;
    for (NSDictionary *building in data)
    {
        NSString *string = [building valueForKey:@"Building Name"];
        if ([string isEqualToString:title])
        {
            ClosestDetailViewController *detail = [[ClosestDetailViewController alloc]
                                                   initWithNibName:@"ClosestDetailViewController" bundle:nil];
            detail.building = [building objectForKey:@"Building Name"];
            detail.donorPic1 = [building objectForKey:@"Donor Image 1"];
            detail.donorPic2 = [building objectForKey:@"Donor Image 2"];
            detail.campus = [building objectForKey:@"Campus"];
            detail.donorName1 = [building objectForKey:@"Donor Name 1"];
            detail.donorName2 = [building objectForKey:@"Donor Name 2"];
            detail.description1 = [building objectForKey:@"Building Description 1"];
            detail.description2 = [building objectForKey:@"Building Description 2"];
            [self.navigationController pushViewController:detail animated:YES];
        }
    }
}

//- (IBAction)setMap:(id)sender{
//    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
//        case 0:
            //mapView.mapType = MKMapTypeStandard;
//            break;
//        case 1:
            //mapView.mapType = MKMapTypeSatellite;
//            break;
//        case 2:
            // mapView.mapType = MKMapTypeHybrid;
//            break;
            
//   }
//}
@end
