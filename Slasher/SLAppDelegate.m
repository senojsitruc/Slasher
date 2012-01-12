//
//  SLAppDelegate.m
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLAppDelegate.h"

NSString * const SLNotificationSlashingStarted = @"SLNotificationSlashingStarted";
NSString * const SLNotificationSlashingUpdated = @"SLNotificationSlashingUpdated";
NSString * const SLNotificationSlashingStopped = @"SLNotificationSlashingStopped";

@implementation SLAppDelegate

@synthesize window = _window;
@synthesize progressPanel = mProgressPanel;
@synthesize progressIndicator = mProgressIndicator;
@synthesize progressTxt = mProgressTxt;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNotificationSlashingStarted:) name:SLNotificationSlashingStarted object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNotificationSlashingUpdated:) name:SLNotificationSlashingUpdated object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNotificationSlashingStopped:) name:SLNotificationSlashingStopped object:nil];
}

- (void)doNotificationSlashingStarted:(NSNotification *)notification
{
	mProgressTotal = [[[notification userInfo] objectForKey:@"total"] integerValue];
	mProgressTxt.stringValue = [NSString stringWithFormat:@"0 of %lu", mProgressTotal];
	mProgressIndicator.maxValue = mProgressTotal;
	mProgressIndicator.doubleValue = 0.;
	[mProgressIndicator startAnimation:self];
	[NSApp beginSheet:mProgressPanel modalForWindow:_window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (void)doNotificationSlashingUpdated:(NSNotification *)notification
{
	NSUInteger count = [[[notification userInfo] objectForKey:@"count"] integerValue];
	mProgressTxt.stringValue = [NSString stringWithFormat:@"%lu of %lu", count, mProgressTotal];
	mProgressIndicator.doubleValue = count;
}

- (void)doNotificationSlashingStopped:(NSNotification *)notification
{
	[NSApp endSheet:mProgressPanel];
	[mProgressIndicator stopAnimation:self];
	[mProgressPanel orderOut:self];
}

@end
