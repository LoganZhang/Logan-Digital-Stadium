//
//  Cell2.h
//  Digi Stadium
//
//
//  This class is for the second level item in the swiping menu.
//
//  Created by Hao Zhang on 15/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell2 : UITableViewCell

// the text for the row.
@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
// image for the row.
@property (nonatomic,retain)IBOutlet UIImageView *menuImageView;
// developing image for the row.
@property (nonatomic,retain)IBOutlet UIImageView *developingImageView;
@end
