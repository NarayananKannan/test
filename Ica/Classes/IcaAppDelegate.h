//
//  IcaAppDelegate.h
//  Ica
//
//  Created by Macbook on 2/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Item.h"

@class cuNavController;
@class slNavController;
@class campaignNavController;

@interface IcaAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	IBOutlet UITabBarController *tcController;
	IBOutlet cuNavController *cuNController;
	IBOutlet slNavController *slNController;
	IBOutlet campaignNavController *campaignNController;
	
	NSString *dbName;			//name of the DB "SL.sqlite"
	NSString *dbPath;			
	sqlite3 *db;				
	sqlite3_stmt *selectStmt;	
	sqlite3_stmt *updateStmt;	
	sqlite3_stmt *insertStmt;	
	sqlite3_stmt *deleteStmt;
	sqlite3_stmt *deleteallStmt;
	NSMutableArray *list;
	NSMutableArray *offerlist;
	NSString *myList;
	BOOL copyDb;
	NSInteger count;			//count for number of items unbought
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tcController;
@property (nonatomic, retain) IBOutlet cuNavController *cuNController;
@property (nonatomic, retain) IBOutlet slNavController *slNController;
@property (nonatomic, retain) IBOutlet campaignNavController *campaignNController;
@property (nonatomic, retain) NSMutableArray *list;
@property (nonatomic, retain) NSMutableArray *offerlist;
@property (nonatomic, retain) NSString *myList;

-(void) connectDatabase;		
-(BOOL) createDatabaseIfNeeded;	
-(void) readTable;
-(void) readJSONData;
-(void) updateItem:(NSIndexPath *)path;
-(void) deleteItem:(NSIndexPath *)path;
-(void) deleteAll;
-(void) insertItem:(Item *)item;
-(void) disconnectDatabase;		
-(void) emailShoppingList;
-(void) setBadgeValue;

@end

