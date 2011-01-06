//
//  BPIntegerOptionView.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/7/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>

#import "ALifeSimulation.h"

@interface BPIntegerOptionView : UIView {
	UISlider *slider;
	UILabel *titleLabel;
	UILabel *valueLabel;
	
	ALifeSimulation *simulation;
	NSDictionary *configuration;
}

@property (nonatomic, retain) UISlider *slider;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *valueLabel;

@property (nonatomic, retain) ALifeSimulation *simulation;
@property (nonatomic, retain) NSDictionary *configuration;

- (id)initWithFrame:(CGRect)frame configuration:(NSDictionary *)configuration simulation:(ALifeSimulation *)simulation;

@end
