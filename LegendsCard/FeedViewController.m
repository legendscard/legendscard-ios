//
//  FeedViewController.m
//  LegendsCard
//
//  Created by Josh Sklar on 6/21/12.
//  Copyright (c) 2012 Sklar. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedPost.h"
#import "SVProgressHUD.h"
#import "NSBundle+LoadNib.h"
#import "CacheController.h"
#import "EGORefreshTableHeaderView.h"
#import "FeedTableCell.h"

@interface FeedViewController () <EGORefreshTableHeaderDelegate>
{
@private
    //For pullToRefresh
	EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
}

/* view lifecycle methods */
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewDidUnload;
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

/* FeedController delegate methods */
-(void)didRecieveAllTweets:(NSArray*)results;
-(void)didRecieveAllUsersPosts:(NSArray*)results;
-(void)showTheHud;
-(void)displayErrorMessage;
-(void)informUserAboutSwitch;

/* UITableView delegate methods */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/* pull to refresh methods */
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;

/* internal methods */
- (void)initPullToRefresh;
- (void)onRecievedFirstDataSet;
- (void)loadMorePosts;
- (BOOL)containsLink:(NSString*)text;
- (NSURL*)getURL:(NSString*)text;


/* UI elements */
@property IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;
@property (strong, nonatomic) UIActivityIndicatorView *refreshAct;
@property (strong, nonatomic) UIBarButtonItem *refreshActButton;

@property (strong, nonatomic) NSArray *allTweets;
@property (strong, nonatomic) NSArray *sortedArray;
@property NSInteger defaultFeedPosts;
@property (strong, nonatomic) CacheController *assetManager;

@end

@implementation FeedViewController

@synthesize feedCont;
@synthesize allTweets, sortedArray;
@synthesize tableView = _tableView;
@synthesize defaultFeedPosts;
@synthesize didReceiveFirstDataSet;
@synthesize assetManager;
@synthesize refreshButton, refreshAct, refreshActButton;

#pragma mark - Lifecycle methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Feed";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initPullToRefresh];
    
    /* create the cache */
    self.assetManager = [[CacheController alloc]init];
    
    self.defaultFeedPosts = 20;
    
    /* set up table view */
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    sortedArray = [[NSArray alloc]initWithArray:nil];
    
    self.didReceiveFirstDataSet = NO;
    
    feedCont = [[FeedController alloc]init];
    feedCont.delegate = self;
    
    [self fetchData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fetchData
{
    [self showTheHud];
    
    self.didReceiveFirstDataSet = NO;
    [feedCont fetchAllPosts];
}

#pragma mark - FeedControllerDelegate methods

- (void)didRecieveAllTweets:(NSArray *)results
{
    NSLog(@"recieved twitter posts!");
    //displaying the inform View
    if (results == nil) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
        label.center = self.navigationController.view.center;
        label.numberOfLines = 2;
        label.layer.cornerRadius = 4.0f;
        label.text = @"Error from Twitter. Only displaying users #posts.";
        [label setAppFont:15];
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 0.5;
        [self.navigationController.view addSubview:label];
        [label partialFadeWithDuration:0.5 afterDelay:0 withFinalAlpha:1.0 completionBlock:^(BOOL finished){
            [label partialFadeWithDuration:0.5 afterDelay:1.0 withFinalAlpha:0.0 completionBlock:^(BOOL finished){}];
        }];
        ;
    }
    
    self.tableView.hidden = NO;
    
    allTweets = results;
    
    if (self.didReceiveFirstDataSet) {
        [self onRecievedFirstDataSet];
    }
    
    self.didReceiveFirstDataSet = YES;
}

- (void)didRecieveAllUsersPosts:(NSArray *)results
{
    NSLog(@"recieved users posts!");
    
    if (self.didReceiveFirstDataSet) {
        [self onRecievedFirstDataSet];
    }
    
    self.didReceiveFirstDataSet = YES;
}

-(void)showTheHud
{
    if (sortedArray == nil || [sortedArray count] ==  0) {
        [SVProgressHUD showWithStatus:@"Loading Feed" maskType:SVProgressHUDMaskTypeGradient];
    }
}

- (void)displayErrorMessage
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Error From Twitter"
                          message: @"Over 150 requests from this device in the past hour. Try again in one hour."
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}

-(void)informUserAboutSwitch {
    /* assert type check */
    [[[UIAlertView alloc]initWithTitle:@"Switched" message:@"Now is fetching tweets using Apple's way" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

#pragma mark - TableView delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if ([sortedArray count] < defaultFeedPosts) {
       return [sortedArray count];
  }

   return defaultFeedPosts;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    FeedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadFromNib:@"FeedTableCell" withClass:[FeedTableCell class]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* for the 'Load More' button */
    if (indexPath.row == defaultFeedPosts-1) {
        UIButton *loadMore = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 97, 36)];
        loadMore.center = cell.center;
        [loadMore setImage:[UIImage imageNamed:@"loadmore.png"] forState:UIControlStateNormal];
        [loadMore addTarget:self action:@selector(loadMorePosts) forControlEvents:UIControlEventTouchUpInside];
        [cell showIndicator:NO];
        [cell addSubview:loadMore];
        return cell;
    }
    
    FeedPost *p = [sortedArray objectAtIndex:indexPath.row];
    
    /* pull a post out of the array, initialize it into each cell */
    
    UIView *overlay = [[UIView alloc]initWithFrame:CGRectMake(0, 170, 320, 90)];
    overlay.alpha = 0.55f;
    [cell addSubview:overlay];
    
    if (sortedArray == nil || [sortedArray count] == 0) {
        [cell setName:@""];
        [cell setText:@""];
    }
    else {
        /* the picture for this post has already been fetched and loaded into memory */
        if ([p pic]) {
            [cell setPicture:[p pic]];
            [cell showIndicator:NO];
        }
        /* we need to fetch the picture, either from the network or in memory cache */
        else {
            [cell showIndicator:YES];
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                /* fetching from twitter */
                if ([[p type] isEqualToString:@"twitter"]) {
                    NSData *data;
                    if ([self.assetManager localURLForAssetURL:[p picURL]]) {
                        data = [NSData dataWithContentsOfURL:[self.assetManager localURLForAssetURL:[p picURL]]];
                    }
                    else {
                        data = [NSData dataWithContentsOfURL:[p picURL]];
                        [self.assetManager queueAssetForRetrievalFromURL:[p picURL] withData:data];
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        UIImage *profilePic = [[UIImage alloc] initWithData:data];
                        [cell setPicture:profilePic];
                        p.pic = profilePic;
                        [cell showIndicator:NO];
                    });
                }
                /* fetching from facebook */
                else {
                    
                    NSURL *decoyURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.%@.com",[p uID]]];
                    
                    /* it is in the cache */
                    if ([self.assetManager localURLForAssetURL:decoyURL]) {
                        dispatch_async(dispatch_get_main_queue(), ^ {
                            UIImage *profilePic = [UIImage imageWithData:[NSData dataWithContentsOfURL:[self.assetManager localURLForAssetURL:decoyURL]]];
                            [cell setPicture:profilePic];
                            p.pic = profilePic;
                            [cell showIndicator:NO];
                        });
                    }
                    /* it is not in the cache, and needs to be fetched from the network */
                    else {
                        /* check if it's a LegendsCard admin account, or the user has registered with their email */
                        if ([[p uID] isEqualToString:LC_LOGO_NAME] || [[p uID] isEqualToString:EMAIL_LOGIN_FB_ID]) {
                            dispatch_async(dispatch_get_main_queue(), ^ {
                                UIImage *profilePic = [UIImage imageNamed:@"LC-logo-wide"];
                                [cell setPicture:profilePic];
                                p.pic = profilePic;
                                [cell showIndicator:NO];
                            });
                        }
                        else {
                            NSString *urlStr = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", [p uID]];
                            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
                            dispatch_async(dispatch_get_main_queue(), ^ {
                                UIImage *profilePic = [UIImage imageWithData:imageData];
                                [cell setPicture:profilePic];
                                p.pic = profilePic;
                                [cell showIndicator:NO];
                            });
                            [self.assetManager queueAssetForRetrievalFromURL:decoyURL withData:imageData];
                        }
                    }
                }
            });
        }
        
        if ([[p type] isEqualToString:@"twitter"]) {
            overlay.backgroundColor = [UIColor blackColor];
            [cell setCellTextColor:[UIColor whiteColor]];
        }
        else {
            overlay.backgroundColor = [UIColor whiteColor];
            [cell setCellTextColor:[UIColor blackColor]];
        }
        [cell setName:[p name]];
        [cell setText:[p text]];
        [cell setDate:[p date]];
        [cell setCellPost:p];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [User sharedInstance];
    if ([[[sortedArray objectAtIndex:indexPath.row] uID] isEqualToString:user.uID]) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([self containsLink:[[sortedArray objectAtIndex:indexPath.row] text]]) {
        NSLog(@"Post contains a link");
//        PersonViewController *person = [[PersonViewController alloc]init];
//        person.post = [sortedArray objectAtIndex:indexPath.row];
//        person.theURL = [self getURL:[[sortedArray objectAtIndex:indexPath.row] text] ];
//        [self presentModalViewController:person animated:YES];
    }
    else {
        NSLog(@"Post does not contain a link");
                return;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 268.0f;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedPost *p = [sortedArray objectAtIndex:indexPath.row];
    User *user = [User sharedInstance];
    if (![[p uID] isEqualToString:user.uID]) {
        [[[UIAlertView alloc]initWithTitle:@"Whoops" message:@"Can't delete other people's #posts." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        return;
    }
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:sortedArray];
        [temp removeObject:p];
        sortedArray = nil;
        sortedArray = temp;
        self.defaultFeedPosts--;
        PFQuery *query = [PFQuery queryWithClassName:[NSString stringWithFormat:@"%@_feed",user.school]];
        [query getObjectInBackgroundWithId:p.postID block:^(PFObject *object, NSError *error) {
            /* go into parse and delete the post */
            [object deleteInBackground];
        }];

        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];      
    }      
}

#pragma mark - Pull to refresh methods

- (void)reloadTableViewDataSource
{
	NSLog(@"reloadTableViewDataSource method");
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    self.didReceiveFirstDataSet = NO;
    
    [feedCont fetchAllPosts];
   // [feedCont getTweetsContainingMention];

	_reloading = YES;
	
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];	
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0.0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return _reloading; // should return if data source model is reloading	
}

#pragma mark - Internal methods

- (void)initPullToRefresh
{
    /* set up pull to refresh */
   	if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
    }
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)onRecievedFirstDataSet
{
    NSArray *allPosts = [feedCont mergeTwitterAndUsersPosts:allTweets];
    sortedArray = [allPosts sortedArrayUsingSelector:@selector(compareDates:)];
    sortedArray = [[sortedArray reverseObjectEnumerator]allObjects];
    
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
    [SVProgressHUD dismiss];
    [self doneLoadingTableViewData];
    //self.refreshButton.enabled = YES;
    //self.navigationItem.rightBarButtonItem = self.refreshButton;
}

- (void)loadMorePosts
{
    defaultFeedPosts = defaultFeedPosts + 10;
    [self.tableView reloadData];
}

- (BOOL)containsLink:(NSString*)text
{
    if ([text rangeOfString:@"http" options:NSCaseInsensitiveSearch].location != NSNotFound) {
        return YES;
    }
    if ([text rangeOfString:@"www." options:NSCaseInsensitiveSearch].location != NSNotFound) {
        return YES;
    }
    return NO;
}

- (NSURL*)getURL:(NSString*)text
{
    NSArray *components = [text componentsSeparatedByString:@" "];
    for(int i=0; i < components.count;i++){
        if([[components objectAtIndex:i] rangeOfString:@"http:" options:NSCaseInsensitiveSearch].location != NSNotFound)
            return [NSURL URLWithString:[components objectAtIndex:i]];
        if ([[components objectAtIndex:i] rangeOfString:@"www." options:NSCaseInsensitiveSearch].location != NSNotFound) {
            NSString *newStr = [NSString stringWithFormat:@"%@%@",@"http://",[components objectAtIndex:i]];
            return [NSURL URLWithString:newStr];
        }
    }
    return nil;
}



@end
