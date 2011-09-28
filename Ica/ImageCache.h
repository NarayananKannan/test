//
//  ImageCache.h
//  Providence
//
//  Copyright 2010 EverTrue, LLC. All rights reserved.
//
// $Rev:: 113                                                     $: Latest Revision
// $Author:: EverTrueEric                                         $: Author
// $Date:: 2011-01-24 14:36:28 -0500 (Mon, 24 Jan 2011)           $: Date
//

#import <Foundation/Foundation.h>

@class ImageCacheObject;

@interface ImageCache : NSObject {
  
	NSUInteger totalSize;  // total number of bytes
    
	NSUInteger maxSize;    // maximum capacity
    
	NSMutableDictionary *myDictionary;
}

@property (nonatomic, readonly) NSUInteger totalSize;

-(id)initWithMaxSize:(NSUInteger) max;

-(void)insertImage:(UIImage*)image withSize:(NSUInteger)sz forKey:(NSString*)key;

-(UIImage*)imageForKey:(NSString*)key;

@end
