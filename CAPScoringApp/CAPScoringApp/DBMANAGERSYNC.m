//
//  DBMANAGERSYNC.m
//  CAPScoringApp
//
//  Created by Lexicon on 22/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBMANAGERSYNC.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@implementation DBMANAGERSYNC

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

//Copy database to application document
+ (void) copyDatabaseIfNotExist{
    
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
    
    //NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {//If file not exist
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SQLITE_FILE_NAME];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

//Get database path
+(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}



+(BOOL) CheckCompetitionCode:(NSString *)COMPETITIONCODE{
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM COMPETITION WHERE COMPETITIONCODE ='%@'",COMPETITIONCODE];
    
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            sqlite3_finalize(statement);
            sqlite3_close(dataBase);
            
            
            return YES;
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}





+(BOOL) InsertMASTEREvents:(NSString*) COMPETITIONCODE:(NSString*) COMPETITIONNAME:(NSString*) SEASON:(NSString*) TROPHY:(NSString*) STARTDATE:(NSString*) ENDDATE:(NSString*) MATCHTYPE:(NSString*) ISOTHERSMATCHTYPE :(NSString*) MANOFTHESERIESCODE:(NSString*) BESTBATSMANCODE :(NSString*) BESTBOWLERCODE:(NSString*) BESTALLROUNDERCODE:(NSString*) MOSTVALUABLEPLAYERCODE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *INSERTSQL = [NSString stringWithFormat:@"INSERT INTO COMPETITION(COMPETITIONCODE,COMPETITIONNAME,SEASON,TROPHY, STARTDATE, ENDDATE,MATCHTYPE,ISOTHERSMATCHTYPE,MANOFTHESERIESCODE,BESTBATSMANCODE, BESTBOWLERCODE,BESTALLROUNDERCODE, MOSTVALUABLEPLAYERCODE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",COMPETITIONCODE,COMPETITIONNAME,SEASON,TROPHY, STARTDATE, ENDDATE,MATCHTYPE,ISOTHERSMATCHTYPE,MANOFTHESERIESCODE,BESTBATSMANCODE, BESTBOWLERCODE,BESTALLROUNDERCODE, MOSTVALUABLEPLAYERCODE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE];
        
        
        const char *update_stmt = [INSERTSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_close(dataBase);
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        
    }
    return YES;
}



+(BOOL ) UPDATECOMPETITION:(NSString*) COMPETITIONCODE:(NSString*) COMPETITIONNAME:(NSString*) SEASON:(NSString*) TROPHY:(NSString*) STARTDATE:(NSString*) ENDDATE:(NSString*) MATCHTYPE:(NSString*) ISOTHERSMATCHTYPE :(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SET COMPETITIONNAME='%@', SEASON='%@', TROPHY='%@',STARTDATE='%@',ENDDATE='%@', MATCHTYPE='%@',ISOTHERSMATCHTYPE='%@', MODIFIEDBY='%@', MODIFIEDDATE='%@', WHERE COMPETITIONCODE='%@'",COMPETITIONNAME,SEASON,TROPHY, STARTDATE, ENDDATE,MATCHTYPE,ISOTHERSMATCHTYPE,MODIFIEDBY,MODIFIEDDATE,COMPETITIONCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return YES;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}



@end
