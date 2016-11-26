//
//  DBManager.m
//  MotivationFromSteveJobs
//
//  Created by Tarpian Gabriel Lucian on 20/11/2016.
//  Copyright © 2016 Tarpian Gabriel Lucian. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

// returns the instance of the database, only one instance available (Singleton Pattern used)
+(DBManager*) getSharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

// creation of the database
-(BOOL) createDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // build the path to the database file
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"quotes.db"]];
    BOOL succes = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // check if the database already exists
    if([fileManager fileExistsAtPath:databasePath ] == NO)
    {
        const char *dbPath = [databasePath UTF8String];
        
        // open the database then execute the statement that creates it
        if(sqlite3_open(dbPath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sqlStatement = "create table if not exists quotes(id integer primary key, quote text)";
            
            if(sqlite3_exec(database, sqlStatement,NULL,NULL, &errMsg ) != SQLITE_OK)
            {
                succes = NO;
                NSLog(@"Failed to create table \n");
            }
            
            sqlite3_close(database);
            
            // populate the database
            [self populateDatabase];

            return succes;
        }
        else
        {
            succes = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return succes;
}

-(BOOL) insertData:(int)quoteId quote:(NSString *)quote
{
    const char *dbPath = [databasePath UTF8String];
    
    // open the database then execute the statement that inserts the quote into it
    if( sqlite3_open(dbPath, &database) == SQLITE_OK )
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into quotes (id, quote) values (\"%d\",\"%@\")",
                               quoteId, quote];
        const char *insertStatement = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insertStatement, -1, &statement, NULL);
        if( sqlite3_step(statement) == SQLITE_DONE )
        {
            return YES;
        }
        
        sqlite3_reset(statement);
    }
    
    return NO;
}

-(NSString*) findById:(int)quoteId
{
    const char *dbPath = [databasePath UTF8String];
    
    // open the database then execute the statement
    if( sqlite3_open(dbPath, &database) == SQLITE_OK )
    {
        NSString *querySQL = [NSString stringWithFormat:@"select quote from quotes where id = \"%d\"",quoteId];
        const char *queryStatement = [querySQL UTF8String];
        NSString *result;
        if( sqlite3_prepare_v2(database, queryStatement, -1, &statement, NULL) == SQLITE_OK)
        {
            // query was succesfully executed
            if( sqlite3_step(statement) == SQLITE_ROW)
            {
                result = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 0)];
                return result;
            }
            else
            {
                NSLog(@"Quote not found");
                return nil;
            }
        }
    }
    
    return nil;
}

-(BOOL) populateDatabase
{
    bool boResult;
    
    // quote id = 1
    boResult = [self insertData:1 quote:@"Your work is going to fill a large part of your life, and the only way to be truly satisfied is to do what you believe is great work. And the only way to do great work is to love what you do. If you haven't found it yet, keep looking. Don't settle. As with all matters of the heart, you'll know when you find it"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 2
    boResult = [self insertData:2 quote:@"My favorite things in life don’t cost any money. It’s really clear that the most precious resource we all have is time"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 3
    boResult = [self insertData:3 quote:@"I think money is a wonderful thing because it enables you to do things. It enables you to invest in ideas that don't have a short-term payback"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 4
    boResult = [self insertData:4 quote:@"That’s been one of my mantras — focus and simplicity. Simple can be harder than complex"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 5
    boResult = [self insertData:5 quote:@"I think if you do something and it turns out pretty good, then you should go do something else wonderful, not dwell on it for too long. Just figure out what’s next"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 6
    boResult = [self insertData:6 quote:@"Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 7
    boResult = [self insertData:7 quote:@"Being the richest man in the cemetery doesn’t matter to me. Going to bed at night saying we’ve done something wonderful...that’s what matters to me"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 8
    boResult = [self insertData:8 quote:@"Here’s to the crazy ones, the misfits, the rebels, the troublemakers, the round pegs in the square holes… The ones who see things differently — they’re not fond of rules… You can quote them, disagree with them, glorify or vilify them, but the only thing you can’t do is ignore them because they change things… They push the human race forward, and while some may see them as the crazy ones, we see genius, because the ones who are crazy enough to think that they can change the world, are the ones who do"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 9
    boResult = [self insertData:9 quote:@"Your time is limited, so don’t waste it living someone else’s life. Don’t be trapped by dogma—which is living with the results of other people’s thinking. Don’t let the noise of others’ opinions drown out your own inner voice. And most important, have the courage to follow your heart and intuition. They somehow already know what you truly want to become. Everything else is secondary"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 10
    boResult = [self insertData:10 quote:@"You can’t connect the dots looking forward; you can only connect them looking backwards. So you have to trust that the dots will somehow connect in your future. You have to trust in something—your gut, destiny, life, karma, whatever. This approach has never let me down, and it has made all the difference in my life"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 11
    boResult = [self insertData:11 quote:@"Be a yardstick of quality. Some people aren’t used to an environment where excellence is expected"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 12
    boResult = [self insertData:12 quote:@"For the past 33 years, I have looked in the mirror every morning and asked myself: ‘If today were the last day of my life, would I want to do what I am about to do today?’ And whenever the answer has been ‘No’ for too many days in a row, I know I need to change something"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 13
    boResult = [self insertData:13 quote:@"I'm convinced that about half of what separates successful entrepreneurs from the non-successful ones is pure perseverance"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 14
    boResult = [self insertData:14 quote:@"Things don’t have to change the world to be important"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 15
    boResult = [self insertData:15 quote:@"Bottom line is, I didn’t return to Apple to make a fortune. I’ve been very lucky in my life and already have one. When I was 25, my net worth was $100 million or so. I decided then that I wasn’t going to let it ruin my life. There’s no way you could ever spend it all, and I don’t view wealth as something that validates my intelligence"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 16
    boResult = [self insertData:16 quote:@"Remembering that you are going to die is the best way I know to avoid the trap of thinking you have something to lose. You are already naked. There is no reason not to follow your heart"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 17
    boResult = [self insertData:17 quote:@"Getting fired from Apple was the best thing that could have ever happened to me. The heaviness of being successful was replaced by the lightness of being a beginner again. It freed me to enter one of the most creative periods of my life"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 18
    boResult = [self insertData:18 quote:@"We don’t get a chance to do that many things, and every one should be really excellent. Because this is our life. Life is brief, and then you die, you know? And we’ve all chosen to do this with our lives. So it better be damn good. It better be worth it"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 19
    boResult = [self insertData:19 quote:@"You have to work hard to get your thinking clean to make it simple. But it’s worth it in the end because once you get there, you can move mountains"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 20
    boResult = [self insertData:20 quote:@"Innovation distinguishes between a leader and a follower"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 21
    boResult = [self insertData:21 quote:@"Stay hungry. Stay foolish"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 22
    boResult = [self insertData:22 quote:@"If you want to live your life in a creative way, as an artist, you have to not look back too much. You have to be willing to take whatever you’ve done and whoever you were and throw them away"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 23
    boResult = [self insertData:23 quote:@"Sometimes life hits you in the head with a brick. Don't lose faith"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 24
    boResult = [self insertData:24 quote:@"No one wants to die. Even people who want to go to heaven don't want to die to get there. And yet death is the destination we all share. No one has ever escaped it. And that is as it should be, because Death is very likely the single best invention of Life. It is Life's change agent. It clears out the old to make way for the new"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 25
    boResult = [self insertData:25 quote:@"Great things in business are never done by one person. They're done by a team of people"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 26
    boResult = [self insertData:26 quote:@"Remembering that I'll be dead soon is the most important tool I've ever encountered to help me make the big choices in life. Because almost everything - all external expectations, all pride, all fear of embarrassment or failure - these things just fall away in the face of death, leaving only what is truly important"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 27
    boResult = [self insertData:27 quote:@"Everyone here has the sense that right now is one of those moments when we are influencing the future"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 28
    boResult = [self insertData:28 quote:@"I believe life is an intelligent thing: that things aren't random"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 29
    boResult = [self insertData:29 quote:@"When you're a carpenter making a beautiful chest of drawers, you're not going to use a piece of plywood on the back, even though it faces the wall and nobody will see it. You'll know it's there, so you're going to use a beautiful piece of wood on the back. For you to sleep well at night, the aesthetic, the quality, has to be carried all the way through"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 30
    boResult = [self insertData:30 quote:@"If you don’t love something, you’re not going to go the extra mile, work the extra weekend, challenge the status quo as much"];
    if(boResult == FALSE)
        return FALSE;
    
    // quote id = 31
    boResult = [self insertData:31 quote:@"If I try my best and fail, well, I've tried my best"];
    if(boResult == FALSE)
        return FALSE;
    
    NSLog(@"Database successfully populated!\n");
    return TRUE;
}

@end
