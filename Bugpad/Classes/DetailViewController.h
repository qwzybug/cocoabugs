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

#import <QuartzCore/QuartzCore.h>

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIScrollViewDelegate> {
    
    UIPopoverController *popoverController;
    UINavigationBar *navigationBar;
    
    NSManagedObject *detailItem;
	
	IBOutlet LifeView *lifeView;
	IBOutlet UIScrollView *scrollView;
	ALifeSimulation *simulation;
}

@property (nonatomic, retain) LifeView *lifeView;
@property (nonatomic, retain) ALifeSimulation *simulation;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSManagedObject *detailItem;

- (IBAction)insertNewObject:sender;
- (IBAction)tickAction:sender;

@end
