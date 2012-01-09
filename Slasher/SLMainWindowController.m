//
//  SLMainWindowController.m
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLMainWindowController.h"
#import "SLSlasher.h"
#import "SLSlasherView.h"

static SLMainWindowController *gController;

@interface SLMainWindowController (PrivateMethods)
- (void)enableDisableControls;
@end

@implementation SLMainWindowController

@synthesize window = mWindow;
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
	NSString *formatStr = mFormatBtn.titleOfSelectedItem;
	NSString *extension = nil;
	
	     if ([formatStr isEqualToString:@"BMP" ]) { formatType = NSBMPFileType;  extension = @"bmp";  }
	else if ([formatStr isEqualToString:@"GIF" ]) { formatType = NSGIFFileType;  extension = @"gif";  }
	else if ([formatStr isEqualToString:@"JPEG"]) { formatType = NSJPEGFileType; extension = @"jpg";  }
	else if ([formatStr isEqualToString:@"PNG" ]) { formatType = NSPNGFileType;  extension = @"png";  }
	else if ([formatStr isEqualToString:@"TIFF"]) { formatType = NSTIFFFileType; extension = @"tiff"; }
	else
		return;
	
	NSOpenPanel *openPanel = [NSOpenPanel openPanel];
	openPanel.canChooseFiles = FALSE;
	openPanel.canChooseDirectories = TRUE;
	openPanel.allowsMultipleSelection = FALSE;
	
	[openPanel beginSheetModalForWindow:mWindow completionHandler:^ (NSInteger result) {
		if (NSFileHandlingPanelOKButton == result) {
			for (NSUInteger row = 0; row < mRowsNum; ++row) {
				for (NSUInteger col = 0; col < mColsNum; ++col) {
					NSString *filename = [NSString stringWithFormat:@"slasher-%lu-%lu.%@", row, col, extension];
					[[slasher dataForRow:row andCol:col ofType:formatType] writeToFile:[openPanel.directoryURL.path stringByAppendingPathComponent:filename] atomically:TRUE];
				}
			}
		}
	}];
}

/**
 *
 *
 */
- (IBAction)doActionImage:(id)sender
{
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
