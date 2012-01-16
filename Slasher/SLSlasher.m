//
//  SLSlasher.m
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SLSlasher.h"
#import "NSBitmapImageRep+Additions.h"

@interface SLSlasher (PrivateMethods)
- (void)initializeAreas;
@end

@implementation SLSlasher

#pragma mark - Structors

/**
 *
 *
 */
- (id)initWithImage:(NSImage *)image rows:(NSUInteger)rows cols:(NSUInteger)cols
{
	self = [super init];
	
	if (self) {
		mImage = image;
		mRows = rows;
		mCols = cols;
		
		CGImageRef cgimage = [mImage CGImageForProposedRect:nil context:[NSGraphicsContext currentContext] hints:nil];
		mBitmapImage = [[NSBitmapImageRep alloc] initWithCGImage:cgimage];
		mBitmapData = mBitmapImage.nonPlanarBitmapData;
		mIsPlanar = mBitmapImage.isPlanar;
		
		[self initializeAreas];
	}
	
	return self;
}

/**
 *
 *
 */
- (void)dealloc
{
	if (mAreas)
		free(mAreas);
	
	if (mIsPlanar && mBitmapData)
		free(mBitmapData);
}





#pragma mark - Private

/**
 * Given a source image in bitmap form along with the stats on the image (bytes per pixel, pixels
 * per row, etc.) and the target number of rows/columns, initialize an SLSlasherArea for each which
 * specifies the block's starting bitmap pointer and width/height in pixels. Later on, when we
 * actually perform the slashing, we can do so image-format-agnostically.
 *
 * The only assumption is that the image is non-planar; that is, the colors are all interleaved.
 * The nonPlanarBitmapData() call *supposedly* resolves this dependency, but since I don't have any
 * planar images to test with, I can only hope that it is bug-free.
 */
- (void)initializeAreas
{
	if (NULL == (mAreas = malloc(sizeof(SLSlasherArea) * mRows * mCols))) {
		NSLog(@"%s.. failed to malloc(), %s", __PRETTY_FUNCTION__, strerror(errno));
		return;
	}
	
	memset(mAreas, 0, sizeof(SLSlasherArea) * mRows * mCols);
	
	SLSlasherArea *currentArea = &mAreas[0];
	unsigned char *bitmapPtr = mBitmapData;
	NSUInteger bytesPerPixel = mBitmapImage.bitsPerPixel / 8;
	NSUInteger colWidthInPixels = mBitmapImage.size.width / mCols;
	NSUInteger rowHeightInPixels = mBitmapImage.size.height / mRows;
	NSUInteger lastColWidthInPixels = (mBitmapImage.size.width - (colWidthInPixels*(mCols-1)));
	NSUInteger lastRowHeightInPixels = (mBitmapImage.size.height - (rowHeightInPixels*(mRows-1)));
	
	for (NSUInteger row = 0; row < mRows; ++row) {
		unsigned char *tmpBitmapPtr = bitmapPtr;
		
		for (NSUInteger col = 0; col < mCols; ++col) {
			currentArea->data = tmpBitmapPtr;
			currentArea->pixelsWide = col < mCols - 1 ? colWidthInPixels : lastColWidthInPixels;
			currentArea->pixelsHigh = row < mRows - 1 ? rowHeightInPixels : lastRowHeightInPixels;
			currentArea->colWidthInBytes = currentArea->pixelsWide * bytesPerPixel;
			tmpBitmapPtr += currentArea->colWidthInBytes;
			currentArea += 1;
		}
		
		bitmapPtr += mBitmapImage.bytesPerRow * rowHeightInPixels;
	}
}





#pragma mark - Accessors

/**
 *
 *
 */
- (NSData *)dataForRow:(NSUInteger)row andCol:(NSUInteger)col ofType:(NSBitmapImageFileType)type
{
	return [[self bitmapForRow:row andCol:col] representationUsingType:type properties:nil];
}

/**
 *
 *
 */
- (NSImage *)imageForRow:(NSUInteger)row andCol:(NSUInteger)col
{
	return [[NSImage alloc] initWithCGImage:[[self bitmapForRow:row andCol:col] CGImageForProposedRect:NULL context:NULL hints:NULL] size:NSZeroSize];
}

/**
 *
 *
 */
- (NSBitmapImageRep *)bitmapForRow:(NSUInteger)row andCol:(NSUInteger)col
{
	if (row >= mRows || col >= mCols) {
		NSLog(@"%s.. requested coordinate is outside the grid (row=%lu, col=%lu, rows=%lu, cols=%lu)", __PRETTY_FUNCTION__, row, col, mRows, mCols);
		return nil;
	}
	else if (!mAreas) {
		NSLog(@"%s.. there are no defined areas; did initializeAreas() fail?", __PRETTY_FUNCTION__);
		return nil;
	}
	
	SLSlasherArea *area = &mAreas[(mCols*row)+col];
	NSUInteger imageWidthInBytes = mBitmapImage.bytesPerRow;
	
	NSBitmapImageRep *sliceRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
																																			 pixelsWide:area->pixelsWide
																																			 pixelsHigh:area->pixelsHigh
																																		bitsPerSample:mBitmapImage.bitsPerSample
																																	samplesPerPixel:mBitmapImage.samplesPerPixel
																																				 hasAlpha:mBitmapImage.hasAlpha
																																				 isPlanar:FALSE
																																	 colorSpaceName:mBitmapImage.colorSpaceName
																																		 bitmapFormat:mBitmapImage.bitmapFormat
																																			bytesPerRow:area->colWidthInBytes
																																		 bitsPerPixel:mBitmapImage.bitsPerPixel];
	unsigned char *slicePtr = sliceRep.bitmapData;
	unsigned char *dataPtr = area->data;
	
	for (NSUInteger _row = 0; _row < area->pixelsHigh; ++_row, slicePtr+=area->colWidthInBytes, dataPtr+=imageWidthInBytes)
		memcpy(slicePtr, dataPtr, area->colWidthInBytes);
	
	return sliceRep;
}

@end
