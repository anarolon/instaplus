//
//  DetailsViewController.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/10/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "DetailsViewController.h"
#import "DateTools.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *captionText;
@property (weak, nonatomic) IBOutlet UILabel *timestamp;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeLabel;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
