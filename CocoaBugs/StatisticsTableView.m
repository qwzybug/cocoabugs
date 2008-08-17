//
//  StatisticsTableView.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 8/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "StatisticsTableView.h"


@implementation StatisticsTableView

@synthesize statisticsViews;

- (void)awakeFromNib;
{
	self.delegate = self;
	self.dataSource = self;
}

- (void)drawRow:(NSInteger)rowIndex clipRect:(NSRect)clipRect;
{
	[[self.statisticsViews objectAtIndex:rowIndex] drawRect:clipRect];
}

- (NSInteger)numberOfRows;
{
	return [self.statisticsViews count];
}



@end
