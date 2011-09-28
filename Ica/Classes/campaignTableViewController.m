//
//  campaignTableViewController.m
//  Ica
//
//  Created by Admin on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "campaignTableViewController.h"
#import "IcaAppDelegate.h"
#import "offerItem.h"
#import "DetailViewController.h"
#import "CustomCell.h"
#import "ImageViewAsync.h"

@implementation campaignTableViewController

@synthesize highlightcell;

#pragma mark -
#pragma mark Initialization

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title=@"Erbjudanden";
	appDelegate = (IcaAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	//to check for interenet connection
	NSStringEncoding enc;
	NSError *error;
	NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.apple.com"] usedEncoding:&enc error:&error];
	if (connected == nil) {
	    NSString * infoString = [NSString stringWithFormat:@"Kontrollera din anslutning och försök igen"];
	    UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Anslutningsproblem" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[infoAlert show];
		[infoAlert release];
    } else {
		[appDelegate readJSONData];
	}
	
	self.view.backgroundColor=[UIColor colorWithRed:204 green:0 blue:0 alpha:100];
		
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.leftBarButtonItem = self.editButtonItem;
	refreshButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked)];
	self.navigationItem.rightBarButtonItem=refreshButton;
	
	app = [UIApplication sharedApplication];

	
}

-(void)refreshClicked{
	self.navigationItem.rightBarButtonItem.enabled=NO;
	
	//check for internet connection
	NSStringEncoding enc;
	NSError *error;
	NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.apple.com"] usedEncoding:&enc error:&error];
	if (connected == nil) {
	    NSString *infoString = [NSString stringWithFormat:@"Kontrollera din anslutning och försök igen"];
	    UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"Anslutningsproblem" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[infoAlert show];
		[infoAlert release];
    } else {
		app.networkActivityIndicatorVisible = YES;
		
		// do data processing in the background
		[self performSelectorInBackground:@selector(doBackgroundProcessing) withObject:self];
		
		UIAlertView *infoAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Kampanjerna är nu uppdaterade" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[infoAlert show];
		[infoAlert release];
	
	}
}

- (void)doBackgroundProcessing {
	
	NSAutoreleasePool*pool=[[NSAutoreleasePool alloc] init]; 
	[appDelegate readJSONData]; 
	
	// must update the UI from the main thread only; equivalent to [self.tableView reloadData]; 
	[self performSelectorOnMainThread:@selector(reloadData) withObject:self.tableView waitUntilDone:NO];
	[pool release];
}

-(void)reloadData{
	[self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (actionSheet.tag==1) {
		highlightcell.highlighted=NO;
	}
	
	if (buttonIndex == 0)
	{
		app.networkActivityIndicatorVisible = NO;
		//self.navigationItem.rightBarButtonItem=refreshButton;
		self.navigationItem.rightBarButtonItem.enabled=YES;
	}
	
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
 */


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [appDelegate.offerlist count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	if ((indexPath.row+1)==[appDelegate.offerlist count]) {
		[spinner stopAnimating];
	}
	*/
	
	static NSString *CellIdentifier = @"customCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        NSArray *nibObjects=[[NSBundle mainBundle]loadNibNamed:@"CustomCell" owner:nil options:nil];
		
		for (id currentObject in nibObjects) {
			if ([currentObject isKindOfClass:[CustomCell class]]){
				cell=(CustomCell *)currentObject;
			}
		}
    }
	
	offerItem *item=(offerItem *)[appDelegate.offerlist objectAtIndex:indexPath.row];
    // Configure the cell...
	
	[[cell itemName] setText:item.name];
	[[cell offer] setText:item.offer];
	[[cell offer] setTextColor:[UIColor redColor]];
	
	NSString *servername = @"http://appcrate.thinkapi.com/asset/upload/i1_";
	NSString *imageString = [servername stringByAppendingString:item.imageURL];
	
	asyncImage = [[[ImageViewAsync alloc]
								   initWithFrame:CGRectMake(7,5,40,40)] autorelease];
	asyncImage.contentMode=UIViewContentModeScaleAspectFit;
 	asyncImage.backgroundColor=[UIColor 
								clearColor];
	NSURL* url = [NSURL URLWithString:imageString];
	[asyncImage loadImageFromURL:url];
	[cell.contentView addSubview:asyncImage];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	
	if (item.card==1) {
		UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 28, 25, 17)];
		imgView.image=[UIImage imageNamed:@"ica_card.png"];
		[cell.contentView addSubview:imgView];
		[imgView release];
	}

	return cell;
}

//increasing table height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

//plus button for editing
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (self.editing) {
		//self.navigationController.navigationBar.tintColor = [UIColor blackColor];
		return UITableViewCellEditingStyleInsert;
	}else {
		return UITableViewCellEditingStyleNone;
	}

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
	highlightcell=[tableView cellForRowAtIndexPath:indexPath];
	
	highlightcell.highlighted=YES;
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
		offerItem *oItem=[appDelegate.offerlist objectAtIndex:indexPath.row];
		Item *item=[[Item alloc]init];
		NSString *addString=[NSString stringWithFormat:@"%@ (%@)",oItem.name,oItem.offer];
		item.iName=addString;
		item.iNeed=1;
		[appDelegate insertItem:item];
		NSString *insertString = [NSString stringWithFormat:@"%@ är inlagd i inköpslistan",item.iName];
	    UIAlertView *insertAlert = [[UIAlertView alloc] initWithTitle:@"ICA" message:insertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		insertAlert.tag=1;
		[insertAlert show];
		[insertAlert release];
		[item release];
    }   
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    offerItem *item=(offerItem *)[appDelegate.offerlist objectAtIndex:indexPath.row];
	
	UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
	[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
	
	// Navigation logic may go here. Create and push another view controller.
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailView" bundle:nil];
	
	detailViewController.item=item;
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
	detailViewController=nil;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[highlightcell release];
    [super dealloc];
}


@end

