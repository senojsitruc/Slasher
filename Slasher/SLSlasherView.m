//
//  SLSlasherView.m
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLSlasherView.h"
#import "SLMainWindowController.h"
#import "NSImageView+Additions.h"

@implementation SLSlasherView

@synthesize imageCell = mImageCell;
@synthesize filePath = mFilePath;
@synthesize fileName = mFileName;

- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(context);
	CGColorRef redColor = CGColorCreate(colorSpace, (CGFloat[]){1., 0., 0., 1.});
	SLMainWindowController *controller = [SLMainWindowController mainWindowController];
	
	// image size and location
	CGRect imageRect = [self imageRect];
	CGFloat width=imageRect.size.width, height=imageRect.size.height;
	NSUInteger rowCount=controller.rowCount, colCount=controller.colCount;
	CGFloat rowHeight=height/(CGFloat)rowCount, colWidth=width/(CGFloat)colCount;
	
	//NSLog(@"rect1 = { x=%f, y=%f, w=%f, h=%f }", imageRect.origin.x, imageRect.origin.y, imageRect.size.width, imageRect.size.height);
	//NSLog(@"rect2 = { x=%f, y=%f, w=%f, h=%f }", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
	
	// draw settings
	CGContextSetStrokeColorWithColor(context, redColor);
	CGContextSetLineWidth(context, 1.);
	
	// vertical lines
	for (NSUInteger colNum = 1; colNum < colCount; ++colNum) {
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, imageRect.origin.x+(colWidth*colNum), imageRect.origin.y);
		CGContextAddLineToPoint(context, imageRect.origin.x+(colWidth*colNum), imageRect.origin.y+height);
		CGContextDrawPath(context, kCGPathStroke);
	}
	
	// horizontal lines
	for (NSUInteger rowNum = 1; rowNum < rowCount; ++rowNum) {
		CGContextBeginPath(context);
		CGContextMoveToPoint(context, imageRect.origin.x, imageRect.origin.y+(rowNum*rowHeight));
		CGContextAddLineToPoint(context, imageRect.origin.x+width, imageRect.origin.y+(rowNum*rowHeight));
		CGContextDrawPath(context, kCGPathStroke);
	}
	
	// restore previous state
	CGContextRestoreGState(context);
}

/**
 *
 *
 */
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	
	NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
	
	if ([files count]) {
		mFilePath = [files objectAtIndex:0];
		mFileName = [mFilePath lastPathComponent];
	}
	
	return [super performDragOperation:sender];
}

@end
