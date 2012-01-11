//
//  SLSlasherView.h
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface SLSlasherView : NSImageView
{
@protected
	NSString *mFilePath;
	NSString *mFileName;
}

@property (assign) IBOutlet NSImageCell *imageCell;
@property (readonly, strong) NSString *filePath;
@property (readonly, strong) NSString *fileName;

@end
