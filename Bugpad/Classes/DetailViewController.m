//
//  DetailViewController.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/6/10.
//  Copyright Apple Inc 2010. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DetailViewController.h"
#import "MasterViewController.h"

@implementation DetailViewController

@synthesize navigationBar, popoverController, detailItem;

@synthesize lifeView;
@synthesize simulation;
@synthesize scrollView;
@synthesize playButton;
@synthesize pauseButton;
@synthesize runTimer;

@synthesize statisticsViewController;
@synthesize optionsViewController;

#pragma mark -
#pragma mark Object insertion

- (IBAction)insertNewObject:sender {
	
	MasterViewController *masterViewController = (MasterViewController *)[(UINavigationController *)[[self splitViewController] masterViewController] topViewController];
	[masterViewController insertNewObject:sender];	
}

- (void)viewDidLoad;
{
	[super viewDidLoad];
	
	self.navigationBar.topItem.title = @"Packard's Bugs";
	
	Class klass = NSClassFromString(@"World");
	simulation = [[klass alloc] initWithConfiguration:[NSDictionary dictionaryWithObject:[UIImage imageNamed:@"box.png"] forKey:@"foodImage"]];
	
	lifeView.simulation = simulation;
//	lifeView.layer.magnificationFilter = kCAFilterTrilinear;
	
	lifeView.frame = CGRectMake(0, 0, 500, 500);
	[scrollView addSubview:lifeView];
	lifeView.layer.shadowOffset = CGSizeMake(0, 5);
	lifeView.layer.shadowColor = [[UIColor blackColor] CGColor];
	lifeView.layer.shadowOpacity = 0.5;
	lifeView.layer.shadowRadius = 5;
	lifeView.layer.shouldRasterize = YES;
	
	scrollView.contentSize = lifeView.bounds.size;
	scrollView.minimumZoomScale = (self.scrollView.frame.size.width - 128.0) / 500.0;
	
//	float vInset = (scrollView.bounds.size.height - lifeView.frame.size.height) / 2;
//	float hInset = (scrollView.bounds.size.width - lifeView.frame.size.width) / 2;
	float hInset = 64.0, vInset = 32.0;
	UIEdgeInsets insets = {.top = vInset, .left = hInset, .bottom = vInset, .right = hInset};
	scrollView.contentInset = insets;
	
	scrollView.zoomScale = scrollView.minimumZoomScale;
	
	statisticsViewController = [[BPStatisticsViewController alloc] initWithSimulation:simulation];
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


- (BPOptionsViewController *)optionsViewController;
{
	if (!optionsViewController) {
		optionsViewController = [[BPOptionsViewController alloc] initWithNibName:nil bundle:nil];
		optionsViewController.simulation = self.simulation;
	}
	return optionsViewController;
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

- (IBAction)playAction:sender;
{
	NSMutableArray *items = [[toolbar items] mutableCopy];
	int index = [items indexOfObject:self.playButton];
	[items replaceObjectAtIndex:index withObject:self.pauseButton];
	[toolbar setItems:items animated:YES];
	simulation.running = YES;
	
	self.runTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (IBAction)pauseAction:sender;
{
	NSMutableArray *items = [[toolbar items] mutableCopy];
	int index = [items indexOfObject:self.pauseButton];
	[items replaceObjectAtIndex:index withObject:self.playButton];
	[toolbar setItems:items animated:YES];
	simulation.running = NO;
	
	[self.runTimer invalidate];
	self.runTimer = nil;
}

- (IBAction)tickAction:sender;
{
	[self tick];
}

- (void)tick;
{
	[simulation update];
	[lifeView setNeedsDisplay];
}

- (IBAction)reseedAction:(id)sender;
{
	[self.simulation reset];
	[lifeView setNeedsDisplay];
}

- (IBAction)selectorAction:sender;
{
	int index = [(UISegmentedControl *)sender selectedSegmentIndex];
	
	UIViewController *selectedViewController = nil;
	
	switch (index) {
		case 0:
			selectedViewController = self.optionsViewController;
			break;
		case 1:
			selectedViewController = self.statisticsViewController;
			break;
		default:
			break;
	}
	
	if (selectedViewController == accessoryViewController)
		return;
	
	if (!accessoryViewController) {
		CGRect bottomRect = CGRectMake(0, 0, 768, 200.0);
		CGRect myFrame = self.view.frame;
		
		bottomRect.origin.y = myFrame.size.height;
		bottomRect.origin.x = 0;
		
		selectedViewController.view.frame = bottomRect;
		
		[self.view addSubview:selectedViewController.view];
		
		[UIView beginAnimations:nil context:nil];
		
		CGRect toolbarFrame = toolbar.frame;
		CGRect scrollFrame = scrollView.frame;
		
		bottomRect.origin.y -= bottomRect.size.height;
		toolbarFrame.origin.y -= bottomRect.size.height;
		scrollFrame.size.height -= bottomRect.size.height;
		
		selectedViewController.view.frame = bottomRect;
		toolbar.frame = toolbarFrame;
		scrollView.frame = scrollFrame;
		
		[UIView commitAnimations];
	}
	else {
		selectedViewController.view.frame = accessoryViewController.view.frame;
		
		[UIView beginAnimations:nil context:nil];
		
		[accessoryViewController.view removeFromSuperview];
		[self.view addSubview:selectedViewController.view];
		
		[UIView commitAnimations];
	}
	
	accessoryViewController = selectedViewController;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return lifeView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	float fullScale = self.scrollView.frame.size.width / 500.0;
	
	float hInset = 0.0, vInset = 0.0;
	if (scale < fullScale) {
		hInset = 64.0;
		vInset = 32.0;
	}
	
	UIEdgeInsets insets = {.top = vInset, .left = hInset, .bottom = vInset, .right = hInset};
	scrollView.contentInset = insets;
}

#pragma mark -
#pragma mark Image editing

- (IBAction)showAddImageAction:(id)sender;
{
	PixelImage *bitmap = [[[PixelImage alloc] initWithWidth:self.simulation.width height:self.simulation.height] autorelease];
	BPEditBitmapViewController *evc = [[[BPEditBitmapViewController alloc] initWithBitmap:bitmap] autorelease];
	[self presentModalViewController:evc animated:YES];
}

- (IBAction)showEditImageAction:(id)sender;
{
	PixelImage *bitmap = [[[PixelImage alloc] initWithImage:[self.simulation valueForKey:@"foodImage"]] autorelease];
	BPEditBitmapViewController *evc = [[[BPEditBitmapViewController alloc] initWithBitmap:bitmap] autorelease];
	[self presentModalViewController:evc animated:YES];
}

@end
