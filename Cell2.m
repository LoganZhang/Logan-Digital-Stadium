//
//  Cell2.m
//  Digi Stadium
//
//
//  This class is for the second level item in the swiping menu.
//
//  Created by Hao Zhang on 15/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "Cell2.h"

@implementation Cell2
@synthesize titleLabel,menuImageView,developingImageView;

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

@end
