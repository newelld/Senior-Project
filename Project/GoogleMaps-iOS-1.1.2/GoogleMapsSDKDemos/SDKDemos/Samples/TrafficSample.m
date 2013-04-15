#import <GoogleMaps/GoogleMaps.h>

@interface TrafficSample : UIViewController
@end

@implementation TrafficSample {
  GMSMapView *mapView_;
}

+ (NSString *)description {
  return @"Traffic";
}

+ (NSString *)notes {
  return @"Shows traffic data around your location, or a default location.";
}

- (void)loadView {
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-25.5605
                                                          longitude:133.605097
                                                               zoom:3];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  self.view = mapView_;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  mapView_.myLocationEnabled = YES;

  // Observe the current location, as to track it with the camera.
  [mapView_ addObserver:self
                 forKeyPath:@"myLocation"
                    options:NSKeyValueObservingOptionNew
                    context:NULL];
  
  NSLog(@"Waiting for first location update (or ~2 sec) to enable traffic.");
  [NSTimer scheduledTimerWithTimeInterval:2
                                   target:self
                                 selector:@selector(defaultEnableTraffic)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)dealloc {
  [mapView_ removeObserver:self forKeyPath:@"myLocation"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:@"myLocation"]) {
    [self enableTrafficAtLocation:mapView_.myLocation.coordinate];
  }
}

- (void)defaultEnableTraffic {
  if (mapView_.trafficEnabled == NO) {
    [self enableTrafficAtLocation:CLLocationCoordinate2DMake(37.786191, -122.391315)];
  }
}

- (void)enableTrafficAtLocation:(CLLocationCoordinate2D)location {
  [mapView_ animateToLocation:location];
  [mapView_ animateToZoom:14];
  [mapView_ animateToBearing:30];
  [mapView_ animateToViewingAngle:15];
  mapView_.trafficEnabled = YES;
}

@end
