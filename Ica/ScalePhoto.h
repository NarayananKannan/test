//
//  ScalePhoto.h
//  Providence
//
//  Copyright 2010 EverTrue, LLC. All rights reserved.
//
// $Rev:: 113                                                     $: Latest Revision
// $Author:: EverTrueEric                                         $: Author
// $Date:: 2011-01-24 14:36:28 -0500 (Mon, 24 Jan 2011)           $: Date
//

#import <UIKit/UIKit.h>

@interface UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
 
@end
