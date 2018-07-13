//
//  SUProfileViewController.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/12/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "SUProfileViewController.h"
#import "Parse.h"
#import "PostCollectionCell.h"
#import "Post.h"

@interface SUProfileViewController ()

@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *postsCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *bio;
@property (strong, nonatomic) NSArray *instaPosts;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@end

@implementation SUProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.profileImage.file = self.user[@"profileImage"];
    [self.profileImage loadInBackground];
    self.bio.text = self.user[@"bio"];
    
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
    
    [query whereKey:@"author" equalTo:self.user];
    
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

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"SUPostCollectionCell" forIndexPath:indexPath];
    
    Post *post = self.instaPosts[indexPath.item];
    self.name.text = self.user[@"name"];
    cell.imageSUPost.file = post[@"image"];
    [cell.imagePost loadInBackground];
    self.postsCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.instaPosts.count];
    
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.instaPosts.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
