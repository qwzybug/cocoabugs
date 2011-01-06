//
//  PixelImage.h
//  CGFuckery
//
//  Created by Devin Chalmers on 2/8/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PixelImage : NSObject {
	CGContextRef ctx;
	
	unsigned char *data;
	
	int width;
	int height;
	
	int yScale;
}

@property (nonatomic, readonly) int width;
@property (nonatomic, readonly) int height;

- (id)initWithWidth:(int)w height:(int)h;
- (id)initWithImage:(UIImage *)image;

- (void)drawImage:(UIImage *)image;

- (void)setColor:(UIColor *)color atX:(int)x y:(int)y;
- (UIColor *)colorAtX:(int)x y:(int)y;

- (void)double;

@property (nonatomic, readonly) UIImage *image;

@end
