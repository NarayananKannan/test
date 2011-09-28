//
//  cuViewController.h
//  Ica
//
//  Created by Macbook on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface cuViewController : UIViewController<MFMailComposeViewControllerDelegate> {

	IBOutlet UIScrollView *scroller;
}

@property (nonatomic,retain) UIScrollView *scroller;

-(IBAction)numberClicked:(id)sender;
-(IBAction)emailClicked:(id)sender;
-(IBAction)addressClicked:(id)sender;

@end
