//
//  ComposeViewController.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/9/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "ComposeViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "MBProgressHUD.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Cancel compose
- (IBAction)onCancel:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)alertAction:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // handle response here.
    }];
    
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
        // optional code for what happens after the alert controller has finished presenting
    }];
    
}

// Share image
- (IBAction)onShare:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if(self.composedImage != nil) {
        NSLog(@"Ready to Share Post");
        
        [Post postUserImage:self.composedImage.image withCaption:self.composedCaption.text withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if(error != nil) {
                NSLog(@"Unable to post: %@", error.localizedDescription);
                [self alertAction:@"Image Upload Error" message:@"Couldn't upload image;"];
            } else {
                NSLog(@"Successfully created post");
                [MBProgressHUD showHUDAddedTo:self.view animated:NO];
                [self dismissViewControllerAnimated:NO completion:nil];
            }
        }];
    } else {
        [self alertAction:@"Error" message:@"Image required"];
    }
}

// Present Image Picker/Camera
- (IBAction)onTapImage:(id)sender {
    
    NSLog(@"Tapped to take image");
    
    // Instantiate a UIImagePickerController
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

// Delegate method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    [self.composedImage setImage:editedImage];
    [self resizeImage:self.composedImage.image withSize:CGSizeMake(50, 50)];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
