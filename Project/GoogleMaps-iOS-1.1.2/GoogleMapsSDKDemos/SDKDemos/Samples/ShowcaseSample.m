#import <GoogleMaps/GoogleMaps.h>

@interface ShowcaseSample : UIViewController<GMSMapViewDelegate>
@end

@implementation ShowcaseSample {
  GMSMapView *mapView_;
  GMSGeocoder *geocoder_;
  id<GMSMarker> australiaMarker_;
}

+ (NSString *)notes {
  return @"Showcases the Google Maps SDK for iOS, including custom markers, "
         @"polylines and the geocoder.";
}

- (id)init {
  if ((self = [super init])) {
    geocoder_ = [[GMSGeocoder alloc] init];
  }
  return self;
}

- (void)loadView {
  GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-25.5605
                                                          longitude:133.605097
                                                               zoom:3];
  mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
  mapView_.delegate = self;
  self.view = mapView_;

  mapView_.myLocationEnabled = YES;

  // Add a button allowing iteration through map types.
  self.navigationItem.rightBarButtonItem =
      [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                    target:self
                                                    action:@selector(didTapTypeButton)];


  // Add a large Australia custom marker, with an image that changes on tap.
  GMSMarkerOptions *options = [GMSMarkerOptions options];
  options.position = CLLocationCoordinate2DMake(-24.644606, 133.76294);
  options.groundAnchor = CGPointMake(0.5, 0.5);  // the center of the icon
  options.infoWindowAnchor = CGPointMake(0.25, 0.125);  // top left
  options.title = @"Australia";
  options.icon = [UIImage imageNamed:@"australia"];
  options.userData = @{
      @"default": options.icon,
      @"selected": [UIImage imageNamed:@"australia_large"]
  };
  australiaMarker_ = [mapView_ addMarkerWithOptions:options];

  // Add a 'normal' custom marker.
  options = [GMSMarkerOptions options];
  options.position = CLLocationCoordinate2DMake(-33.454, 151.314);
  options.title = @"Near Sydney";
  options.icon = [UIImage imageNamed:@"arrow"];
  [mapView_ addMarkerWithOptions:options];

  // Add Melbourne Airport.
  options = [GMSMarkerOptions options];
  options.position = CLLocationCoordinate2DMake(-37.673333, 144.843333);
  options.title = @"MEL \u2708";
  [mapView_ addMarkerWithOptions:options];

  // Add a demo polyline.
  [mapView_ addPolylineWithOptions:[ShowcaseSample NSWBorder]];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // Watch the selectedMarker, so icons can be changed dynamically.
  [mapView_ addObserver:self
                 forKeyPath:@"selectedMarker"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:NULL];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [mapView_ removeObserver:self forKeyPath:@"selectedMarker"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:@"selectedMarker"]) {
    id<GMSMarker> previous = change[NSKeyValueChangeOldKey];
    if ((id)previous != [NSNull null] && previous.userData) {
      previous.icon = [previous.userData valueForKey:@"default"];
    }

    id<GMSMarker> selected = mapView_.selectedMarker;
    if (selected != nil && selected.userData) {
      selected.icon = [selected.userData valueForKey:@"selected"];
    }
  }
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView
    didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
  // On a long press, reverse geocode this location.
  GMSReverseGeocodeCallback handler =
      ^(GMSReverseGeocodeResponse *response, NSError *error){
        if (response && response.firstResult) {
          GMSMarkerOptions *options = [GMSMarkerOptions options];
          options.position = coordinate;
          options.title = response.firstResult.addressLine1;
          options.snippet = response.firstResult.addressLine2;
          [mapView addMarkerWithOptions:options];
        } else {
          NSLog(@"Could not reverse geocode point (%f,%f): %@",
                coordinate.latitude, coordinate.longitude, error);
        }
      };
  [geocoder_ reverseGeocodeCoordinate:coordinate
                    completionHandler:handler];

}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(id<GMSMarker>)marker {
  if (marker != mapView.selectedMarker) {
    // This marker is about to become the selected marker; animate to it.
    [mapView animateToLocation:marker.position];
    [mapView animateToBearing:0];
    [mapView animateToViewingAngle:0];
  }
  return NO;  // the GMSMapView should handle this event normally
}

- (void)mapView:(GMSMapView *)mapView
    didTapInfoWindowOfMarker:(id<GMSMarker>)marker {
  if (marker == australiaMarker_) {
    if (![australiaMarker_.snippet length]) {
      australiaMarker_.snippet = @"Quit poking me!";
    } else {
      australiaMarker_.snippet = nil;
    }
  }
}

#pragma mark - Private methods

- (void)didTapTypeButton {
  GMSMapViewType nextType;
  switch (mapView_.mapType) {
    case kGMSTypeNormal:
      nextType = kGMSTypeSatellite;
      break;
    case kGMSTypeSatellite:
      nextType = kGMSTypeTerrain;
      break;
    case kGMSTypeTerrain:
      nextType = kGMSTypeHybrid;
      break;
    case kGMSTypeHybrid:
      nextType = kGMSTypeNormal;
      break;
  }
  mapView_.mapType = nextType;
}

// Returns a semi-transparent polyline options describing the border of the
// state of NSW, Australia.
+ (GMSPolylineOptions *)NSWBorder {
  GMSPolylineOptions *border = [GMSPolylineOptions options];
  border.color = [UIColor colorWithRed:0.0f
                                 green:0.0f
                                  blue:1.0f
                                 alpha:0.5f];
  border.width = 3;
  border.accessibilityLabel = @"NSW";

  GMSMutablePath *path = [GMSMutablePath path];
  [path addCoordinate:CLLocationCoordinate2DMake(-37.5042800, 149.972992)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.8018000, 148.194580)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.7929500, 148.169861)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.7918510, 148.139633)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.8072510, 148.114914)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.7896500, 148.101196)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.6322210, 148.216553)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.6145900, 148.205566)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.6013600, 148.217926)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.5782010, 148.195953)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.5715790, 148.178101)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.5594480, 148.153381)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.5660710, 148.138275)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.5528300, 148.131393)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.5274580, 148.139633)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.4965520, 148.120422)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.4623180, 148.123154)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.4512710, 148.087463)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.4291800, 148.087463)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.4181290, 148.076477)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.4126010, 148.059998)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.3783300, 148.033905)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.3352010, 148.051743)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.2843020, 148.039383)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.2222790, 148.031143)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1469120, 148.033905)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1369290, 148.003693)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0825610, 147.984467)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0514790, 147.999573)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0381580, 147.981720)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0503690, 147.933655)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0037190, 147.914413)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9325900, 147.708435)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9670490, 147.617783)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9692800, 147.566986)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9837190, 147.579346)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0014990, 147.547760)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9781680, 147.510681)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9503780, 147.514801)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9448200, 147.466736)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9626080, 147.451630)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9437100, 147.409058)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9503780, 147.389832)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9726100, 147.392563)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0137210, 147.340393)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0303800, 147.348633)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0548100, 147.318420)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0459290, 147.299194)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0403790, 147.238770)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0536990, 147.208557)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0314900, 147.165985)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0370480, 147.141266)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9981690, 147.120667)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0159420, 147.094574)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0559200, 147.090454)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0659100, 147.062973)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0881120, 147.056122)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1036490, 147.049255)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1147380, 147.034134)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0903280, 147.010803)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0836720, 147.003937)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0881120, 146.965485)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0759010, 146.957245)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1136280, 146.944885)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1114080, 146.913300)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0858920, 146.892700)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0803410, 146.872101)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0836720, 146.825394)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0581400, 146.808914)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0603600, 146.762238)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0303800, 146.727905)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0359380, 146.683960)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9959490, 146.618042)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9726100, 146.618042)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9692800, 146.596054)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9948390, 146.550751)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9626080, 146.521912)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9603880, 146.498566)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9915010, 146.497192)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9670490, 146.462860)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9648280, 146.421661)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0126110, 146.380463)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0392680, 146.394196)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0525890, 146.369476)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0248300, 146.337891)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0492590, 146.310425)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0425990, 146.289825)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0126110, 146.284332)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0070610, 146.255493)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0403790, 146.197815)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0181690, 146.178574)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0237200, 146.155243)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0059510, 146.138763)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0148320, 146.089325)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9881710, 146.028900)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0103910, 146.020660)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0070610, 145.958862)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9648280, 145.953354)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9570500, 145.899811)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9592700, 145.857224)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9814990, 145.846252)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9870610, 145.810547)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9648280, 145.777573)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9370380, 145.717163)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9203610, 145.702057)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9303700, 145.680084)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8703000, 145.627884)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8769680, 145.610046)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8324510, 145.561981)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8035010, 145.537262)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8202020, 145.520782)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8090710, 145.505676)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8291090, 145.420532)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8513790, 145.410904)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8669590, 145.351852)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8513790, 145.325775)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8602790, 145.307922)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8313410, 145.246124)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8413580, 145.173340)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8235400, 145.128021)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8625110, 144.968704)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8803100, 144.974213)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9370380, 144.950867)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9592700, 144.959106)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9759480, 144.926147)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0237200, 144.967346)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0425990, 144.972824)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0659100, 144.982452)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0881120, 144.952240)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0670200, 144.928894)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0592500, 144.862976)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0781210, 144.849243)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0980990, 144.842377)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1280520, 144.779205)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1169590, 144.770966)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1280520, 144.735260)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.1213990, 144.720154)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0847820, 144.721527)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0969890, 144.692673)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0648000, 144.680313)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0792310, 144.651474)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0581400, 144.651474)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0481490, 144.629517)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0847820, 144.624023)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0592500, 144.613037)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0392680, 144.613037)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0370480, 144.585571)];
  [path addCoordinate:CLLocationCoordinate2DMake(-36.0259400, 144.585571)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9959490, 144.523773)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9748310, 144.519653)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9370380, 144.467453)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9359280, 144.445496)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.9047890, 144.420776)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.8647310, 144.408417)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.7957000, 144.372711)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.7600520, 144.330124)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.7388690, 144.291687)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.7522510, 144.271072)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.7243800, 144.249115)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.7109990, 144.221634)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.6931610, 144.218903)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.6741910, 144.187317)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.6730800, 144.158463)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.6418420, 144.154343)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.6474190, 144.147491)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.5882490, 144.098053)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.5525020, 144.041733)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.5614400, 144.011536)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.5536190, 143.989563)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.5368610, 143.993683)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.4977420, 143.962097)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.5022090, 143.905792)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.4664310, 143.849487)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.4418180, 143.819275)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.4261510, 143.794556)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.4261510, 143.768463)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.4082410, 143.767090)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.3948100, 143.762970)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.3869710, 143.739624)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.3925700, 143.709412)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.3724210, 143.687424)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.4004100, 143.643494)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.3242490, 143.559723)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.2850300, 143.592682)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.2457810, 143.566574)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.2199780, 143.577576)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.1986620, 143.555603)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.2177390, 143.535004)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.2177390, 143.466324)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.2076420, 143.463593)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.1919290, 143.447113)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.1885600, 143.388062)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.1470300, 143.385315)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.1054690, 143.359222)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.0717580, 143.345490)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.0447810, 143.330383)];
  [path addCoordinate:CLLocationCoordinate2DMake(-35.0087890, 143.335876)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.9919200, 143.327637)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.9570310, 143.318024)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.9424020, 143.335876)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.9131320, 143.341370)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.8861010, 143.323517)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.8601800, 143.346863)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.8128400, 143.360596)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7936710, 143.350983)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7801400, 143.312531)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7925420, 143.283691)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7767490, 143.253464)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7541890, 143.272705)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7462880, 143.243866)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7485500, 143.220520)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7293590, 143.219147)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7304920, 143.194427)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7135580, 143.195801)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7169490, 143.173813)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7022710, 143.161453)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7113000, 143.139496)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6932410, 143.125763)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6853290, 143.114777)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7022710, 143.092804)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6819500, 143.068085)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6954990, 143.043365)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6740420, 143.014526)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6672590, 142.981567)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6954990, 142.977448)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6683880, 142.955475)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6491890, 142.930756)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6763000, 142.888184)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6695210, 142.866211)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6299780, 142.867584)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6186790, 142.853851)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6039890, 142.822266)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6085090, 142.812653)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5960810, 142.790680)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5610200, 142.808533)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5451890, 142.782440)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5757290, 142.770081)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5768590, 142.742615)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5938190, 142.764587)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6028590, 142.748093)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5938190, 142.724762)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6356320, 142.676697)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6593590, 142.704163)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6808200, 142.712402)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6695210, 142.676697)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7101710, 142.691803)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7361300, 142.676697)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7225910, 142.660217)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7316210, 142.620392)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7620890, 142.617645)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7643390, 142.642365)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7767490, 142.642365)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7891620, 142.620392)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7711110, 142.592926)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7643390, 142.551727)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.7417790, 142.500916)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6977620, 142.518753)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6729090, 142.495422)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6717800, 142.477570)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6424100, 142.484436)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.6344990, 142.452850)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5960810, 142.470703)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5644190, 142.430862)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5689390, 142.413025)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5440600, 142.404785)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5474510, 142.395172)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5361400, 142.373184)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5191690, 142.395172)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.5089910, 142.366333)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.4942700, 142.396545)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.4863510, 142.356720)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.4682390, 142.378693)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.4670980, 142.344360)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.4297290, 142.362213)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3946110, 142.345734)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3662800, 142.375946)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3390690, 142.395172)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3288610, 142.370453)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3368000, 142.340240)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3368000, 142.327881)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3243220, 142.281174)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3016400, 142.292175)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.2925610, 142.272934)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.3095820, 142.244110)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.2721410, 142.245483)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.2210500, 142.246857)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1813010, 142.234497)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1733510, 142.182312)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1847110, 142.172684)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1528890, 142.165833)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1494790, 142.153473)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1528890, 142.127380)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1813010, 142.117767)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1540300, 142.068314)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1369780, 142.080673)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1244810, 142.031250)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0983310, 142.036743)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0994610, 142.014771)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1199300, 141.996902)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1119690, 141.980423)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1347080, 141.968063)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1222000, 141.952972)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1131100, 141.889801)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1358410, 141.871933)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0926400, 141.730484)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1517600, 141.597290)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1915210, 141.597290)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.2108310, 141.508026)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1528890, 141.502533)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1665310, 141.437973)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1301610, 141.410522)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1085590, 141.358337)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.1392520, 141.319885)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0653380, 141.240234)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0653380, 141.204514)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0960500, 141.186676)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0835420, 141.159210)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0550990, 141.156464)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0346180, 141.035614)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0505490, 141.020493)];
  [path addCoordinate:CLLocationCoordinate2DMake(-34.0380290, 141.005402)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9963090, 140.997162)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9975110, 148.947144)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9806900, 148.973236)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9734800, 148.996582)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9590610, 149.007553)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9482500, 149.035034)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8737200, 149.063873)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8304100, 149.094086)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8316190, 149.124283)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8063510, 149.140778)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8015400, 149.181976)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7738490, 149.191574)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7124500, 149.294586)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6859490, 149.363251)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6943800, 149.392090)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5955510, 149.451141)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5738390, 149.525284)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5798700, 149.592590)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5991710, 149.639282)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6136400, 149.659882)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6305100, 149.674973)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6305100, 149.699707)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6184600, 149.706573)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6100200, 149.721680)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6100200, 149.817810)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6064000, 149.857635)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6100200, 149.975723)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5786710, 150.019684)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5847000, 150.055374)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5690190, 150.106201)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5509300, 150.151520)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5593700, 150.180344)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5714300, 150.209183)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5629900, 150.231171)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5485100, 150.254517)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5412810, 150.310822)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5461010, 150.335541)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6039910, 150.368500)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6244910, 150.380844)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6305100, 150.397324)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6377390, 150.426163)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6558210, 150.442657)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6642610, 150.486603)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6558210, 150.497574)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6558210, 150.538773)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6702800, 150.531921)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6678700, 150.556641)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6558210, 150.563507)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6726890, 150.637665)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6473900, 150.677490)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6329190, 150.739273)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6341300, 150.770874)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6642610, 150.836792)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6895600, 150.906830)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7100390, 150.931534)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7317200, 150.938416)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7281000, 150.985107)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7485690, 151.024933)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7666300, 151.018066)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7991290, 151.045532)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8195900, 151.038666)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8472600, 151.057892)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8304100, 151.096344)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9434390, 151.278992)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9951000, 151.278992)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.0203300, 151.273483)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.0407390, 151.288605)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.0743500, 151.272125)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.1043490, 151.287231)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.1223510, 151.317444)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.1535400, 151.305084)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.1775210, 151.361374)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.1703300, 151.399841)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.0863490, 151.475372)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.0683500, 151.497345)];
  [path addCoordinate:CLLocationCoordinate2DMake(-29.0491410, 151.497345)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9494500, 151.550903)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9218100, 151.611313)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9278200, 151.638794)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9109900, 151.648407)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8689000, 151.729431)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9362300, 151.767883)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9602600, 151.767883)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9434390, 151.806335)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9626690, 151.818695)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9530510, 151.833801)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9109900, 151.844788)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9218100, 151.949142)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8929500, 151.997223)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.9145910, 152.006836)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8520700, 152.046661)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8592800, 152.021942)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.8532700, 152.012314)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7798690, 152.028793)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.7353310, 152.049393)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6907600, 152.082367)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.6666700, 152.013702)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5919300, 151.986237)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5581610, 151.956024)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5243890, 151.949142)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5038700, 151.983490)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.5243890, 151.998596)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.4881800, 152.075500)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.4676610, 152.070007)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.4338490, 152.156525)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.4398900, 152.204590)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.4410990, 152.216934)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3891600, 152.271881)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3903690, 152.285614)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3637910, 152.310333)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3625790, 152.387238)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3323590, 152.416077)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3142300, 152.411957)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2985100, 152.417450)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3009300, 152.440796)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2586000, 152.464142)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2513410, 152.513580)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2670710, 152.542404)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3045600, 152.528687)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3432410, 152.583603)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3118100, 152.598724)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2900510, 152.595963)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2707000, 152.612457)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3118100, 152.644043)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3106000, 152.670135)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3661990, 152.751160)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3480800, 152.770386)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3553300, 152.799225)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3106000, 152.848663)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3106000, 152.880234)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3408200, 152.942047)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3323590, 152.981873)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3432410, 153.043671)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3553300, 153.090363)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3541200, 153.101334)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3311500, 153.128815)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.3178600, 153.127441)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2936800, 153.164520)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2803710, 153.160400)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2731210, 153.172760)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2477090, 153.174133)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2658600, 153.237305)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2477090, 153.244171)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2368300, 153.278503)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2368300, 153.330673)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2465000, 153.344421)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.2283590, 153.389740)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1994800, 153.418915)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1846500, 153.446381)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1807190, 153.457367)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1770900, 153.460464)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1731490, 153.459763)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1628610, 153.468704)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1604400, 153.473846)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1562000, 153.475571)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1568110, 153.487579)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1731490, 153.526382)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1767810, 153.533585)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1707310, 153.539413)];
  [path addCoordinate:CLLocationCoordinate2DMake(-28.1646800, 153.551773)];
  border.path = path;

  return border;
}

@end
