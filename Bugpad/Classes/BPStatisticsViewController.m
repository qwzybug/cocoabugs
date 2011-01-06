//
//  BPStatisticsViewController.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/9/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BPStatisticsViewController.h"

#import "StatisticsData.h"
#import "BPStatisticsView.h"

@implementation BPStatisticsViewController

@synthesize statisticsViews;
@synthesize statisticsData;
@synthesize simulation;
@synthesize timer;

- (id)initWithSimulation:(ALifeSimulation *)theSimulation;
{
	if (!(self = [super initWithNibName:nil bundle:nil]))
		return nil;
	
	self.simulation = theSimulation;
	
	NSDictionary *statistics = [[simulation class] statistics];
	NSMutableArray *views = [NSMutableArray array];
	NSMutableArray *datas = [NSMutableArray array];
	for (NSDictionary *stats in [statistics allValues]) {
		NSString *keyPath = [stats valueForKey:@"keyPath"];
		StatisticsData *data = [[[StatisticsData alloc] initWithSimulation:simulation keyPath:keyPath capacity:1000 samplingFrequency:10] autorelease];
		data.singular = [[stats valueForKey:@"singular"] boolValue];
		BPStatisticsView *statsView = [[[BPStatisticsView alloc] initWithFrame:CGRectMake(0, 0, 768, 100)] autorelease];
		statsView.data = data;
		PixelImage *bitmap = [[[PixelImage alloc] initWithWidth:768 height:100] autorelease];
		data.bitmap = bitmap;
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 20)] autorelease];
		label.font = [UIFont boldSystemFontOfSize:12.0];
		label.text = [stats valueForKey:@"title"];
		[statsView addSubview:label];
		[views addObject:statsView];
		[datas addObject:data];
	}
	
	self.statisticsViews = [NSArray arrayWithArray:views];
	self.statisticsData = [NSArray arrayWithArray:datas];
	
	[simulation addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	if ([keyPath isEqual:@"running"]) {
		if (simulation.running) {
			self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update) userInfo:nil repeats:YES];
		} else {
			[self.timer invalidate];
			self.timer = nil;
		}
	}
}

- (void)update;
{
	for (BPStatisticsView *statsView in self.statisticsViews) {
		if (statsView.superview) {
			[statsView update];
		}
	}
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

/*
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [statisticsViews count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"StatisticsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	BPStatisticsView *statsView = [statisticsViews objectAtIndex:indexPath.row];
	[statsView setNeedsDisplay];
    [cell addSubview:statsView];
	
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
    // [self.navigationController pushViewController:anotherViewController];
    // [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
    [super dealloc];
}


@end

