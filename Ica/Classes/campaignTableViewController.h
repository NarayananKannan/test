//
//  campaignTableViewController.h
//  Ica
//
//  Created by Admin on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IcaAppDelegate.h"
#import "CustomCell.h"
#import "ImageViewAsync.h"

@interface campaignTableViewController : UITableViewController <UITableViewDataSource,UITableViewDataSource,UIAlertViewDelegate>{

	IBOutlet UITableView *cTableView;
	
	IcaAppDelegate *appDelegate;
	ImageViewAsync* asyncImage;
	UIBarButtonItem *refreshButton;
	UIApplication *app;
	UITableViewCell *highlightcell;
}

@property(nonatomic,retain) UITableViewCell *highlightcell;

@end
