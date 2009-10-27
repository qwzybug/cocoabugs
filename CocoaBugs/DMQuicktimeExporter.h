//
//  DMQuicktimeExporter.h
//  CocoaBugs
//
//  Created by Devin Chalmers on 9/14/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <QTKit/QTKit.h>
#import <QuickTime/QuickTime.h>

@interface DMQuicktimeExporter : NSObject {
	QTMovie                                *mMovie;
	QTCaptureSession                       *mCaptureSession;
	QTCaptureDecompressedVideoOutput       *mCaptureDecompressedVideoOutput;
	
	int selectedComponentIndex;
	NSView *view;
	NSModalSession session;
	
	IBOutlet NSWindow *progressWindow;
	IBOutlet NSProgressIndicator *progressBar;
	BOOL shouldCancel;
}

@property (readwrite, retain) NSView *view;

+ (id)movieExporterForView:(NSView *)theView;
- (id)initWithView:(NSView *)theView;
- (void)addFrame;
- (void)exportMovie:(NSString *)filePath;
- (BOOL)writeMovie:(QTMovie *)movie toFile:(NSString *)file withComponent:(NSDictionary *)component withExportSettings:(NSData *)exportSettings;

- (NSArray *)availableComponents;
- (NSData *)getExportSettings;

- (IBAction)cancelButton:(id)sender;

@end
