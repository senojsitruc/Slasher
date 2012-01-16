//
//  SLMainWindowController.m
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLMainWindowController.h"
#import "SLAppDelegate.h"
#import "SLSlasher.h"
#import "SLSlasherView.h"
#import "NSThread+Additions.h"
#import <math.h>

static SLMainWindowController *gController;

@interface SLMainWindowController (PrivateMethods)
- (void)enableDisableControls;
@end

@implementation SLMainWindowController

@synthesize window = mWindow;
@synthesize alertTxt = mAlertTxt;
@synthesize rowsTxt = mRowsTxt;
@synthesize colsTxt = mColsTxt;
@synthesize rowsStepper = mRowsStepper;
@synthesize colsStepper = mColsStepper;
@synthesize formatBtn = mFormatBtn;
@synthesize slashBtn = mSlashBtn;
@synthesize slasherView = mSlasherView;
@synthesize rowCount = mRowsNum;
@synthesize colCount = mColsNum;





#pragma mark - Structors

+ (SLMainWindowController *)mainWindowController
{
	return gController;
}

/**
 *
 *
 */
- (id)initWithWindow:(NSWindow *)window
{
	self = [super initWithWindow:window];
	
	if (self) {
		// ...
	}
	
	return self;
}

/**
 *
 *
 */
- (void)awakeFromNib
{
	gController = self;
	
	[self performSelector:@selector(doActionRowsStepper:) withObject:self];
	[self performSelector:@selector(doActionColsStepper:) withObject:self];
	
	[mFormatBtn selectItemWithTitle:@"PNG"];
	
	[self enableDisableControls];
}





#pragma mark - Private

/**
 *
 *
 */
- (void)enableDisableControls
{
	if (!mSlasherView.image) {
		[mRowsTxt setEnabled:FALSE];
		[mColsTxt setEnabled:FALSE];
		[mRowsStepper setEnabled:FALSE];
		[mColsStepper setEnabled:FALSE];
		[mFormatBtn setEnabled:FALSE];
		[mSlashBtn setEnabled:FALSE];
	}
	else if (mRowsNum == 1 && mColsNum == 1) {
		[mFormatBtn setEnabled:FALSE];
		[mSlashBtn setEnabled:FALSE];
	}
	else {
		[mRowsTxt setEnabled:TRUE];
		[mColsTxt setEnabled:TRUE];
		[mRowsStepper setEnabled:TRUE];
		[mColsStepper setEnabled:TRUE];
		[mFormatBtn setEnabled:TRUE];
		[mSlashBtn setEnabled:TRUE];
	}
}





#pragma mark - Actions

/**
 *
 *
 */
- (IBAction)doActionSlash:(id)sender
{
	SLSlasher *slasher = [[SLSlasher alloc] initWithImage:mSlasherView.image rows:mRowsNum cols:mColsNum];
	NSBitmapImageFileType formatType;
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	NSString *formatStr = mFormatBtn.titleOfSelectedItem;
	NSString *extension = nil;
	NSString *nameFormat = nil;
	
	     if ([formatStr isEqualToString:@"BMP" ]) { formatType = NSBMPFileType;  extension = @"bmp";  }
	else if ([formatStr isEqualToString:@"GIF" ]) { formatType = NSGIFFileType;  extension = @"gif";  }
	else if ([formatStr isEqualToString:@"JPEG"]) { formatType = NSJPEGFileType; extension = @"jpg";  }
	else if ([formatStr isEqualToString:@"PNG" ]) { formatType = NSPNGFileType;  extension = @"png";  }
	else if ([formatStr isEqualToString:@"TIFF"]) { formatType = NSTIFFFileType; extension = @"tiff"; }
	else
		return;
	
	// the format of the output file name includes the "x" and "y" coordinates. zero-pad those 
	// coordinate numbers to the most appropriate magnitude.
	{
		NSInteger orders = 1 + log10(MAX(mRowsNum, mColsNum));
		nameFormat = [NSString stringWithFormat:@"%%@-%%0%ldlu-%%0%ldlu.%%@", orders, orders];
	}
	
	NSSavePanel *savePanel = [NSSavePanel savePanel];
	savePanel.nameFieldStringValue = [mSlasherView.fileName stringByDeletingPathExtension];
	savePanel.canCreateDirectories = TRUE;
	
	[savePanel beginSheetModalForWindow:mWindow completionHandler:^ (NSInteger result) {
		if (NSFileHandlingPanelOKButton == result) {
			NSString *path = savePanel.directoryURL.path;
			NSString *namePrefix = savePanel.nameFieldStringValue;
			
			[NSThread performBlockInBackground:^{
				NSDate *lastNotification = [NSDate date];
				
				[[NSThread mainThread] performBlock:^{
					[nc postNotificationName:SLNotificationSlashingStarted object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:(mColsNum*mRowsNum)], @"total", nil]];
				}];
				
				for (NSUInteger row = 0; row < mRowsNum; ++row) {
					for (NSUInteger col = 0; col < mColsNum; ++col) {
						@autoreleasepool {
							NSString *filename = [NSString stringWithFormat:nameFormat, namePrefix, mRowsNum - 1 - row, col, extension];
							[[slasher dataForRow:row andCol:col ofType:formatType] writeToFile:[path stringByAppendingPathComponent:filename] atomically:TRUE];
							
							if ([lastNotification timeIntervalSinceNow] < 0.5) {
								lastNotification = [NSDate date];
								[[NSThread mainThread] performBlock:^{
									[nc postNotificationName:SLNotificationSlashingUpdated object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:((row*mColsNum)+col)], @"count", nil]];
								}];
							}
						}
					}
				}
				
				[[NSThread mainThread] performBlock:^{
					[nc postNotificationName:SLNotificationSlashingStopped object:self];
				}];
			}];
		}
	}];
}

/**
 *
 *
 */
- (IBAction)doActionImage:(id)sender
{
	mAlertTxt.hidden = TRUE;
	
	mRowsStepper.maxValue = mSlasherView.image.size.height;
	mColsStepper.maxValue = mSlasherView.image.size.width;
	
	[self enableDisableControls];
}

/**
 *
 *
 */
- (IBAction)doActionRowsStepper:(id)sender
{
	mRowsNum = mRowsStepper.integerValue;
	[mRowsTxt setIntegerValue:mRowsNum];
	[mSlasherView setNeedsDisplay];
	[self enableDisableControls];
}

/**
 *
 *
 */
- (IBAction)doActionColsStepper:(id)sender
{
	mColsNum = mColsStepper.integerValue;
	[mColsTxt setIntegerValue:mColsNum];
	[mSlasherView setNeedsDisplay];
	[self enableDisableControls];
}

@end
