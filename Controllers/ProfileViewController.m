//
//  ProfileViewController.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/11/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse.h"
#import "PostCollectionCell.h"
#import "Post.h"

@interface ProfileViewController ()

@property (strong, nonatomic) NSArray *instaPosts;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCount;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;


@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.profilePicture.file = ([PFUser currentUser])[@"profileImage"];
    [self.profilePicture loadInBackground];
    
    [self fetchPosts];
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    
    CGFloat posterPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (posterPerLine - 1))/posterPerLine;
    layout.itemSize = CGSizeMake(itemWidth, itemWidth);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Fetch posts for current user
- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    
    NSLog(@"%@", [PFUser currentUser].username);
    
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            NSLog(@"Successfully retrieved posts");
            self.instaPosts = posts;
            NSLog(@"Posts: %lu", (unsigned long)self.instaPosts.count);
            
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
        [self.collectionView reloadData];
    }];
}

- (void) editProfileViewController: (EditProfileViewController *)controller editedProfileWithInfo: (NSString *)name username: (NSString *) newUsername biography: (NSString *) bio profilePic:(UIImage *)image{
    self.profilePicture.image = image;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationC = [segue destinationViewController];
    EditProfileViewController *editProfileVC = (EditProfileViewController *) navigationC.topViewController;
    editProfileVC.delegate = self;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.instaPosts[indexPath.item];
    cell.imagePost.file = post.image;
    [cell.imagePost loadInBackground];
    self.usernameLabel.text = [PFUser currentUser].username;
    self.postCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.instaPosts.count];
    
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.instaPosts.count;
}

@end
