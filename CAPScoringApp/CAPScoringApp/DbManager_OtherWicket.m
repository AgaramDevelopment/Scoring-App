//
//  DbManager_OtherWicket.m
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DbManager_OtherWicket.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GetWicketPlayerandtypePlayerDetail.h"
#import "GetPlayerDetail.h"
#import "GetWicketEventsPlayerDetail.h"
#import "GetNotOutOutBatsManPlayerDetail.h"
#import "WicketTypeRecord.h"


@implementation DbManager_OtherWicket
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






//wicket Type
+(NSMutableArray *)RetrieveOtherWicketType{
    NSMutableArray *WicketTypeArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE,METADATATYPECODE,METADATATYPEDESCRIPTION,METASUBCODEDESCRIPTION FROM METADATA  WHERE  METASUBCODE ='MSC102' OR METASUBCODE ='MSC108'  OR METASUBCODE ='MSC101' OR METASUBCODE ='MSC133'  OR METASUBCODE ='MSC107'"];
        
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                WicketTypeRecord *record=[[WicketTypeRecord alloc]init];
                
                record.metasubcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.metadatatypecode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.metadatatypedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.metasubcodedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                [WicketTypeArray addObject:record];
                
                
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return WicketTypeArray;
}






                                               
   @end
