//
//  DBManager.h
//  MotivationFromSteveJobs
//
//  Created by Tarpian Gabriel Lucian on 20/11/2016.
//  Copyright © 2016 Tarpian Gabriel Lucian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

// returns the instance of the database
+(DBManager*) getSharedInstance;

// creates the database
-(BOOL) createDB;

// insert data into database
-(BOOL) insertData:(int)quoteId quote:(NSString*)quote;

// populate the database
-(BOOL) populateDatabase;

// find the quote by id
-(NSString*) findById:(int)quoteId;
@end
