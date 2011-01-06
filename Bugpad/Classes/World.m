//
//  World.m
//  CocoaBugs
//
//  Created by Devin Chalmers on 2/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "World.h"

#import "ALifeCritter.h"

#define GENOME_SIZE 32 * 128
#define GENE_NUM(MAG, DIR) (((MAG)<<3)|DIR)
#define GENE_INDEX(STEP, GENE, MAG, DIR) ((STEP) * (GENOME_SIZE) + (((GENE) << 7) | GENE_NUM((MAG), (DIR))))

#import "NSArray+Shuffling.h"
#import "UIColor+HSVSquare.h"

@implementation World

// world properties & statistics
@synthesize population, births, deaths, lifespan, ticks, activeGeneCounts;
@synthesize grid, morgue, maternity;
@synthesize initialPopulationDensity;
@synthesize collectActivity;
@synthesize foodImage;

@synthesize currentActivity;

// bug properties
@synthesize mutationRate, reproductionFood, movementCost, eatAmount;

// food configuration synthesized methods
@synthesize foodAmount;

- (id)initWithConfiguration:(NSDictionary *)configuration;
{
	if (!(self = [super initWithConfiguration:configuration]))
		return nil;
	
	int i, j;
#ifdef TARGET_OS_IPHONE
	UIImage *image = [configuration valueForKey:@"foodImage"];
	if (image) {
		self.width = image.size.width;
		self.height = image.size.height;
	} else {
		self.width = self.height = 100;
	}
#elif TARGET_OS_MAC
	NSImage *image = [configuration valueForKey:@"foodImage"];
	if (image) {
		width = [image size].width;
		height = [image size].height;
	} else {
		width = height = 100;
	}
#endif
	
	population = 0;
	ticks = 0;
	
	mutationRate = 0.5;
	initialPopulationDensity = 0.2;
	reproductionFood = 20;
	movementCost = -1;
	eatAmount = 1;
	foodAmount = 0;
	
	grid = [[NSMutableArray arrayWithCapacity:self.height] retain];
	
	self.critters = [NSMutableSet set];
	morgue = [[NSMutableSet set] retain];
	maternity = [[NSMutableSet set] retain];
	
	NSMutableArray *row;
	Cell *cell;
	for (i = 0; i < self.height; i++) {
		row = [NSMutableArray arrayWithCapacity:self.width];
		for (j = 0; j < self.width; j++) {
			cell = [[[Cell alloc] initWithFood:NO atRow:i column:j] autorelease];
			[row addObject:cell];
		}
		[grid addObject:row];
	}
	
	self.foodImage = image;
	// TODO: fuck this
//	for (int row = 0; row < height; row++) {
//		for (int col = 0; col < width; col++) {
//			if (row > 35 && row < 65 && col > 35 && col < 65) {
//				[self cellAtRow:row andColumn:col].food = YES;
//			}
//		}
//	}

	[self seedBugsWithDensity:self.initialPopulationDensity];
	
	self.collectActivity = YES; // TODO nope
	
	return self;
}

- (void)setMovementCost:(int)newMovementCost;
{
	movementCost = newMovementCost;
}

//- (void)setFoodImage:(NSImage *)image;
//{
//	if (foodImage == image)
//		return;
//	
//	[foodImage release];
//	foodImage = [image retain];
//	
//	NSBitmapImageRep *bitmap = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
//	BOOL sample;
//	int i = 0, j = 0;
//	float xScale = (float)[image size].width / width;
//	float yScale = (float)[image size].height / height;
//	foodAmount = 0;
//	for (NSArray *row in grid) {
//		j = 0;
//		for (Cell *cell in row) {
//			sample = [[bitmap colorAtX:(j * xScale) y:((height - i - 1) * yScale)] brightnessComponent] < 0.5;
//			cell.food = sample;
//			if (sample) foodAmount += 1;
//			j++;
//		}
//		i++;
//	}
//}

- (void)dealloc;
{
	self.grid = nil;
	self.critters = nil;
	self.morgue = nil;
	self.maternity = nil;
//	[foodImage release], foodImage = nil;
	
	if (activity)
		free(activity);
	
	[super dealloc];
}

- (Cell *)cellAtRow:(int)row andColumn:(int)col;
{
	row = row < 0 ? self.height + row : row % self.height;
	col = col < 0 ? self.width + col : col % self.width;
	return [[grid objectAtIndex:row] objectAtIndex:col];
}

- (void)update;
{
	if (self.collectActivity)
		[self updateActivity];
	
	// blank statistics for accumulation
	population = 0;
	[morgue removeAllObjects];
	[maternity removeAllObjects];
	
	// do we trust NSSet to have a stable order for -allObjects if we define a custom hash?
	// I suppose we do, but if you don't you can uncomment this.
	//	NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:@"hash" ascending:YES] autorelease];
	//	NSArray *bugArray = [[self.bugs allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
	
	for (Bug *bug in [[self.critters allObjects] shuffledArray]) {
		// check for bug death
		if (bug.food <= 0) {
			[morgue addObject:bug];
			[self cellAtRow:bug.y andColumn:bug.x].bug = nil;
			[critters removeObject:bug];
			lifespan += bug.age;
			continue;
		}
		
		// check for reproduction
		if (bug.food > reproductionFood) {
			Bug *newBug = [bug doReproduceWithMutationRate:mutationRate];
			[self place:newBug atRow:bug.y andCol:bug.x];
			[critters addObject:newBug];
			[maternity addObject:newBug];
			population++;
		}
		population++;
		
		// perform buggy movement and eating
		[self updateBug:bug atRow:bug.y column:bug.x];
	}
	self.population = population;
	self.ticks++;
}

- (int)calculateNeighborhoodForCellAtRow:(int)i andColumn:(int)j;
{
	int gene = 0;
	Cell *cell, *upCell, *leftCell, *rightCell, *downCell;
	
	// get neighborhood for each bug
	cell	  = [self cellAtRow:i	andColumn:j];
	upCell	  = [self cellAtRow:i+1 andColumn:j];
	leftCell  = [self cellAtRow:i	andColumn:j-1];
	rightCell = [self cellAtRow:i	andColumn:j+1];
	downCell  = [self cellAtRow:i-1 andColumn:j];
	
	// calculate relevant gene #
	if (upCell.food)
		gene = gene | 1;
	if (leftCell.food)
		gene = gene | 2;
	if (cell.food)
		gene = gene | 4;
	if (rightCell.food)
		gene = gene | 8;
	if (downCell.food)
		gene = gene | 16;
	
	return gene;
}

- (void)exterminate;
{
	for (NSMutableArray *row in grid) {
		for (Cell *cell in row) {
			cell.bug = nil;
		}
	}
	[critters removeAllObjects];
	self.population = 0;
	self.ticks = 0;
}

- (void)updateBug:(Bug *)bug atRow:(int)row column:(int)col;
{
	Cell *cell = [self cellAtRow:row andColumn:col];
	// check for food
	if (cell.food) {
		[bug doEat:eatAmount];
	} else {
		[bug doDigest:-movementCost];
	}
	// bug has survived to bug another day
	bug.age++;
	
	// get neighborhood for cell
	int gene = [self calculateNeighborhoodForCellAtRow:row andColumn:col];
	// get movement for neighborhood
	BugMovement move = [bug getMovementForGene:gene];
	// place bug at new position
	[self place:bug atRow:(row + move.y) andCol:(col + move.x)];
	// update gene activity
	if (self.collectActivity) {
		activity[GENE_INDEX(0, gene, move.mag, move.dir)] += 1;
	}
	// remove old bug pointer
	cell.bug = nil;
}

- (void)place:(Bug *)bug atRow:(int)row andCol:(int)col;
{
	Cell *cell = [self cellAtRow:row andColumn:col];
	// check if cell is occupied
	if (cell.bug) {
		// if so, randomly adjust row and col, and replace
		[self place:bug atRow:(row + random() % 3 - 1) andCol:(col + random() % 3 - 1)];
	} else {
		cell.bug = bug;
		bug.x = cell.col;
		bug.y = cell.row;
	}
}

- (void)reset;
{
	[self exterminate];
	[self seedBugsWithDensity:self.initialPopulationDensity];
}

- (void)seedBugsWithDensity:(float)density;
{
	Bug *bug;
	int i, j, pop = 0;
	for (i = 0; i < self.height; i++) {
		for(j = 0; j < self.width; j++) {
			if ((float)random() / INT_MAX < density) {
				bug = [[[Bug alloc] init] autorelease];
				[self place:bug atRow:i andCol:j];
				[critters addObject:bug];
				pop++;
			}
		}
	}
	self.population = pop;
}

// activity statistics
- (void)setCollectActivity:(BOOL)newCollectActivity;
{
	if (activity) {
		free(activity);
		activity = NULL;
	}
	
	collectActivity = newCollectActivity;
	
	if (collectActivity) {
		activityDelta = 10;
		activitySize = 1;
		activity = calloc(activitySize * GENOME_SIZE, sizeof(long));
		memset(activity, 0x0, GENOME_SIZE);
	}
}

- (void)updateActivity;
{
	int newStep = ticks / activityDelta;
	if (newStep > activityStep) {
		// ding the current activity
		NSMutableDictionary *theActivity = [NSMutableDictionary dictionary];
		for (int i = 0; i < GENOME_SIZE; i++) {
			int thisActivity = activity[i];
			if (thisActivity > 0) {
				[theActivity setObject:[NSNumber numberWithInt:thisActivity] forKey:[NSNumber numberWithInt:i]];
			}
		}
		self.currentActivity = theActivity;
		memset(activity, 0x0, GENOME_SIZE * sizeof(long));
		// reallocate if necessary
//		if (newStep >= activitySize) {
//			activitySize = activitySize * 2;
//			activity = realloc(activity, activitySize * GENOME_SIZE * sizeof(long));
//		}
//		memcpy(&activity[newStep * GENOME_SIZE], &activity[activityStep * GENOME_SIZE], sizeof(long) * GENOME_SIZE);
	}
	activityStep = newStep;
}

- (NSArray *)activityLines;
{
	NSMutableArray *lines = [NSMutableArray arrayWithCapacity:activityStep];
	
	// header
	NSMutableString *headerString = [NSMutableString stringWithCapacity:(32 * GENOME_SIZE * 8)];
	[headerString appendString:@"Step"];
	for (int gene = 0; gene < 32; gene++) {
		for (int dir = 0; dir < 8; dir++) {
			for (int mag = 1; mag < 16; mag++) {
				[headerString appendFormat:@",%d.%d.%d", gene, dir, mag];
			}
		}
	}
	[lines addObject:headerString];
	
	NSMutableString *lineString;
	for (int step = 0; step < activityStep; step++) {
		lineString = [NSMutableString stringWithCapacity:(GENOME_SIZE * 8)];
		[lineString appendFormat:@"%d", step * activityDelta];
		for (int gene = 0; gene < 32; gene++) {
			for (int dir = 0; dir < 8; dir++) {
				for (int mag = 1; mag < 16; mag++) {
//					[lineString appendFormat:@",%d", activity[GENE_INDEX(step, gene, mag, dir)]];
				}
			}
		}
		[lines addObject:lineString];
	}
	
	return lines;
}


- (float)sizeForCellAtX:(int)x y:(int)y;
{
	return 1.0;
}

- (UIColor *)colorForCellAtX:(int)x y:(int)y;
{
	Cell *cell = [self cellAtRow:y andColumn:x];
	if (cell.food) {
		return [UIColor blackColor];
	} else {
		return nil;
	}
}

- (float)sizeForCritter:(ALifeCritter *)critter;
{
	return 0.5;
}

- (UIColor *)colorForCritter:(ALifeCritter *)critter;
{
	BugMovement movement = [(Bug *)critter getMovementForGene:31];
	return [UIColor colorForPoint:CGPointMake(movement.x, movement.y)];
}

- (void)setFoodImage:(UIImage *)newFoodImage;
{
	if (foodImage == newFoodImage)
		return;
	
	[foodImage release];
	
	PixelImage *bitmap = [[[PixelImage alloc] initWithWidth:self.width height:self.height] autorelease];
	[bitmap drawImage:newFoodImage];
	foodImage = [[bitmap image] retain];
	
	BOOL sample;
	int i = 0, j = 0;
	float xScale = (float)(foodImage.size.width) / self.width;
	float yScale = (float)(foodImage.size.height) / self.height;
	foodAmount = 0;
	for (NSArray *row in grid) {
		j = 0;
		for (Cell *cell in row) {
			UIColor *color = [bitmap colorAtX:(j * xScale) y:(i * yScale)];
			const CGFloat *components = CGColorGetComponents(color.CGColor);
			sample = (components[0] < 0.5 && CGColorGetAlpha(color.CGColor) > 0.5);
			cell.food = sample;
			if (sample) foodAmount += 1;
			j++;
		}
		i++;
	}
}

+ (NSArray *)configurationOptions;
{
	NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PackardBugs" ofType:@"plist"]];
	return [config valueForKey:@"configuration"];
}

+ (NSDictionary *)statistics;
{
	NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"PackardBugs" ofType:@"plist"]];
	return [config valueForKey:@"statistics"];
}

@end
