#import <GoogleMaps/GoogleMaps.h>

@interface GroundOverlaySample : UIViewController
@end

@implementation GroundOverlaySample {
  GMSGroundOverlayOptions *options_;
  id<GMSGroundOverlay> overlay_;
}

+ (NSString *)description {
  return @"Ground Overlays";
}

- (void)loadView {
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-25.5605
                                                          longitude:133.605097
                                                               zoom:3];
  GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  self.view = mapView;

  // Create a custom Ground Overlay.
  options_ = [GMSGroundOverlayOptions options];
  options_.icon = [UIImage imageNamed:@"australia_large.png"];
  options_.position = CLLocationCoordinate2DMake(-27.644606, 133.76294);
  options_.bearing = 0.f;
  options_.zoomLevel = 4;
  overlay_ = [mapView addGroundOverlayWithOptions:options_];

  // Call rotateOverlay thirty times a second.
  [NSTimer scheduledTimerWithTimeInterval:(1.f/30.f)
                                   target:self
                                 selector:@selector(rotateOverlay)
                                 userInfo:nil
                                  repeats:YES];
}

#pragma mark - Private methods

- (void)rotateOverlay {
  overlay_.bearing += 2.f;
  if (overlay_.bearing > 360.f) {
    overlay_.bearing -= 360.f;
  }
}

@end