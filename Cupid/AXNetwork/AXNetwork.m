//
//  Network.m
//
//  Created by Alex on 12-8-10.
//
//

#import "AXNetwork.h"
#import <pthread.h>

static NSInteger gRequestCount = 0;
static pthread_mutex_t  gMutex = PTHREAD_MUTEX_INITIALIZER;

@implementation AXNetwork

+ (void)requestStart
{
	pthread_mutex_lock(&gMutex);

	gRequestCount++;
	dispatch_async(dispatch_get_main_queue(), ^{
		if (gRequestCount >= 1) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		}
	});
	
	pthread_mutex_unlock(&gMutex);
}

+ (void)requestStop
{
	pthread_mutex_unlock(&gMutex);
	
	gRequestCount--;
	dispatch_async(dispatch_get_main_queue(), ^{
		if (gRequestCount <= 0) {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		}
	});

	pthread_mutex_unlock(&gMutex);
}

@end
