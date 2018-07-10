//
//  Post.m
//  instaplus
//
//  Created by Chaliana Rolon on 7/9/18.
//  Copyright © 2018 Chaliana Rolon. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic postID;
@dynamic userID;
@dynamic author;
@dynamic caption;
@dynamic image;
@dynamic likeCount;
@dynamic commentCount;

+ (nonnull NSString *)parseClassName {
    return @"Post";
}


/**
 Method to add a user post to Parse (uploading image file)
 
 - parameter image: Image that the user wants upload to parse
 - parameter caption: Caption text input by the user
 - parameter completion: Block to be executed after save operation is complete
 */
+ (void) postUserImage: ( UIImage * _Nullable )image withCaption: ( NSString * _Nullable )caption withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Post *newPost = [Post new];
    newPost.image = [self getPFFileFromImage:image];
    newPost.author = [PFUser currentUser];
    newPost.caption = caption;
    newPost.likeCount = @(0);
    newPost.commentCount = @(0);
    
    [newPost saveInBackgroundWithBlock: completion];
}

/**
 Method to convert UIImage to PFFile
 
 - parameter image: Image that the user wants to upload to parse
 
 - returns: PFFile for the the data in the image
 */
+ (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

@end
