//
//  TweetCell.m
//  Digi Stadium
//
//  This is for the tweet cell.
//
//  Created by Hao Zhang on 01/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell
@synthesize name;
@synthesize nickname;
@synthesize tweet;
@synthesize time;
@synthesize image;


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
