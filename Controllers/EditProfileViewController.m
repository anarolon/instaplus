//
//  EditProfileViewController.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/12/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ParseUI.h"
#import "Parse.h"

@interface EditProfileViewController ()

@property (strong, nonatomic) PFUser *currUser;
@property (weak, nonatomic) IBOutlet PFImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currUser = [PFUser currentUser];
    self.imageView.file = ([PFUser currentUser])[@"profileImage"];
    [self.imageView loadInBackground];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Load Camera or library
- (IBAction)onTapImage:(id)sender {
    
    // Instantiate Image picker controller
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

// Once the image has been taken
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    self.imageView.image = [self resizeImage:editedImage withSize: CGSizeMake(1024 , 768)];
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)onExit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)onSaveChanges:(id)sender {
    
    PFFile *profilePic = [PFFile fileWithName:@"profilePic" data:UIImagePNGRepresentation(self.imageView.image)];
    self.currUser[@"profileImage"] = profilePic;
    [self.currUser saveInBackground];
    [self.delegate editProfileViewController:self editedProfileWithInfo:nil username: nil biography:nil profilePic:self.imageView.image];
    [self dismissViewControllerAnimated:YES completion:nil];
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
