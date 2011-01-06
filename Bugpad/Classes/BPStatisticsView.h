//
//  BPStatisticsView.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "StatisticsData.h"

@interface BPStatisticsView : UIView {
	StatisticsData *data;
}

@property (nonatomic, retain) StatisticsData *data;

@end
