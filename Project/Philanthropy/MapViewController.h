#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController {
    
	MKMapView *mapView;
    NSArray *data;    
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (IBAction)getLocation;
- (IBAction)setMap:(id)sender;

@end