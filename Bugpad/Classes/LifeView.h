//
//  LifeView.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALifeSimulation;

@interface LifeView : UIView {
	ALifeSimulation *simulation;
}

@property (nonatomic, retain) ALifeSimulation *simulation;

@end
