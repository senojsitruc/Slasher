//
//  NSBitmapImageRep+Additions.m
//  Slasher
//
//  Created by Curtis Jones on 2012.01.09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSBitmapImageRep+Additions.h"

@implementation NSBitmapImageRep (Additions)

- (unsigned char *)nonPlanarBitmapData
{
	if (!self.isPlanar)
		return self.bitmapData;
	else {
		NSUInteger bytesPerPlane = self.bytesPerPlane;
		NSUInteger numberOfPlanes = self.numberOfPlanes;
		unsigned char *bitmapData = malloc(bytesPerPlane * numberOfPlanes);
		unsigned char *bitmapDataPlanes = NULL;
		
		if (!bitmapData) {
			NSLog(@"%s.. failed to malloc(), %s", __PRETTY_FUNCTION__, strerror(errno));
			return NULL;
		}
		
		[self getBitmapDataPlanes:&bitmapDataPlanes];
		
		for (NSUInteger bitmapDataPlaneNdx = 0; bitmapDataPlaneNdx < numberOfPlanes; ++bitmapDataPlaneNdx) {
			unsigned char *bitmapDataPtr = bitmapData + bitmapDataPlaneNdx;
			unsigned char *planeData = (bitmapDataPlanes + bitmapDataPlaneNdx);
			
			for (NSUInteger byteNdx = 0; byteNdx < bytesPerPlane; ++byteNdx, bitmapDataPtr+=numberOfPlanes, ++planeData)
				*bitmapDataPtr = *planeData;
		}
		
		return bitmapData;
	}
}

@end
