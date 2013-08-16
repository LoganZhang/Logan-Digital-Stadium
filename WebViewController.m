//
//  WebViewController.m
//  Digi Stadium
//
//  This is for the web view.
//
//  Created by Hao Zhang on 01/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "WebViewController.h"
#import "CacheData.h"
#define UPDATE_INTERVAL 5

@implementation WebViewController
@synthesize webView;

// initialize from nib
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// called when the view has been loaded.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    self.webView.scalesPageToFit = NO;
    self.webView.delegate = self;
    uiUpdateCentre = [UIUpdateCentre alloc];
    [uiUpdateCentre addDelegate:(id)self];
    [self loadWebView:@"first_page"];
    [self.view addSubview:self.webView];
}

// called when cahce data has been received by the web view.
-(void)messageCallBack:(CacheData *)data
{
    if(data ==nil || ![data.url isEqualToString:currentURL])
    {
        return;
    }
    [self updateContent:data.content];
    [self setUpdateTime:data.updateTime];
}

//  load a particular digital service by the service name.
- (void)loadWebView:(NSString *) name
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:name ofType:@"html"inDirectory:@"www"]]]];
}

// called before a url is loaded.
// We should reject some urls, because users can only access the urls which are provided by digital stadium.
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    if ( [request.mainDocumentURL.relativePath hasPrefix:@"/loaddata"] ) {
        NSString *url = [request.description substringFromIndex:38];
        url = [url substringToIndex:url.length-1];
        CacheData *content = [uiUpdateCentre getUIContent:url onlyGetFromInternet:NO];   
        currentURL = url;
        [self updateContent:content.content];
        [self setUpdateTime:content.updateTime];
        return false;
    }
    
    if([[request.URL scheme] isEqualToString: @"file"])
    {
        NSString * description = request.description;
        NSRange r = [description rangeOfString: @"match.html?matchId"];
        if(r.length !=0)
        {
            return FALSE;
        }
        return TRUE;
    }
    return FALSE;
}

// fill the html page with the JSON data.
-(void)updateContent:(NSString *) content
{
    if([content hasPrefix:@"processData"])
    {    
        [NSString stringWithString:[self.webView stringByEvaluatingJavaScriptFromString:content]];
    }
}

// set the update time label.
-(void)setUpdateTime:(NSDate *)date
{
    
    NSString* color = nil;
    NSTimeInterval late=[date timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSTimeInterval gap=now-late;
    double timeGap = gap/60;
    if(timeGap>=UPDATE_INTERVAL)
    {
        color = @"red";
    }
    else
    {
        color = @"green";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm:ss"];
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    [NSString stringWithString:[self.webView stringByEvaluatingJavaScriptFromString:
                                [NSString stringWithFormat:@"setUpdated('%@','%@');",formattedDateString,color]]];
}

@end
