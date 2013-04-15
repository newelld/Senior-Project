#import <GoogleMaps/GoogleMaps.h>

@interface PolylineSample : UIViewController<GMSMapViewDelegate>
@end

@implementation PolylineSample {
  GMSMapView *mapView_;
  BOOL colorMode_;
}

+ (NSString *)description {
  return @"Polylines";
}

+ (NSString *)notes {
  return @"Tap anywhere to mark the spot.";
}

- (void)loadView {
  GMSCameraPosition *camera =
      [GMSCameraPosition cameraWithLatitude:-33.73 longitude:151.41 zoom:5];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.delegate = self;
  self.view = mapView_;

  // Force a 'refresh' of the polylines.
  [self didTapRefresh];

  // Changes the color mode of the initial diamond, and clears the map.
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                    target:self
                                                    action:@selector(didTapRefresh)];
}

- (void)didTapRefresh {
  [mapView_ clear];

  GMSPolylineOptions *options;
  GMSMutablePath *path;

  double baseLat = -33.85;
  double baseLong = 151.20;
  double offset = 4.5;

  colorMode_ = !colorMode_;
  UIColor *firstColor = colorMode_ ? [UIColor greenColor] : [UIColor redColor];
  UIColor *secondColor = colorMode_ ? [UIColor redColor] : [UIColor greenColor];

  // Bottom left.
  options = [GMSPolylineOptions options];
  path = [GMSMutablePath path];
  [path addCoordinate:CLLocationCoordinate2DMake(baseLat - offset, baseLong)];
  [path addCoordinate:CLLocationCoordinate2DMake(baseLat, baseLong - offset)];
  options.path = path;
  options.color = firstColor;
  options.width = 10.f;
  [mapView_ addPolylineWithOptions:options];

  // Top right.
  options = [GMSPolylineOptions options];
  path = [GMSMutablePath path];
  [path addCoordinate:CLLocationCoordinate2DMake(baseLat + offset, baseLong)];
  [path addCoordinate:CLLocationCoordinate2DMake(baseLat, baseLong + offset)];
  options.path = path;
  options.color = firstColor;
  options.width = 10.f;
  [mapView_ addPolylineWithOptions:options];

  // Top left.
  options = [GMSPolylineOptions options];
  path = [GMSMutablePath path];
  [path addCoordinate:CLLocationCoordinate2DMake(baseLat + offset, baseLong)];
  [path addCoordinate:CLLocationCoordinate2DMake(baseLat, baseLong - offset)];
  options.path = path;
  options.color = secondColor;
  options.width = 10.f;
  [mapView_ addPolylineWithOptions:options];

  // Bottom right.
  options = [GMSPolylineOptions options];
  path = [GMSMutablePath path];
  [path addCoordinate:CLLocationCoordinate2DMake(baseLat - offset, baseLong)];
  [path addCoordinate:CLLocationCoordinate2DMake(baseLat, baseLong + offset)];
  options.path = path;
  options.color = secondColor;
  options.width = 10.f;
  [mapView_ addPolylineWithOptions:options];
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
    didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
  // X marks the spot!
  GMSPolylineOptions *options;
  GMSMutablePath *path;

  // Try to scale the X based on the vertical coordinate.
  double scale = 1 - (fabs(coordinate.latitude) / 180.f);
  double offset = 1.f * scale * scale;

  options = [GMSPolylineOptions options];
  path = [GMSMutablePath path];
  options.color = [UIColor redColor];
  options.width = 4.f;
  [path addCoordinate:CLLocationCoordinate2DMake(coordinate.latitude - offset,
                                                coordinate.longitude - 1.f)];
  [path addCoordinate:CLLocationCoordinate2DMake(coordinate.latitude + offset,
                                                coordinate.longitude + 1.f)];
  options.path = path;
  [mapView addPolylineWithOptions:options];

  options = [GMSPolylineOptions options];
  path = [GMSMutablePath path];
  options.color = [UIColor redColor];
  options.width = 4.f;
  [path addCoordinate:CLLocationCoordinate2DMake(coordinate.latitude + offset,
                                                coordinate.longitude - 1.f)];
  [path addCoordinate:CLLocationCoordinate2DMake(coordinate.latitude - offset,
                                                coordinate.longitude + 1.f)];
  options.path = path;
  [mapView addPolylineWithOptions:options];
}

@end
