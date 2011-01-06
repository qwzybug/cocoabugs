//
//  BPOptionsViewController.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALifeSimulation.h"

@protocol BPOptionsViewControllerDelegate;

@interface BPOptionsViewController : UIViewController {
	id <BPOptionsViewControllerDelegate> delegate;
	
	IBOutlet UIScrollView *scrollView;
	
	NSArray *configurationViews;
	
	ALifeSimulation *simulation;
}

@property (nonatomic, assign) id <BPOptionsViewControllerDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSArray *configurationViews;

@property (nonatomic, retain) ALifeSimulation *simulation;

- (void)updateDisplay;

@end


@protocol BPOptionsViewControllerDelegate
- (void)optionsViewControllerDidCancel:(BPOptionsViewController *)controller;
@end