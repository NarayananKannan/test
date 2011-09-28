//
//  ImageCache.m
//  Providence
//
//  Copyright 2010 EverTrue, LLC. All rights reserved.
//
// $Rev:: 113                                                     $: Latest Revision
// $Author:: EverTrueEric                                         $: Author
// $Date:: 2011-01-24 14:36:28 -0500 (Mon, 24 Jan 2011)           $: Date
//

#import "ImageCache.h"

#import "ImageCacheObject.h"

@implementation ImageCache

@synthesize totalSize;

-(id)initWithMaxSize:(NSUInteger) max  {
   
	if (self = [super init]) {
       
		totalSize = 0;
       
		maxSize = max;
       
		myDictionary = [[NSMutableDictionary alloc] init];
    }
   
	return self;
}

-(void)dealloc {
   
	[myDictionary release];
   
	[super dealloc];
}

-(void)insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key{
   
	ImageCacheObject *object = [[ImageCacheObject alloc] initWithSize:sz Image:image];
	
	NSDate *oldestTime = nil;
	
	NSString *oldestKey= nil;
	
	while (totalSize + sz > maxSize) {
    
	
        
		for (NSString *key in [myDictionary allKeys]) {
        
			ImageCacheObject *obj = [myDictionary objectForKey:key];
            
			if (oldestTime == nil || [obj.timeStamp compare:oldestTime] == NSOrderedAscending) {
            
				oldestTime = obj.timeStamp;
                
				oldestKey = key;
            }
        }
        
		if (oldestKey == nil) 
            break; // shoudn't happen
        
		ImageCacheObject *obj = [myDictionary objectForKey:oldestKey];
        
		totalSize -= obj.size;
        
		[myDictionary removeObjectForKey:oldestKey];
    }
   
	[myDictionary setObject:object forKey:key];
    
	[object release];
	
	
}

-(UIImage*)imageForKey:(NSString*)key {
   
	ImageCacheObject *object = [myDictionary objectForKey:key];
    
	if (object == nil)
        return nil;
    
	[object resetTimeStamp];
    
	return object.image;
}

@end
