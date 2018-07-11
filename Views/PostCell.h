//
//  PostCell.h
//  instaplus
//
//  Created by Chaliana Rolon on 7/9/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI.h"

@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionText;
@property (weak, nonatomic) IBOutlet UILabel *timestampText;
@property (weak, nonatomic) IBOutlet UILabel *userText;

- (void) refreshCell;

@end
