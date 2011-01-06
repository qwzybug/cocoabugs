//
//  BitmapOptionView.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALifeSimulation.h"

#import "BPEditBitmapViewController.h"

@interface BitmapOptionView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate, BPEditBitmapViewControllerDelegate> {
	UILabel *label;
	UIImageView *imageView;
	UIImagePickerController *imagePicker;
	UIPopoverController *popover;
	
	ALifeSimulation *simulation;
	NSDictionary *configuration;
}

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIImagePickerController *imagePicker;
@property (nonatomic, retain) UIPopoverController *popover;

@property (nonatomic, retain) ALifeSimulation *simulation;
@property (nonatomic, retain) NSDictionary *configuration;

- (id)initWithFrame:(CGRect)frame configuration:(NSDictionary *)configuration simulation:(ALifeSimulation *)simulation;

- (IBAction)editAction:(id)sender;
- (IBAction)addAction:(id)sender;

- (IBAction)imageButtonAction:sender;

@end
