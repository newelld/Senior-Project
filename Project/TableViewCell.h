//
//  TableViewCell.h
//  Philanthropy
//
//  Created by Nickolas Workman on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"

@interface TableViewCell : UITableViewCell


@property IBOutlet UILabel *building;
@property IBOutlet UIImageView *thumbnail;
@property IBOutlet UILabel *donor1;
@property IBOutlet UILabel *donor2;
@property IBOutlet UILabel *donors;
@property IBOutlet UILabel *distance;

@property (nonatomic, retain)NSString *build, *don1, *don2, *thumb, *dist;

-(void)setDetails:(TableViewCell *)cell;

@end
