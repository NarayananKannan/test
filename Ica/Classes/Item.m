//
//  Item.m
//  Ica
//
//  Created by Macbook on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Item.h"


@implementation Item
@synthesize iId,iName,iNeed;

-(id)initWithPrimaryKey:(NSInteger)nid{
	[super init];
	iId=nid;
	iName=@"";
	iNeed=1;
	
	return self;
}

-(void)dealloc{
	[iName release];
	[super dealloc];
}

@end
