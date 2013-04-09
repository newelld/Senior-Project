//
//  gvsuClosestViewController.m
//  Philanthropy
//
//  Created by Thomas Peterson on 3/23/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "ClosestDetailViewController.h"
#import "gvsuClosestViewController.h"

@interface gvsuClosestViewController ()
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSMutableArray *filteredData;
@property (nonatomic, retain) NSDictionary *building;
@end

@implementation gvsuClosestViewController
@synthesize data;
@synthesize building;
@synthesize filteredData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	clController = [[gvsuCLController alloc] init];
	clController.delegate = self;
    [clController.locationManager startMonitoringSignificantLocationChanges];
    
    
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"Senior Project Data" ofType:@"plist"];
    data = [[NSArray alloc]initWithContentsOfFile:mylist];
    filteredData = [[NSMutableArray alloc]init];
    
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Buildings Near Me";
    [label setShadowColor:[UIColor darkGrayColor]];
    [label setShadowOffset:CGSizeMake(0, -0.5)];
    self.navigationItem.titleView = label;
    [self closestBuilding];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)locationDisplay:(CLLocation *)location {
	//locationLabel.text = [location description];
    locationLabel.text = [building valueForKey:@"Building Name"];
    
    locationPic.image = [UIImage imageNamed:[building valueForKey:@"Image"]];
    
   // [locationPic setImage:image];
}

- (void)locationError:(NSError *)error {
	locationLabel.text = [error description];
}

- (void)closestBuilding {
    CLLocationDistance firstDistance = DBL_MAX;
    CLLocationDistance secondDistance = DBL_MAX;
    CLLocationDistance thirdDistance = DBL_MAX;
    CLLocationDistance fourthDistance = DBL_MAX;
    CLLocationDistance fifthDistance = DBL_MAX;
    NSDictionary *firstBuilding;
    NSDictionary *secondBuilding;
    NSDictionary *thirdBuilding;
    NSDictionary *fourthBuilding;
    NSDictionary *fifthBuilding;
    	
    for (NSDictionary *currentBuilding in data)
    {
        NSString *full_coords = [currentBuilding valueForKey:@"GPS Coordinates"];
        NSArray *deliminated_coords = [full_coords componentsSeparatedByString:@","];
        if([deliminated_coords count] > 1)
        {
            NSString *x = deliminated_coords[0];
            NSString *y = deliminated_coords[1];
        
            CLLocation *locA = [[CLLocation alloc] initWithLatitude:[x doubleValue] longitude:[y doubleValue]];
            CLLocation *locB = [[CLLocation alloc] initWithLatitude:clController.locationManager.location.coordinate.latitude longitude:clController.locationManager.location.coordinate.longitude];
            CLLocationDistance distance = [locA distanceFromLocation:locB];
            if (distance < firstDistance)
            {
                fifthDistance = fourthDistance;
                fifthBuilding = fourthBuilding;
                fourthDistance = thirdDistance;
                fourthBuilding = thirdBuilding;
                thirdDistance = secondDistance;
                thirdBuilding = secondBuilding;
                secondDistance = firstDistance;
                secondBuilding = firstBuilding;
                firstDistance = distance;
                firstBuilding = currentBuilding;
            }else if (distance < secondDistance){
                fifthDistance = fourthDistance;
                fifthBuilding = fourthBuilding;
                fourthDistance = thirdDistance;
                fourthBuilding = thirdBuilding;
                thirdDistance = secondDistance;
                thirdBuilding = secondBuilding;
                secondDistance = distance;
                secondBuilding = currentBuilding;
            }else if (distance < thirdDistance){
                fifthDistance = fourthDistance;
                fifthBuilding = fourthBuilding;
                fourthDistance = thirdDistance;
                fourthBuilding = thirdBuilding;
                thirdDistance = distance;
                thirdBuilding = currentBuilding;
            }else if (distance < fourthDistance){
                fifthDistance = fourthDistance;
                fifthBuilding = fourthBuilding;
                fourthDistance = distance;
                fourthBuilding = currentBuilding;
            }else if (distance < fifthDistance){
                fifthDistance = distance;
                fifthBuilding = currentBuilding;
            }
        }
    }
    [filteredData addObject:firstBuilding];
    [filteredData addObject:secondBuilding];
    [filteredData addObject:thirdBuilding];
    [filteredData addObject:fourthBuilding];
    [filteredData addObject:fifthBuilding];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [filteredData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    NSArray *rows;
    rows = [filteredData copy];
    cell.textLabel.text = [[rows objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
    cell.detailTextLabel.text = [[rows objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:11.0];
    //cell.imageView.image = [UIImage imageNamed:[[rows objectAtIndex:indexPath.row]objectForKey:@"Image"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClosestDetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"closestdetail"];
    
    detail.building = [[data objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
    detail.campus = [[data objectAtIndex:indexPath.row]objectForKey:@"Campus"];
    detail.donorName1 = [[data objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    detail.donorName2 = [[data objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    detail.description1 = [[data objectAtIndex:indexPath.row]objectForKey:@"Building Description 1"];
    detail.description2 = [[data objectAtIndex:indexPath.row]objectForKey:@"Building Description 2"];
    [self.navigationController pushViewController:detail animated:YES];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end

