//
//  TwitterTableViewController.m
//  Digi Stadium
//
//  This is for a twitter table view.
//
//  Created by Hao Zhang on 03/07/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//

#import "TwitterTableViewController.h"
#import "TweetCell.h"
#import "TweetData.h"
#import "CJSONDeserializer.h"

@implementation TwitterTableViewController

// set the data set of tweets.
- (void)setDataSource:(NSMutableArray *) data
{
    tweetsList = data;
}

//  set the twitter table by url and decide if use the default image for the profile.
- (void)setTwitterTableURL:(NSString *) url useDefaultImage:(BOOL) b
{
    TWITTER_URL = url;
    useDefaultImage = b;
}

// called when cache data was received by twitter table.
// the event is sent by UI Update Centre in Cache Module.
-(void)messageCallBack:(CacheData *)data
{
    if(data ==nil || ![data.url isEqualToString:TWITTER_URL])
    {
        return;
    }
    [self fillTableView:data.content];
    lastDate = data.updateTime;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            _reloading = NO;
        });
    });
}

// this is used to update the friendly screen time every 30 seconds.
-(void)timerTicked:(NSTimer *)timer
{
    @synchronized(tweetsList)
    {
        for(TweetData *td in tweetsList)
        {
            td.time=[utility getScreenTime:td.realtime];
        }
        [self.tableView reloadData];
    }
}

// called when the view has been loaded.
- (void)viewDidLoad {
    [super viewDidLoad];
	utility = [[UtilityFunction alloc] init];
	if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
        tweetsList = [NSMutableArray array];
        uiUpdateCentre = [UIUpdateCentre alloc];
        // register in the ui update centre.
        [uiUpdateCentre addDelegate:(id)self];
        CacheData * data = [uiUpdateCentre getUIContent:TWITTER_URL onlyGetFromInternet:YES];
        [self fillTableView:data.content];
        lastDate = data.updateTime;
        [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timerTicked:) userInfo:nil repeats:YES];
    }
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
	
}

// use the JSON string to fill the twitter table view.
-(void)fillTableView:(NSString *)jsonString
{
    NSMutableArray *tList = [NSMutableArray array];
    NSError *error;
    NSArray * list= [[CJSONDeserializer deserializer] deserializeAsArray:[jsonString dataUsingEncoding:NSUTF8StringEncoding] error:&error];
                                                                                                                                                                                                                                                                                                                                                                  
    if(list == nil)
    {
        return;
    }
    for(NSDictionary *l in list)
    {
        TweetData * td = [TweetData alloc];
        NSDictionary * user = [l objectForKey:@"user"];
        td.name = [user objectForKey:@"name"];
        td.nickname = [user objectForKey:@"screenName"];
        if([[user allKeys] containsObject:@"profileImage"])
        {
            NSString * imageString =[user objectForKey:@"profileImage"];
            NSString *str = @"data:image/png;base64,";
            str = [str stringByAppendingString:imageString];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            td.image = [[UIImage alloc]initWithData:imageData];
        }
        else
        {
            td.image = nil;
        }
        td.realtime = [l objectForKey:@"createdAt"];
        td.time =[utility getScreenTime:td.realtime];
        td.tweet = [l objectForKey:@"text"];
        [tList addObject:td];
        
    }
    
    [self setDataSource:tList];
    
}

// return the number of the tweets.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tweetsList.count;
}

//return the tweet cell.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TweetCell";
    if([utility.getDeviceName isEqualToString:@"mini"])
    {
        CellIdentifier  =  @"TweetCellForMiniPad";
    }
    
    TweetCell *cell = (TweetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    // cell.menuImageView.image = [UIImage imageNamed:icon];
    TweetData * td = [tweetsList objectAtIndex:indexPath.row];
    cell.tweet.text = [NSString stringWithFormat:@"%@", td.tweet];
    cell.nickname.text = [NSString stringWithFormat:@"%@", td.nickname];
    cell.name.text = [NSString stringWithFormat:@"%@", td.name];
    cell.time.text = [NSString stringWithFormat:@"%@", td.time];
    if(!useDefaultImage && td.image != nil)
    {
        cell.image.image = td.image;
    }
    return cell;
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

// return 'depth' of row for hierarchies
- (NSInteger) tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

// return the height of the tweet cell.
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetData * td = [tweetsList objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size = [td.tweet sizeWithFont:font constrainedToSize:CGSizeMake(utility.getDeviceWidth-20, 1000)
                           lineBreakMode:UILineBreakModeWordWrap];
    return size.height+70;
}

// reload data
- (void)reloadTableViewDataSource{
    _reloading =YES;
    [uiUpdateCentre getUIContent:TWITTER_URL onlyGetFromInternet:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerLoaded:) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(timerTimeout:) userInfo:nil repeats:NO];
}

// reload time out.
-(void)timerTimeout:(NSTimer *)timer
{
    _reloading =NO;
}

// check if the reloading has been done every second. 
-(void)timerLoaded:(NSTimer *)timer
{
    if(!_reloading)
    {
        [self performSelector:@selector(doneLoadingTableViewData) withObject:nil];
        [timer invalidate];
    }
}

// called when the reloading has done.
- (void)doneLoadingTableViewData{
	
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    if(view == nil)
        return NO;
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return lastDate; // should return date data source was last changed
	
}


#pragma mark -
#pragma mark Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	_refreshHeaderView=nil;
}

- (void)dealloc {
	
	_refreshHeaderView = nil;
}


@end

