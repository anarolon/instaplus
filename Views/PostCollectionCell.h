//
//  PostCollectionCell.h
//  instaplus
//
//  Created by Chaliana Rolon on 7/11/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

@interface PostCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *imagePost;
@property (weak, nonatomic) IBOutlet PFImageView *imageSUPost;

@end
