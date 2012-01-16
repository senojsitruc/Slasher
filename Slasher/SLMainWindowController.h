//
//  SLMainWindowController.h
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SLSlasherView;

@interface SLMainWindowController : NSWindowController <NSWindowDelegate>
{
@protected
	NSUInteger mRowsNum;
	NSUInteger mColsNum;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *alertTxt;
@property (assign) IBOutlet NSTextField *rowsTxt;
@property (assign) IBOutlet NSTextField *colsTxt;
@property (assign) IBOutlet NSStepper *rowsStepper;
@property (assign) IBOutlet NSStepper *colsStepper;
@property (assign) IBOutlet NSPopUpButton *formatBtn;
@property (assign) IBOutlet NSButton *slashBtn;
@property (assign) IBOutlet SLSlasherView *slasherView;
@property (readonly) NSUInteger rowCount;
@property (readonly) NSUInteger colCount;

+ (SLMainWindowController *)mainWindowController;

@end
