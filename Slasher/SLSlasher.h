//
//  SLSlasher.h
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct
{
	unsigned char *data;
	NSUInteger pixelsWide;
	NSUInteger pixelsHigh;
	NSUInteger colWidthInBytes;
} SLSlasherArea;

@interface SLSlasher : NSObject
{
@protected
	NSImage *mImage;
	NSUInteger mRows;
	NSUInteger mCols;
	
	NSBitmapImageRep *mBitmapImage;
	unsigned char *mBitmapData;
	SLSlasherArea *mAreas;
	BOOL mIsPlanar;
}

/**
 *
 */
- (id)initWithImage:(NSImage *)image rows:(NSUInteger)rows cols:(NSUInteger)cols;

/**
 *
 */
- (NSBitmapImageRep *)bitmapForRow:(NSUInteger)row andCol:(NSUInteger)col;
- (NSImage *)imageForRow:(NSUInteger)row andCol:(NSUInteger)col;
- (NSData *)dataForRow:(NSUInteger)row andCol:(NSUInteger)col ofType:(NSBitmapImageFileType)type;

@end
