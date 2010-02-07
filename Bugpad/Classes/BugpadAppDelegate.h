//
//  BugpadAppDelegate.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class MasterViewController;
@class DetailViewController;

@interface BugpadAppDelegate : NSObject <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
    UIWindow *window;

	UISplitViewController *splitViewController;

	MasterViewController *masterViewController;
	DetailViewController *detailViewController;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic,retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic,retain) IBOutlet MasterViewController *masterViewController;
@property (nonatomic,retain) IBOutlet DetailViewController *detailViewController;

- (NSString *)applicationDocumentsDirectory;

@end
