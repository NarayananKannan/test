//
//  ScalePhoto.m
//  Providence
//
//  Copyright 2010 EverTrue, LLC. All rights reserved.
//
// $Rev:: 113                                                     $: Latest Revision
// $Author:: EverTrueEric                                         $: Author
// $Date:: 2011-01-24 14:36:28 -0500 (Mon, 24 Jan 2011)           $: Date
//

#import "ScalePhoto.h"
@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size
{
	
      // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
 	// Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source
{
	CGSize size = [source size];
	UIGraphicsBeginImageContext(size);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[source drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
  	
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	
	CGContextSetLineWidth(context, 3.0);
	
	CGContextStrokeRect(context, rect);
	UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return testImg;
}

 
 
@end