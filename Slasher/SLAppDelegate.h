//
//  SLAppDelegate.h
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const SLNotificationSlashingStarted;
extern NSString * const SLNotificationSlashingUpdated;
extern NSString * const SLNotificationSlashingStopped;

@interface SLAppDelegate : NSObject <NSApplicationDelegate>
{
@protected
	NSUInteger mProgressTotal;
}

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSPanel *progressPanel;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;
@property (assign) IBOutlet NSTextField *progressTxt;

@end
