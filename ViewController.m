//
//  ViewController.m
//  Digi Stadium
//
//
//  This class is for the swiping menu.
//
//  Created by Hao Zhang on 15/06/2013.
//  Copyright (c) 2013 Informatics. All rights reserved.
//


#import "ViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "Cell1.h"
#import "Cell2.h"
@interface ViewController()<UITableViewDataSource,UITableViewDelegate>
{
    //the data list contains all of the data in the swiping menu.
    NSMutableArray *_dataList;
    //previous selected row.
    NSInteger _previouslySelectedRow;
    //previous selected section.
    NSInteger _previouslySelectedSection;

}
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;

@property (nonatomic,retain)IBOutlet UITableView *expansionTableView;
@end

@implementation ViewController
@synthesize isOpen,selectIndex;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        
    }
    return self;
}
// Called after the view has been loaded.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"MenuData" ofType:@"plist"];
    _dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];
     _previouslySelectedRow = -1 ;
    _previouslySelectedSection = -1;
    self.expansionTableView.sectionFooterHeight = 0;
    self.expansionTableView.sectionHeaderHeight = 0;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.expansionTableView setTableFooterView:view];
    self.isOpen = NO;
}
// return the number of first level items.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}
// return the number of rows in one particular section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section == section) {
            return [[[_dataList objectAtIndex:section] objectForKey:@"list"] count]+1;;
        }
    }
    return 1;
}

// set the height for a row.
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

// return the cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *CellIdentifier = @"Cell2";
        Cell2 *cell = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSArray *list = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"list"];
        cell.titleLabel.text = [list objectAtIndex:indexPath.row-1];
        
        NSArray *icons = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"icons"];
        NSString *icon =[icons objectAtIndex:indexPath.row-1];
        cell.menuImageView.image = [UIImage imageNamed:icon];
        
        NSArray *status = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"status"];
        NSString *sta = [status objectAtIndex:indexPath.row-1];
        if([sta intValue]==0 )
        {
            cell.developingImageView.hidden = YES;
        }
        else
        {
            cell.developingImageView.hidden = NO;
        }
        
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"Cell1";
        Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        cell.titleLabel.text = name;
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}

// called when a row has been selected.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else
    {
        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
        NSArray *list = [dic objectForKey:@"views"];
        NSString *item = [list objectAtIndex:indexPath.row-1];
        [self openView:item section:indexPath.section row:indexPath.row-1];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView setContentOffset:CGPointZero animated:YES];
}

// set the background color for the first level items.
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==0) {
        cell.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:57.0/255.0 blue:166.0/255.0 alpha:1.0];
    }
}

// open a particular view.
-(void)openView:(NSString *) viewName
        section:(NSInteger) sectionNumber
            row:(NSInteger) rowNumber
{
    
    SWRevealViewController *revelController = self.revealViewController;
    
    if(sectionNumber == _previouslySelectedSection && rowNumber==_previouslySelectedRow)
    {
        [revelController revealToggleAnimated:YES];
        return;
    }
    
    _previouslySelectedRow = rowNumber;
    _previouslySelectedSection = sectionNumber;
    
    
    UIViewController *viewController = nil;
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    [mainViewController openView:viewName];
    viewController = mainViewController;

    [revelController setFrontViewPosition:FrontViewPositionLeft animated:YES];
}

//  called when a row has been selected.
- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    Cell1 *cell = (Cell1 *)[self.expansionTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.expansionTableView beginUpdates];
    
    int section = self.selectIndex.section;
    int contentCount = [[[_dataList objectAtIndex:section] objectForKey:@"list"] count];
	NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
	for (NSUInteger i = 1; i < contentCount + 1; i++) {
		NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
		[rowToInsert addObject:indexPathToInsert];
	}
	
	if (firstDoInsert)
    {   [self.expansionTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
	else
    {
        [self.expansionTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
	
	[self.expansionTableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.expansionTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.expansionTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}


@end
