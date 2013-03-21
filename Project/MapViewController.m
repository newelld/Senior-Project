#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation MapViewController{
    GMSMapView *mapView;
}
NSArray *data;

- (IBAction)getLocation{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.961329900896835 longitude:-85.88285207748413 zoom:12];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;

    
    //[mapView setUserTrackingMode:MKUserTrackingModeFollow animated: YES ];
    
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"DataFile" ofType:@"plist"];
    data = [[NSArray alloc]initWithContentsOfFile:mylist];
    NSInteger count = [data count];
    NSLog(@"%@", data);
    
    CLLocationCoordinate2D coordinate;
    //MKPointAnnotation *annotation;
    
    GMSMarkerOptions *locations = [[GMSMarkerOptions alloc] init];
    //NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    
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
            //locations.snippet = @"Australia";
            
            //annotation = [[MKPointAnnotation alloc] init];
            //coordinate.latitude = [x doubleValue];
            //coordinate.longitude = [y doubleValue];
            //[annotation setCoordinate:coordinate];
            //[annotation setTitle:[[data objectAtIndex:i]objectForKey:@"Building Name"]];
            
            [mapView addMarkerWithOptions:locations];
            //[locations addObject:annotation];
        }
    }
    
    
    //[self.mapView addAnnotations:locations];
}

- (IBAction)setMap:(id)sender{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            //mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            //mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
           // mapView.mapType = MKMapTypeHybrid;
            break;
            
    }
}

//@synthesize mapView;

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
    mapView.myLocationEnabled = YES;
    //mapView.showsUserLocation = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end