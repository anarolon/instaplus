//
//  SUProfileViewController.h
//  instaplus
//
//  Created by Chaliana Rolon on 7/12/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

@interface SUProfileViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) PFUser *user;

@end
