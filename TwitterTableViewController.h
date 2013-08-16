//
//  TwitterTableViewController.h
//  Digi Stadium
//
//  This is for a twitter table view.
//
//  Created by Hao Zhang on 03/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "UtilityFunction.h"
#import "UIUpdateCentre.h"

@interface TwitterTableViewController : UITableViewController  <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource>{
	
    // view for pulling down refresh.
	EGORefreshTableHeaderView *_refreshHeaderView;
    // mark if the view is reloading now.
	BOOL _reloading;
    // the data set of tweets.
    NSMutableArray *tweetsList;
    // the url of the twitter table view.
    NSString * TWITTER_URL;
    // mark if use the default image for profile.
    bool useDefaultImage ;
    UIUpdateCentre *uiUpdateCentre;
    UtilityFunction * utility;
    // the date for last update time.
    NSDate * lastDate;
}

//  set the twitter table by url and decide if use the default image for the profile.
- (void)setTwitterTableURL:(NSString *) url useDefaultImage:(BOOL) b;
@end