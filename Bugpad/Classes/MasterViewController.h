//
//  MasterViewController.h
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    
    DetailViewController *detailViewController;
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

- (void)insertNewObject:sender;

@end
