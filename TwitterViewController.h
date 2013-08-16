//
//  TwitterViewController.h
//  Digi Stadium
//
//  This is for the twitter view.
//
//  Created by Hao Zhang on 01/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterTableViewController.h"
@interface TwitterViewController : UIViewController< UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    TwitterTableViewController *clubTableView;
    TwitterTableViewController *bhafcTableView;
	UIPageControl *pageControl;
    int currentPage;
    UtilityFunction * utility;
    
}

@property (retain, nonatomic) IBOutlet UIButton *clubButton;
@property (retain, nonatomic) IBOutlet UIButton *bhafcButton;
@property (retain, nonatomic) IBOutlet UILabel *slidLabel;


@end