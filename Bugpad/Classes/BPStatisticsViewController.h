//
//  BPStatisticsViewController.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ALifeSimulation.h"

@interface BPStatisticsViewController : UITableViewController {
	NSArray *statisticsViews;
	NSArray *statisticsData;
	
	ALifeSimulation *simulation;
	
	NSTimer *timer;
}

- (id)initWithSimulation:(ALifeSimulation *)simulation;

@property (nonatomic, retain) NSArray *statisticsViews;
@property (nonatomic, retain) NSArray *statisticsData;

@property (nonatomic, retain) ALifeSimulation *simulation;
@property (nonatomic, retain) NSTimer *timer;

@end
