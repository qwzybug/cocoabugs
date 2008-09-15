//
//  DMQuicktimeExporter.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 9/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface DMQuicktimeExporter : NSObject {
	QTMovie                                *mMovie;
	QTCaptureSession                       *mCaptureSession;
	QTCaptureDecompressedVideoOutput       *mCaptureDecompressedVideoOutput;	
}

+ (id)movieExporter;
- (void)addFrameFromView:(NSView *)view;
- (void)exportMovie:(NSString *)filePath;

@end
