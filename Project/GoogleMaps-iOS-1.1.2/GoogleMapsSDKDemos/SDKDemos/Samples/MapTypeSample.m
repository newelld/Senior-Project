#import <GoogleMaps/GoogleMaps.h>

static NSString const * kNormalType = @"Normal";
static NSString const * kSatelliteType = @"Satellite";
static NSString const * kHybridType = @"Hybrid";
static NSString const * kTerrainType = @"Terrain";

@interface LayersSample : UIViewController
@end

@implementation LayersSample {
  UISegmentedControl *switcher_;
  GMSMapView *mapView_;
}

+ (NSString *)description {
  return @"Map Types";
}

- (void)loadView {
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-25.5605
                                                          longitude:133.605097
                                                               zoom:3];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  self.view = mapView_;
}

- (void)viewDidLoad {
  // The possible different types to show.
  NSArray *types = @[ kNormalType, kSatelliteType, kHybridType, kTerrainType ];

  // Create a UISegmentedControl that is the navigationItem's titleView.
  switcher_ = [[UISegmentedControl alloc] initWithItems:types];
  switcher_.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
      UIViewAutoresizingFlexibleWidth |
      UIViewAutoresizingFlexibleBottomMargin;
  switcher_.selectedSegmentIndex = 0;
  switcher_.segmentedControlStyle = UISegmentedControlStyleBar;
  self.navigationItem.titleView = switcher_;

  // Listen to touch events on the UISegmentedControl.
  [switcher_ addTarget:self action:@selector(didChangeSwitcher)
      forControlEvents:UIControlEventValueChanged];
}

- (void)didChangeSwitcher {
  // Switch to the type clicked on.
  NSString *title =
      [switcher_ titleForSegmentAtIndex:switcher_.selectedSegmentIndex];
  if ([kNormalType isEqualToString:title]) {
    mapView_.mapType = kGMSTypeNormal;
  } else if ([kSatelliteType isEqualToString:title]) {
    mapView_.mapType = kGMSTypeSatellite;
  } else if ([kHybridType isEqualToString:title]) {
    mapView_.mapType = kGMSTypeHybrid;
  } else if ([kTerrainType isEqualToString:title]) {
    mapView_.mapType = kGMSTypeTerrain;
  }
}

@end
