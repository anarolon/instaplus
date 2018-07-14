//
//  PostCell.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/9/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) refreshCell: (NSInteger *) count {
    
}

- (IBAction)onFavoriteTap:(id)sender {
    
    UIButton *button = sender;
    
    NSArray *users = [self.post objectForKey:@"likedUsers"];
    NSInteger *count = (NSInteger *)users.count;
    
    if([users containsObject:[PFUser currentUser]]) {
        [self.post removeObject:[PFUser currentUser] forKey:@"likedUsers"];
        count-=1;
        self.post[@"likeCount"] = [NSNumber numberWithInteger: (long) count];
        self.likeCount.text = [NSString stringWithFormat:@"%li likes", (long) count];
        NSLog(@"Un-Liked");
    } else if(![users containsObject:[PFUser currentUser]]) {
        [self.post addObject:[PFUser currentUser] forKey:@"likedUsers"];
        count+=1;
        self.post[@"likeCount"] = [NSNumber numberWithInteger: (long) count];
        self.likeCount.text = [NSString stringWithFormat:@"%li likes", (long) count];
        NSLog(@"Liked");
    }
    [self.post saveInBackground];
}


@end
