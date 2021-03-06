//
//  BPFloatOptionView.m
//  Bugpad
//
//  Created by Devin Chalmers on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "BPFloatOptionView.h"


@implementation BPFloatOptionView

@synthesize titleLabel;
@synthesize valueLabel;
@synthesize slider;

@synthesize configuration;
@synthesize simulation;

- (id)initWithFrame:(CGRect)frame configuration:(NSDictionary *)theConfiguration simulation:(ALifeSimulation *)theSimulation;
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	self.configuration = theConfiguration;
	self.simulation = theSimulation;
	
	NSString *keyPath = [configuration valueForKey:@"keyPath"];
	float value = [[simulation valueForKeyPath:keyPath] floatValue];

	titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.height - 20.0, 40.0)];
	titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
	titleLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
	titleLabel.numberOfLines = 2;
	titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	titleLabel.text = [self.configuration valueForKey:@"title"];
	titleLabel.transform = CGAffineTransformMakeRotation(-M_PI / 2);
	titleLabel.center = CGPointMake(20.0, frame.size.height/ 2);
	titleLabel.shadowColor = [UIColor whiteColor];
	titleLabel.shadowOffset = CGSizeMake(-1, 0);
	titleLabel.backgroundColor = [UIColor clearColor];
	[self addSubview:titleLabel];
	
	slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 50.0, frame.size.height - 40.0, 40.0)];
	slider.minimumValue = [[configuration valueForKey:@"minValue"] floatValue];
	slider.maximumValue = [[configuration valueForKey:@"maxValue"] floatValue];
	[slider addTarget:self action:@selector(sliderChangeAction:) forControlEvents:UIControlEventValueChanged];
	slider.value = value;
	slider.transform = CGAffineTransformMakeRotation(-M_PI / 2);
	slider.center = CGPointMake(60.0, (frame.size.height - 40.0) / 2 + 30.0);
	[self addSubview:slider];
	
	valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 40.0, 20.0)];
	valueLabel.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
	valueLabel.text = [NSString stringWithFormat:@"%0.2f", value];
	valueLabel.textAlignment = UITextAlignmentCenter;
	valueLabel.shadowColor = [UIColor whiteColor];
	valueLabel.shadowOffset = CGSizeMake(0, 1);
	valueLabel.backgroundColor = [UIColor clearColor];
	valueLabel.center = CGPointMake(60.0, 15.0);
	[self addSubview:valueLabel];
	
	[simulation addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial) context:nil];
	
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
	float newValue = [[change valueForKey:NSKeyValueChangeNewKey] floatValue];
	NSLog(@"New %@ value: %0.2f", [self.configuration valueForKey:@"keyPath"], newValue);
	if (!slider.tracking) {
		slider.value = newValue;
	}
	valueLabel.text = [NSString stringWithFormat:@"%0.2f", newValue];
}

- (IBAction)sliderChangeAction:(id)sender;
{
	float value = [slider value];
	NSLog(@"New %@ value: %0.2f", [self.configuration valueForKey:@"keyPath"], value);
	
	[simulation setValue:[NSNumber numberWithFloat:value] forKey:[configuration valueForKey:@"keyPath"]];
}

- (void)dealloc {
	[simulation removeObserver:self forKeyPath:[configuration valueForKey:@"keyPath"]];
	[simulation release], simulation = nil;
	
	[configuration release], configuration = nil;
	[slider release], slider = nil;
	[titleLabel release], titleLabel = nil;
	[valueLabel release], valueLabel = nil;
	
    [super dealloc];
}

@end
