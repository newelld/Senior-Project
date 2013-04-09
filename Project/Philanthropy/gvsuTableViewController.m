//
//  gvsuTableViewController.m
//  Philanthropy
// 
//  Created by Nickolas Workman on 2/26/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//
#import "DetailViewController.h"
#import "gvsuTableViewController.h"

@interface gvsuTableViewController ()
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSArray *filteredData;
@property (nonatomic, retain) NSArray *sortedData;
@end

@implementation gvsuTableViewController
@synthesize data, filteredData, sortedData;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"Senior Project Data" ofType:@"plist"];
    data = [[NSArray alloc]initWithContentsOfFile:mylist];
    filteredData = [[NSMutableArray alloc]init];
    sortedData = [[NSArray alloc]init];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"Building Name" ascending:YES];
    sortedData = [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"Directory";
    [label setShadowColor:[UIColor darkGrayColor]];
    [label setShadowOffset:CGSizeMake(0, -0.5)];
    self.navigationItem.titleView = label;
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [filteredData removeAllObjects];    
    for (NSDictionary *building in sortedData)
    {
            NSRange rng = [[building valueForKey:@"Building Name"] rangeOfString:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)];
            
            if (rng.length != 0)
            {
                //NSLog(@"%@", building);
                [filteredData addObject:building];
            }
    }
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [filteredData count];
    } else {
        return [sortedData count];
    } 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    NSArray *rows;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        rows = [filteredData copy];
    } else {
        rows = sortedData;
    }
    cell.textLabel.text = [[rows objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:11.0];
    cell.detailTextLabel.text = [[rows objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:11.0];
    //cell.imageView.image = [UIImage imageNamed:[[rows objectAtIndex:indexPath.row]objectForKey:@"Image"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    detail.building = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
    detail.donorName = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    detail.campus = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Campus"];
    detail.description = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Building Description 1"];
    detail.donor2 = [sortedData objectAtIndex:indexPath.row];
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
