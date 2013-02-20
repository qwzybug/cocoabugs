#import "HSVColorSquare.h"

@implementation HSVColorSquare
- (id)initWithFrame:(NSRect)frame;
{
	if (!(self = [super initWithFrame:frame]))
		return nil;
	
	return self;
}

- (void)drawRect:(NSRect)rect;
{
	int i, j;
	float rectWidth, rectHeight, relX, relY;
	float rotation, saturation;
	rectWidth = [self frame].size.width / 31.0;
	rectHeight = [self frame].size.height / 31.0;
	NSRect rects[31 * 31];
	NSColor *colors[31 * 31];
	for (i = 0; i < 31; i++) {
		for (j = 0; j < 31; j++) {
			relX = (j - 15)/15.0;
			relY = (i - 15)/15.0;
			rotation = atan2(relY, relX)/(2*M_PI);
			rotation = rotation < 0 ? rotation + 1.0 : rotation;
			saturation = MAX(fabs(relX), fabs(relY));
			rects[i*31 + j] = NSMakeRect(rectWidth * j, rectWidth * i, rectWidth, rectHeight);
			colors[i*31 + j] = [NSColor colorWithCalibratedHue:rotation saturation:saturation brightness:1.0 alpha:1.0];
		}
	}
	NSRectFillListWithColors(rects, colors, 31 * 31);
}

@end
