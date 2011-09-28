//
//  DetailViewController.m
//  Ica
//
//  Created by Admin on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "IcaAppDelegate.h"
#import "ImageViewAsync.h"
#import "GANTracker.h"

@implementation DetailViewController
@synthesize item;

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

-(void)viewWillAppear:(BOOL)animated{
	NSString *servername = @"http://appcrate.thinkapi.com/asset/upload/w1_";
	NSString *imageString = [servername stringByAppendingString:item.imageURL];

	asyncImage = [[[ImageViewAsync alloc]
				   initWithFrame:CGRectMake(195,113,100,100)] autorelease];
	asyncImage.backgroundColor=[UIColor 
								clearColor];
 	NSURL* url = [NSURL URLWithString:imageString];
	[asyncImage loadImageFromURL:url];
	[self.view addSubview:asyncImage];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor colorWithRed:204 green:0 blue:0 alpha:100];	
	nameLabel.text=item.name;
	descriptionLabel.text=item.description;
	offerLabel.text=item.offer;
	quantityLabel.text=item.quantity;
	oldpriceLabel.text=item.oldPrice;
	limitPerCustomerLabel.text=item.limitPerCustomer;
	typeOfOfferLabel.text=item.typeOfOffer;
	
	if (item.card==1) {
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(210, 230, 70, 45)];
		imgView.image=[UIImage imageNamed:@"card_ica.png"];
		[self.view addSubview:imgView];
		[imgView release];
	}
	
	NSError *error;
	if (![[GANTracker sharedTracker] trackPageview:@"/DetailView" withError:&error]) {
		// Handle error here
		NSLog(@"Track Detail PageView Error %@ %@",error,[error userInfo]);
	}
}

-(void)addToShoppingList{
	IcaAppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
	Item *ditem=[[Item alloc]init];
	NSString *addString=[NSString stringWithFormat:@"%@ (%@)",item.name,item.offer];
	ditem.iName=addString;
	ditem.iNeed=1;
	[appDelegate insertItem:ditem];
	
	NSString *insertString = [NSString stringWithFormat:@"%@ är inlagd i inköpslistan",ditem.iName];
	UIAlertView *insertAlert = [[UIAlertView alloc] initWithTitle:@"ICA" message:insertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[insertAlert show];
	[insertAlert release];
	
	[ditem release];
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
    [super dealloc];
	[item release];
}


@end
