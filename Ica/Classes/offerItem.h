//
//  offerItem.h
//  Ica
//
//  Created by Admin on 4/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface offerItem : NSObject {
	NSString *name;
	NSString *description;
	NSString *offer;
	NSString *quantity;
	NSString *oldPrice;
	NSString *limitPerCustomer;
	//NSString *startAndEndDate;
	NSString *typeOfOffer;
	NSInteger card;
	NSString *imageURL;
}

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *description;
@property (nonatomic,retain) NSString *offer;
@property (nonatomic,retain) NSString *quantity;
@property (nonatomic,retain) NSString *oldPrice;
@property (nonatomic,retain) NSString *limitPerCustomer;
//@property (nonatomic,retain) NSString *startAndEndDate;
@property (nonatomic,retain) NSString *typeOfOffer;
@property (nonatomic,assign) NSInteger card;
@property (nonatomic,retain) NSString *imageURL;

//-(id)initWithID:(NSInteger)xid;

@end
