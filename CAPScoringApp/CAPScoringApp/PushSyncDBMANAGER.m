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


+(NSMutableArray *)RetrieveINNINGSEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *INNINGSEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM INNINGSEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                InningsEventPushRecord *record=[[InningsEventPushRecord alloc]init];
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. INNINGSSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. INNINGSENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.  BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.  BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.  CURRENTSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.  CURRENTNONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.  CURRENTBOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record. TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record. TOTALOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.  TOTALWICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.  ISDECLARE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.  ISFOLLOWON=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.   INNINGSSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                record.  BOWLINGEND=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record.   issync=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                
                [INNINGSEVENTSArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return INNINGSEVENTSArray;
}

//INNINGSBREAKEVENTS
+(NSMutableArray *)RetrieveIINNINGSBREAKEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *INNINGSBREAKEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM INNINGSEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                INNINGSBREAKEVENTSPushRecord *record=[[INNINGSBREAKEVENTSPushRecord alloc]init];
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. BREAKNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. BREAKSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. BREAKENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. ISINCLUDEINPLAYERDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. BREAKCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. issync=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                
                

                
                [INNINGSBREAKEVENTSArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return INNINGSBREAKEVENTSArray;
}
//BALLEVENTS
+(NSMutableArray *)RetrieveBALLEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *BALLEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM BALLEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BALLEVENTSPushRecords *record=[[BALLEVENTSPushRecords alloc]init];
                
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. DAYNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. BALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. BALLCOUNT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.OVERBALLCOUNT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.SESSIONNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record. STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record. NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record. BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record. WICKETKEEPERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record. UMPIRE1CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record. UMPIRE2CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record. ATWOROTW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.BOWLINGEND=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                record.BOWLTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record. SHOTTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                record. ISLEGALBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                record. ISFOUR=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                record. ISSIX=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                record. RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                record. OVERTHROW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                record. TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                record.WIDE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                record.NOBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                record. BYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)];
                record. LEGBYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)];
                record. PENALTY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                record. TOTALEXTRAS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)];
                record. GRANDTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)];
                record. RBW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)];
                record. PMLINECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 35)];
                
                record. PMLENGTHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 36)];
                record.PMX1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)];
                record.PMY1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 38)];
                record. PMX2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 39)];
                record. PMY2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 40)];
                record. PMX3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 41)];
                record. PMY3=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 42)];
                record. WWREGION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 43)];
                record. WWX1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 44)];
                record. WWY1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 45)];
                record.WWX2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 46)];
                record.WWY2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 47)];
                record. BALLDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 48)];
                record. ISAPPEAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 49)];
                record. ISBEATEN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 50)];
                record. ISUNCOMFORT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 51)];
                record. ISWTB=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 52)];
                record. ISRELEASESHOT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 53)];
                record. MARKEDFOREDIT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 54)];
                
                record.REMARKS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 55)];
                record. VIDEOFILENAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 56)];
                record. SHOTTYPECATEGORY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 57)];
                record. PMSTRIKEPOINT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 58)];
                record. PMSTRIKEPOINTLINECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 59)];
                record. BALLSPEED=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 60)];
                record. UNCOMFORTCLASSIFCATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 61)];



                
                
                
                
                
                [BALLEVENTSArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return BALLEVENTSArray;
}

//BATTINGSUMMARY
+(NSMutableArray *)RetrieveBATTINGSUMMARYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *BATTINGSUMMARYArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM BATTINGSUMMARY  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BATTINGSUMMARYPushRecord *record=[[BATTINGSUMMARYPushRecord alloc]init];
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. BATTINGPOSITIONNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. BATSMANCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. BALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. ONES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.TWOS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.THREES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record. FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record. SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record. DOTBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record. WICKETNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record. WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record. FIELDERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record. BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record. WICKETOVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                record. WICKETBALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record. WICKETSCORE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                
              
                
                
                
                [BATTINGSUMMARYArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return BATTINGSUMMARYArray;
}

//OVEREVENTS

+(NSMutableArray *)RetrieveOVEREVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    NSMutableArray *OVEREVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM OVEREVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                OVEREVENTSPushRecord *record=[[OVEREVENTSPushRecord alloc]init];
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. OVERSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                
                [OVEREVENTSArray addObject:record];
                
                
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return OVEREVENTSArray;
}

@end
