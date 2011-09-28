//
//  slTableViewController.h
//  Ica
//
//  Created by Macbook on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IcaAppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface slTableViewController : UITableViewController <UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UITextFieldDelegate,UIActionSheetDelegate> {
	
	IBOutlet UITableView *slTableView;
	NSMutableArray *list;
	IcaAppDelegate *appDelegate;
	IBOutlet UITextField *textField;

}

@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic,retain) UITextField *textField;

-(IBAction)textFieldDidBeginEditing:(UITextField *)textField;
-(void)emailClicked:(id)sender;
-(void)smsClicked:(id)sender;
@end
