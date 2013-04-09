//
//  DirectoryViewController.m
//  Philanthropy
//
//  Created by Nickolas Workman on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "DirectoryViewController.h"
#import "ClosestDetailViewController.h"
#import "TableViewCell.h"

@interface DirectoryViewController ()
@property (nonatomic, retain) NSArray *data;
@property (nonatomic, retain) NSArray *filteredData;
@property (nonatomic, retain) NSArray *sortedData;
@end

@implementation DirectoryViewController
@synthesize data, filteredData, sortedData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Directory";
        self.tabBarItem.title = @"Directory";
    }
    return self;
}

- (void)viewDidLoad
{
    NSString *mylist = [[NSBundle mainBundle] pathForResource:@"Senior Project Data" ofType:@"plist"];
    data = [[NSArray alloc]initWithContentsOfFile:mylist];
    filteredData = [[NSMutableArray alloc]init];
    sortedData = [[NSArray alloc]init];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"Building Name" ascending:YES];
    sortedData = [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    //CGRect frame = CGRectMake(0, 0, 400, 44);
    //UILabel *label = [[UILabel alloc] initWithFrame:frame];
    //label.backgroundColor = [UIColor clearColor];
   // label.font = [UIFont boldSystemFontOfSize:18.0];
   // label.textAlignment = NSTextAlignmentCenter;
    //label.textColor = [UIColor whiteColor];
    //label.text = @"Directory";
    ////[label setShadowColor:[UIColor darkGrayColor]];
    //[label setShadowOffset:CGSizeMake(0, -0.5)];
    //self.navigationItem.titleView = label;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"TableViewCell";
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        rows = [filteredData copy];
    } else {
        rows = sortedData;
    }
    cell.build = [[rows objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
    cell.thumb = [[rows objectAtIndex:indexPath.row]objectForKey:@"Building Image"];
    cell.don1 = [[rows objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    cell.don2 = [[rows objectAtIndex:indexPath.row]objectForKey:@"Donor Name 2"];
    
    [cell setDetails:cell];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ClosestDetailViewController *detail = [[ClosestDetailViewController alloc]
                                           initWithNibName:@"ClosestDetailViewController" bundle:nil];
    
    detail.building = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Building Name"];
    detail.campus = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Campus"];
    detail.donorName1 = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Donor Name 1"];
    detail.donorName2 = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Donor Name 2"];
    detail.donorPic1 = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Donor Image 1"];
    detail.donorPic2 = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Donor Image 2"];
    detail.description1 = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Building Description 1"];
    detail.description2 = [[sortedData objectAtIndex:indexPath.row]objectForKey:@"Building Description 2"];
    [self.navigationController pushViewController:detail animated:YES];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 86;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


@end
