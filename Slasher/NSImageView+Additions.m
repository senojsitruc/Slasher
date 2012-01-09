//
//  NSImageView+Additions.m
//  Slasher
//
//  Created by Curtis Jones on 2012.01.08.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
//  ------------------------------------------------------------------------------------------------
//
//  http://stackoverflow.com/a/7939408/157141
//

#import "NSImageView+Additions.h"

@implementation NSImageView (Additions)

- (CGSize)imageScale
{
	CGFloat sx = self.frame.size.width / self.image.size.width;
	CGFloat sy = self.frame.size.height / self.image.size.height;
	CGFloat s = 1.0;
	
	switch (self.imageScaling)
	{
		case NSImageScaleProportionallyDown:
			{
				if (sx > 1. && sy > 1.)
					return CGSizeMake(s, s);
				else {
					s = fminf(sx, sy);
					return CGSizeMake(s, s);
				}
			}
			break;
			
			/*
		case NSImageScaleAxesIndependently:
			return CGSizeMake(sx, sy);
			break;
			
		case NSImageScaleProportionallyUpOrDown:
			s = fminf(sx, sy);
			return CGSizeMake(s, s);
			break;
			*/
			
		default:
			return CGSizeMake(s, s);
			
			/*
		case UIViewContentModeScaleAspectFit:
			s = fminf(sx, sy);
			return CGSizeMake(s, s);
			break;
			
		case UIViewContentModeScaleAspectFill:
			s = fmaxf(sx, sy);
			return CGSizeMake(s, s);
			break;
			
		case UIViewContentModeScaleToFill:
			return CGSizeMake(sx, sy);
			
		default:
			return CGSizeMake(s, s);
			*/
			
	}
}

/**
 * Erica Sadun, http://ericasadun.com
 * iPhone Developer's Cookbook, 5.x Edition
 * BSD License, Use at your own risk
 */
CGRect CGRectCenteredInCGRect(CGRect inner, CGRect outer)
{
	return CGRectMake((outer.size.width - inner.size.width) / 2., (outer.size.height - inner.size.height) / 2., inner.size.width, inner.size.height);
}

CGSize CGSizeScale(CGSize aSize, CGFloat wScale, CGFloat hScale)
{
	return CGSizeMake(aSize.width * wScale, aSize.height * hScale);
}

CGRect CGRectFromCGSize (CGSize size)
{
	return CGRectMake(0., 0., size.width, size.height);
}

- (CGRect)imageRect
{
	CGSize imgScale = [self imageScale];
	return CGRectCenteredInCGRect(CGRectFromCGSize(CGSizeScale(self.image.size, imgScale.width, imgScale.height)), self.frame);
}

@end
