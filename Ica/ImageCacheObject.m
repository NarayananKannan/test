//
//  ImageCacheObject.m
//  Providence
//
//  Copyright 2010 EverTrue, LLC. All rights reserved.
//
// $Rev:: 113                                                     $: Latest Revision
// $Author:: EverTrueEric                                         $: Author
// $Date:: 2011-01-24 14:36:28 -0500 (Mon, 24 Jan 2011)           $: Date
//

#import "ImageCacheObject.h"

@implementation ImageCacheObject

@synthesize size;

@synthesize timeStamp;

@synthesize image;

-(id)initWithSize:(NSUInteger)sz Image:(UIImage*)anImage{
   
	if (self = [super init]) {
       
		size = sz;
        
		timeStamp = [[NSDate date] retain];
       
		image = [anImage retain];
    }
   
	return self;
}

-(void)resetTimeStamp {
   
	[timeStamp release];
   
	timeStamp = [[NSDate date] retain];
}

-(void) dealloc {
   
	[timeStamp release];
    
	[image release];
    
	[super dealloc];
}

@end
