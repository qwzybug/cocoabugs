//
//  BPEditBitmapViewController.h
//  Bugpad
//
//  Created by Devin Chalmers on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BPEditBitmapViewControllerDelegate;

@class PixelImage;
@class BPEditBitmapView;

@interface BPEditBitmapViewController : UIViewController {

}

@property (nonatomic, retain) IBOutlet BPEditBitmapView *imageView;

@property (nonatomic, assign) id<BPEditBitmapViewControllerDelegate> delegate;
@property (nonatomic, retain) PixelImage *bitmap;

- (id)initWithBitmap:(PixelImage *)bitmap;

- (IBAction)cancelAction:(id)sender;
- (IBAction)doneAction:(id)sender;

@end


@protocol BPEditBitmapViewControllerDelegate

- (void)editBitmapViewController:(BPEditBitmapViewController *)controller finishedEditingWithBitmap:(PixelImage *)bitmap;
- (void)editBitmapViewControllerCancelled:(BPEditBitmapViewController *)controller;

@end