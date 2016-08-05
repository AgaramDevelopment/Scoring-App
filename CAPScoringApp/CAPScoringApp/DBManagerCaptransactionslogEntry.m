//
//  DBManagerCaptransactionslogEntry.m
//  CAPScoringApp
//
//  Created by APPLE on 05/08/16.
//  Copyright © 2016 agaram. All rights reserved.
//
#import <sqlite3.h>
#import "DBManagerCaptransactionslogEntry.h"
#import "CaptransactionslogEntryRecord.h"

@implementation DBManagerCaptransactionslogEntry


static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}


- (void) copyDatabaseIfNotExist{
    
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

-(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}
-(NSMutableArray *) GetCaptransactionslogentry
{
    NSMutableArray *transactionArray=[[NSMutableArray alloc]init];
   
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT  MATCHCODE, TABLENAME,SCRIPTTYPE,SCRIPTDATA,SCRIPTSTATUS,SEQNO FROM  captransactionslogentry WHERE SCRIPTSTATUS  = 'MSC247'"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                CaptransactionslogEntryRecord *record=[[CaptransactionslogEntryRecord alloc]init];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                 record.TABLENAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.SCRIPTTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                record.SCRIPTDATA=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.SCRIPTSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                record.SEQNO =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                [transactionArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return transactionArray;
    
}

-(BOOL)updateCaptransactionslogentry:(NSString*)SCRIPTSTATUS matchCode:(NSString*) matchCode SEQNO:(NSString*)SEQNO  {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE CAPTRANSACTIONSLOGENTRY SET SCRIPTSTATUS = '%@' WHERE ISNULL(MATCHCODE,'') = '%@' AND SCRIPTSTATUS = 'MSC247' AND SEQNO = '%@';",SCRIPTSTATUS,matchCode,SEQNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    
    
    return NO;
    
}

@end
