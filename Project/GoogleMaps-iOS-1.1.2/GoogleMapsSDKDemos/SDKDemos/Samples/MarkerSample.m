#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>

@interface MarkerSample : UIViewController<GMSMapViewDelegate>
@end

@implementation MarkerSample {
  GMSMapView *mapView_;
  id<GMSMarker> sydneyMarker_;
  int count_;
}

+ (NSString *)description {
  return @"Markers";
}

+ (NSString *)notes {
  return @"Allows many markers to be added to a GMSMapView.";
}

- (void)loadView {
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-25.5605
                                                          longitude:133.605097
                                                               zoom:3];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.delegate = self;
  self.view = mapView_;

  // Create a master, 'Sydney' marker.
  GMSMarkerOptions *options = [GMSMarkerOptions options];
  options.position = CLLocationCoordinate2DMake(-33.85, 151.20);
  options.icon = [UIImage imageNamed:@"glow-marker"];
  options.title = @"Sydney!";
  sydneyMarker_ = [mapView_ addMarkerWithOptions:options];
  ++count_;

  // Create a right navigation item that adds more markers.
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                    target:self
                                                    action:@selector(didTapAddMarker)];
}

- (void)didTapAddMarker {
  for (int i = 0; i < 7; ++i) {
    float latitude = (((float)arc4random()/0x100000000)*180)-90.f;
    float longitude = (((float)arc4random()/0x100000000)*360)-180.f;

    GMSMarkerOptions *options = [GMSMarkerOptions options];
    options.position = CLLocationCoordinate2DMake(latitude, longitude);
    options.title = [NSString stringWithFormat:@"#%d", count_];
    [mapView_ addMarkerWithOptions:options];
    ++count_;
  }
  NSLog(@"now have %d markers", count_);
}

#pragma mark - GMSMapViewDelegate

- (UIView *)mapView:(GMSMapView *)mapView
    markerInfoWindow:(id<GMSMarker>)marker {
  if (marker == sydneyMarker_) {
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
  }
  return nil;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker {
  if (marker != mapView_.selectedMarker) {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.125f];  // short animation

     mapView_.camera = [GMSCameraPosition cameraWithTarget:marker.position
                                                      zoom:10];
     [mapView_ animateToLocation:marker.position];
     [mapView_ animateToBearing:0];
     [mapView_ animateToViewingAngle:0];

     // If the highlight marker is selected, show it off.
     if (marker == sydneyMarker_) {
       [mapView_ animateToBearing:15];
       [mapView_ animateToViewingAngle:30];
     }

    [CATransaction commit];
  }
  return NO;
}

@end
