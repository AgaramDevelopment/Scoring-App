//
//  PushSyncDBMANAGER.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PushSyncDBMANAGER.h"
#import <sqlite3.h>
#import "MatchRegistrationPushRecord.h"
#import "MatchTeamPlayerDetailsPushRecord.h"
#import "MatchResultPushRecord.h"
#import "MatchEventPushRecord.h"
#import "InningsSummeryPushRecord.h"
#import "InningsEventPushRecord.h"
#import "INNINGSBREAKEVENTSPushRecord.h"
#import "BALLEVENTSPushRecords.h"
#import "BATTINGSUMMARYPushRecord.h"
#import "OVEREVENTSPushRecord.h"

@implementation PushSyncDBMANAGER

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

//MATCHREGISTRATION

+(NSMutableArray *)RetrieveMATCHREGISTRATIONData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *MATCHREGISTRATIONArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM MATCHREGISTRATION  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                MatchRegistrationPushRecord *record=[[MatchRegistrationPushRecord alloc]init];
                
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. MATCHOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. MATCHOVERCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. MATCHDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. ISDAYNIGHT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. ISNEUTRALVENUE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.  GROUNDCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.  TEAMACODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.  TEAMBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.  TEAMACAPTAIN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.  TEAMAWICKETKEEPER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record. TEAMBCAPTAIN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record. TEAMBWICKETKEEPER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.  UMPIRE1CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.  UMPIRE2CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.  UMPIRE3CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.   MATCHREFEREECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                //record.  VIDEOLOCATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record.   MATCHRESULT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                record.   MATCHRESULTTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                record.   TEAMAPOINTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                record.   TEAMBPOINTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                record.   MATCHSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                record.  RECORDSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                record.  CREATEDBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                record. CREATEDDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                record. MODIFIEDBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                record. MODIFIEDDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)];
                record.   ISDEFAULTORLASTINSTANCE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)];
               // record.   RELATIVEVIDEOLOCATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                //TEAMCODE_TOSSWONBY
                [MATCHREGISTRATIONArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return MATCHREGISTRATIONArray;
}

//SELECT * FROM  MATCHTEAMPLAYERDETAILS  WHERE COMPETITIONCODE='UCC0000004' AND MATCHCODE='IMSC02400E04C5AE5CD00003'


//MATCHTEAMPLAYERDETAILS

+(NSMutableArray *)RetrieveMATCHTEAMPLAYERDETAILSData:(NSString *) MATCHCODE{
    NSMutableArray *MATCHTEAMPLAYERDETAILSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM MATCHTEAMPLAYERDETAILS  WHERE  MATCHCODE='%@'",MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                MatchTeamPlayerDetailsPushRecord *record=[[MatchTeamPlayerDetailsPushRecord alloc]init];
                
                record.MATCHTEAMPLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. PLAYINGORDER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. RECORDSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
              
                //TEAMCODE_TOSSWONBY
                [MATCHTEAMPLAYERDETAILSArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return MATCHTEAMPLAYERDETAILSArray;
}


//MATCHRESULT


+(NSMutableArray *)RetrieveMATCHRESULTData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *MATCHRESULTArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM MATCHRESULT  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                MatchResultPushRecord *record=[[MatchResultPushRecord alloc]init];
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. MATCHRESULTCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. MATCHWONTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. TEAMAPOINTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. TEAMBPOINTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. MANOFTHEMATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. COMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                [MATCHRESULTArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return MATCHRESULTArray;
}


//MATCHEVENTS
+(NSMutableArray *)RetrieveMATCHEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *MATCHEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM MATCHREGISTRATION  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                MatchEventPushRecord *record=[[MatchEventPushRecord alloc]init];
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TOSSWONTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. ELECTEDTO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. BOWLINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. TARGETRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. TARGETOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. TARGETCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record. BOWLCOMPUTESHOW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                [MATCHEVENTSArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return MATCHEVENTSArray;
}

//INNINGSSUMMARY
+(NSMutableArray *)RetrieveINNINGSSUMMARYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *INNINGSSUMMARYArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM INNINGSSUMMARY  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                InningsSummeryPushRecord *record=[[InningsSummeryPushRecord alloc]init];
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. BYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. LEGBYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. NOBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. PENALTIES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record. INNINGSTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                  record. INNINGSTOTALWICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
               [INNINGSSUMMARYArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return INNINGSSUMMARYArray;
}








@end
