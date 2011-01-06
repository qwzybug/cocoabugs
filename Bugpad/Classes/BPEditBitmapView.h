//
//  BPEditBitmapView.h
//  Bugpad
//
//  Created by Devin Chalmers on 8/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PixelImage;

@interface BPEditBitmapView : UIImageView {
	int lastX;
	int lastY;
}

@property (nonatomic, retain) PixelImage *bitmap;

@property (nonatomic, retain) UIColor *currentColor;

@end
