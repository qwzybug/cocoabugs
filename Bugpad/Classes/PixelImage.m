//
//  PixelImage.m
//  CGFuckery
//
//  Created by Devin Chalmers on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "PixelImage.h"


@implementation PixelImage

@synthesize width;
@synthesize height;

- (id)initWithWidth:(int)w height:(int)h;
{
	if (!(self = [super init]))
		return nil;
	
	width = w;
	height = h;
	
	data = calloc(width * height, sizeof(unsigned char));
	memset(data, 0xFF, width * height); // fill with white
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	ctx = CGBitmapContextCreate((void *)data, width, height, 8, width, colorSpace, kCGBitmapByteOrderDefault);
	CGColorSpaceRelease(colorSpace);
	
	yScale = 1;
	
	return self;
}

- (id)initWithImage:(UIImage *)image;
{
	if (!(self = [self initWithWidth:image.size.width height:image.size.height]))
		return nil;
	
	CGImageRef theCGImage = image.CGImage;
	CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), theCGImage);
	
	return self;
}

- (void)drawImage:(UIImage *)image;
{
	CGImageRef theCGImage = image.CGImage;
	CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), theCGImage);
}

- (UIImage *)image;
{
	UIGraphicsBeginImageContext(CGSizeMake(self.width, self.height));
	CGContextRef imageContext = UIGraphicsGetCurrentContext();
	CGImageRef img = CGBitmapContextCreateImage(ctx);
	CGContextDrawImage(imageContext, CGRectMake(0, 0, self.width, self.height), img);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	CGImageRelease(img);
	return image;
//	CGImageRef img = CGBitmapContextCreateImage(ctx);
//	UIImage *image = [UIImage imageWithCGImage:img];
//	CGImageRelease(img);
//	return image;
}

- (void)double;
{
	CGImageRef img = CGBitmapContextCreateImage(ctx);
	UIImage *image = [UIImage imageWithCGImage:img];
	CGImageRelease(img);
	
	CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
	CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
	CGContextFillRect(ctx, CGRectMake(0, 0, self.width, self.height));
	CGContextDrawImage(ctx, CGRectMake(0, self.height / 2, self.width, self.height / 2), image.CGImage);
	yScale *= 2;
}

- (void)setColor:(UIColor *)color atX:(int)x y:(int)y;
{
	while (y > height * yScale)
		[self double];
	
	y /= yScale;
	
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	unsigned char val = (unsigned char)(components[0] * 255.0);
	data[width * y + x] = val;
}

- (UIColor *)colorAtX:(int)x y:(int)y;
{
	unsigned char val = ((unsigned char *)data)[width * y + x];
	float amt = (float)val / 255.0;
	return [UIColor colorWithWhite:amt alpha:1];
}

@end
