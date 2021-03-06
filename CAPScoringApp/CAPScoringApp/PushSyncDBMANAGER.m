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
#import "SessionEventPushRecord.h"
#import "BOWLINGMAIDENSUMMARYPushRecord.h"
#import "BOWLEROVERDETAILSPushRecord.h"
#import "FIELDINGEVENTSPushRecord.h"
#import "DAYEVENTSPushRecord.h"
#import "AppealEventPushRecord.h"
#import "WicketEventsPushRecord.h"
#import "PowerPlayPushRecord.h"
#import "PlayerInOutPushRecord.h"
#import "PenalityDetailsPushRecord.h"
#import "CapTransactionslogentryPushRecord.h"
#import "BowlingSummeryPushRecord.h"
#import "Utitliy.h"

@implementation PushSyncDBMANAGER

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

//Copy database to application document
-(void) copyDatabaseIfNotExist{
    
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
-(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}


-(NSNumber *) getNumberValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [NSNumber numberWithInt: [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"0":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]].intValue];
}

//MATCHREGISTRATION

-(NSMutableArray *)RetrieveMATCHREGISTRATIONData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
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
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
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
                record.   TEAMAPOINTS=[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)] isEqual:@""]?@"0":[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                record.   TEAMBPOINTS=[[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)] isEqual:@""]?@"0":[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                record.   MATCHSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                record.  RECORDSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                record.  CREATEDBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                record. CREATEDDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                record. MODIFIEDBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                record. MODIFIEDDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)];
                record.ISDEFAULTORLASTINSTANCE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)];
                
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)];
                
                [MATCHREGISTRATIONArray addObject:[record MatchRegistrationPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return MATCHREGISTRATIONArray;
    }
}


//MATCHTEAMPLAYERDETAILS

-(NSMutableArray *)RetrieveMATCHTEAMPLAYERDETAILSData:(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
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
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                
                
                record.MATCHTEAMPLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. PLAYINGORDER=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. RECORDSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                //TEAMCODE_TOSSWONBY
                [MATCHTEAMPLAYERDETAILSArray addObject:[record MatchTeamPlayerDetailsPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return MATCHTEAMPLAYERDETAILSArray;
    }
}


//MATCHRESULT


-(NSMutableArray *)RetrieveMATCHRESULTData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *MATCHRESULTArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM MATCHRESULT  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                MatchResultPushRecord *record=[[MatchResultPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. MATCHRESULTCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. MATCHWONTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. TEAMAPOINTS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. TEAMBPOINTS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                record. MANOFTHEMATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. COMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                [MATCHRESULTArray addObject:[record MatchResultPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return MATCHRESULTArray;
    }
}


//MATCHEVENTS
-(NSMutableArray *)RetrieveMATCHEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *MATCHEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        //NSString *query=[NSString stringWithFormat:@"SELECT * FROM MATCHREGISTRATION  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM MATCHEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                MatchEventPushRecord *record=[[MatchEventPushRecord alloc]init];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TOSSWONTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. ELECTEDTO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. BOWLINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                //record. TARGETRUNS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                //record. TARGETOVERS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                //record. TARGETCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                record. TARGETRUNS=[self getNumberValueByNull :statement:6];
                record. TARGETOVERS=[self getNumberValueByNull :statement:7];
                record. TARGETCOMMENTS=[self getValueByNull :statement:8];
                
                
                
                record. BOWLCOMPUTESHOW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                [MATCHEVENTSArray addObject:[record MatchEventPushRecordDictionary]];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return MATCHEVENTSArray;
    }
}

//INNINGSSUMMARY
-(NSMutableArray *)RetrieveINNINGSSUMMARYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
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
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record. BYES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. LEGBYES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                record. NOBALLS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                record. WIDES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                record. PENALTIES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                record. INNINGSTOTAL=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
                record. INNINGSTOTALWICKETS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                [INNINGSSUMMARYArray addObject:[record InningsSummeryPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return INNINGSSUMMARYArray;
    }
}




//SESSIONEVENTS


-(NSMutableArray *)RetrieveSESSIONEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *SESSIONEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM SESSIONEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                SessionEventPushRecord *record=[[SessionEventPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                record. DAYNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record. SESSIONNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. SESSIONSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. SESSIONENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.  STARTOVER=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                record.  ENDOVER=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
                record.  TOTALRUNS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                record.  TOTALWICKETS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)]];
                record.  DOMINANTTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record. SESSIONSTATUS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)]];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                
                [SESSIONEVENTSArray addObject:[record SessionEventPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return SESSIONEVENTSArray;
    }
}


//INNINGSEVENTS
-(NSMutableArray *)RetrieveINNINGSEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
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
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record. INNINGSSTARTTIME=[self getValueByNull :statement:4];
                record. INNINGSENDTIME=[self getValueByNull :statement:5];
                record. STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.  BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.  BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.  CURRENTSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.  CURRENTNONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.  CURRENTBOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record. TOTALRUNS=[self getNumberValueByNull :statement:13];
                record. TOTALOVERS=[self getNumberValueByNull :statement:14];
                record.  TOTALWICKETS=[self getNumberValueByNull :statement:15];
                record.  ISDECLARE=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)]];
                record.  ISFOLLOWON=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)]];
                record.   INNINGSSTATUS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)]];
                record.  BOWLINGEND=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record.   issync=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                
                [INNINGSEVENTSArray addObject:[record InningsEventPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return INNINGSEVENTSArray;
    }
}

//BATTINGSUMMARY
-(NSMutableArray *)RetrieveBATTINGSUMMARYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
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
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record. BATTINGPOSITIONNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. BATSMANCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. RUNS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                record. BALLS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                record. ONES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                record.TWOS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
                record.THREES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                record. FOURS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)]];
                record. SIXES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)]];
                record. DOTBALLS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)]];
                record. WICKETNO=[self getNumberValueByNull :statement:14];
                record. WICKETTYPE=[self getValueByNull :statement:15];
                record. FIELDERCODE=[self getValueByNull :statement:16];
                record. BOWLERCODE=[self getValueByNull :statement:17];
                record. WICKETOVERNO=[self getNumberValueByNull :statement:18];
                record. WICKETBALLNO=[self getNumberValueByNull :statement:19];
                record. WICKETSCORE=[self getNumberValueByNull :statement:20];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                
                [BATTINGSUMMARYArray addObject:[record BATTINGSUMMARYPushRecordDictionary]];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return BATTINGSUMMARYArray;
    }
}

//INNINGSBREAKEVENTS
-(NSMutableArray *)RetrieveIINNINGSBREAKEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *INNINGSBREAKEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM INNINGSBREAKEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                INNINGSBREAKEVENTSPushRecord *record=[[INNINGSBREAKEVENTSPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                record. BREAKNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record. BREAKSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. BREAKENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. ISINCLUDEINPLAYERDURATION=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                record. BREAKCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. issync=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                [INNINGSBREAKEVENTSArray addObject:[record INNINGSBREAKEVENTSPushRecordDictionary]];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return INNINGSBREAKEVENTSArray;
    }
}
//OVEREVENTS

-(NSMutableArray *)RetrieveOVEREVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
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
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record. OVERNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. OVERSTATUS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                [OVEREVENTSArray addObject:[record OVEREVENTSPushRecordDictionary]];
                
                
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return OVEREVENTSArray;
    }
}



//BALLEVENTS
-(NSMutableArray *)RetrieveBALLEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
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
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                

                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. DAYNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. OVERNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                record. BALLNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                record. BALLCOUNT=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                record.OVERBALLCOUNT=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
                record.SESSIONNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
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
                record. ISLEGALBALL=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)]];
                record. ISFOUR=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)]];
                record. ISSIX=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)]];
                record. RUNS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)]];
                record. OVERTHROW=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)]];
                record. TOTALRUNS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)]];
                record.WIDE=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)]];
                record.NOBALL=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)]];
                record. BYES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)]];
                record. LEGBYES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)]];
                record. PENALTY=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)]];
                record. TOTALEXTRAS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)]];
                record. GRANDTOTAL=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)]];
                record. RBW=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)]];
                record. PMLINECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 35)];
                
                record. PMLENGTHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 36)];
                
                record. PMX1=[NSNumber numberWithInt: [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)]].intValue];
                record. PMY1=[NSNumber numberWithInt: [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 38) ]].intValue];
                record. PMX2=[NSNumber numberWithInt: [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 39)]].intValue];
                record. PMY2=[NSNumber numberWithInt: [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 40)]].intValue];
                
                record. PMX3=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 41)]]==nil?@1:[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 41)]];
                record. PMY3=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 42)]]==nil?@1:[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 42)]];
                
                record. WWREGION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 43)];
                record. WWX1=[NSNumber numberWithInt: [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 44)]].intValue];
                record. WWY1=[NSNumber numberWithInt: [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 45)]].intValue];
                record.WWX2=[NSNumber numberWithInt: [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 46)]].intValue];
                record.WWY2=[NSNumber numberWithInt: [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 47)]].intValue];
                
                record. BALLDURATION=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 48)]]==nil?@0:[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 48)]];
                
                record. ISAPPEAL=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 49)]]==nil?@0:[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 49)]];
                record. ISBEATEN=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 50)]];
                record. ISUNCOMFORT=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 51)]];
                record. ISWTB=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 52)]];
                record. ISRELEASESHOT=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 53)]];
                record. MARKEDFOREDIT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 54)];
                
                record.REMARKS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 55)];
                //record. VIDEOFILENAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 56)];
                record. VIDEOFILENAME=@"";
                //record. SHOTTYPECATEGORY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 57)];
                record. SHOTTYPECATEGORY=[self getValueByNull :statement:57];
                record. PMSTRIKEPOINT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 58)];
                
                //record. PMSTRIKEPOINTLINECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 59)];
                record. PMSTRIKEPOINTLINECODE=[self getValueByNull :statement:59];
                //[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 60)];
                
                record. BALLSPEED=[self getValueByNull :statement:60];
                record. UNCOMFORTCLASSIFCATION=[self getValueByNull :statement:61];
                //record. UNCOMFORTCLASSIFCATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 61)];
                record. ISSYNC=[self getValueByNull :statement:62];
                //[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 62)];
                [BALLEVENTSArray addObject:[record BALLEVENTSPushRecordsDictionary]];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return BALLEVENTSArray;
    }
}


//APPEALEVENTS

-(NSMutableArray *)RetrieveAPPEALEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *APPEALEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM APPEALEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                AppealEventPushRecord *record=[[AppealEventPushRecord alloc]init];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.APPEALTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. APPEALSYSTEMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. APPEALCOMPONENTCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. UMPIRECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. BATSMANCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. ISREFERRED=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. APPEALDECISION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.  APPEALCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.  FIELDERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.  COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.  MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.  TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)]];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                
                [APPEALEVENTSArray addObject:[record AppealEventPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return APPEALEVENTSArray;
    }
}



//WICKETEVENTS

-(NSMutableArray *)RetrieveWICKETEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *WICKETEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM WICKETEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                WicketEventsPushRecord *record=[[WicketEventsPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. ISWICKET=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]];
                record. WICKETNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                record. WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record. FIELDINGPLAYER=[self getValueByNull :statement:9];
                record.  WICKETEVENT=[self getValueByNull :statement:11];
                record.  ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                
                [WICKETEVENTSArray addObject:[record WicketEventsPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return WICKETEVENTSArray;
    }
}


//POWERPLAY



-(NSMutableArray *)RetrievePOWERPLAYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *POWERPLAYArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        
      //  @"SELECT * FROM POWERPLAY  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'"
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM POWERPLAY  WHERE  MATCHCODE='%@'",MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                PowerPlayPushRecord *record=[[PowerPlayPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.POWERPLAYCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.STARTOVER=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record.ENDOVER=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record.POWERPLAYTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.RECORDSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.CREATEDBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.CREATEDDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.MODIFIEDBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.MODIFIEDDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.  ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                
                [POWERPLAYArray addObject:[record PowerPlayPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return POWERPLAYArray;
    }
}


//PLAYERINOUTTIME



-(NSMutableArray *)RetrievePLAYERINOUTTIMEData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *PLAYERINOUTTIMEArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM PLAYERINOUTTIME  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                PlayerInOutPushRecord *record=[[PlayerInOutPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.INTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.OUTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                
                
                [PLAYERINOUTTIMEArray addObject:[record PlayerInOutPushRecordDictionary ]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return PLAYERINOUTTIMEArray;
    }
}

//PENALTYDETAILS


-(NSMutableArray *)RetrievePENALTYDETAILSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *PENALTYDETAILSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM PENALTYDETAILS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                PenalityDetailsPushRecord *record=[[PenalityDetailsPushRecord alloc]init];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.PENALTYCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.AWARDEDTOTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.PENALTYRUNS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                record.PENALTYTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.PENALTYREASONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)];
                
                
                [PENALTYDETAILSArray addObject:[record PenalityDetailsPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return PENALTYDETAILSArray;
    }
}


//CAPTRANSACTIONSLOGENTRY

-(NSMutableArray *)RetrieveCAPTRANSACTIONSLOGENTRYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *CAPTRANSACTIONSLOGENTRYArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM PLAYERINOUTTIME  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                CapTransactionslogentryPushRecord *record=[[CapTransactionslogentryPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TABLENAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.SCRIPTTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.SCRIPTDATA=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.USERID=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.LOGDATETIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.SCRIPTSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.SEQNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)];
                
                
                [CAPTRANSACTIONSLOGENTRYArray addObject:[record CapTransactionslogentryPushRecordDictionary]];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return CAPTRANSACTIONSLOGENTRYArray;
    }
}

//BOWLINGMAIDENSUMMARY
-(NSMutableArray *)RetrieveBOWLINGMAIDENSUMMARYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *BOWLINGMAIDENSUMMARYArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM BOWLINGMAIDENSUMMARY  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BOWLINGMAIDENSUMMARYPushRecord *record=[[BOWLINGMAIDENSUMMARYPushRecord alloc]init];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                record. BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. OVERS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                
                [BOWLINGMAIDENSUMMARYArray addObject:[record BOWLINGMAIDENSUMMARYPushRecordDictionary]];
                
                
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return BOWLINGMAIDENSUMMARYArray;
}
}

//BOWLEROVERDETAILS

-(NSMutableArray *)RetrieveBOWLEROVERDETAILSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *BOWLEROVERDETAILSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM BOWLEROVERDETAILS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BOWLEROVERDETAILSPushRecord *record=[[BOWLEROVERDETAILSPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record. OVERNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. STARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. ENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                [BOWLEROVERDETAILSArray addObject:[record BOWLEROVERDETAILSPushRecordDictionary]];
                
                
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return BOWLEROVERDETAILSArray;
    }
}


//FIELDINGEVENTS
-(NSMutableArray *)RetrieveFIELDINGEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *FIELDINGEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM FIELDINGEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                FIELDINGEVENTSPushRecord *record=[[FIELDINGEVENTSPushRecord alloc]init];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.FIELDERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. ISSUBSTITUTE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record. FIELDINGFACTORCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record. NRS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                record.ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
                [FIELDINGEVENTSArray addObject:[record FIELDINGEVENTSPushRecordDictionary]];
                
                
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return FIELDINGEVENTSArray;
    }
}

//DAYEVENTS
-(NSMutableArray *)RetrieveDAYEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *DAYEVENTSArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM DAYEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                DAYEVENTSPushRecord *record=[[DAYEVENTSPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]];
                record. DAYNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record. STARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record. ENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record. TOTALOVERS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                record. TOTALWICKETS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                record. COMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record. DAYSTATUS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                [DAYEVENTSArray addObject:[record DAYEVENTSPushRecordDictionary]];
                
                
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return DAYEVENTSArray;
    }
}




//BOWLINGSUMMARY
-(NSMutableArray *)RetrieveBOWLINGSUMMARYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *BOWLINGSUMMARYArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM BOWLINGSUMMARY  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'", COMPETITIONCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BowlingSummeryPushRecord *record=[[BowlingSummeryPushRecord alloc]init];
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                // [f numberFromString:
                
                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record. BOWLINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.INNINGSNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]];
                record.BOWLINGPOSITIONNO=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]];
                record. BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record. OVERS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]];
                record. BALLS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]];
                record. PARTIALOVERBALLS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)]];
                record. MAIDENS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)]];
                record. RUNS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)]];
                record. WICKETS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)]];
                record. NOBALLS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)]];
                record. WIDES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)]];
                record. DOTBALLS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)]];
                record. FOURS=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)]];
                record. SIXES=[f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,16)]];
                
                record. ISSYNC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                
                
                
                [BOWLINGSUMMARYArray addObject:[record BowlingSummeryPushRecordDictionary]];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return BOWLINGSUMMARYArray;
    }
}
-(BOOL) InsertTransactionLogEntry: (NSString*) MATCHCODE : (NSString*) TABLENAME : (NSString*)SCRIPTTYPE : (NSString*)
SCRIPTDATA
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userCode=[defaults stringForKey:@"userCode"];
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO CAPTRANSACTIONSLOGENTRY ( MATCHCODE, TABLENAME, SCRIPTTYPE, SCRIPTDATA, USERID, LOGDATETIME, SCRIPTSTATUS ) VALUES ( '%@', '%@', '%@', \"%@\", '%@', datetime('now','localtime'), 'MSC247' );",MATCHCODE,TABLENAME,SCRIPTTYPE,SCRIPTDATA,userCode];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
                    NSLog(@"UPDATE Database Error Message : %s", sqlite3_errmsg(dataBase));
                return NO;
            }
        }
        sqlite3_close(dataBase);
    }
    return NO;
}
}
@end
