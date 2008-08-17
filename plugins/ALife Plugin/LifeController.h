//
//  LifeController.h
//  ALife Plugin
//

#import <Cocoa/Cocoa.h>
#import "ALifeController.h"

@class LifeModel, LifeView, StatisticsCollector;

@interface LifeController : NSObject <ALifeController> {
	LifeModel *simulation;
	LifeView *view;
	StatisticsCollector *statistics;
	NSDictionary *properties;
	// add instance variables here
}

@property (readonly) NSDictionary *properties;

// add method declarations here

@end
