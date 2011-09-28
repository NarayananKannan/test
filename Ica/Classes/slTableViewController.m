//
//  slTableViewController.m
//  Ica
//
//  Created by Macbook on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "slTableViewController.h"
#import "IcaAppDelegate.h"
#import "Item.h"

@implementation slTableViewController
@synthesize list;
@synthesize textField;

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
	appDelegate = (IcaAppDelegate *)[[UIApplication sharedApplication] delegate];
	//set background
	/*
	UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
	self.view.backgroundColor = background;
	[background release];
	*/
	self.view.backgroundColor=[UIColor colorWithRed:204 green:0 blue:0 alpha:100];
	
	self.title=@"Inköpslista";
	self.navigationItem.leftBarButtonItem=self.editButtonItem;
	self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plusClicked:)];
	self.navigationController.toolbarHidden=NO;
	
	UIBarButtonItem *trash = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashClicked:)];
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showShareActionSheet:)];
	
	NSArray *items = [NSArray arrayWithObjects: share,flexItem,trash,nil];
	[trash release];
	[share release];
	[flexItem release];
	
	[self setToolbarItems:items];
	[super viewDidLoad];
	
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 31, 30, 32)];
	imgView.image=[UIImage imageNamed:@"pin_red.png"];
	[self.view addSubview:imgView];
	[imgView release];
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)plusClicked:(id)sender{
	self.navigationItem.rightBarButtonItem=nil;
	[textField becomeFirstResponder];
}

-(void)showShareActionSheet:(id)sender{
	UIActionSheet *shareActionSheet = [[UIActionSheet alloc]initWithTitle:@"Dela inköpslista" delegate:self cancelButtonTitle:@"Avbryt" destructiveButtonTitle:nil otherButtonTitles:@"E-post",@"SMS",nil];
	[shareActionSheet setTag:0];
	[shareActionSheet showInView:[UIApplication sharedApplication].keyWindow];
	[shareActionSheet release];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 0)
	{
		[self emailClicked:nil];
	}else if (buttonIndex ==1) {
		[self smsClicked:nil];
	}else {
			//NSLog(@"cancel");
		}
}
	
-(void)trashClicked:(id)sender{
	UIAlertView *trashAlert=[[UIAlertView alloc]initWithTitle:@"Rensa inköpslistan?" message:@"Är du säker att du vill ta bort alla varor från inköpslistan?" delegate:self cancelButtonTitle:@"Avbryt" otherButtonTitles:@"Ok",nil];
	[trashAlert show];
	[trashAlert release];
}

-(void)emailClicked:(id)sender{
	[appDelegate emailShoppingList];
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate=self;
	[[controller navigationBar]setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
	if ([MFMailComposeViewController canSendMail]) {
		[controller setSubject:@"Min inköpslista till ICA SAMköp"];
		[controller setMessageBody:appDelegate.myList isHTML:NO];
		[self presentModalViewController:controller animated:YES];
	}
	[controller release];
}

-(void)smsClicked:(id)sender{
	[appDelegate emailShoppingList];
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	controller.messageComposeDelegate=self;
	if ([MFMessageComposeViewController canSendText]) {
		controller.body=appDelegate.myList;
		[self presentModalViewController:controller animated:YES];
	}
	else {
		//NSLog(@"Cannot send text from your device");
	}
	[controller release];
	
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0)
	{
		//NSLog(@"cancel");
	}
	else
	{
		[appDelegate deleteAll];
		[self.tableView reloadData];
	}
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
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

-(IBAction)textFieldDidBeginEditing:(UITextField *)textField{
	self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Spara" style:UIBarButtonItemStyleBordered target:self action:@selector(addClicked:)];
	self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Avbryt" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelClicked:)];
}

-(void)addClicked:(id)sender{
	Item *i=[[Item alloc]init];
	i.iName=textField.text;
	i.iNeed=1;
	[appDelegate insertItem:i];
	[i release];
	[appDelegate readTable];
	
	//text field operations
	self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plusClicked:)];
	self.navigationItem.leftBarButtonItem=self.editButtonItem;
	textField.text=@"";
	[textField resignFirstResponder];
	[self.tableView reloadData];
}

-(void)cancelClicked:(id)sender{
	self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(plusClicked:)];
	self.navigationItem.leftBarButtonItem=self.editButtonItem;
	textField.text=@"";
	[textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)txtField{
    [txtField resignFirstResponder];
	[self addClicked:nil];
    return YES;
}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [appDelegate.list count];
}
 



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	Item *i=(Item *)[appDelegate.list objectAtIndex:indexPath.row];
	
	cell.textLabel.text=[NSString stringWithFormat:@"%d. %@",(indexPath.row+1),i.iName];
	if (i.iNeed==0){
		cell.accessoryType=UITableViewCellAccessoryCheckmark;
		cell.textLabel.textColor=[UIColor grayColor];
    }else{
		cell.accessoryType=UITableViewCellAccessoryNone;
		cell.textLabel.textColor=[UIColor blackColor];
	}
	// Configure the cell...
	[cell.textLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	cell.backgroundColor = [UIColor clearColor];
	UIImage *image = [UIImage imageNamed:@"cell.png"];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	cell.backgroundView = imageView;
	[imageView release];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[appDelegate deleteItem:indexPath];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		[self.tableView reloadData];
		
	}   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIImage *myImage = [UIImage imageNamed:@"pin_red.png"];
	UIImageView *imageView = [[[UIImageView alloc] initWithImage:myImage] autorelease];
	imageView.frame = CGRectMake(10,10,300,100);
	return imageView;
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
	
	UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
	//[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//IcaAppDelegate *d=(IcaAppDelegate *)[[UIApplication sharedApplication]delegate];
	Item *item=[(Item *)[appDelegate.list objectAtIndex:indexPath.row]retain];
	
	NSUInteger index=indexPath.row;
	NSUInteger lastindex=appDelegate.list.count-1;
	
	if (item.iNeed==1) {
		item.iNeed=0;
		[appDelegate updateItem:indexPath];
		if (index!=lastindex) {
			//// with animation
			[tableView beginUpdates];
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationBottom];
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
			[tableView endUpdates];		
			[tableView reloadData];
		}
		else{
			cell.accessoryType=UITableViewCellAccessoryCheckmark;
			[tableView reloadData];
		}
	}
	else if(item.iNeed==0) {
		item.iNeed=1;
		cell.accessoryType=UITableViewCellAccessoryNone;
		[appDelegate updateItem:indexPath];
		[tableView reloadData];
	}
	[item release];
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
	self.textField.text=nil;
}


- (void)dealloc {
	[list release];
	[textField release];
    [super dealloc];
}


@end

