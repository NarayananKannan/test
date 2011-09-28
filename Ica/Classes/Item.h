//
//  Item.h
//  Ica
//
//  Created by Macbook on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Item : NSObject {

	NSInteger iId;
	NSString *iName;
	NSInteger iNeed;

}
@property (nonatomic,readwrite) NSInteger iId;
@property (nonatomic,retain) NSString *iName;
@property (nonatomic,readwrite) NSInteger iNeed;

-(id)initWithPrimaryKey:(NSInteger)nid;

@end
