//
//  Cell1.h
//  Digi Stadium
//
//
//  This class is for the first level item in the swiping menu.
//
//  Created by Hao Zhang on 15/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell1 : UITableViewCell

// the text for the section.
@property (nonatomic,retain)IBOutlet UILabel *titleLabel;
// arrow image
@property (nonatomic,retain)IBOutlet UIImageView *arrowImageView;

// set the direction of the arrow.
- (void)changeArrowWithUp:(BOOL)up;
@end
