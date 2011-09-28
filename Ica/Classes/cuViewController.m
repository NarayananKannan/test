    //
//  cuViewController.m
//  Ica
//
//  Created by Macbook on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cuViewController.h"

@implementation cuViewController
@synthesize scroller;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title=@"Fråga";
	self.view.backgroundColor=[UIColor redColor];
	self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Maila" style:UIBarButtonItemStyleBordered target:self action:@selector(mainEmailClicked:)];
	self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Ring" style:UIBarButtonItemStyleBordered target:self action:@selector(mainCallClicked:)];
	[scroller setScrollEnabled:YES];
	[scroller setContentSize:CGSizeMake(320, 600)];
    [super viewDidLoad];
}


-(IBAction)numberClicked:(id)sender{
	BOOL open;
	NSString *phoneNumber=[NSString stringWithFormat:@"tel://%@",[sender currentTitle]];
	open=[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
	if (!open) {
		//NSLog(@"cannot dial in your device");
	}
}

-(IBAction)emailClicked:(id)sender{
	
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate=self;
	[[controller navigationBar]setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
	NSString *emailId=[NSString stringWithFormat:@"%@",[sender currentTitle]];
	
	if ([MFMailComposeViewController canSendMail]) {
		[controller setToRecipients:[NSArray arrayWithObjects:emailId,nil]];
		[self presentModalViewController:controller animated:YES];
	}
	[controller release];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	[self dismissModalViewControllerAnimated:YES];
}

-(void)mainEmailClicked:(id)sender{
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate=self;
	[[controller navigationBar]setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
	NSString *emailId=[NSString stringWithFormat:@"info@icasamkop.se"];
	
	if ([MFMailComposeViewController canSendMail]) {
		[controller setToRecipients:[NSArray arrayWithObjects:emailId,nil]];
		[self presentModalViewController:controller animated:YES];
	}
	[controller release];
}

-(void)mainCallClicked:(id)sender{
	BOOL open;
	NSString *phoneNumber=[NSString stringWithFormat:@"tel://018-194700"];
	open=[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
	if (!open) {
		//NSLog(@"cannot dial in your device");
	}
}

-(IBAction)addressClicked:(id)sender{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.icasamkop.se"]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[scroller release];
    [super dealloc];
}


@end
