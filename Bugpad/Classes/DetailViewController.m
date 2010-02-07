//
//  DetailViewController.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"

@implementation DetailViewController

@synthesize navigationBar, popoverController, detailItem;

@synthesize lifeView;
@synthesize simulation;
@synthesize scrollView;

#pragma mark -
#pragma mark Object insertion

- (IBAction)insertNewObject:sender {
	
	MasterViewController *masterViewController = (MasterViewController *)[(UINavigationController *)[[self splitViewController] masterViewController] topViewController];
	[masterViewController insertNewObject:sender];	
}

- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	Class klass = NSClassFromString(@"World");
	simulation = [[klass alloc] initWithConfiguration:nil];
	
	lifeView.simulation = simulation;
	
	lifeView.frame = CGRectMake(0, 0, 500, 500);
	[scrollView addSubview:lifeView];
	lifeView.layer.shadowOffset = CGSizeMake(0, 5);
	lifeView.layer.shadowColor = [[UIColor blackColor] CGColor];
	lifeView.layer.shadowOpacity = 0.5;
	lifeView.layer.shadowRadius = 5;
	lifeView.layer.shouldRasterize = YES;
	
	scrollView.contentSize = lifeView.bounds.size;
	
	float vInset = (scrollView.bounds.size.height - lifeView.frame.size.height) / 2;
	float hInset = (scrollView.bounds.size.width - lifeView.frame.size.width) / 2;
	UIEdgeInsets insets = {.top = vInset, .left = hInset, .bottom = vInset, .right = hInset};
	scrollView.contentInset = insets;
}


#pragma mark -
#pragma mark Managing the popover controller

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.
 */
- (void)setDetailItem:(NSManagedObject *)managedObject {
    
	if (detailItem != managedObject) {
		[detailItem release];
		detailItem = [managedObject retain];
		
        // Update the view.
        navigationBar.topItem.title = [[detailItem valueForKey:@"timeStamp"] description];
	}
    
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }		
}



#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    
    barButtonItem.title = @"Options";
    [navigationBar.topItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    [navigationBar.topItem setLeftBarButtonItem:nil animated:YES];
    self.popoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
}


#pragma mark -
#pragma mark View lifecycle

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
 */

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.popoverController = nil;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
	
    [popoverController release];
    [navigationBar release];
	
	[detailItem release];
	
	[super dealloc];
}	

- (IBAction)tickAction:sender;
{
	[simulation update];
	[lifeView setNeedsDisplay];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return lifeView;
}

@end
