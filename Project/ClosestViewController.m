//
//  ClosestViewController.m
//  Philanthropy
//
//  Created by Nickolas Workman on 4/8/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "ClosestViewController.h"
#import "ClosestDetailViewController.h"
#import "gvsuCLController.h"
#import "TableViewCell.h"

@interface ClosestViewController ()
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSMutableArray *filteredData;
@property (nonatomic, retain) NSDictionary *building;
@end

@implementation ClosestViewController
@synthesize data;
@synthesize building;
@synthesize filteredData;

#pragma mark - View Life Cycle Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Near me";
        self.tabBarItem.title = @"Near me";
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //SET UP NSARRAY WITH DATA
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Table View Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [filteredData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableViewCell";
    
    TableViewCell *cell = (TableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:nil options:nil];
        
        for(id currentObject in objects){
            if([currentObject isKindOfClass:[TableViewCell class]])
            {
                cell = (TableViewCell *)currentObject;
                break;
            }
        }        
    }
    NSArray *rows;
    rows = [filteredData copy];
    
    cell.build = [[rows objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
    cell.don1 = [[rows objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    cell.don2 = [[rows objectAtIndex:indexPath.row]objectForKey:@"Donor Name 2"];
    cell.thumb = [[rows objectAtIndex:indexPath.row]objectForKey:@"Building Image"];
    
    NSString *full_coords = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"GPS Coordinates"];
    NSArray *deliminated_coords = [full_coords componentsSeparatedByString:@","];
    NSString *x = deliminated_coords[0];
    NSString *y = deliminated_coords[1];
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:[x doubleValue] longitude:[y doubleValue]];
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:clController.locationManager.location.coordinate.latitude longitude:clController.locationManager.location.coordinate.longitude];
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    cell.dist =  [NSString stringWithFormat:@"%.2f %@", distance * 0.000621371, @"mi"];
    
    [cell setDetails:cell];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClosestDetailViewController *detail = [[ClosestDetailViewController alloc]
        initWithNibName:@"ClosestDetailViewController" bundle:nil];
    
    detail.building = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
    detail.campus = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"Campus"];    
    detail.donorName1 = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    detail.donorName2 = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"Donor Name 2"];
    detail.donorPic1 = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"Donor Image 1"];
    detail.donorPic2 = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"Donor Image 2"];    
    detail.description1 = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"Building Description 1"];
    detail.description2 = [[filteredData objectAtIndex:indexPath.row]objectForKey:@"Building Description 2"];
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

@end
