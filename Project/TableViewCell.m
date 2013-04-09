//
//  TableViewCell.m
//  Philanthropy
//
//  Created by Nickolas Workman on 4/9/13.
//  Copyright (c) 2013 Nickolas Workman. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell
@synthesize thumbnail, building, donor1, donor2, distance;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDetails:(TableViewCell *)cell
{
    donor1.text = self.don1;
    if(self.don2.length > 4) donor2.text = self.don2;
    thumbnail.image = [UIImage imageNamed:self.thumb];
    building.text =  self.build;
    distance.text = self.dist;
}

@end
