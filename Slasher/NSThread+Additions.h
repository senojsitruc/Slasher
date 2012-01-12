//
//  NSThread+Naming.h
//  Slasher
//
//  Created by Curtis Jones.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (Additions)
+ (void)printStackTrace;
@end





@interface NSThread (Naming)
+ (void)__setCurrentThreadName:(NSString *)name;
+ (void)__updateCurrentThreadName;
@end





@interface PGThread : NSThread
{
	NSString *mName;
}
- (id)initWithName:(NSString *)threadName target:(id)target selector:(SEL)selector object:(id)argument;
@end





@interface NGThreadBlock : NSObject
{
@public
	void (^mBlock)();
}
@end





@interface NSThread (BlocksAdditions)
- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;
- (void)performAfterDelay:(NSTimeInterval)delay block:(void (^)())block;
+ (void)performBlockInBackground:(void (^)())block;
+ (NSThread *)detachNewThreadBlock:(void (^)())block;
- (id)initWithBlock:(void (^)())block;
@end
