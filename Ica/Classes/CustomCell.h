//
//  CustomCell.h
//  Ica
//
//  Created by Admin on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell {

	IBOutlet UILabel *itemName;
	IBOutlet UILabel *offer;
	
	IBOutlet UIImageView *itemImage;
	IBOutlet UIImageView *card;
}

@property(nonatomic,retain)	IBOutlet UILabel *itemName;
@property(nonatomic,retain)	IBOutlet UILabel *offer;
@property(nonatomic,retain) IBOutlet UIImageView *itemImage;
@property(nonatomic,retain) IBOutlet UIImageView *card;


@end
