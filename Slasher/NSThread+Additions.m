//
//  NSThread+Naming.m
//  Slasher
//
//  Created by Curtis Jones.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSThread+Additions.h"
#import "pthread.h"

@implementation NSThread (Additions)

+ (void)printStackTrace
{
	NSArray *symbols = [NSThread callStackSymbols];
	
	for (NSString *symbol in symbols) {
		NSLog(@"%@", symbol);
	}
}

@end





@implementation NSThread (Naming)

+ (void)__setCurrentThreadName:(NSString *)name
{
	if (name != nil)
		pthread_setname_np([name UTF8String]);
}

+ (void)__updateCurrentThreadName
{
	[NSThread __setCurrentThreadName:[[NSThread currentThread] name]];
}

@end





@implementation PGThread

- (id)initWithName:(NSString *)threadName target:(id)target selector:(SEL)selector object:(id)argument
{
	self = [super initWithTarget:target selector:selector object:argument];
	
	if (self) {
		mName = threadName;
	}
	
	return self;
}

- (void)main
{
	[NSThread __setCurrentThreadName:mName];
	[super main];
}

@end




@implementation NGThreadBlock

@end





@implementation NSThread (BlocksAdditions)

- (void)performBlock:(void (^)())block
{
	if ([[NSThread currentThread] isEqual:self])
		block();
	else
		[self performBlock:block waitUntilDone:FALSE];
}

- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait
{
	[NSThread performSelector:@selector(__runBlock:) onThread:self withObject:[block copy] waitUntilDone:wait];
}

- (void)performAfterDelay:(NSTimeInterval)delay block:(void (^)())theBlock
{
	void (^block)() = [theBlock copy];
	[self performBlock:^{
		[NSThread performSelector:@selector(__runBlock:) withObject:block afterDelay:delay];
	}];
}

+ (void)__runBlock:(void (^)())block
{
	block();
}

+ (void)performBlockInBackground:(void (^)())block
{
	[NSThread performSelectorInBackground:@selector(__runBlock:) withObject:[block copy]];
}

+ (NSThread *)detachNewThreadBlock:(void (^)())block
{
	NSThread *thread = [[NSThread alloc] initWithBlock:block];
	[thread start];
	return thread;
}

- (id)initWithBlock:(void (^)())block
{
	NGThreadBlock *threadBlock = [[NGThreadBlock alloc] init];
	
	threadBlock->mBlock = [block copy];
	
	self = [self initWithTarget:self selector:@selector(__runThreadBlock:) object:threadBlock];
	
	if (self)
		[self setStackSize:1024 * 1024 * 8];
	
	return self;
}

- (void)__runThreadBlock:(NGThreadBlock *)threadBlock
{
	threadBlock->mBlock();
}

@end
