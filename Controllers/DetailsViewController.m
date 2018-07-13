//
//  DetailsViewController.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/10/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "DetailsViewController.h"
#import "DateTools.h"
#import "ParseUI.h"
#import "SUProfileViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *captionText;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profilePic;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.postDetails.image getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        self.imageView.image = [UIImage imageWithData:data];
    }];
    self.usernameLabel.text = self.postDetails.author.username;
    self.captionText.text = self.postDetails.caption;
    self.timestamp.text = [self.postDetails.createdAt timeAgoSinceNow];
    if(self.postDetails.likeCount.integerValue != 0) {
        self.likeLabel.text = [NSString stringWithFormat:@"%li", (long) self.postDetails.likeCount.integerValue];
    }
    self.profilePic.file = self.postDetails.author[@"profileImage"];
    [self.profilePic loadInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onImageTap:(id)sender {
    [self performSegueWithIdentifier:@"SUProfile" sender:sender];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SUProfileViewController *someUserProfile = [segue destinationViewController];
    someUserProfile.user = self.postDetails.author;
    
}


@end
