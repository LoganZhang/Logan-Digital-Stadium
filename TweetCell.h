//
//  TweetCell.h
//  Digi Stadium
//
//  This is for the tweet cell.
//
//  Created by Hao Zhang on 01/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell

@property (nonatomic,retain)IBOutlet UILabel *name;
@property (nonatomic,retain)IBOutlet UILabel *nickname;
@property (nonatomic,retain)IBOutlet UILabel *tweet;
@property (nonatomic,retain)IBOutlet UILabel *time;
@property (nonatomic,retain)IBOutlet UIImageView *image;
@end
