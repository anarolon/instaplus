//
//  FeedViewController.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/9/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "FeedViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Parse.h"
#import "PostCell.h"
#import "Post.h"
#import "DetailsViewController.h"
#import "DateTools.h"

@interface FeedViewController ()

@property (strong, nonatomic) NSArray *instaPosts;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setRowHeight: 500];
    self.instaPosts = [[NSArray alloc] init];
    
     [self fetchPosts];
    
    // Initialize a UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.instaPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PostCell"];
    
    Post *post = self.instaPosts[indexPath.row];
    
    cell.userText.text = post.author.username;
    cell.postImageView.file = post.image;
    [cell.postImageView loadInBackground];
    cell.captionText.text = post.caption;
    cell.timestampText.text = [post.createdAt timeAgoSinceNow];
    cell.profilePic.file = post.author[@"profileImage"];
    [cell.profilePic loadInBackground];
    if(post.likeCount.integerValue != 0) {
        cell.likeCount.text = [NSString stringWithFormat:@"%li likes", (long) post.likeCount.integerValue];
    } else {
        cell.likeCount.text = @"0 likes";
    }
    return cell;
}


- (IBAction)onLogout:(id)sender {
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        
        if(error != nil) {
            NSLog(@"Logout unseccessful: %@", error.localizedDescription);
        } else {
            NSLog(@"Logout successful");
            
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
        }

    }];
}

- (IBAction)onFavorite:(id)sender {
    
    
}

- (IBAction)onCompose:(id)sender {
    [self performSegueWithIdentifier:@"Compose" sender:self];
    NSLog(@"Ready to compose");
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            NSLog(@"Successfully retrieved posts");
            self.instaPosts = posts;
            NSLog(@"Posts: %@", self.instaPosts);
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.tableView reloadData];
    }];
}

// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    [self fetchPosts];
    
    // Reload the tableView now that there is new data
    [self.tableView reloadData];
    
    // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}

// TODO
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Handle scroll behavior
    if(!self.isMoreDataLoading) {
        self.isMoreDataLoading = YES;
        
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = true;
            // Load more results
            [self fetchPosts];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Details"]) {
        PostCell *tappedCell = sender;
        NSIndexPath *indexPath =  [self.tableView indexPathForCell:tappedCell];
        Post *post = self.instaPosts[indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.postDetails = post;
        NSLog(@"Tapping on a post");
        [tappedCell setSelected:NO];
    }
}

@end
