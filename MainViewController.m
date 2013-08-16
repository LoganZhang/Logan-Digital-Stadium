//
//  MainViewController.m
//  DigitalStadium
//
//  This is the class for the main view.
//
//  Created by Hao Zhang on 04/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"
#import "DevelopViewController.h"
#import "WebViewController.h"
#import "TwitterViewController.h"
#import "CommonStrings.h"
@implementation MainViewController

// singleton instance
static MainViewController *sharedRootController = nil;

// singleton instance initialization
+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (sharedRootController == nil)
        {
            sharedRootController = [super allocWithZone:zone];
            return sharedRootController;
        }
    }   
    return sharedRootController; 
}

// Called after the view has been loaded.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:57.0/255.0 blue:166.0/255.0 alpha:1.0];
    [self showMainView];
}

// initialize the main view.
- (void)showMainView
{
    [self setTop];
    [self setStatusBar];
    
    subWebView = [WebViewController alloc];
    subWebView.view.frame = CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height-75);
    
    viewsDic=[NSDictionary dictionaryWithObjectsAndKeys:
              [NSNumber numberWithInt:1],@"trains",
              [NSNumber numberWithInt:2],@"buses",
              [NSNumber numberWithInt:3],@"traffic",
              [NSNumber numberWithInt:4],@"results",
              [NSNumber numberWithInt:5],@"fixtures",
              [NSNumber numberWithInt:6],@"livescores",
              [NSNumber numberWithInt:7],@"leaguetable",
              [NSNumber numberWithInt:8],@"currentmatch",
              [NSNumber numberWithInt:9],@"vidiprinter",
              [NSNumber numberWithInt:10],@"about",
              [NSNumber numberWithInt:11],@"matchcommentary",
              [NSNumber numberWithInt:12],@"competition",
              [NSNumber numberWithInt:13],@"news",
              [NSNumber numberWithInt:14],@"tickets",
              [NSNumber numberWithInt:15],@"players",
              [NSNumber numberWithInt:16],@"store",
              [NSNumber numberWithInt:17],@"parkride",
              [NSNumber numberWithInt:18],@"cycling",
              [NSNumber numberWithInt:19],@"walk",
              [NSNumber numberWithInt:20],@"twitter",
              [NSNumber numberWithInt:21],@"account",
              [NSNumber numberWithInt:22],@"preferences",
              [NSNumber numberWithInt:23],@"feedback",
              [NSNumber numberWithInt:24],@"status",
              [NSNumber numberWithInt:25],@"help",
              nil];
    
    [self.view addSubview:lb_text];
    [self.view addSubview:seagullsImageView];
    [self.view addSubview:btn_menu];
    [self.view addSubview:subWebView.view];
    [self setStatusBar];
    [self openView:@"twitter"];
    subWebView.view.hidden = YES;
    subUIView.view.hidden = NO;
    
}

// load subviews
-(void) loadSubView:(UIViewController *) view
{
    subWebView.view.hidden = YES;
    subUIView.view.hidden = NO;
    [subUIView.view removeFromSuperview];
    [subWebView loadWebView:@"first_page"];
    subUIView = view;
    subUIView.view.frame =CGRectMake(0, 55, self.view.frame.size.width, self.view.frame.size.height-75);
    [self.view addSubview:subUIView.view];
}

// open a view by a pariticular name which is in viewsDic.
- (void)openView:(NSString *) name
{
    int number = [[viewsDic objectForKey:name] intValue];
    switch (number) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
            subWebView.view.hidden = NO;
            subUIView.view.hidden = YES;
            [subWebView loadWebView:name];
            break;
        case 9:
        case 10:
        case 11:
        case 12:
        case 13:
            subWebView.view.hidden = NO;
            subUIView.view.hidden = YES;
            [subWebView loadWebView:name];
            break;
        case 14:
            [self loadSubView:[DevelopViewController alloc]];
            break;
        case 15:
            subWebView.view.hidden = NO;
            subUIView.view.hidden = YES;
            [subWebView loadWebView:name];
            break;
        case 16:
        case 17:
        case 18:
        case 19:
            [self loadSubView:[DevelopViewController alloc]];
            break;
        case 20:
            [self loadSubView:[TwitterViewController alloc]];
            break;
        case 21:
        case 22:
        case 23:
        case 24:
        case 25:
           [self loadSubView:[DevelopViewController alloc]];
            break;
        default:
            break;
    }
    
}

// initialize the top bar of the main view.
- (void)setTop
{
    lb_text = [[UILabel alloc] initWithFrame:CGRectMake(118, 13, self.view.frame.size.width, 30.0)];
    lb_text.backgroundColor = [UIColor clearColor];
    lb_text.textColor = [UIColor blackColor];
    seagullsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(80, 10, 35, 35)];
    seagullsImageView.image = [UIImage imageNamed:@"Icon-Small@2x.png"];
    lb_text.text =MAIN_VIEW_TITLE;
    lb_text.font = [UIFont systemFontOfSize:20];
    lb_text.textColor = [UIColor whiteColor];
    UIImage *img_menu = [UIImage imageNamed:@"reveal-icon"];
    btn_menu = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_menu.frame = CGRectMake(10, 10, img_menu.size.width+20, img_menu.size.height+20);
    [btn_menu setImage:img_menu forState:UIControlStateNormal];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SWRevealViewController *revealController = (SWRevealViewController *)delegate.window.rootViewController;
    [btn_menu addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
}

// this should be called when the app has been actived.
- (void)activeApp
{
    [self setStatusBar];
}

// this should be called when the app goes to background.
- (void)pauseApp
{
    [self removeStatusBar];
}

// remove status bar.
- (void)removeStatusBar
{
     [scrollingTicker removeFromSuperview];
    scrollingTicker= nil;
}

// add status bar.
- (void)setStatusBar
{

    if(scrollingTicker!=nil)
    {
        return;
    }
    scrollingTicker = [[DMScrollingTicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-20, self.view.frame.size.width, 20)];
    scrollingTicker.backgroundColor = [UIColor clearColor];
    [self.view addSubview:scrollingTicker];
    NSMutableArray *l = [[NSMutableArray alloc] init];
    NSMutableArray *sizes = [[NSMutableArray alloc] init];
    for (NSUInteger k = 0; k < 5; k++) {
        LPScrollingTickerLabelItem *label = [[LPScrollingTickerLabelItem alloc] initWithTitle:[NSString stringWithFormat:@" News %d:",k]
                                                                                  description:[NSString stringWithFormat:@"hello seagulls %d",k]];
        [label layoutSubviews];
        [sizes addObject:[NSValue valueWithCGSize:label.frame.size]];
        [l addObject:label];
    }
    
    [scrollingTicker beginAnimationWithViews:l
                                   direction:LPScrollingDirection_FromRight
                                       speed:0
                                       loops:2
                                completition:^(NSUInteger loopsDone, BOOL isFinished) {
                                }];
}



@end
