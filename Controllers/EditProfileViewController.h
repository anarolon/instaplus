//
//  EditProfileViewController.h
//  instaplus
//
//  Created by Chaliana Rolon on 7/12/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditProfileViewController;

@protocol EditProfileViewControllerDelegate

- (void) editProfileViewController: (EditProfileViewController *)controller editedProfileWithInfo: (NSString *)name username: (NSString *) newUsername biography: (NSString *) bio profilePic: (UIImage *) image;
@end

@interface EditProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) id<EditProfileViewControllerDelegate> delegate;

@end
