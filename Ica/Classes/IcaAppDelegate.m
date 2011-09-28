//
//  IcaAppDelegate.m
//  Ica
//
//  Created by Macbook on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IcaAppDelegate.h"
#import "cuNavController.h"
#import	"slNavController.h"
#import "campaignNavController.h"
#import "Item.h"
#import "JSON.h"
#import "offerItem.h"
#import "GANTracker.h"

@implementation IcaAppDelegate

@synthesize window;
@synthesize tcController;
@synthesize cuNController;
@synthesize slNController;
@synthesize campaignNController;
@synthesize list;
@synthesize offerlist;
@synthesize myList;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after application launch.
	//tracker object
	[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-23115601-3" dispatchPeriod:10 delegate:nil];
	
	
	NSError *error;
	if (![[GANTracker sharedTracker] trackPageview:@"/AppLaunched" withError:&error]) {
		// Handle error here
		NSLog(@"TrackPageView Error %@ %@",error,[error userInfo]);
	}
	
	dbName=@"SL.sqlite";
	copyDb=TRUE;		//flag to copy DB to device
	
	//getting the full path of the DB
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	dbPath = [path stringByAppendingPathComponent:dbName];
	
	db = nil;			//not opened yet
	selectStmt = nil;	//not compiled 
	updateStmt = nil;
	insertStmt=nil;		//not compiled 
	deleteStmt=nil;
	deleteallStmt=nil;
	
	[self connectDatabase];
	[self readTable];
	
    [self.window addSubview:tcController.view];
	[self.window makeKeyAndVisible];
	offerlist = [[NSMutableArray alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[self disconnectDatabase];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[[GANTracker sharedTracker] stopTracker];
	[myList release];
	[dbName release];
	[dbPath release];
	[list release];
	[offerlist release];
	[cuNController release];
	[slNController release];
	[campaignNController release];
	[tcController release];
    [window release];
    [super dealloc];
}

-(void) connectDatabase{
	BOOL success;
	NSError *error;
	list = [[NSMutableArray alloc] init]; // array for items
	
	//check if DB exists in the specified Path
	NSFileManager *fm = [NSFileManager defaultManager]; // file manager
	success = [fm fileExistsAtPath:dbPath];
	
	// if DB does not exist copy from the path already set
	if (!success)
	{
		if (copyDb)
		{
			NSString *appPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbName];
			success = [fm copyItemAtPath:appPath toPath:dbPath error:&error];
		}
	}
	//relese filemanager as we donot need it further
	//[fm release];
	
	// connect to DB and check for SQLITE_OK
	if (sqlite3_open([dbPath UTF8String], &db) != SQLITE_OK)
	{
		sqlite3_close(db);	//if not opened properly close it
		db = nil;		// reset to nil
	}
	
	if (!copyDb && !success)
	{ 
		//create an empty DB if DB does not exist and not able to connect
		[self createDatabaseIfNeeded];
	}
	
}		

-(BOOL) createDatabaseIfNeeded{
	BOOL done;
	int prepared;
	int stepped;
	
	//sql statment for creating new table
	const char *createTable=
	"CREATE  TABLE 'items' ('id' INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , 'name' VARCHAR NOT NULL , 'need' INTEGER DEFAULT 1";
	
	sqlite3_stmt *createStmt;
	
	//prepare the statement and check with SQLITE_OK
	prepared=sqlite3_prepare_v2(db, createTable, -1, &createStmt, NULL);
	
	if (prepared==SQLITE_OK)
		done=TRUE;
	else
		done=FALSE;
	
	//if prepared execute the statement and check with SQLITE_DONE
	if (done) {
		stepped=sqlite3_step(createStmt);
		done=(stepped==SQLITE_DONE);
	}
	
	//release memory for createStmt;
	sqlite3_finalize(createStmt);
	
	return done;	
}	

-(void) insertItem:(Item *)item {
	//NSLog(@"insertin item :%@,need:%d",item.iName,item.iNeed);
	
	const char *sql = "insert into items (name,need) values (?,?);";
	
	if (!insertStmt)
	{ 
		if (sqlite3_prepare_v2(db, sql, -1, &insertStmt, NULL)!=SQLITE_OK)
		{
			NSAssert1(0, @"Error building statement to insert item [%s]", sqlite3_errmsg(db));
		}
	}
	
	// bind values
	NSString *s = item.iName;
	if (s==NULL) s = @"";
	sqlite3_bind_text(insertStmt, 1, [s UTF8String], -1, SQLITE_TRANSIENT);
	
	NSInteger n=item.iNeed;
	sqlite3_bind_int(insertStmt, 2, n);
	
	// now execute sql statement
	if (sqlite3_step(insertStmt)!= SQLITE_DONE)
	{
		NSAssert1(0, @"Error inserting item [%s]", sqlite3_errmsg(db));
	}
	
	// now reset bound statement to original state
	sqlite3_reset(insertStmt);
	
	[self readTable]; // refresh array
}

-(void)readJSONData{
	[offerlist removeAllObjects];
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	
	// Prepare URL request to download statuses from server
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://admin:123@appcrate.thinkapi.com/api/current_items/store_id/1"]];
	
	// Perform request and get JSON back as a NSData object
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	
	// Get JSON as a NSString from NSData response
	NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
	
	// parse the JSON response into an object
	// Here we're using NSArray since we're parsing an array of JSON status objects
	NSArray *statuses = [parser objectWithString:json_string error:nil];
	[json_string release];
	[parser release];
	
	// Each element in statuses is a single status
	// represented as a NSDictionary
	for (NSDictionary *status in statuses)
	{	
		offerItem *oItem=[[offerItem alloc]init];
		oItem.name=[status objectForKey:@"name"];
		oItem.description=[status objectForKey:@"description"];
		oItem.offer=[status objectForKey:@"offer"];
		oItem.quantity=[status objectForKey:@"std"];
		oItem.oldPrice=[status objectForKey:@"old_price"];
		oItem.limitPerCustomer=[status objectForKey:@"limit"];
		oItem.card=[[status objectForKey:@"ica_card"]intValue];
		oItem.typeOfOffer=[status objectForKey:@"type"];
		oItem.imageURL=[status objectForKey:@"image"];
		[offerlist addObject:oItem];
		[oItem release];
	}
}

-(void) readTable{
	
	if(!db)
		return;	
	
	//if database and select stmt is not compiled prepare and execute it,jus like the method above
	if (!selectStmt) {
		const char *sql="SELECT * FROM items order by need DESC;";
		if (sqlite3_prepare_v2(db, sql, -1, &selectStmt, NULL)!=SQLITE_OK){
			selectStmt=nil;
		}
	}
	[list removeAllObjects];
	myList=@"";
	count=0;
	//if prepared execute the statement to fetch the records
	//int stepped;
	while (sqlite3_step(selectStmt)==SQLITE_ROW){
		NSInteger i=sqlite3_column_int(selectStmt, 0);
		Item *item=[[Item alloc]initWithPrimaryKey:i];		//create an Item object
		char *n=(char *)sqlite3_column_text(selectStmt, 1);
		if (n==NULL) n="";
		item.iName=[NSString stringWithUTF8String:(char *)n];
		NSInteger need=sqlite3_column_int(selectStmt, 2);
		item.iNeed=need;
		[list addObject:item];
		if (item.iNeed==1) {
			myList=[myList stringByAppendingString:[NSString stringWithFormat:@"- %@\n",item.iName]];
			count++;
		}
		[item release];
	}
	sqlite3_reset(selectStmt);
	[self setBadgeValue];
}		


-(void)emailShoppingList{
	[self readTable];
}

-(void)updateItem:(NSIndexPath *)path{
	Item *i=(Item *)[list objectAtIndex:path.row];
	//int done;
	
	const char *sql="update items set need=? where id=?";
	
	if(!updateStmt){
		if (sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL)!= SQLITE_OK) {
			//NSLog(@"not able to prepare");
		}
	}
	
	NSInteger need=i.iNeed;
	sqlite3_bind_int(updateStmt, 1, need);
	need=i.iId;
	sqlite3_bind_int(updateStmt, 2, need);
	
	sqlite3_step(updateStmt);
	
	[self readTable];
	sqlite3_reset(updateStmt);
}

-(void)deleteItem:(NSIndexPath *)path{
	
	Item *i = (Item *)[list objectAtIndex:path.row];
	//NSLog(@"Deleting item [%@]", i.iName);
	
	const char *sql = "delete from items where id = ?;";
	
	if (!deleteStmt)
	{ // build update statement
		if (sqlite3_prepare_v2(db, sql, -1, &deleteStmt, NULL)!=SQLITE_OK)
		{
			NSAssert1(0, @"Error building statement to delete items [%s]", sqlite3_errmsg(db));
		}
	}
	
	// bind values to statement
	NSInteger n = i.iId;
	sqlite3_bind_int(deleteStmt, 1, n);
	
	// now execute sql statement
	if (sqlite3_step(deleteStmt)!= SQLITE_DONE)
	{
		NSAssert1(0, @"Error deleting item [%s]", sqlite3_errmsg(db));
	}
	
	// now reset bound statement to original state
	sqlite3_reset(deleteStmt);
	
	[list removeObjectAtIndex:path.row]; // remove from table
	
	[self readTable]; // refresh array
	
}

-(void)deleteAll{
	
	const char *sql = "delete from items where id >= 1";
	
	if (!deleteallStmt)
	{ // build update statement
		if (sqlite3_prepare_v2(db,sql, -1, &deleteallStmt, NULL)!=SQLITE_OK)
		{
			NSLog(@"not able to prepare");
			//NSAssert1(0, @"Error building statement to delete items [%s]", sqlite3_errmsg(db));
		}
	}
	// now execute sql statement
	if (sqlite3_step(deleteallStmt)!= SQLITE_DONE)
	{
		NSLog(@"not able to delete all");
	}
	// now reset bound statement to original state
	sqlite3_reset(deleteallStmt);
	
	[list removeAllObjects];
	[self readTable];		// refresh array
}

-(void) disconnectDatabase{
	sqlite3_finalize(selectStmt); 
	sqlite3_finalize(updateStmt); 
	sqlite3_finalize(deleteStmt); 
	sqlite3_finalize(deleteallStmt); 
	sqlite3_close(db);
}		

-(void)setBadgeValue{
	//set badge value for shopping list
	NSString *badge=[NSString stringWithFormat:@"%d",count];
	[[[[[self tcController]viewControllers] objectAtIndex:1]tabBarItem] setBadgeValue:badge];
}

@end
