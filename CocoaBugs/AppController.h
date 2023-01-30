//
//  AppController.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 6/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ALifeConfigurationWindowController.h"
#import "ALifeWindowController.h"

@interface AppController : NSObject <ALifeConfigurationControllerDelegate, ALifeWindowControllerDelegate>

@property (nonatomic, strong) NSMutableArray <NSWindowController *> *windowControllers;

- (IBAction)showConfigurationWindow:(id)sender;

@end
