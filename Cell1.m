//
//  Cell1.m
//  Digi Stadium
//
//
//  This class is for the first level item in the swiping menu.
//
//  Created by Hao Zhang on 15/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//
#import "Cell1.h"

@implementation Cell1
@synthesize titleLabel,arrowImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

// set the direction of the arrow.
- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"UpAccessory.png"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"DownAccessory.png"];
    }
}

@end
