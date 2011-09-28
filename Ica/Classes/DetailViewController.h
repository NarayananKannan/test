//
//  DetailViewController.h
//  Ica
//
//  Created by Admin on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "offerItem.h"
#import "ImageViewAsync.h"

@interface DetailViewController : UIViewController {
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UILabel *offerLabel;
	IBOutlet UILabel *quantityLabel;
	IBOutlet UILabel *oldpriceLabel;
	IBOutlet UILabel *limitPerCustomerLabel;
	IBOutlet UILabel *startAndEndDateLabel;
	IBOutlet UILabel *typeOfOfferLabel;
	IBOutlet UIImageView *image;
	
	offerItem *item;
	
	ImageViewAsync* asyncImage;
}

@property (nonatomic,retain) offerItem *item;

-(IBAction)addToShoppingList;

@end
