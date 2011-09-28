//
//  ImageCacheObject.h
//  Providence
//
//  Copyright 2010 EverTrue, LLC. All rights reserved.
//
// $Rev:: 113                                                     $: Latest Revision
// $Author:: EverTrueEric                                         $: Author
// $Date:: 2011-01-24 14:36:28 -0500 (Mon, 24 Jan 2011)           $: Date
//

#import <Foundation/Foundation.h>

@interface ImageCacheObject : NSObject {
   
	NSUInteger size;    
   
	NSDate *timeStamp;  
    
	UIImage *image;    
}

@property (nonatomic, readonly) NSUInteger size;

@property (nonatomic, retain, readonly) NSDate *timeStamp;

@property (nonatomic, retain, readonly) UIImage *image;

-(id)initWithSize:(NSUInteger)sz Image:(UIImage*)anImage;

-(void)resetTimeStamp;

@end
