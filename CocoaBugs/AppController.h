//
//  AppController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeConfigurationWindowController.h"

@interface AppController : NSObject <ALifeConfigurationWindowControllerDelegate>

@property (nonatomic, strong) NSMutableArray <NSWindowController *> *windowControllers;

- (IBAction)showConfigurationWindow:(id)sender;

@end
