//
//  TwitterViewController.m
//  Digi Stadium
//
//  This is for the twitter view.
//
//  Created by Hao Zhang on 01/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "TwitterViewController.h"
#import "UtilityFunction.h"
#import "CommonStrings.h"
#define UNSELECTEDCOLOR 100

@interface TwitterViewController ()

- (void) addBasicView;
- (void)initScrollView;
- (void)createAllEmptyPagesForScrollView;
- (void) clubButtonAction;
- (void) bhafcButtonAction;

@end

@implementation TwitterViewController
@synthesize clubButton;
@synthesize bhafcButton;
@synthesize slidLabel;
UIScrollView * nibScrollView;


static TwitterViewController *sharedTwitter = nil;

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedTwitter == nil)
        {
            sharedTwitter = [super allocWithZone:zone];
            return sharedTwitter;
        }
    }
    [sharedTwitter btnActionShow];
    return sharedTwitter;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    utility = [[UtilityFunction alloc] init];
    [self addBasicView];
    [self initScrollView];
}

- (void) addBasicView
{
    
    nibScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, utility.getDeviceWidth, utility.getDeviceHeigt)];
    
    
    nibScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:nibScrollView];
    
    clubButton.showsTouchWhenHighlighted = YES; 
    [clubButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bhafcButton.showsTouchWhenHighlighted = YES; 
    [bhafcButton setTitleColor:[UIColor colorWithRed:(UNSELECTEDCOLOR/255.0) green:(UNSELECTEDCOLOR/255.0) blue:(UNSELECTEDCOLOR/255.0) alpha:1] forState:UIControlStateNormal];
    
}
-(IBAction)clubButtonPressed:(id)sender{
    [self clubButtonAction];
}

-(IBAction)bhafcButtonAction:(id)sender{
    [self bhafcButtonAction];
}

- (void) btnActionShow
{
    if (currentPage == 0) {
        [self clubButtonAction];
    }
    else{
        [self bhafcButtonAction];
    }
}

- (void) clubButtonAction
{
    [clubButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bhafcButton setTitleColor:[UIColor colorWithRed:(UNSELECTEDCOLOR/255.0) green:(UNSELECTEDCOLOR/255.0) blue:(UNSELECTEDCOLOR/255.0) alpha:1] forState:UIControlStateNormal];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    slidLabel.frame = CGRectMake(0, 36, 160, 4);
    [nibScrollView setContentOffset:CGPointMake(utility.getDeviceWidth*0, 0)];
    currentPage = 0;
    [UIView commitAnimations];
}

- (void) bhafcButtonAction
{
    [bhafcButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clubButton setTitleColor:[UIColor colorWithRed:(UNSELECTEDCOLOR/255.0) green:(UNSELECTEDCOLOR/255.0) blue:(UNSELECTEDCOLOR/255.0) alpha:1] forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    slidLabel.frame = CGRectMake(utility.getDeviceWidth-160, 36, 161, 4);
    [nibScrollView setContentOffset:CGPointMake(utility.getDeviceWidth*1, 0)];
    [UIView commitAnimations];
}



- (void)initScrollView {
    
    nibScrollView.contentSize = CGSizeMake(utility.getDeviceWidth * 2, utility.getDeviceHeigt);
    nibScrollView.showsVerticalScrollIndicator = YES;
    [nibScrollView setScrollEnabled:NO];
    nibScrollView.scrollsToTop = NO;
    nibScrollView.delegate = self;
    currentPage = 0;
    pageControl.numberOfPages = 2;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = [UIColor yellowColor];
    [self createAllEmptyPagesForScrollView];
}


- (void)createAllEmptyPagesForScrollView {
    
    clubTableView = [[TwitterTableViewController alloc]init ];
    [clubTableView setTwitterTableURL: CLUBC_URL useDefaultImage:true];
    clubTableView.tableView.frame = CGRectMake(utility.getDeviceWidth*0, 0, utility.getDeviceWidth, self.view.frame.size.height);
    bhafcTableView = [[TwitterTableViewController alloc]init ];
    [bhafcTableView setTwitterTableURL:FANSC_URL useDefaultImage:false];
    bhafcTableView.tableView.frame = CGRectMake(utility.getDeviceWidth*1, 0, utility.getDeviceWidth, self.view.frame.size.height);
    
    [nibScrollView addSubview: clubTableView.tableView];
    [nibScrollView addSubview: bhafcTableView.tableView];
    
}




@end
