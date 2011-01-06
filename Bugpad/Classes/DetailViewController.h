//
//  DetailViewController.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "LifeView.h"
#import "ALifeSimulation.h"

#import "BPOptionsViewController.h"
#import "BPStatisticsViewController.h"

#import "BPEditBitmapViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIScrollViewDelegate, BPEditBitmapViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UINavigationBar *navigationBar;
	
	IBOutlet UIToolbar *toolbar;
    
    NSManagedObject *detailItem;
	
	IBOutlet LifeView *lifeView;
	IBOutlet UIScrollView *scrollView;
	ALifeSimulation *simulation;
	
	UIViewController *accessoryViewController;
	BPOptionsViewController *optionsViewController;
	BPStatisticsViewController *statisticsViewController;
	
	IBOutlet UIBarButtonItem *playButton;
	IBOutlet UIBarButtonItem *pauseButton;
	
	NSTimer *runTimer;
}

@property (nonatomic, retain) LifeView *lifeView;
@property (nonatomic, retain) ALifeSimulation *simulation;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *playButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *pauseButton;
@property (nonatomic, retain) NSTimer *runTimer;

@property (nonatomic, retain) BPOptionsViewController *optionsViewController;
@property (nonatomic, retain) BPStatisticsViewController *statisticsViewController;

@property (nonatomic, retain) NSManagedObject *detailItem;

- (IBAction)insertNewObject:sender;
- (IBAction)playAction:sender;
- (IBAction)pauseAction:sender;
- (IBAction)tickAction:sender;
- (IBAction)reseedAction:(id)sender;

- (IBAction)selectorAction:sender;

@end
