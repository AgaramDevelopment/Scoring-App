//
//  DBManager.m
//  CAP
//
//  Created by Lexicon on 20/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManager.h"
#import "EventRecord.h"
#import "UserRecord.h"
#import "TossDeatilsEvent.h"
#import "BowlerEvent.h"
#import "FixturesRecord.h"
#import "OfficialMasterRecord.h"
#import "SelectPlayerRecord.h"
#import "BallEventRecord.h"
#import "AppealRecord.h"
#import "MatcheventRecord.h"
#import "AppealSystemRecords.h"
#import "AppealComponentRecord.h"
#import "AppealUmpireRecord.h"
#import "BowlAndShotTypeRecords.h"
#import "FieldingFactorRecord.h"
#import "FieldingEventRecord.h"
#import "CapitainWicketKeeperRecord.h"
#import "WicketTypeRecord.h"
#import "FetchSEPageLoadRecord.h"
#import "BreakEventRecords.h"
#import "EndInnings.h"
#import "InningsBowlerDetailsRecord.h"
#import "OversorderRecord.h"
#import "MetaDataRecord.h"
#import "PenaltyDetailsRecord.h"
#import "UpdateBreaksArrayDetails.h"
#import "DeleteEventRecord.h"
#import "PowerPlayRecord.h"
#import "PushSyncDBMANAGER.h"
#import "Utitliy.h"

@implementation DBManager

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}

//Copy database to application document
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

//Get database path
-(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
}





//Copy database to application document



-(NSMutableArray *)RetrieveEventData: (NSString *) userCode{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT  COM.COMPETITIONCODE,COM.COMPETITIONNAME,COM.RECORDSTATUS FROM COMPETITION COM INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE=COM.COMPETITIONCODE AND MATCHSTATUS IN('MSC123','MSC281')INNER JOIN MATCHSCORERDETAILS MATSC ON MR.COMPETITIONCODE=MATSC.COMPETITIONCODE AND MR.MATCHCODE=MATSC.MATCHCODE WHERE   MATSC.SCORERCODE='%@' GROUP BY   COM.COMPETITIONCODE,COM.COMPETITIONNAME,COM.RECORDSTATUS",userCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EventRecord *record=[[EventRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                record.competitioncode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.competitionname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.recordstatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    }
}










-(NSMutableArray *)RetrieveEventData1: (NSString *) userCode{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT  COM.COMPETITIONCODE,COM.COMPETITIONNAME,COM.RECORDSTATUS FROM COMPETITION COM INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE=COM.COMPETITIONCODE AND MATCHSTATUS NOT IN ('MSC123','MSC281')  INNER JOIN MATCHSCORERDETAILS MATSC ON MR.COMPETITIONCODE=MATSC.COMPETITIONCODE AND MR.MATCHCODE=MATSC.MATCHCODE WHERE   MATSC.SCORERCODE='%@' GROUP BY COM.COMPETITIONCODE,COM.COMPETITIONNAME,COM.RECORDSTATUS",userCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                EventRecord *record=[[EventRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                record.competitioncode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.competitionname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.recordstatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}





-(BOOL)checkExpiryDate: (NSString *) userId{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT  USERCODE  FROM Userdetails WHERE  strftime('%%Y-%%m-%%d %%H:%%M:%%S', LICENSEUPTO) >= datetime('now','localtime') AND USERCODE = '%@'",userId];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
        
    }
    return NO;
	}
}



-(BOOL)checkSecurityExpiryDate: (NSString *) USERNAME{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT  USERNAME  FROM SECUREIDDETAILS WHERE  strftime('%%Y-%%m-%%d %%H:%%M:%%S', ENDDATE) >= datetime('now','localtime') AND USERNAME = '%@'",USERNAME];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
        
    }
    return NO;
	}
}


-(NSMutableArray *)checkUserLogin: (NSString *) userName password: (NSString *) password{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT USERCODE,LOGINID  FROM Userdetails WHERE  LOGINID = '%@' AND PASSWORD = '%@' AND RECORDSTATUS = 'MSC001'",userName,password];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                UserRecord *record=[[UserRecord alloc]init];
                record.userCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.userName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [eventArray addObject:record];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
	}
}





-(NSMutableArray *)checkTossDetailsWonby: (NSString *) MATCHCODE{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *TOSSWonArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT MR.TEAMACODE AS TEAMCODE,TMA.TEAMNAME AS TEAMNAME FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TMA ON TMA.TEAMCODE = MR.TEAMACODE WHERE MR.MATCHCODE = '%@' UNION SELECT MR.TEAMBCODE AS TEAMCODE,TMB.TEAMNAME AS TEAMNAME  FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TMB ON TMB.TEAMCODE = MR.TEAMBCODE WHERE MR.MATCHCODE = '%@'", MATCHCODE,MATCHCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                EventRecord *record=[[EventRecord alloc]init];
                //need to edit
                record.TEAMCODE_TOSSWONBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMNAME_TOSSWONBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [TOSSWonArray addObject:record];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return TOSSWonArray;
	}
}




-(NSMutableArray *)Electedto{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *electedeventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT [METASUBCODE],[METASUBCODEDESCRIPTION]FROM [METADATA] WHERE [METADATATYPECODE] = 'MDT007'"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                UserRecord *record=[[UserRecord alloc]init];
                record.MasterSubCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.electedTo=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [electedeventArray addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return electedeventArray;
    }
}




-(NSMutableArray *)StrikerNonstriker: (NSString *) MATCHCODE :(NSString *) TeamCODE{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *SrikerEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME,PM.BATTINGSTYLE FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE  AND MTP.RECORDSTATUS='MSC001' WHERE MTP.MATCHCODE='%@'  AND MTP.TEAMCODE='%@' order by PLAYINGORDER asc", MATCHCODE,TeamCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                TossDeatilsEvent *record=[[TossDeatilsEvent alloc]init];
                //need to edit
                record.PlaercodeStrike_nonStrike=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PlaerNameStrike_nonStrike=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.batMenStyle=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                
                //TEAMCODE_TOSSWONBY
                [SrikerEventArray addObject:record];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return SrikerEventArray;
	}
}




-(NSMutableArray *)Bowler: (NSString *) MATCHCODE :(NSString *) TeamCODE{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *BowlerEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE INNER JOIN MATCHREGISTRATION MR ON MR.MATCHCODE=MTP.MATCHCODE  AND MTP.PLAYERCODE!=MR.TEAMAWICKETKEEPER AND  MTP.PLAYERCODE!=MR.TEAMBWICKETKEEPER AND MTP.RECORDSTATUS='MSC001' WHERE MTP.MATCHCODE='%@'  AND MTP.TEAMCODE='%@'", MATCHCODE,TeamCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BowlerEvent *record=[[BowlerEvent alloc]init];
                //need to edit
                record.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                //TEAMCODE_TOSSWONBY
                [BowlerEventArray addObject:record];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return BowlerEventArray;
	}
}




// fixtures

-(NSMutableArray *)RetrieveFixturesData:(NSString*)competitionCode :(NSString*)userCode {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        //
        NSString *query=[NSString stringWithFormat:@"SELECT MR.MATCHCODE,MR.MATCHNAME,MR.COMPETITIONCODE,MR.MATCHOVERCOMMENTS,MR.MATCHDATE,MR.GROUNDCODE,GM.GROUNDNAME,GM.CITY,MR.TEAMACODE,MR.TEAMBCODE ,TM.SHORTTEAMNAME AS TEAMANAME,TM1.SHORTTEAMNAME AS TEAMBNAME,MR.MATCHOVERS,MD.METASUBCODEDESCRIPTION AS MATCHTYPENAME, CP.MATCHTYPE AS MATCHTYPECODE, MR.MATCHSTATUS FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MR.TEAMACODE INNER JOIN TEAMMASTER TM1 ON TM1.TEAMCODE = MR.TEAMBCODE INNER JOIN GROUNDMASTER GM ON GM.GROUNDCODE = MR.GROUNDCODE INNER JOIN COMPETITION CP ON CP.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN METADATA MD ON CP.MATCHTYPE = MD.METASUBCODE INNER JOIN  MATCHSCORERDETAILS MSD ON CP.COMPETITIONCODE = MSD.COMPETITIONCODE AND MSD.SCORERCODE = '%@' AND MSD.MATCHCODE = MR.MATCHCODE WHERE MR.COMPETITIONCODE='%@' AND MR.MATCHSTATUS in ('MSC123','MSC281') GROUP BY MSD.MATCHCODE ORDER BY MATCHDATE ASC" ,userCode,competitionCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FixturesRecord *record=[[FixturesRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                
                record.matchcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.competitioncode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                //        const  char mcod = *sqlite3_column_text(statement, 3);
                NSString* mCode=[NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, 3)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 3)]];
                // mCode = [mCode isEqual:@"(null)"]?@"":mCode;
                record.matchovercomments=mCode;
                record.matchdate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.groundcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.groundname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.city=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.teamAcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.teamBcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.teamAname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.teamBname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.overs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.matchTypeName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.matchTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.MatchStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    }
}



-(NSMutableArray *)RetrieveSCORE2:(NSString*)competitionCode :(NSString*)matchcode :(NSString*)userCode {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        //
        NSString *query=[NSString stringWithFormat:@"SELECT SCORERCODE,USD.USERFULLNAME FROM MATCHSCORERDETAILS MAS INNER JOIN USERDETAILS USD ON USD.USERCODE=MAS.SCORERCODE WHERE MAS.COMPETITIONCODE='%@' AND MAS.MATCHCODE='%@' AND MAS.SCORERCODE!='%@' LIMIT 1",competitionCode,matchcode,userCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                OfficialMasterRecord *record=[[OfficialMasterRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                
                record.scorecode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.scorename2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
    }
    return eventArray;
	}
    
}


//Update match overs in match registration
-(BOOL)updateOverInfo:(NSString*)overs matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode  {
    
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update MATCHREGISTRATION Set MATCHOVERS = '%@',MODIFIEDDATE = CURRENT_TIMESTAMP WHERE MATCHCODE='%@' AND COMPETITIONCODE='%@'",overs,matchCode,competitionCode];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:matchCode :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
                
                
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
}

-(BOOL)updateProcced:(NSString*)CompetitionCode:(NSString*)MATCHCODE  {
    
    @synchronized ([Utitliy syncId]) {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHSTATUS = (CASE WHEN MATCHSTATUS = 'MSC123' THEN 'MSC281' ELSE MATCHSTATUS END) WHERE COMPETITIONCODE ='%@' AND MATCHCODE ='%@';",CompetitionCode,MATCHCODE];
            const char *update_stmt = [updateSQL UTF8String];
            if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    
                    PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                    [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
                    
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
}


-(BOOL)updateFixtureInfo:(NSString*)comments matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode  {
    @synchronized ([Utitliy syncId]) {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    
    
    
    
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update MATCHREGISTRATION Set MATCHOVERCOMMENTS = '%@' WHERE MATCHCODE='%@' AND COMPETITIONCODE='%@'",comments,matchCode,competitionCode];
        const char *insert_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:matchCode :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
                
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
    
    
}

-(BOOL)updateMatchStatusProcced:(NSString*)CompetitionCode:(NSString*)MATCHCODE  {
    
    @synchronized ([Utitliy syncId]) {
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHSTATUS = (CASE WHEN MATCHSTATUS = 'MSC281' THEN 'MSC123' ELSE MATCHSTATUS END) WHERE COMPETITIONCODE ='%@' AND MATCHCODE ='%@';",CompetitionCode,MATCHCODE];
            const char *update_stmt = [updateSQL UTF8String];
            if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    
                    PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                    [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
                    
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
}




-(NSMutableArray *)RetrieveOfficalMasterData:(NSString*) matchCode competitionCode:(NSString*)competitionCode{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    //    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT MR.UMPIRE1CODE ,OM.NAME AS  UMPIRE1NAME, MR.UMPIRE2CODE,OM1.NAME AS UMPIRE2NAME,MR.UMPIRE3CODE,IFNULL(OM2.NAME,'-') AS UMPIRE3NAME,MR.MATCHREFEREECODE, IFNULL(OM3.NAME,'-')   AS MATCHREFEREENAME  FROM  MATCHREGISTRATION MR  INNER JOIN OFFICIALSMASTER OM ON MR.UMPIRE1CODE= OM.OFFICIALSCODE  INNER JOIN OFFICIALSMASTER OM1 ON MR.UMPIRE2CODE= OM1.OFFICIALSCODE  LEFT JOIN OFFICIALSMASTER OM2 ON MR.UMPIRE3CODE= OM2.OFFICIALSCODE  LEFT JOIN OFFICIALSMASTER OM3 ON MR.MATCHREFEREECODE= OM3.OFFICIALSCODE  WHERE MATCHCODE='%@' AND COMPETITIONCODE='%@'",matchCode,competitionCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                OfficialMasterRecord *record=[[OfficialMasterRecord alloc]init];
                
                
                record.umpire1code=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.umpire1name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.umpire2code=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.umpire2name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.umpire3code=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.umpire3name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.matchrefereecode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.matchrefereename=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}



//select count team A and B players
-(NSMutableArray *)SelectTeamPlayers:(NSString*) matchCode teamCode:(NSString*)teamCode  {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    // NSString *count = [[NSString alloc]init];
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT COUNT(*) AS COUNT FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND TEAMCODE = '%@' AND RECORDSTATUS = 'MSC001'",matchCode,teamCode];
        stmt=[selectPlayersSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FixturesRecord *record=[[FixturesRecord alloc]init];
                record.count=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    }
}

//Fetch active players based on team code
-(NSMutableArray *)getSelectingPlayerArray: (NSString *) teamCode matchCode:(NSString *) matchCode{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *selectPlayerArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    //NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT distinct PM.PLAYERCODE, PM.PLAYERNAME,MTPD.RECORDSTATUS,MTPD.PLAYINGORDER  FROM PLAYERTEAMDETAILS AS PTD INNER JOIN PLAYERMASTER AS PM ON PTD.PLAYERCODE = PM.PLAYERCODE INNER JOIN MATCHTEAMPLAYERDETAILS MTPD ON MTPD.PLAYERCODE = PTD.PLAYERCODE  WHERE MTPD.RECORDSTATUS = 'MSC001' AND PTD.RECORDSTATUS = 'MSC001'  AND PTD.TEAMCODE = '%@' AND MTPD.MATCHCODE = '%@'  ORDER BY MTPD.PLAYINGORDER",teamCode,matchCode];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                SelectPlayerRecord *record=[[SelectPlayerRecord alloc]init];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *recordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.playerOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                //Set selected based on record status
                record.isSelected = [NSNumber numberWithInteger:[recordStatus isEqual:@"MSC001"]?1:0];
                
                [selectPlayerArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return selectPlayerArray;
	}
}

-(NSMutableArray *)getSelectingPlayer: (NSString *) teamCode matchcode:(NSString *) matchcode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *selectPlayerArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    //NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT distinct PM.PLAYERCODE, PM.PLAYERNAME,MTPD.RECORDSTATUS,MTPD.PLAYINGORDER  FROM PLAYERTEAMDETAILS AS PTD INNER JOIN PLAYERMASTER AS PM ON PTD.PLAYERCODE = PM.PLAYERCODE INNER JOIN COMPETITIONTEAMPLAYER CTP ON CTP.PLAYERCODE = PTD.PLAYERCODE LEFT JOIN MATCHTEAMPLAYERDETAILS MTPD ON MTPD.PLAYERCODE = PTD.PLAYERCODE AND  MTPD.TEAMCODE=PTD.TEAMCODE AND MATCHCODE='%@' WHERE PM.RECORDSTATUS = 'MSC001'   AND PTD.TEAMCODE = '%@' order by PLAYINGORDER asc ",matchcode,teamCode];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                SelectPlayerRecord *record=[[SelectPlayerRecord alloc]init];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *recordStatus=[self getValueByNull:statement :2];
                record.playerOrder=[self getValueByNull:statement :3];
                
                //Set selected based on record status
                record.isSelected = [NSNumber numberWithInteger:[recordStatus isEqual:@"MSC001"]?1:0];
                
                [selectPlayerArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return selectPlayerArray;
	}
}

# pragma Create automatically TeamPlayerCode

-(NSString*)  GetMaxIdForInsertMatchTeamPlayer{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT 'MRP' ||SUBSTR(SUBSTR(QUOTE(ZEROBLOB(5)),3,10) ||  CAST(CAST(IFNULL(MAX(SUBSTR(MATCHTEAMPLAYERCODE,-7)),0) AS INT)+1 AS TEXT),-7,7) FROM MATCHTEAMPLAYERDETAILS"];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BallCodeNo =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BallCodeNo;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
        
    }
    
    return @"";
	}
}

# pragma SelectPlayerExit

-(NSString *)SelectPlayerExit:(NSString *) matchCode :(NSString *) PlayerCode :(NSString *) TeamCode;
{
@synchronized ([Utitliy syncId]) {
    NSString * Exit;
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"select  PLAYERCODE,TEAMCODE ,MATCHCODE From MATCHTEAMPLAYERDETAILS   WHERE PLAYERCODE='%@' AND MATCHCODE='%@' AND TEAMCODE = '%@'",PlayerCode,matchCode,TeamCode];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                // MatcheventRecord *matchrecord=[[MatcheventRecord alloc]init];
                
                Exit = @"YES";
                
                
                //[TossArray addObject:matchrecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return Exit;
	}
}



# pragma InsertSelectPlayer Method

-(BOOL)InsertSelectPlayer:(NSString*)playerCode :(NSString*) matchCode :(NSString *)MatchTeamPlayerCode:(NSString *) Teamcode:(NSString *) Playerorder :(NSString*)recordStatus
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"Insert into MATCHTEAMPLAYERDETAILS  ( MATCHTEAMPLAYERCODE,MATCHCODE,TEAMCODE,PLAYERCODE,PLAYINGORDER,RECORDSTATUS) VALUES (\'%@\',\'%@\',\'%@\',\'%@\',\'%@\',\'%@\')",MatchTeamPlayerCode,matchCode,Teamcode,playerCode,Playerorder,recordStatus];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:matchCode :@"MATCHTEAMPLAYERDETAILS" :@"MSC251" :updateSQL];
                
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
}


//Update selected player record status
-(BOOL)updateSelectedPlayersResultCode:(NSString*)playerCode matchCode:(NSString*) matchCode recordStatus:(NSString*)recordStatus:(NSString*)playingOrder  {
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHTEAMPLAYERDETAILS SET RECORDSTATUS = '%@',PLAYINGORDER = '%@' WHERE PLAYERCODE='%@' AND MATCHCODE='%@'",recordStatus,playingOrder,playerCode,matchCode];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
            
                
                [objPushSyncDBMANAGER InsertTransactionLogEntry:matchCode :@"MATCHTEAMPLAYERDETAILS" :@"MSC251" :updateSQL];
                
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
}


-(BOOL) saveBallEventData:(BallEventRecord *) ballEventData
{
@synchronized ([Utitliy syncId]) {
    BOOL success;
    NSString *databasePath =[self getDBPath];
    sqlite3 *mySqliteDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        
        
      //  [Utitliy getWagonWheelXAxisForDB: ballEventData.objWWX1],[Utitliy getWagonWheelYAxisForDB: ballEventData.objWWY1],[Utitliy getWagonWheelXAxisForDB: ballEventData.objWWX2],[Utitliy getWagonWheelYAxisForDB: ballEventData.objWWY2]
        
       // ballEventData.objWWX1,ballEventData.objWWY1,ballEventData.objWWX2,ballEventData.objWWY2
        
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO BALLEVENTS(BALLCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,DAYNO,INNINGSNO,OVERNO,BALLNO,BALLCOUNT,OVERBALLCOUNT,SESSIONNO,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE,UMPIRE2CODE,ATWOROTW,BOWLINGEND,BOWLTYPE,SHOTTYPE,ISLEGALBALL,ISFOUR,ISSIX,RUNS,OVERTHROW,TOTALRUNS,WIDE,NOBALL,BYES,LEGBYES,PENALTY,TOTALEXTRAS,GRANDTOTAL,RBW,PMLINECODE,PMLENGTHCODE,PMX1,PMY1,PMX2,PMY2,WWREGION,WWX1,WWY1,WWX2,WWY2,BALLDURATION,ISAPPEAL,ISBEATEN,ISUNCOMFORT,ISWTB,ISRELEASESHOT,MARKEDFOREDIT,REMARKS,VIDEOFILENAME,SHOTTYPECATEGORY,PMSTRIKEPOINT,PMSTRIKEPOINTLINECODE,BALLSPEED,UNCOMFORTCLASSIFCATION) VALUES (\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\" %@\",\"%@\",\"%@\",\"%@\",\"PYC0000146\",\"OFC0000001\",\"OFC0000002\",\"%@\",\"BWT0000009\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"0\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'%@',\"%@\",\"%@\",\"%@\",\"%@\",'%@','%@','0',1,'0','0','0','0','%@',1,1,2,2,2,2)",ballEventData.objBallcode,ballEventData.objcompetitioncode,ballEventData.objmatchcode,ballEventData.objTeamcode,ballEventData.objDayno,ballEventData.objInningsno,ballEventData.objOverno,ballEventData.objBallno,ballEventData.objBallcount,ballEventData.objOverBallcount,ballEventData.objSessionno,ballEventData.objStrikercode,ballEventData.objNonstrikercode,ballEventData.objBowlercode,ballEventData.objAtworotw,ballEventData.objBowltype,ballEventData.objShottype,ballEventData.objIslegalball,ballEventData.objIsFour,ballEventData.objIssix,ballEventData.objRuns,ballEventData.objOverthrow,ballEventData.objTotalruns,ballEventData.objWide,ballEventData.objNoball,ballEventData.objByes,ballEventData.objLegByes,ballEventData.objTotalextras,ballEventData.objGrandtotal,ballEventData.objRbw,ballEventData.objPMlinecode,ballEventData.objPMlengthcode,ballEventData.objPMX1,ballEventData.objPMY1,  [Utitliy getPitchMapXAxisForDB:ballEventData.objPMX2] ,  [Utitliy getPitchMapYAxisForDB:ballEventData.objPMY2],ballEventData.objWWREGION,[Utitliy getWagonWheelXAxisForDB: ballEventData.objWWX1],[Utitliy getWagonWheelYAxisForDB: ballEventData.objWWY1],[Utitliy getWagonWheelXAxisForDB: ballEventData.objWWX2],[Utitliy getWagonWheelYAxisForDB: ballEventData.objWWY2],ballEventData.objballduration,ballEventData.objRemark];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        if(sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(mySqliteDB);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:ballEventData.objmatchcode :@"BALLEVENTS" :@"MSC250" :insertBallevent];
                
                
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(mySqliteDB);
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(mySqliteDB);
        
    }
    
    return NO;
    }
    
}

-(BOOL) insertBallCodeAppealEvent:(BallEventRecord *) ballEvent
{
@synchronized ([Utitliy syncId]) {
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dataBase) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO APPEALEVENTS(BALLCODE,APPEALTYPECODE,APPEALSYSTEMCODE,APPEALCOMPONENTCODE,UMPIRECODE,BATSMANCODE,ISREFERRED,APPEALDECISION,APPEALCOMMENTS,FIELDERCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO) VALUES (\"%@\",\"MSC104\",\"MSC218\",\"MSC219\",\"OFC0000001\",\"PYC0000359\",\"MSC118\",\"MSC236\",\"PYC0000148\",\"UCC0000004\",\"%@\",\"%@\",\"%@\",\"%@\")",ballEvent.objBallcode,ballEvent.objcompetitioncode,ballEvent.objmatchcode,ballEvent.objTeamcode,ballEvent.objInningsno];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:ballEvent.objmatchcode :@"APPEALEVENTS" :@"MSC250" :insertBallevent];
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
}

-(BOOL) insertBallCodeFieldEvent :(BallEventRecord *) ballEvent bowlerEvent:(BowlerEvent *)bowlerEvent fieldingFactor:(FieldingFactorRecord *) fieldingFactor nrs:(NSString *) nrs;

{
@synchronized ([Utitliy syncId]) {
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dataBase) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO FIELDINGEVENTS(BALLCODE,FIELDERCODE,ISSUBSTITUTE,FIELDINGFACTORCODE,NRS,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO) VALUES (\"%@\",\"%@\",\"MSC218\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",ballEvent.objBallcode,bowlerEvent.BowlerCode,fieldingFactor.fieldingfactorcode,nrs,ballEvent.objcompetitioncode,ballEvent.objmatchcode,ballEvent.objTeamcode,ballEvent.objInningsno];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:ballEvent.objmatchcode :@"FIELDINGEVENTS" :@"MSC250" :insertBallevent];
                
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
}

-(BOOL) insertBallCodeWicketEvent :(BallEventRecord *) ballEvent
{
@synchronized ([Utitliy syncId]) {
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dataBase) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO WICKETEVENTS(BALLCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER,VIDEOLOCATION,WICKETEVENT) VALUES (\"%@\",\"%@\",\"%@\",\"MSC219\",\"OFC0000001\",\"PYC0000359\",\"MSC118\",\"MSC236\",\"PYC0000148\",\"\",\"\",\"\")",ballEvent.objBallcode,ballEvent.objcompetitioncode,ballEvent.objmatchcode];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:ballEvent.objmatchcode :@"WICKETEVENTS" :@"MSC250" :insertBallevent];
                
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
    
}


-(NSString *) getballcodemethod :(NSString *)matchcode
{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    const char *dbpath = [databasePath UTF8String];
    
    NSString* ballcodeStr = [[NSString alloc] init];
    // Setup the database object
    sqlite3 *database2;
    // Open the database from the users filessytem
    if(sqlite3_open(dbpath, &database2) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        //SQLIte Statement
        //select    matchcode || substr(  (SELECT    10000000000+max(ifnull(substr( BALLCODE,25,38) ,0))+1 as a  FROM BALLEVENTS where matchcode='%@') ,2,10)    FROM BALLEVENTS where matchcode='%@'
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"select    max(BALLCODE) FROM BALLEVENTS where matchcode= '%@'",matchcode];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database2, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                ballcodeStr =[self getValueByNull :compiledStatement :0];
                
                //[ModiArray addObject:recordParentID];
            }
            sqlite3_reset(compiledStatement);
            sqlite3_finalize(compiledStatement);
            
        }
        
        
        sqlite3_close(database2);
        
    }
    
    return ballcodeStr;
    }
}

-(NSMutableArray *) getTeamCodemethod
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    const char *dbpath = [databasePath UTF8String];
    
    NSMutableArray* ModiArray = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database2;
    // Open the database from the users filessytem
    if(sqlite3_open(dbpath, &database2) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        //SQLIte Statement
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select TEAMCODE from INNINGSEVENTS"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database2, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSString *recordParentID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                [ModiArray addObject:recordParentID];
            }
            sqlite3_reset(compiledStatement);
            sqlite3_finalize(compiledStatement);
            
        }
        sqlite3_close(database2);
        
    }
    
    return ModiArray;
    }
}

-(NSMutableArray *) getInningsNomethod
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    const char *dbpath = [databasePath UTF8String];
    
    NSMutableArray* ModiArray = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database2;
    // Open the database from the users filessytem
    if(sqlite3_open(dbpath, &database2) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        //SQLIte Statement
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select INNINGSNO from INNINGSEVENTS"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database2, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSString *recordParentID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                [ModiArray addObject:recordParentID];
            }
            
            sqlite3_reset(compiledStatement);
            sqlite3_finalize(compiledStatement);
            
        }
        sqlite3_close(database2);
        
    }
    
    return ModiArray;
	}
}
-(NSMutableArray *) getDayNomethod
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath =[self getDBPath];
    const char *dbpath = [databasePath UTF8String];
    
    NSMutableArray* ModiArray = [[NSMutableArray alloc] init];
    // Setup the database object
    sqlite3 *database2;
    // Open the database from the users filessytem
    if(sqlite3_open(dbpath, &database2) == SQLITE_OK)
    {
        // Setup the SQL Statement and compile it for faster access
        //SQLIte Statement
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select DAYNO from DAYEVENTS"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database2, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSString *recordParentID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                [ModiArray addObject:recordParentID];
            }
            sqlite3_reset(compiledStatement);
            sqlite3_finalize(compiledStatement);
        }
        sqlite3_close(database2);
        
    }
    
    return ModiArray;
    }
}


//  Appeal Database

-(NSMutableArray *)AppealRetrieveEventData{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *AppealeventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM METADATA WHERE METADATATYPECODE='MDT021'"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                AppealRecord *appealrecord=[[AppealRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                appealrecord.MetaSubCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                appealrecord.MetaSubCodeDescriptision=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                [AppealeventArray addObject:appealrecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
    }
    return AppealeventArray;
    }
}

-(NSMutableArray *)getOtwRtw{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *OtwRtwArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE,METASUBCODEDESCRIPTION FROM METADATA WHERE METADATATYPECODE = 'MDT032'"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                AppealRecord *appealrecord=[[AppealRecord alloc]init];
                appealrecord.MetaSubCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                appealrecord.MetaSubCodeDescriptision=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [OtwRtwArray addObject:appealrecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return OtwRtwArray;
    }
}

//Bowl Type for Spin
-(NSMutableArray *)getBowlType {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *bowlTypeArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT BOWLTYPECODE,BOWLTYPE FROM BOWLTYPE WHERE BOWLERTYPE = 'MSC016' AND RECORDSTATUS = 'MSC001'"];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BowlAndShotTypeRecords *bowlTypeRecord = [[BowlAndShotTypeRecords alloc]init];
                bowlTypeRecord.BowlTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                bowlTypeRecord.BowlType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [bowlTypeArray addObject:bowlTypeRecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return bowlTypeArray;
	}
}


//Bowl Type for Fast
-(NSMutableArray *)getBowlFastType {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *fastBowlTypeArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT BOWLTYPECODE,BOWLTYPE FROM BOWLTYPE WHERE BOWLERTYPE = 'MSC015' AND RECORDSTATUS = 'MSC001'"];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BowlAndShotTypeRecords *bowlTypeRecord = [[BowlAndShotTypeRecords alloc]init];
                bowlTypeRecord.BowlTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                bowlTypeRecord.BowlType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [fastBowlTypeArray addObject:bowlTypeRecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return fastBowlTypeArray;
	}
}

//Aggressive Shot Type
-(NSMutableArray *)getAggressiveShotType {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *aggressiveShotType=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT SHOTCODE,SHOTNAME FROM SHOTTYPE WHERE SHOTTYPE = 'MSC005' AND RECORDSTATUS = 'MSC001'"];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BowlAndShotTypeRecords *shotTypeRecord = [[BowlAndShotTypeRecords alloc]init];
                shotTypeRecord.ShotTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                shotTypeRecord.ShotType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [aggressiveShotType addObject:shotTypeRecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return aggressiveShotType;
	}
}


//Defence Shot Type
-(NSMutableArray *)getDefenceShotType {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *defenceShotType=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT SHOTCODE,SHOTNAME FROM SHOTTYPE WHERE SHOTTYPE = 'MSC006' AND RECORDSTATUS = 'MSC001'"];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BowlAndShotTypeRecords *shotTypeRecord = [[BowlAndShotTypeRecords alloc]init];
                shotTypeRecord.ShotTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                shotTypeRecord.ShotType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [defenceShotType addObject:shotTypeRecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return defenceShotType;
	}
}

//Retrieve FieldingFactor
-(NSMutableArray *)RetrieveFieldingFactorData{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"select * FROM FIELDINGFACTOR WHERE RECORDSTATUS = 'MSC001'"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FieldingFactorRecord *record=[[FieldingFactorRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                record.fieldingfactorcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.fieldingfactor=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.displayorder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                record.recordstatus=[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                
                
                [eventArray addObject:record];
                
                //            record.displayorder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                //            record.recordstatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                //            [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}


-(NSMutableArray *)RetrieveFieldingPlayerData : (NSString *) MATCHCODE : (NSString *) TEAMCODE {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *BowlerEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE INNER JOIN MATCHREGISTRATION MR ON MR.MATCHCODE=MTP.MATCHCODE WHERE MTP.MATCHCODE='%@' AND MTP.RECORDSTATUS = 'MSC001' AND MTP.TEAMCODE=(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)",MATCHCODE,TEAMCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BowlerEvent *record=[[BowlerEvent alloc]init];
                //need to edit
                record.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                //TEAMCODE_TOSSWONBY
                [BowlerEventArray addObject:record];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return BowlerEventArray;
	}
}


//proceed save action




-(NSString *) TossSaveDetails:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE{
@synchronized ([Utitliy syncId]) {
    // NSMutableArray *TossArray=[[NSMutableArray alloc]init];
    NSString *count = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM MATCHEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE ='%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                // MatcheventRecord *matchrecord=[[MatcheventRecord alloc]init];
                
                count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
                //[TossArray addObject:matchrecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return count;
    }
}

-(BOOL) insertMatchEvent :(NSString*) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)selectTeamcode :(NSString*)electedcode:(NSString*)teamCode:(NSString*)teambCode;
{
@synchronized ([Utitliy syncId]) {
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dataBase) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO  MATCHEVENTS (COMPETITIONCODE,MATCHCODE,TOSSWONTEAMCODE,ELECTEDTO,BATTINGTEAMCODE,BOWLINGTEAMCODE,BOWLCOMPUTESHOW)  VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'1')",COMPETITIONCODE,MATCHCODE,selectTeamcode,electedcode,teamCode,teambCode];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHEVENTS" :@"MSC250" :insertBallevent];
                
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
    
}



-(NSString *) getMaxInningsNumber : (NSString*) MATCHCODE : (NSString*)COMPETITIONCODE{
@synchronized ([Utitliy syncId]) {
    // NSMutableArray *TossArray=[[NSMutableArray alloc]init];
    NSString *maxInnNo = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT  IFNULL(MAX(INNINGSNO),0)+1 from INNINGSEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE ='%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                // MatcheventRecord *matchrecord=[[MatcheventRecord alloc]init];
                
                maxInnNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
                //[TossArray addObject:matchrecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return maxInnNo;
    }
}




-(BOOL) inserMaxInningsEvent : (NSString*) CompetitionCode :(NSString*) MATCHCODE :(NSString*) teamaCode :(NSString*) maxInnNo :(NSString*) StrikerCode :(NSString*) NonStrikerCode :(NSString*) selectBowlerCode :(NSString*) StrikerCode : (NSString*) NonStrikerCode : (NSString*)selectBowlerCode : (NSString*) teamaCode :(NSString*) inningsStatus : (NSString*)BowlingEnd
{
@synchronized ([Utitliy syncId]) {
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &dataBase) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO  INNINGSEVENTS (COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,CURRENTSTRIKERCODE,CURRENTNONSTRIKERCODE,CURRENTBOWLERCODE,BATTINGTEAMCODE,INNINGSSTATUS,BOWLINGEND)  VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'%@','%@')",CompetitionCode,MATCHCODE ,teamaCode,maxInnNo ,StrikerCode,NonStrikerCode ,selectBowlerCode,StrikerCode ,NonStrikerCode ,selectBowlerCode,teamaCode,inningsStatus,BowlingEnd];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC250" :insertBallevent];
                
                
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
    
}




//Appeal


-(NSMutableArray *)AppealSystemRetrieveEventData{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *AppealSyetemeventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE,METASUBCODEDESCRIPTION FROM METADATA WHERE METADATATYPECODE='MDT046';"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                AppealSystemRecords *appealsystemrecord=[[AppealSystemRecords alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                appealsystemrecord.AppealSystemMetaSubCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                appealsystemrecord.AppealSystemMetaSubCodeDescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [AppealSyetemeventArray addObject:appealsystemrecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return AppealSyetemeventArray;
    }
}




-(NSMutableArray *)AppealComponentRetrieveEventData{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *AppealComponenteventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE,METASUBCODEDESCRIPTION FROM METADATA WHERE METADATATYPECODE='MDT047';"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                AppealComponentRecord *appealComponentrecord=[[AppealComponentRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                appealComponentrecord.AppealComponentMetaSubCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                appealComponentrecord.AppealComponentMetaSubCodeDescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [AppealComponenteventArray addObject:appealComponentrecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return AppealComponenteventArray;
    }
}



-(NSMutableArray *) AppealUmpireRetrieveEventData:(NSString*) COMPETITIONCODE:(NSString*)MATCHCODE{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *AppealUmpireEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT UMPIRE1CODE,OM.NAME AS UMPIRE1NAME,UMPIRE2CODE ,OM1.NAME AS UMPIRE2NAME FROM MATCHREGISTRATION MR INNER JOIN OFFICIALSMASTER OM ON OM.OFFICIALSCODE=MR.UMPIRE1CODE INNER JOIN OFFICIALSMASTER OM1 ON OM1.OFFICIALSCODE=MR.UMPIRE2CODE WHERE COMPETITIONCODE ='%@' AND MATCHCODE ='%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                AppealUmpireRecord *appealumpirerecord=[[AppealUmpireRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                appealumpirerecord.AppealUmpireCode1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                appealumpirerecord.AppealUmpireName1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                appealumpirerecord.AppealUmpireCode2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                appealumpirerecord.AppealUmpireName2=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                [AppealUmpireEventArray addObject:appealumpirerecord];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return AppealUmpireEventArray;
    }
}
-(BOOL)updatePlayerorder:(NSString *) matchCode :(NSString *) teamcode PlayerCode:(NSString *)playerCode PlayerOrder:(NSString *)playerorder
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHTEAMPLAYERDETAILS SET PLAYINGORDER='%@' WHERE TEAMCODE=  '%@' AND MATCHCODE ='%@' AND PLAYERCODE='%@'",playerorder,teamcode,matchCode,playerCode];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:matchCode :@"MATCHTEAMPLAYERDETAILS" :@"MSC251" :updateSQL];
                
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
}

-(BOOL)updateCapitainWicketkeeper:(NSString *) compatitioncode :(NSString *) matchCode capitainAteam:(NSString *)capitainAteam capitainBteam:(NSString *)capitainBteam wicketkeeperAteam:(NSString *)wicketkeeperAteam  wicketkeeperBteam:(NSString *)wicketkeeperBteam
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET TEAMACAPTAIN='%@' ,TEAMBCAPTAIN='%@',TEAMAWICKETKEEPER='%@',TEAMBWICKETKEEPER='%@' WHERE COMPETITIONCODE=  '%@' AND MATCHCODE ='%@'",capitainAteam,capitainBteam,wicketkeeperAteam,wicketkeeperBteam,compatitioncode,matchCode];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:matchCode :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
                
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
}
-(NSMutableArray *)getTeamCaptainandTeamwicketkeeper:(NSString*) competitioncode :(NSString*) matchcode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    // NSString *count = [[NSString alloc]init];
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT MR.TEAMACAPTAIN,MR.TEAMAWICKETKEEPER,MR.TEAMBCAPTAIN,MR.TEAMBWICKETKEEPER from  matchregistration MR where competitioncode='%@' and matchcode='%@'",competitioncode,matchcode];
        stmt=[selectPlayersSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                CapitainWicketKeeperRecord *record=[[CapitainWicketKeeperRecord alloc]init];
                record.objTeamACapitain=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.objTeamAWicketKeeper=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.objTeamBCapitain=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.objTeamBWicketKeeper=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return eventArray;
    
    }
}

-(NSMutableArray *)GetBallDetails: (NSString*) competitioncode : (NSString*) matchcode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT BALL.BALLCODE, (BALL.OVERNO+'.'+ BALL.BALLNO) AS BALLNO, BWLR.PLAYERNAME BOWLER, STRKR.PLAYERNAME STRIKER, NSTRKR.PLAYERNAME NONSTRIKER,  BT.BOWLTYPE BOWLTYPE, ST.SHOTNAME AS SHOTTYPE, BALL.TOTALRUNS, BALL.TOTALEXTRAS, BALL.OVERNO,BALL.BALLCOUNT,BALL.ISLEGALBALL,BALL.ISFOUR,BALL.ISSIX,BALL.RUNS,BALL.OVERTHROW, BALL.WIDE,BALL.NOBALL,BALL.BYES,BALL.LEGBYES,BALL.GRANDTOTAL,WE.WICKETNO,WE.WICKETTYPE,BALL.MARKEDFOREDIT, PTY.PENALTYRUNS, PTY.PENALTYTYPECODE, 0 AS ISINNINGSLASTOVER, (MR.VIDEOLOCATION + '\' + BALL.VIDEOFILENAME) VIDEOFILEPATH FROM BALLEVENTS BALL INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE = BALL.COMPETITIONCODE AND MR.MATCHCODE = BALL.MATCHCODE INNER JOIN TEAMMASTER TM ON BALL.TEAMCODE = TM.TEAMCODE INNER JOIN PLAYERMASTER BWLR ON BALL.BOWLERCODE=BWLR.PLAYERCODE INNER JOIN PLAYERMASTER STRKR ON BALL.STRIKERCODE = STRKR.PLAYERCODE INNER JOIN PLAYERMASTER NSTRKR ON BALL.NONSTRIKERCODE = NSTRKR.PLAYERCODE LEFT JOIN BOWLTYPE BT ON BALL.BOWLTYPE = BT.BOWLTYPECODE LEFT JOIN SHOTTYPE ST ON BALL.SHOTTYPE = ST.SHOTCODE LEFT JOIN WICKETEVENTS WE ON BALL.BALLCODE = WE.BALLCODE AND WE.ISWICKET = 1 LEFT JOIN PENALTYDETAILS PTY ON BALL.BALLCODE = PTY.BALLCODE WHERE  BALL.COMPETITIONCODE='%@'  AND BALL.MATCHCODE='%@' AND BALL.OVERNO =(CASE WHEN   = 1 THEN 4+1 ELSE 4 END) ORDER BY BALL.OVERNO, BALL.BALLNO, BALL.BALLCOUNT;",competitioncode,matchcode];
        stmt=[selectPlayersSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                BallEventRecord *record=[[BallEventRecord alloc]init];
                record.objBallcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.objBallno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.objBowltype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.objShottype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                record.objTotalruns=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.objTotalextras=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.objOverno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.objBallcount=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.objIslegalball=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.objIsFour=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.objIssix=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.objRuns=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.objOverthrow=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                
                record.objWide=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.objNoball=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.objByes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                record.objLegByes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record.objGrandtotal=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                record.objWicketno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                record.objWicketType=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                record.objMarkedforedit=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                record.objPenalty=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                
                record.objPenaltytypecode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                
                record.objVideoFile=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return eventArray;
	}
}

//wicket Type
-(NSMutableArray *)RetrieveWicketType{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *WicketTypeArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE,METADATATYPECODE,METADATATYPEDESCRIPTION,METASUBCODEDESCRIPTION FROM METADATA WHERE METADATATYPECODE ='MDT021' AND (METASUBCODE !='MSC133'  AND METASUBCODE !='MSC108'  AND METASUBCODE !='MSC107'  AND METASUBCODE !='MSC102'  AND METASUBCODE !='MSC101')"];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                WicketTypeRecord *record=[[WicketTypeRecord alloc]init];
                
                record.metasubcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.metadatatypecode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.metadatatypedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.metasubcodedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                [WicketTypeArray addObject:record];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return WicketTypeArray;
	}
}

//wicket bowler detail
-(NSMutableArray *)RetrievePlayerData: (NSString *) MATCHCODE :(NSString *) TeamCODE{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *BowlerEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE INNER JOIN MATCHREGISTRATION MR ON MR.MATCHCODE=MTP.MATCHCODE WHERE MTP.MATCHCODE='%@'  AND MTP.TEAMCODE='%@'AND  MTP.RECORDSTATUS = 'MSC001'", MATCHCODE,TeamCODE];
        
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BowlerEvent *record=[[BowlerEvent alloc]init];
                //need to edit
                record.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                //TEAMCODE_TOSSWONBY
                [BowlerEventArray addObject:record];
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return BowlerEventArray;
	}
}



//Fetch SE page load Conversion


-(NSString *)getComletedInnings:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 1",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *getInnings = [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getInnings;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
    }
}

-(NSString *)getTotalBatTeamRuns:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *totalRuns = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return totalRuns;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}


-(NSString *)getTOTALBOWLTEAMRUNS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BOWLINGTEAMCODE:(NSString *)BOWLINGTEAMCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *runs = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return runs;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}

-(NSString *)getTEMPBOWLPENALTY:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BOWLINGTEAMCODE:(NSString *)BOWLINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO <= '%@' AND (AWARDEDTOTEAMCODE = '%@') AND ((BALLCODE IS NULL OR BALLCODE = '(null)') OR PENALTYTYPECODE = 'MSC135')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLINGTEAMCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *runs = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return runs;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return @"0";
    }
}

-(NSString *)getTEMPBATPENALTY:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO < '%@' - 1 AND AWARDEDTOTEAMCODE = '%@' AND ((INNINGSNO = '%@' AND BALLCODE IS NULL) OR ((INNINGSNO < '%@' - 1 AND (BALLCODE IS NULL OR BALLCODE = '(null)')) OR PENALTYTYPECODE = 'MSC135'))",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE,INNINGSNO,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *runs = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return runs;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return @"0";
    }
}


-(NSNumber *)getTARGETRUNS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO < %@",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *TARGETRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TARGETRUNS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return @"0";
    }
}


-(NSMutableArray *)getT_BOWLINGEND:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE LASTBALLCODE:(NSString *)LASTBALLCODE:(NSString*)BATTEAMOVERS{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT ATWOROTW, CASE WHEN '%@' = 0 AND OVERNO = '%@' THEN BOWLINGEND ELSE (CASE BOWLINGEND WHEN 'MSC150' THEN 'MSC151' WHEN 'MSC151' THEN 'MSC150' END) END FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND BALLCODE = '%@' LIMIT 1;",ISOVERCOMPLETE,BATTEAMOVERS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,LASTBALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *ATWOROTW = [self getValueByNull:statement :0];
                NSString *T_BOWLINGEND = [self getValueByNull:statement :1];
                
                [result addObject:ATWOROTW];
                [result addObject:T_BOWLINGEND];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return result;
    }
}

-(NSNumber *)getNOBALL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO BATTEAMOVERS:(NSString *)BATTEAMOVERS BATTEAMOVRWITHEXTRASBALLS:(NSString *)BATTEAMOVRWITHEXTRASBALLS{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(NOBALL),0)  FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRWITHEXTRASBALLS];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *NOBALL = [f numberFromString:[self getValueByNull:statement :0]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NOBALL;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}



-(NSMutableArray *)getBATSMANDETAIL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                          INNINGSNO:(NSString *)INNINGSNO ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE T_BOWLINGEND:(NSString *)T_BOWLINGEND{
						  @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    NSMutableArray *result = [[NSMutableArray alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT CURRENTSTRIKERCODE,CURRENTNONSTRIKERCODE,CURRENTSTRIKERCODE,CURRENTNONSTRIKERCODE,CURRENTBOWLERCODE,(CASE WHEN ('%@' IS NULL OR '%@' = '') THEN BOWLINGEND ELSE '%@' END)FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@;",T_BOWLINGEND,T_BOWLINGEND,T_BOWLINGEND,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *STRIKERCODE = [self getValueByNull:statement :0];
                NSString *NONSTRIKERCODE = [self getValueByNull:statement :1];
                NSString *T_STRIKERCODE = [self getValueByNull:statement :2];
                NSString *T_NONSTRIKERCODE = [self getValueByNull:statement :3];
                NSString *BOWLERCODE = [self getValueByNull:statement :4];
                NSString *T_BOWLINGEND = [self getValueByNull:statement :5];
                
                [result addObject:STRIKERCODE];
                [result addObject:NONSTRIKERCODE];
                [result addObject:T_STRIKERCODE];
                [result addObject:T_NONSTRIKERCODE];
                [result addObject:BOWLERCODE];
                [result addObject:T_BOWLINGEND];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return result;
    }
}


-(NSNumber *)getBallEventCount:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                
                // NSString *ballString =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                //            int ball = sqlite3_column_int(statement, 0);
                //            NSNumber *BALLS = [NSNumber numberWithInt:ball];
                NSNumber *BALLS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}


-(NSMutableArray *)getTotalRuns:(NSString *)LASTBALLCODE {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT (BALL.TOTALRUNS + (CASE WHEN BALL.WIDE > 0 THEN BALL.WIDE-1 ELSE BALL.WIDE END) -(CASE WHEN BALL.NOBALL > 0 THEN BALL.NOBALL-1 ELSE BALL.NOBALL END) + BALL.LEGBYES + BALL.BYES + (CASE WHEN (BALL.BYES > 0 OR BALL.LEGBYES > 0) THEN BALL.OVERTHROW ELSE 0 END)) AS T_TOTALRUNS, OVR.OVERSTATUS,WKT.WICKETPLAYER, WKT.WICKETTYPE FROM BALLEVENTS BALL INNER JOIN OVEREVENTS OVR ON OVR.COMPETITIONCODE = BALL.COMPETITIONCODE AND OVR.MATCHCODE = BALL.MATCHCODE AND OVR.TEAMCODE = BALL.TEAMCODE AND OVR.INNINGSNO = BALL.INNINGSNO AND OVR.OVERNO = BALL.OVERNO LEFT OUTER JOIN WICKETEVENTS WKT ON WKT.BALLCODE = BALL.BALLCODE WHERE BALL.BALLCODE = '%@'",LASTBALLCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *T_TOTALRUNS = [self getValueByNull:statement :0];
                NSString *T_OVERSTATUS = [self getValueByNull:statement :1];
                NSString *T_WICKETPLAYER = [self getValueByNull:statement :2];
                NSString *T_WICKETTYPE = [self getValueByNull:statement :3];
                
                [result addObject:T_TOTALRUNS];
                [result addObject:T_OVERSTATUS];
                [result addObject:T_WICKETPLAYER];
                [result addObject:T_WICKETTYPE];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return result;
	}
}


-(NSMutableArray *) getWICKETPLAYER:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *wicketPlayers = [[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT WICKETPLAYER FROM WICKETEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND WICKETTYPE != 'MSC102'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *WICKETPLAYER = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                [wicketPlayers addObject:WICKETPLAYER];
                //            sqlite3_finalize(statement);
                //            sqlite3_close(dataBase);
                //            return WICKETPLAYER;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return wicketPlayers;
	}
}

-(NSNumber *) getSTRIKERBALLS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE STRIKERCODE:(NSString *)STRIKERCODE
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        //        SELECT COUNT(BALL.BALLCODE) FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BALL.BALLCODE) FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *STRIKERBALLS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return STRIKERBALLS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
}
}

-(BOOL) hasSTRIKERBALLS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE STRIKERCODE:(NSString *)STRIKERCODE
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
                
        NSString *query=[NSString stringWithFormat:@" SELECT BALL.STRIKERCODE FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0 GROUP BY BALL.STRIKERCODE",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
}
}

-(NSMutableArray *) getStrickerCode:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE STRIKERCODE:(NSString *)STRIKERCODE STRIKERBALLS:(NSString *)STRIKERBALLS
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT BALL.STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME,IFNULL(SUM(BALL.TOTALRUNS),0) AS TOTALRUNS, IFNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISFOUR = 1 THEN 1 ELSE 0 END),0) AS FOURS, IFNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISSIX = 1 THEN 1 ELSE 0 END),0) AS SIXES, %@ AS TOTALBALLS,CASE WHEN %@ = 0 THEN 0 ELSE ((IFNULL(SUM(BALL.TOTALRUNS),0)*1.0/%@)*100) END AS STRIKERATE, PM.BATTINGSTYLE FROM BALLEVENTS BALL INNER JOIN PLAYERMASTER PM ON BALL.STRIKERCODE = PM.PLAYERCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0 GROUP BY BALL.STRIKERCODE,PM.PLAYERNAME, PM.BATTINGSTYLE",STRIKERBALLS,STRIKERBALLS,STRIKERBALLS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *playerCode = [self getValueByNull:statement :0];
                NSString *playerName = [self getValueByNull:statement :1];
                NSString *totalRuns = [self getValueByNull:statement :2];
                
                NSString *fours = [self getValueByNull:statement :3];
                
                NSString *sixes = [self getValueByNull:statement :4];
                
                NSString *totalBalls = [self getValueByNull:statement :5];
                NSString *strickRate = [self getValueByNull:statement :6];
                NSString *battingStyle = [self getValueByNull:statement :7];
                
                
                [result addObject:playerCode];
                [result addObject:playerName];
                [result addObject:totalRuns];
                [result addObject:fours];
                [result addObject:sixes];
                [result addObject:totalBalls];
                [result addObject:strickRate];
                [result addObject:battingStyle];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return result;
}
}



-(NSMutableArray *) getStrickerDetails:(NSString *)STRIKERCODE{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT PLAYERCODE,PLAYERNAME,0 AS TOTALRUNS, 0 AS FOURS, 0 AS SIXES,0 AS TOTALBALLS, 0 AS STRIKERATE, BATTINGSTYLE FROM PLAYERMASTER WHERE PLAYERCODE = '%@'",STRIKERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                NSString *playerCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *playerName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *totalRuns = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                NSString *fours = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *sixes = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                NSString *totalBalls = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                NSString *strickRate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                NSString *battingStyle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                
                [result addObject:playerCode];
                [result addObject:playerName];
                [result addObject:totalRuns];
                [result addObject:fours];
                [result addObject:sixes];
                [result addObject:totalBalls];
                [result addObject:strickRate];
                [result addObject:battingStyle];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return result;
	}
}

-(NSNumber *) getBALLCODECOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE NONSTRIKERCODE:(NSString *)NONSTRIKERCODE
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        //        SELECT COUNT(BALL.BALLCODE) FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BALL.BALLCODE) FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLCOUNT = [f numberFromString:[self  getValueByNull:statement :0]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                
                return BALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
}
}

-(NSNumber *) getBALLCODECOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE NONSTRIKERCODE:(NSString *)NONSTRIKERCODE :(NSString *) BATTEAMOVERS :(NSNumber *) BATTEAMOVRBALLS :(NSString *) BATTEAMOVRBALLSCNT{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
//        SELECT COUNT(BALL.BALLCODE) FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BALL.BALLCODE) FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0 AND (BALL.OVERNO + '.' + BALL.BALLNO+BALL.BALLCOUNT) <= ('%@' + '.' + '%@'+'%@')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMOVRBALLSCNT];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLCOUNT = [f numberFromString:[self  getValueByNull:statement :0]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                
                return BALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}




-(NSNumber *) getBALLCODECOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO STRIKERCODE:(NSString *)STRIKERCODE NONSTRIKERCODE:(NSString *)NONSTRIKERCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) PARTNERSHIPRUNS, SUM(CASE WHEN WIDE > 0 THEN 0 ELSE 1 END) PARTNERSHIPBALLS FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@' AND (BALL.STRIKERCODE = '%@' OR BALL.NONSTRIKERCODE = '%@') AND (BALL.STRIKERCODE = '%@' OR BALL.NONSTRIKERCODE = '%@');",COMPETITIONCODE,MATCHCODE,INNINGSNO,STRIKERCODE,STRIKERCODE,NONSTRIKERCODE,NONSTRIKERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLCOUNT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return BALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}


-(NSNumber *) getWicket:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE BOWLERCODE:(NSString *)BOWLERCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(WKT.WICKETNO)FROM BALLEVENTS BALL INNER JOIN WICKETEVENTS WKT ON WKT.BALLCODE = BALL.BALLCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@' AND WKT.WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *WKT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return WKT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}



-(NSNumber *) getLASTBOWLEROVERNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE BOWLERCODE:(NSString *)BOWLERCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = %@ AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *LASTBOWLEROVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return LASTBOWLEROVERNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}


-(NSString *) getLASTBOWLEROVERSTATUS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,LASTBOWLEROVERNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *OVERSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return OVERSTATUS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return @"";
	}
}


//////////////
//========================================================


-(NSNumber *) getMAXINNINGS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT  IFNULL(MAX(INNINGSNO),0) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *INNINGSNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return INNINGSNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}


-(NSNumber *) getMAXOVERNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE MAXINNINGS:(NSString *)MAXINNINGS{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,MAXINNINGS];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return OVERNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSNumber *) getMAXBALL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE MAXINNINGS:(NSString *)MAXINNINGS MAXOVER:(NSString *)MAXOVER{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,MAXINNINGS,MAXOVER];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return BALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSNumber *) getBALLCOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE MAXINNINGS:(NSString *)MAXINNINGS MAXOVER:(NSString *)MAXOVER MAXBALL:(NSString *)MAXBALL{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLCOUNT),0) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@' AND BALLNO='%@'",COMPETITIONCODE,MATCHCODE,MAXINNINGS,MAXOVER,MAXBALL];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLCOUNT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                
                return BALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSString *) getMATCHRESULTSTATUS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT MATCHRESULT FROM MATCHREGISTRATION WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *MATCHRESULTSTATUS = [self getValueByNull:statement :0];
                
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MATCHRESULTSTATUS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
	}


-(BOOL) getSPINSPEEDBALLS{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM METADATA MD WHERE MD.METADATATYPECODE='MDT054'"];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
	}
}



-(BOOL) getFASTSPEEDBALLS{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM METADATA MD WHERE MD.METADATATYPECODE='MDT055'"];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
	}
}



-(BOOL) getUNCOMFORT{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT * FROM METADATA MD WHERE MD.METADATATYPECODE='MDT056'"];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
    }
}


-(BOOL) getTeamDetails:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT BE.TEAMCODE, TM.TEAMNAME FROM BALLEVENTS BE INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE WHERE BE.COMPETITIONCODE='%@' AND BE.MATCHCODE='%@' GROUP BY BE.TEAMCODE,TM.TEAMNAME",COMPETITIONCODE,MATCHCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
    }
}


-(BOOL) getUmpireDetails{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT OFFICIALSCODE AS UMPIRECODE, NAME AS UMPIRENAME FROM OFFICIALSMASTER WHERE ROLE = 'MSC112' AND RECORDSTATUS = 'MSC001'"];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
    }
}

-(NSMutableArray *)GetBallGridDetails: (NSString*) COMPETITIONCODE MATCHCODE: (NSString*) MATCHCODE ISINNINGSLASTOVER: (NSString*) ISINNINGSLASTOVER  TEAMCODE: (NSString*) TEAMCODE INNINGSNO: (NSString*) INNINGSNO ISOVERCOMPLETE : (NSString*) ISOVERCOMPLETE BATTEAMOVERS : (NSString*) BATTEAMOVERS
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT BALL.BALLCODE, (BALL.OVERNO||'.'|| BALL.BALLNO) AS BALLNO, BWLR.PLAYERNAME BOWLER, STRKR.PLAYERNAME STRIKER, NSTRKR.PLAYERNAME NONSTRIKER,  BT.BOWLTYPE BOWLTYPE, ST.SHOTNAME AS SHOTTYPE, BALL.TOTALRUNS, BALL.TOTALEXTRAS, BALL.OVERNO,BALL.BALLCOUNT,BALL.ISLEGALBALL,BALL.ISFOUR,BALL.ISSIX,BALL.RUNS,BALL.OVERTHROW, BALL.WIDE,BALL.NOBALL,BALL.BYES,BALL.LEGBYES,BALL.GRANDTOTAL,WE.WICKETNO,WE.WICKETTYPE,BALL.MARKEDFOREDIT, PTY.PENALTYRUNS, PTY.PENALTYTYPECODE, %@ AS ISINNINGSLASTOVER, (MR.VIDEOLOCATION || '\' || BALL.VIDEOFILENAME) VIDEOFILEPATH,BWLR.PLAYERCODE BOWLERCODE FROM BALLEVENTS BALL INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE = BALL.COMPETITIONCODE AND MR.MATCHCODE = BALL.MATCHCODE INNER JOIN TEAMMASTER TM ON BALL.TEAMCODE = TM.TEAMCODE INNER JOIN PLAYERMASTER BWLR ON BALL.BOWLERCODE=BWLR.PLAYERCODE LEFT JOIN PLAYERMASTER STRKR ON BALL.STRIKERCODE = STRKR.PLAYERCODE LEFT JOIN PLAYERMASTER NSTRKR ON BALL.NONSTRIKERCODE = NSTRKR.PLAYERCODE LEFT JOIN BOWLTYPE BT ON BALL.BOWLTYPE = BT.BOWLTYPECODE LEFT JOIN SHOTTYPE ST ON BALL.SHOTTYPE = ST.SHOTCODE LEFT JOIN WICKETEVENTS WE ON BALL.BALLCODE = WE.BALLCODE AND WE.ISWICKET = 1 LEFT JOIN PENALTYDETAILS PTY ON BALL.BALLCODE = PTY.BALLCODE WHERE  BALL.COMPETITIONCODE='%@'  AND BALL.MATCHCODE='%@' AND BALL.TEAMCODE='%@' AND BALL.INNINGSNO=%@ AND BALL.OVERNO =(CASE WHEN %@  = 1 THEN %@+1 ELSE %@ END) ORDER BY BALL.OVERNO, BALL.BALLNO, BALL.BALLCOUNT;",ISINNINGSLASTOVER,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,ISOVERCOMPLETE,BATTEAMOVERS,BATTEAMOVERS];
        stmt=[selectPlayersSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                BallEventRecord *record=[[BallEventRecord alloc]init];
                record.objBallcode=[self getValueByNull:statement :0];
                record.objBallno=[self getValueByNull:statement :1];
                record.objBowltype=[self getValueByNull:statement :5];
                //[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]
                record.objShottype=[self getValueByNull:statement :6];
                //[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                record.objTotalruns=[self getValueByNull:statement :7];
                record.objTotalextras=[self getValueByNull:statement :8];
                record.objOverno=[self getValueByNull:statement :9];
                record.objBallcount=[self getValueByNull:statement :10];
                record.objIslegalball=[self getValueByNull:statement :11];
                record.objIsFour=[self getValueByNull:statement :12];
                record.objIssix=[self getValueByNull:statement :13];
                record.objRuns=[self getValueByNull:statement :14];
                record.objOverthrow=[self getValueByNull:statement :15];
                record.objWide=[self getValueByNull:statement :16];
                record.objNoball=[self getValueByNull:statement :17];
                record.objByes=[self getValueByNull:statement :18];
                record.objLegByes=[self getValueByNull:statement :19];
                record.objGrandtotal=[self getValueByNull:statement :20];
                record.objWicketno=[self getValueByNull:statement :21];
                record.objWicketType=[self getValueByNull:statement : 22];
                record.objMarkedforedit=[self getValueByNull:statement : 23];
                record.objPenalty=[self getValueByNull:statement : 24];
                record.objPenaltytypecode=[self getValueByNull:statement : 25];
                record.objVideoFile=[self getValueByNull:statement : 26];
                record.objBowlercode=[self getValueByNull:statement : 28];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return eventArray;
	}
}

//------------------------------------------------------------------
//VENKATESAN

-(NSNumber *) getLASTBOWLEROVERBALLNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE{
    @synchronized ([Utitliy syncId]) {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,LASTBOWLEROVERNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSNumber *) getLASTBOWLEROVERBALLNOWITHEXTRAS:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,LASTBOWLEROVERNO];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                return BALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

//LASTBOWLEROVERBALLCOUNT
-(NSNumber *) getLASTBOWLEROVERBALLCOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:(NSString *)LASTBOWLEROVERBALLNOWITHEXTRAS{
    
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@' AND OVERNO = '%@' AND BALLNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,LASTBOWLEROVERNO,LASTBOWLEROVERBALLNOWITHEXTRAS];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}
//S_ATWOROTW
-(NSString *) getS_ATWOROTW:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:(NSString *)LASTBOWLEROVERBALLNOWITHEXTRAS LASTBOWLEROVERBALLCOUNT:(NSString *)LASTBOWLEROVERBALLCOUNT{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT ATWOROTW FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE ='%@' AND OVERNO='%@' AND BALLNO ='%@' AND BALLCOUNT ='%@'", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,LASTBOWLEROVERNO,LASTBOWLEROVERBALLNOWITHEXTRAS,LASTBOWLEROVERBALLCOUNT];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *ATWOROTW =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return ATWOROTW;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return @"";
	}
}
//ISPARTIALOVER
-(NSNumber *) getISPARTIALOVER:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE LASTBOWLEROVERNO:(NSString *)LASTBOWLEROVERNO BOWLERCODE:(NSString *)BOWLERCODE  BATTEAMOVERS:(NSString *)BATTEAMOVERS{
    
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT CASE WHEN COUNT(BOWLERCODE) > 1 THEN 1 ELSE 0 END FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@'  AND OVERNO IN(SELECT OVERNO FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'  AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@' AND OVERNO < '%@')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,BATTEAMOVERS];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BOWLERCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BOWLERCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}


//ISPARTIALOVER=0
-(NSNumber *) getISPARTIALOVERWHEN0:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE  BOWLERCODE:(NSString *)BOWLERCODE  BATTEAMOVERS:(NSString *)BATTEAMOVERS{
    @synchronized ([Utitliy syncId]) {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(1) FROM BOWLEROVERDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@'  AND OVERNO = '%@' AND  BOWLERCODE <> '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BOWLERCODE];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *ISPARTIALOVER = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return ISPARTIALOVER;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

//TOTALBALLSBOWL
-(NSMutableArray *)getTOTALBALLSBOWL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE BOWLERCODE:(NSString *)BOWLERCODE  {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(CASE WHEN BALLCOUNT >= 6 AND OVERSTATUS = 1 THEN 6 ELSE BALLCOUNT END),0),IFNULL(SUM(CASE WHEN BALLCOUNT >= 6 AND OVERSTATUS = 1 AND TOTALRUNS = 0 THEN 1 ELSE 0 END),0),IFNULL(SUM(OE.TOTALRUNS),0) FROM ( SELECT OE.OVERNO + 1 AS OVERNO, IFNULL(SUM(CASE WHEN BALL.ISLEGALBALL = 1 THEN 1 ELSE 0 END),0) AS BALLCOUNT, OE.OVERSTATUS,IFNULL(SUM(BALL.TOTALRUNS + CASE WHEN BALL.NOBALL > 0 AND BALL.BYES > 0 THEN 1+BALL.BYES WHEN BALL.NOBALL > 0 AND BALL.BYES = 0 THEN BALL.NOBALL ELSE 0 END + BALL.WIDE),0) AS TOTALRUNS FROM BALLEVENTS BALL INNER JOIN OVEREVENTS OE ON BALL.COMPETITIONCODE = OE.COMPETITIONCODE AND BALL.MATCHCODE = OE.MATCHCODE AND BALL.INNINGSNO = OE.INNINGSNO AND BALL.TEAMCODE = OE.TEAMCODE AND BALL.OVERNO = OE.OVERNO WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@' GROUP BY BOWLERCODE,OE.OVERNO,OE.OVERSTATUS)OE",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *TOTALBALLSBOWL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *MAIDENS = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *BOWLERRUNS = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [result addObject:TOTALBALLSBOWL];
                [result addObject:MAIDENS];
                [result addObject:BOWLERRUNS];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return result;
	}
}








//BOWLERSPELL
-(NSNumber *) getBOWLERSPELL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE  BOWLERCODE:(NSString *)BOWLERCODE  BATTEAMOVERS:(NSString *)BATTEAMOVERS V_SPELLNO:(NSString *)V_SPELLNO{
    @synchronized ([Utitliy syncId]) {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(SPELL),0) FROM ( SELECT BALL.BOWLERCODE AS BOWLERCODE, BALL.OVERNO, IFNULL((SELECT CASE WHEN BALL.OVERNO - MAX(B.OVERNO) > 2 THEN '%@' + 1 ELSE '%@' END FROM BALLEVENTS B WHERE B.COMPETITIONCODE = BALL.COMPETITIONCODE AND B.MATCHCODE = BALL.MATCHCODE AND B.INNINGSNO = BALL.INNINGSNO AND B.BOWLERCODE = BALL.BOWLERCODE AND B.OVERNO < BALL.OVERNO GROUP BY B.COMPETITIONCODE, B.MATCHCODE, B.INNINGSNO, B.BOWLERCODE), 1) SPELL FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@' GROUP BY BALL.COMPETITIONCODE, BALL.MATCHCODE, BALL.INNINGSNO, BALL.BOWLERCODE, BALL.OVERNO ) BOWLERSPELL",V_SPELLNO,V_SPELLNO,COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BOWLERSPELL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BOWLERSPELL;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}



//BOWLER DETAIL


-(BOOL )GETBOLWERDETAIL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE  BOWLERCODE:(NSString *)BOWLERCODE  {
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.BOWLERCODE FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
}

//BOWLING DETAIL

-(NSMutableArray *)GETBOLWLINGDETAIL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO  BOWLERCODE:(NSString *)BOWLERCODE BOWLERSPELL:(NSString *)BOWLERSPELL BOWLERRUNS:(NSString *)BOWLERRUNS S_ATWOROTW:(NSString *)S_ATWOROTW TOTALBALLSBOWL:(NSString *)TOTALBALLSBOWL WICKETS:(NSString *)WICKETS MAIDENS:(NSString *)MAIDENS ISPARTIALOVER:(NSString *)ISPARTIALOVER LASTBOWLEROVERBALLNO:(NSString *)LASTBOWLEROVERBALLNO{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE, BOWLERNAME, %@ BOWLERSPELL, %@ AS TOTALRUNS, '%@' AS ATWOROTW,CASE WHEN %@ > 0 THEN (CASE WHEN '%@' = 0 THEN '0' ELSE  CAST(('%@' / 6) AS INT)|| '.' ||  CAST(('%@' %% 6) AS INT) END)ELSE OVERS ||'.'|| %@ END AS OVERS,%@ AS MAIDENOVERS, %@ AS WICKETS, (CASE WHEN %@ = 0 THEN 0 ELSE (%@ / (%@*1.0)) * 6 END) AS ECONOMY FROM(SELECT BOWLERCODE,BOWLERNAME,SUM(CASE WHEN OVERSTATUS = 1 THEN 1 ELSE 0 END) OVERS FROM(SELECT BALL.BOWLERCODE AS BOWLERCODE,PM.PLAYERNAME BOWLERNAME,OE.OVERSTATUS FROM BALLEVENTS BALL INNER JOIN OVEREVENTS OE ON BALL.COMPETITIONCODE = OE.COMPETITIONCODE AND BALL.MATCHCODE = OE.MATCHCODE AND BALL.INNINGSNO = OE.INNINGSNO AND BALL.TEAMCODE = OE.TEAMCODE AND BALL.OVERNO = OE.OVERNO INNER JOIN PLAYERMASTER PM ON BALL.BOWLERCODE = PM.PLAYERCODE WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@' GROUP BY BALL.BOWLERCODE,PM.PLAYERNAME,OE.OVERNO,OE.OVERSTATUS ) OE GROUP BY BOWLERCODE,BOWLERNAME)BOWLDTLS",BOWLERSPELL,BOWLERRUNS,S_ATWOROTW,ISPARTIALOVER,TOTALBALLSBOWL,TOTALBALLSBOWL,TOTALBALLSBOWL,LASTBOWLEROVERBALLNO,MAIDENS,WICKETS,TOTALBALLSBOWL,BOWLERRUNS,TOTALBALLSBOWL,COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                NSString *playerCode = [self getValueByNull:statement :0];
                NSString *playerName = [self getValueByNull:statement :1];
                NSString *totalRuns = [self getValueByNull:statement :3];
                
                NSString *overs = [self getValueByNull:statement :5];
                
                NSString *maidan = [self getValueByNull:statement :6];
                
                NSString *wicket = [self getValueByNull:statement :7];
                NSString *ecoRate = [self getValueByNull:statement :8];
                
                [result addObject:playerCode];
                [result addObject:playerName];
                [result addObject:totalRuns];
                [result addObject:overs];
                [result addObject:maidan];
                [result addObject:wicket];
                [result addObject:ecoRate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return result;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return result;
    }
}



//PLAYER DETAIL
-(NSMutableArray *)GETPLAYERDETAIL:(NSString *)BOWLERCODE {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PLAYERCODE AS BOWLERCODE, PLAYERNAME AS BOWLERNAME, 0 AS BOWLERSPELL, 0 AS TOTALRUNS, 0 AS OVERS, 0 AS MAIDENOVERS, 0 AS WICKETS, 0 AS ECONOMY FROM PLAYERMASTER WHERE PLAYERCODE = '%@'",BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                NSString *playerCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *playerName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *totalRuns = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                NSString *overs = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                NSString *maidan = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                NSString *wicket = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                NSString *ecoRate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                [result addObject:playerCode];
                [result addObject:playerName];
                [result addObject:totalRuns];
                [result addObject:overs];
                [result addObject:maidan];
                [result addObject:wicket];
                [result addObject:ecoRate];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return result;
                
            }
            sqlite3_reset(statement);
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        
    }
    return NO;
    }
}





//BALL DETAIL
-(BOOL)GETBALLDETAIL:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO LASTBALLCODE:(NSString *)LASTBALLCODE  TEAMCODE:(NSString *)TEAMCODE BALLCODE:(NSString *)BALLCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BALLCODE = '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
    }
}




//GETUMPIREBYBALLEVENT//

-(NSMutableArray *)GETUMPIREBYBALLEVENT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO  UMPIRE1CODE:(NSString *)UMPIRE1CODE ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE  UMPIRE2CODE:(NSString *)UMPIRE2CODE  LASTBALLCODE:(NSString *)LASTBALLCODE  {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT CASE WHEN '%@' = 1 THEN BALL.UMPIRE2CODE ELSE BALL.UMPIRE1CODE END, CASE WHEN '%@' = 1 THEN BALL.UMPIRE1CODE ELSE BALL.UMPIRE2CODE END FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.BALLCODE = '%@'",ISOVERCOMPLETE,ISOVERCOMPLETE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,LASTBALLCODE];//TEAMCODE AND BALLCODE
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *UMPIRE1CODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *UMPIRE2CODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [result addObject:UMPIRE1CODE];
                [result addObject:UMPIRE2CODE];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
	}
}

//GETUMPIREBYMATCHREGISTRATION

-(NSMutableArray *)GETUMPIREBYMATCHREGISTRATION:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE UMPIRE1CODE:(NSString *)UMPIRE1CODE UMPIRE2CODE:(NSString *)UMPIRE2CODE  {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT  UMPIRE1CODE, UMPIRE2CODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *UMPIRE1CODE = [self getValueByNull:statement :0];
                NSString *UMPIRE2CODE = [self getValueByNull:statement :1];
                
                [result addObject:UMPIRE1CODE];
                [result addObject:UMPIRE2CODE];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
	}
}




//U_OVERNO  NUMERIC
-(NSNumber *) getU_OVERNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO {
    @synchronized ([Utitliy syncId]) {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return OVERNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}



//U_BALLNO  NUMERIC
-(NSNumber *) getU_BALLNO:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO{
    @synchronized ([Utitliy syncId]) {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) FROM BALLEVENTS B WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return OVERNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

//U_BALLCOUNT  NUMERIC
-(NSNumber *) getU_BALLCOUNT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO BALLNO:(NSString *)BALLNO{
    
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLCOUNT),0) FROM BALLEVENTS B WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BALLNO];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return OVERNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}


//GETUMPIREBYBALLEVENT//
-(BOOL)GETUMPIREBYBALLEVENT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE BALLNO:(NSString *)BALLNO INNINGSNO:(NSString *)INNINGSNO  BALLCOUNT:(NSString *)BALLCOUNT  OVERNO:(NSString *)OVERNO {
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS BALL WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            {
                
                while(sqlite3_step(statement)==SQLITE_ROW){
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return YES;
                }
                
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    
    return NO;
    }
}

//UMBIREBYBALLEVENT

-(NSMutableArray *)GETUMBIREBYBALLEVENT:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE UMPIRE1CODE:(NSString *)UMPIRE1CODE UMPIRE2CODE:(NSString *)UMPIRE2CODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO BALLNO:(NSString *)BALLNO BALLCOUNT:(NSString *)BALLCOUNT {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT UMPIRE1CODE,UMPIRE2CODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT = '%@'", UMPIRE1CODE,UMPIRE2CODE,COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *UMPIRE1CODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *UMPIRE2CODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [result addObject:UMPIRE1CODE];
                [result addObject:UMPIRE2CODE];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
	}
}

//MATCHUMPIREDETAILS

-(NSMutableArray *)GETMATCHUMPIREDETAILS:(NSString *)UMPIRE1CODE UMPIRE2CODE:(NSString *)UMPIRE2CODE  {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT '%@', '%@',(SELECT NAME FROM OFFICIALSMASTER WHERE OFFICIALSCODE = '%@') AS UMPIRE1NAME, (SELECT NAME FROM OFFICIALSMASTER WHERE OFFICIALSCODE = '%@') AS UMPIRE2NAME", UMPIRE1CODE,UMPIRE2CODE,UMPIRE1CODE,UMPIRE2CODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *UMPIRE1CODE = [self getValueByNull:statement :0];
                NSString *UMPIRE2CODE = [self getValueByNull:statement :1];
                
                NSString *UMPIRE1NAME = [self getValueByNull:statement :2];
                NSString *UMPIRE2NAME = [self getValueByNull:statement :3];
                
                [result addObject:UMPIRE1CODE];
                [result addObject:UMPIRE2CODE];
                [result addObject:UMPIRE1NAME];
                [result addObject:UMPIRE2NAME];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return result;
	}
}



//ISINNINGSLASTOVER
-(NSNumber *) getISINNINGSLASTOVER:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO OVERNO:(NSString *)OVERNO  ISINNINGSLASTOVER:(NSString *)ISINNINGSLASTOVER TEAMCODE:(NSString *)TEAMCODE{
    
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(BALLCODE) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND TEAMCODE = '%@' AND OVERNO > '%@'",ISINNINGSLASTOVER,COMPETITIONCODE,MATCHCODE,INNINGSNO,TEAMCODE,OVERNO];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return 0;
	}
}


//=============================================================================
//Deepak



-(NSString *) InningsNo:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *inningsNumber = [[NSString alloc]init];
    inningsNumber = @"1";
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT INNINGSNO FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 0",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                inningsNumber = [self getValueByNull:statement :0];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return inningsNumber;
    }
}


//team code
-(NSString *) batsManteamCode:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *batsmanCode ;
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT  TEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 0",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                batsmanCode = [self getValueByNull:statement :0];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return batsmanCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
    }
}





//Day Number

-(NSString *) dayNO:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *dayNumber = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(DAYNO),0) + 1 FROM DAYEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND DAYSTATUS = 1",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                dayNumber = [self getValueByNull:statement :0];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return dayNumber;
    }
}

//session number

-(NSString *) sessionNo:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE:(NSString*)DAYNO{
    @synchronized ([Utitliy syncId]) {
    NSString *sessionNumber = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(SESSIONNO),0) + 1 FROM SESSIONEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND DAYNO = '%@' AND SESSIONSTATUS = 1;",COMPETITIONCODE,MATCHCODE,DAYNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                sessionNumber = [self getValueByNull:statement :0];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return sessionNumber;
    }
}



//innings status
-(NSString *) inningsStatus:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE:(NSString*)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *inningStatus = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"SELECT INNINGSSTATUS FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                inningStatus = [self getValueByNull:statement :0];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return inningStatus;
    }
}

//Fetch SE



-(NSMutableArray *)getTeamCodeAndMatchOver:(NSString*) competitioncode :(NSString*) matchcode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    int retVal;
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT TEAMACODE, TEAMBCODE, MATCHOVERS FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@';",competitioncode,matchcode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.TEAMACODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                record.MATCHOVERS =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}



-(NSMutableArray *)getMatchTypeAndIso:(NSString*) competitioncode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT MATCHTYPE,ISOTHERSMATCHTYPE FROM COMPETITION WHERE COMPETITIONCODE = '%@';",competitioncode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.MATCHTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.ISOTHERSMATCHTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}






-(NSMutableArray *)getCountOver:(NSString*) competitioncode :(NSString*) matchcode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT COUNT(1) FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 0",competitioncode,matchcode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.INNINGSPROGRESS=[self getValueByNull:statement :0];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}

-(NSMutableArray *)getInningsNo:(NSString*) competitioncode :(NSString*) matchcode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT INNINGSNO FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 0;",competitioncode,matchcode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}


-(NSString *)getBattingTeamCode:(NSString*) competitioncode :(NSString*) matchcode
{
@synchronized ([Utitliy syncId]) {
    NSString *battingTeamCode=[[NSString alloc]init];
    
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT  TEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 0",competitioncode,matchcode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                // FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                
                battingTeamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                // [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return battingTeamCode;
    }
}


-(NSMutableArray *)getMaxInningsNo:(NSString*) competitioncode :(NSString*) matchcode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(INNINGSNO),0)+1 FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 1",competitioncode,matchcode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}


-(NSString *)getTeamCode:(NSString*) competitioncode :(NSString*) matchcode :(NSString*)inningsNo
{
@synchronized ([Utitliy syncId]) {
    NSString *bolwingTeamcode;
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT TEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = ('%@' - 1)",competitioncode,matchcode,inningsNo];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                //FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                bolwingTeamcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                //[eventArray addObject:record];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return bolwingTeamcode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
    }
}


-(NSMutableArray *)getDayNo:(NSString*) competitioncode :(NSString*) matchcode {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(DAYNO),0) + 1 FROM DAYEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND DAYSTATUS = 1;",competitioncode, matchcode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.DAYNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);    }
    return eventArray;
    }
}


-(NSMutableArray *)getSessionNo:(NSString*) competitioncode :(NSString*) matchcode :(NSString*) dayNo{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(SESSIONNO),0) + 1 FROM SESSIONEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND DAYNO = '%@' AND SESSIONSTATUS = 1;",competitioncode,matchcode,dayNo];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.SESSIONNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}




-(NSMutableArray *)getInningsStatus:(NSString*) competitioncode :(NSString*) matchcode :(NSString*) inningsNo{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT INNINGSSTATUS FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO = '%@'",competitioncode,matchcode,inningsNo];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.INNINGSSTATUS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}




-(NSString *)getBowlteamCode:(NSString*) matchcode :(NSString*) competitioncode
                            :(NSString *)teamAcode :(NSString *)teamBcode{
    @synchronized ([Utitliy syncId]) {
    NSString *bowlingTeamCode=[[NSString alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT CASE WHEN ME.ELECTEDTO = 'MSC017' THEN ME.TOSSWONTEAMCODE ELSE (CASE WHEN ME.TOSSWONTEAMCODE = '%@' THEN '%@' ELSE '%@' END) END FROM MATCHEVENTS ME WHERE ME.MATCHCODE = '%@' AND ME.COMPETITIONCODE= '%@'", teamAcode,teamBcode,teamAcode,matchcode,competitioncode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                bowlingTeamCode  =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return bowlingTeamCode;
    }
}


//BATTING TEAM NAMES
-(NSMutableArray *)getBattingTeamName:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT SHORTTEAMNAME, TEAMNAME ,TEAMLOGO FROM TEAMMASTER WHERE TEAMCODE = '%@'",BATTINGTEAMCODE];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.BATTEAMSHORTNAME=[self getValueByNull:statement :0];
                record.BATTEAMNAME = [self getValueByNull:statement :1];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}


//BOWLING TEAM NAMES
-(NSMutableArray *)getBowlingTeamName:(NSString*)BOWLINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT SHORTTEAMNAME,TEAMNAME ,TEAMLOGO FROM TEAMMASTER WHERE TEAMCODE = '%@';",BOWLINGTEAMCODE];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                record.BOWLTEAMSHORTNAME=[self getValueByNull:statement :0];
                record.BOWLTEAMNAME = [self getValueByNull:statement :1];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}





//target runs and target overs
-(NSMutableArray *)getTargetRunsOvers:(NSString*)competitioncode:(NSString*)matchcode{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT TARGETRUNS, TARGETOVERS FROM MATCHEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@';",competitioncode,matchcode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                record.T_TARGETRUNS = [f numberFromString:[self getValueByNull:statement :0]];
                record.T_TARGETOVERS = [f numberFromString:[self getValueByNull:statement :1]];
                
                
                //                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                //                NSNumber  *targetRuns = [NSNumber numberWithInteger: [record.T_TARGETRUNS integerValue]];
                //                NSNumber *targetOvers = [NSNumber numberWithInteger:[record.T_TARGETOVERS integerValue]];
                //                //record.T_TARGETRUNS = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}


//match type

-(NSMutableArray *)getMatchType :(NSString*)competitioncode :(NSString*)matchcode{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT MR.TEAMAWICKETKEEPER, MR.TEAMBWICKETKEEPER, MR.TEAMACAPTAIN, MR.TEAMBCAPTAIN, MR.TEAMACODE, MR.TEAMBCODE,ISDEFAULTORLASTINSTANCE FROM MATCHREGISTRATION MR WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@';",competitioncode,matchcode];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                
                //            record.COMPETITIONCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                //            record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                //            record.BATTINGTEAMCODE = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                //            record.BOWLINGTEAMCODE =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                //            record.INNINGSNO =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
                //            record.SESSIONNO =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
                //            record.DAYNO =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];
                //            record.MATCHOVERS =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
                //            record.ISOTHERSMATCHTYPE =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 8)];
                
                record.TEAMAWICKETKEEPER =[self getValueByNull:statement :0];
                record.TEAMBWICKETKEEPER =[self getValueByNull:statement :1];
                record.TEAMACAPTAIN =[self getValueByNull:statement :2];
                record.TEAMBCAPTAIN =[self getValueByNull:statement :3];
                record.TEAMACODE =[self getValueByNull:statement :4];
                record.TEAMBCODE =[self getValueByNull:statement :5];
                record.ISDEFAULTORLASTINSTANCE =[self getValueByNull:statement :6];
                // record.INNINGSSTATUS =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 7)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}



//bowl type
-(NSMutableArray *)getBowlTypeCode{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT BOWLTYPECODE,BOWLTYPE,MD.METASUBCODEDESCRIPTION ,MD.METASUBCODE FROM BOWLTYPE BT INNER JOIN METADATA MD ON MD.METASUBCODE=BT.BOWLERTYPE WHERE BT.RECORDSTATUS='MSC001' ORDER BY BT.DISPLAYORDER*1 ASC;"];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                
                record.BOWLTYPECODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                record.BOWLTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.METASUBCODEDESCRIPTION = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                record.METASUBCODE =[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}






//shot type code
-(NSMutableArray *)getShotTypeCode{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *teamOverSQL = [NSString stringWithFormat:@"SELECT ST.SHOTCODE, ST.SHOTNAME, ST.SHOTTYPE FROM SHOTTYPE ST WHERE ST.RECORDSTATUS = 'MSC001' ORDER BY  ST.DISPLAYORDER*1 ASC;"];
        stmt=[teamOverSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                FetchSEPageLoadRecord *record = [[FetchSEPageLoadRecord alloc]init];
                
                record.SHOTCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
                record.SHOTNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.SHOTTYPE = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return eventArray;
    }
}

//follow on
-(NSString *) getFollowOn:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE:(NSString*)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query = [NSString stringWithFormat:@"SELECT ISFOLLOWON FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE ='%@' AND INNINGSNO = %@",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}

//penalty runs

-(NSString *) getPenalty:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO IN (2, 3) AND AWARDEDTOTEAMCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}

//penalty run scor
-(NSString *) getPenaltyScore:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)INNINGSNO:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@" SELECT IFNULL(SUM(PENALTYRUNS),0) AS PENALTYRUNS FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND AWARDEDTOTEAMCODE = '%@' AND BALLCODE = '(null)'",COMPETITIONCODE,MATCHCODE, INNINGSNO,BATTINGTEAMCODE];
        

                        //   SELECT IFNULL(SUM(PENALTYRUNS),0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO IN ('%@', '%@' - 1)AND AWARDEDTOTEAMCODE = '%@' AND (BALLCODE NOT NULL  OR INNINGSNO = '%@' - 1)"
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}

//ExtrasRun

-(NSString *) getBatingTeamExtrasRun:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT (ISMRY.BYES + ISMRY.LEGBYES + ISMRY.NOBALLS + ISMRY.WIDES + ISMRY.PENALTIES ) TOTALEXTRAS FROM INNINGSSUMMARY ISMRY INNER JOIN INNINGSEVENTS IEVNTS ON ISMRY.COMPETITIONCODE = IEVNTS.COMPETITIONCODE AND ISMRY.MATCHCODE = IEVNTS.MATCHCODE AND ISMRY.INNINGSNO = IEVNTS.INNINGSNO WHERE ISMRY.COMPETITIONCODE = '%@' AND ISMRY.MATCHCODE = '%@' AND ISMRY.INNINGSNO = '%@' ",COMPETITIONCODE,MATCHCODE, INNINGSNO,INNINGSNO,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
 }
}


//grand total
-(NSString *) getGrandTotal:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


//BATTEAMPENALTY

-(NSString *) getBatTeamPenalty:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = 1 AND AWARDEDTOTEAMCODE = '%@' AND BALLCODE IS NULL",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    
	}
}




//penalty details
-(NSString *) getPenaltyDetails:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO <= '%@' AND AWARDEDTOTEAMCODE = '%@' AND (BALLCODE IS NULL OR INNINGSNO < '%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO, BATTINGTEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}



//penalty details two
-(NSString *) getPenaltyDetailsBowling:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ - 1 AND AWARDEDTOTEAMCODE = '%@' AND BALLCODE IS NULL",COMPETITIONCODE,MATCHCODE,INNINGSNO, BATTINGTEAMCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}




//penalty details two
-(NSString *) getPenaltyInnings:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO <= '%@' AND AWARDEDTOTEAMCODE = '%@' AND ((BALLCODE IS NULL OR BALLCODE = '(null)') OR PENALTYTYPECODE = 'MSC135')",COMPETITIONCODE,MATCHCODE,INNINGSNO, BATTINGTEAMCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}


//penalty details innings two
-(NSString *) getPenaltyInningsTwo:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND AWARDEDTOTEAMCODE = '%@' AND (BALLCODE IS NULL OR PENALTYTYPECODE = 'MSC135')",COMPETITIONCODE,MATCHCODE,INNINGSNO, BATTINGTEAMCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


//penalty details innings three
-(NSString *) getPenaltyInningsThree:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO <= '%@' AND AWARDEDTOTEAMCODE = '%@' AND ((INNINGSNO = '%@' AND BALLCODE IS NULL) OR ((INNINGSNO < '%@' AND BALLCODE IS NULL) OR PENALTYTYPECODE = 'MSC135'))",COMPETITIONCODE,MATCHCODE,INNINGSNO, BATTINGTEAMCODE,INNINGSNO,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *COMPETITIONCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return COMPETITIONCODE;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


//penalty details innings three
-(NSString *) getBowlingPenaltyInnings:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@'AND MATCHCODE ='%@'AND INNINGSNO <= '%@' - 1 AND AWARDEDTOTEAMCODE = '%@'AND (BALLCODE IS NULL OR (INNINGSNO <= '%@' - 1 AND PENALTYTYPECODE = 'MSC135'))",COMPETITIONCODE,MATCHCODE,INNINGSNO, BATTINGTEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}






//follow on innings four details
-(NSString *) getFollowOnFour:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT ISFOLLOWON FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO = '%@' - 1",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


//batting penality
-(NSString *) getBattingPenalty:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO > 1 AND AWARDEDTOTEAMCODE = '%@' AND (BALLCODE IS NULL OR (INNINGSNO IN (2,3) AND BALLCODE IS NULL))",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}



//bowling penality
-(NSString *) getBowlPnty:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)FROM PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO <= '%@' AND AWARDEDTOTEAMCODE = '%@' AND (BALLCODE IS NULL OR (INNINGSNO <= '%@' AND PENALTYTYPECODE = 'MSC135'))",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}



//batting team wicket
-(NSString *) getBattingWkt:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(COUNT(WKT.WICKETNO),0)FROM WICKETEVENTS WKT WHERE WKT.COMPETITIONCODE = '%@' AND WKT.MATCHCODE = '%@' AND WKT.TEAMCODE = '%@' AND WKT.INNINGSNO = '%@' AND WKT.WICKETTYPE != 'MSC102'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}


// Team Overs
-(NSString *) getTeamOver:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(OVERNO),0) FROM OVEREVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@'AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TOTAL =  [self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TOTAL;
            }
            
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


// Team Overs ball
-(NSString *) getTeamOverBall:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS{
    @synchronized ([Utitliy syncId]) {
    NSString *teamOversBall = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND ISLEGALBALL = 1",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


// Team Overs with extra balls
-(NSString *) getTeamExtraBall:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS{
    @synchronized ([Utitliy syncId]) {
    NSString *extraBall = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}

//get prev over ball
-(NSString *) getPrevOverBall:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@'AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = ('%@' - 1) AND ISLEGALBALL = 1'",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


//get prev over with extra ball
-(NSString *) getPrevOverExtBall:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS{
   @synchronized ([Utitliy syncId]) { 
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = ('%@' - 1)",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}



// get previous over ball count
-(NSString *) getPrevOvrBallCnt:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS:(NSString*)PREVOVRWITHEXTRASBALLS{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLCOUNT),1)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = ('%@' -1) AND BALLNO = '%@'",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS,PREVOVRWITHEXTRASBALLS];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}



// get batting team over ball count
-(NSString *) getbatTeamOvrBallCnt:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS:(NSString*)BATTEAMOVRWITHEXTRASBALLS{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLCOUNT),1)FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@'",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS,BATTEAMOVRWITHEXTRASBALLS];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}

// get over number
-(NSString *) getOverNumber:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT OVR.OVERNO FROM OVEREVENTS OVR WHERE OVR.COMPETITIONCODE = '%@' AND OVR.MATCHCODE = '%@' AND OVR.TEAMCODE = '%@' AND OVR.INNINGSNO = '%@' AND OVR.OVERNO = '%@'",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


//get over number if exists
-(NSString *) getOverNumberExits:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT OVR.OVERNO FROM OVEREVENTS OVR WHERE OVR.COMPETITIONCODE = '%@' AND OVR.MATCHCODE = '%@' AND OVR.TEAMCODE = '%@' AND OVR.INNINGSNO = '%@' AND OVR.OVERNO = '%@' AND OVR.OVERSTATUS = 0",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


// last ball code
-(NSString *) getLastBallCode:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS:(NSString*)BATTEAMOVRWITHEXTRASBALLS:(NSString*)BATTEAMOVRBALLSCNT{
    @synchronized ([Utitliy syncId]) {
    NSString *lastBall = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT = '%@'",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS,BATTEAMOVRWITHEXTRASBALLS,BATTEAMOVRBALLSCNT];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}

//last ball code minus one

-(NSString *) getLastBallCodeMinus:(NSString*)COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*)BATTINGTEAMCODE:(NSString*)INNINGSNO :(NSString*)BATTEAMOVERS:(NSString*)PREVOVRWITHEXTRASBALLS:(NSString*)PREVOVRBALLSCNT{
    @synchronized ([Utitliy syncId]) {
    NSString *lastBall = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = ('%@' - 1) AND BALLNO = '%@' AND BALLCOUNT = '%@'",COMPETITIONCODE,MATCHCODE, BATTINGTEAMCODE, INNINGSNO,BATTEAMOVERS,PREVOVRWITHEXTRASBALLS,PREVOVRBALLSCNT];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}

//OVERNUMBERBYOVEREVENTS

-(BOOL)GETOVERNUMBERBYOVEREVENTS:(NSString *)COMPETITIONCODE :(NSString *)MATCHCODE :(NSString *)INNINGSNO :(NSString *)BATTINGTEAMCODE :(NSString *)BATTEAMOVERS{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVR.OVERNO FROM OVEREVENTS OVR WHERE OVR.COMPETITIONCODE = '%@' AND OVR.MATCHCODE = '%@' AND OVR.TEAMCODE = '%@' AND OVR.INNINGSNO = '%@' AND OVR.OVERNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}





//OVERNUMBERBYOVERSTATUS0
-(BOOL)GETOVERNUMBERBYOVERSTATUS0:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO  BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE  BATTEAMOVERS:(NSString *)BATTEAMOVERS{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVR.OVERNO FROM OVEREVENTS OVR WHERE OVR.COMPETITIONCODE = '%@' AND OVR.MATCHCODE = '%@' AND OVR.TEAMCODE = '%@' AND OVR.INNINGSNO = '%@' AND OVR.OVERNO = '%@' AND OVR.OVERSTATUS = 0",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}


// get is leagal ball
-(NSString *) getLegalBall:(NSString*)LASTBALLCODE{
    @synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query = [NSString stringWithFormat:@"SELECT ISLEGALBALL FROM BALLEVENTS WHERE BALLCODE = '%@'",LASTBALLCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


//PENULTIMATEBOWLERCODE
-(NSString *) getPENULTIMATEBOWLERCODE:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE INNINGSNO:(NSString *)INNINGSNO BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE OVERNO:(NSString *)OVERNO ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE BATTEAMOVERS:(NSString *)BATTEAMOVERS {
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = (CASE WHEN '%@' = 1 THEN %@ - 1 ELSE %@ - 1 END) LIMIT 1", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,ISOVERCOMPLETE,OVERNO,OVERNO];
        
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare_v2(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [self getValueByNull:statement :0];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

//BOWLING TEAM PLAYERS
-(NSMutableArray *)GETBOWLINGTEAMPLAYERS:(NSString *)PENULTIMATEBOWLERCODE MATCHCODE:(NSString *)MATCHCODE BOWLINGTEAMCODE:(NSString *)BOWLINGTEAMCODE COMPETITIONCODE:(NSString *)COMPETITIONCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE INNINGSNO:(NSString *)INNINGSNO ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE BATTEAMOVERS:(NSString *)BATTEAMOVERS  {
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *bowlerCodeArray = [[NSMutableArray alloc]init];
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME, PM.BOWLINGTYPE, PM.BOWLINGSTYLE, '%@' AS PENULTIMATEBOWLERCODE FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE AND MPD.RECORDSTATUS='MSC001' INNER JOIN COMPETITION COM ON COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN TEAMMASTER TMA ON MPD.MATCHCODE = '%@' AND	MPD.TEAMCODE = '%@' AND MPD.TEAMCODE = TMA.TEAMCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE MPD.PLAYERCODE != (CASE WHEN MR.TEAMACODE = '%@' THEN MR.TEAMAWICKETKEEPER ELSE MR.TEAMBWICKETKEEPER END) AND PM.PLAYERCODE NOT IN (SELECT BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = (CASE WHEN %@ = 1 THEN %@ ELSE %@ - 1 END)) AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))",PENULTIMATEBOWLERCODE,MATCHCODE,BOWLINGTEAMCODE,BOWLINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,ISOVERCOMPLETE,BATTEAMOVERS,BATTEAMOVERS];
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME, PM.BOWLINGTYPE, PM.BOWLINGSTYLE, '%@' AS PENULTIMATEBOWLERCODE FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE INNER JOIN COMPETITION COM ON COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN TEAMMASTER TMA ON MPD.MATCHCODE = '%@'  AND MPD.RECORDSTATUS = 'MSC001' AND MPD.TEAMCODE = '%@' AND MPD.TEAMCODE = TMA.TEAMCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE MPD.PLAYERCODE != (CASE WHEN MR.TEAMACODE = '%@' THEN MR.TEAMAWICKETKEEPER ELSE MR.TEAMBWICKETKEEPER END) AND PM.PLAYERCODE NOT IN (SELECT BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = (CASE WHEN %@ = 1 THEN %@ ELSE %@ - 1 END)) AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))",PENULTIMATEBOWLERCODE,MATCHCODE,BOWLINGTEAMCODE,BOWLINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,ISOVERCOMPLETE,BATTEAMOVERS,BATTEAMOVERS];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                BowlerEvent *bowlerEvnt = [[BowlerEvent alloc]init];
                bowlerEvnt.BowlerCode =  [self getValueByNull:statement :0];
                bowlerEvnt.BowlerName =  [self getValueByNull:statement :1];
                bowlerEvnt.bowlingType =  [self getValueByNull:statement :2];
                bowlerEvnt.bowlingStyle =  [self getValueByNull:statement :3];
                bowlerEvnt.penaltyMate = [self getValueByNull:statement :4];
                
                [bowlerCodeArray addObject:bowlerEvnt];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return bowlerCodeArray;
    }
}



//FIELDING FACTORS DETAILS
-(BOOL)GETFIELDINGFACTORSDETAILS{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT FIELDINGFACTORCODE, FIELDINGFACTOR FROM FIELDINGFACTOR WHERE RECORDSTATUS = 'MSC001' ORDER BY DISPLAYORDER"];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    
    }
}

//BOWLING TEAM PLAYERS
-(BOOL)GETBOWLINGTEAMPLAYERS:(NSString *)MATCHCODE TEAMCODE:(NSString *)TEAMCODE {
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME FROM MATCHTEAMPLAYERDETAILS MPD INNER JOIN TEAMMASTER TMA ON MPD.MATCHCODE = '%@' AND MPD.TEAMCODE = '%@' AND MPD.RECORDSTATUS = 'MSC001' AND MPD.TEAMCODE = TMA.TEAMCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE",MATCHCODE,TEAMCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    
    }
}


//FIELDING EVENTS DETAILS
-(BOOL)GETFIELDINGEVENTSDETAILS:(NSString *)MATCHCODE TEAMCODE:(NSString *)TEAMCODE COMPETITIONCODE:(NSString *)COMPETITIONCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT FE.BALLCODE,BE.OVERNO,BE.BALLNO,(CONVERT(NVARCHAR,BE.OVERNO)+'.'+CONVERT(NVARCHAR,BE.BALLNO)) AS [OVER], FE.FIELDERCODE, PM.PLAYERNAME AS FIELDERNAME,FE.FIELDINGFACTORCODE AS FIELDINGEVENTSCODE, UPPER(FF.FIELDINGFACTOR) AS FIELDINGEVENTS,FE.NRS AS NETRUNS, 'F' AS FLAG FROM FIELDINGEVENTS FE INNER JOIN BALLEVENTS BE ON FE.BALLCODE = BE.BALLCODE INNER JOIN FIELDINGFACTOR FF ON FE.FIELDINGFACTORCODE = FF.FIELDINGFACTORCODE INNER JOIN PLAYERMASTER PM ON FE.FIELDERCODE = PM.PLAYERCODE WHERE BE.COMPETITIONCODE = '%@' AND BE.MATCHCODE = '%@' AND BE.TEAMCODE <> '%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
    
}

//WICKETDETAILS
-(NSMutableArray *)GETWICKETDETAILS:(NSString *)MATCHCODE BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE COMPETITIONCODE:(NSString *)COMPETITIONCODE INNINGSNO:(NSString *)INNINGSNO{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        //        NSString *updateSQL = [NSString stringWithFormat:@"WITH WICKETDETAILS(ROWNUM,WICKETPLAYER,WICKETTYPE,BALLCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO) AS ( SELECT (SELECT COUNT(*) FROM WICKETEVENTS AS t2 WHERE t2.MATCHCODE <= WKT.MATCHCODE) AS ROWNUM,WKT.WICKETPLAYER, WKT.WICKETTYPE, WKT.BALLCODE, WKT.COMPETITIONCODE, WKT.MATCHCODE, WKT.TEAMCODE, WKT.INNINGSNO FROM WICKETEVENTS WKT WHERE WKT.COMPETITIONCODE = '%@' AND WKT.MATCHCODE =   '%@' AND	WKT.TEAMCODE =   '%@' AND WKT.INNINGSNO = '%@')SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME, PM.BATTINGSTYLE FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE AND MPD.RECORDSTATUS='MSC001' INNER JOIN COMPETITION COM ON COM.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN TEAMMASTER TMA ON MPD.MATCHCODE = '%@' AND	MPD.TEAMCODE = '%@' AND MPD.TEAMCODE = TMA.TEAMCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE PM.PLAYERCODE NOT IN ( SELECT X.WICKETPLAYER AS WICKETPLAYER  FROM WICKETDETAILS AS X LEFT JOIN WICKETDETAILS nex ON nex.rownum = X.rownum + 1 WHERE  (X.WICKETTYPE  != 'MSC102' OR NEX.WICKETPLAYER IS NULL) AND X.COMPETITIONCODE = '%@' AND X.MATCHCODE = '%@' AND	X.TEAMCODE = '%@' AND X.INNINGSNO = '%@'  ) AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11)) ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,MATCHCODE,BATTINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        NSString *updateSQL = [NSString stringWithFormat:@"WITH X AS(SELECT WKTEVT.COMPETITIONCODE, WKTEVT.MATCHCODE, WKTEVT.TEAMCODE, WKTEVT.INNINGSNO, WKTEVT.BALLCODE, WKTEVT.WICKETPLAYER, WKTEVT.WICKETTYPE, (SELECT IFNULL(COUNT(WKT.WICKETNO),0) FROM WICKETEVENTS WKT INNER JOIN BALLEVENTS BE ON WKT.BALLCODE = BE.BALLCODE WHERE WKT.COMPETITIONCODE = WKTEVT.COMPETITIONCODE AND WKT.MATCHCODE = WKTEVT.MATCHCODE AND WKT.TEAMCODE = WKTEVT.TEAMCODE AND WKT.INNINGSNO = WKTEVT.INNINGSNO AND CAST(BE.OVERNO AS NVARCHAR(5)) + CAST(BE.BALLNO AS NVARCHAR(5)) + CAST(BE.BALLCOUNT AS NVARCHAR(5)) <= WKTEVT.SNO) WKTNO FROM(SELECT WKTEVT.COMPETITIONCODE, WKTEVT.MATCHCODE, WKTEVT.TEAMCODE, WKTEVT.INNINGSNO, WKTEVT.BALLCODE, WKTEVT.WICKETPLAYER, WKTEVT.WICKETTYPE, WKTEVT.WICKETNO, CAST(BE.OVERNO AS NVARCHAR(5)) + CAST(BE.BALLNO AS NVARCHAR(5)) + CAST(BE.BALLCOUNT AS NVARCHAR(5)) SNO    FROM WICKETEVENTS WKTEVT INNER JOIN BALLEVENTS BE ON WKTEVT.BALLCODE = BE.BALLCODE WHERE WKTEVT.COMPETITIONCODE = '%@' AND WKTEVT.MATCHCODE =   '%@' AND	WKTEVT.TEAMCODE =   '%@' AND WKTEVT.INNINGSNO = %@) WKTEVT)SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME, PM.BATTINGSTYLE FROM MATCHREGISTRATION MR INNER JOIN MATCHTEAMPLAYERDETAILS MPD ON MR.MATCHCODE = MPD.MATCHCODE AND MPD.RECORDSTATUS='MSC001' INNER JOIN COMPETITION COM ON COM.COMPETITIONCODE = MR.COMPETITIONCODE  INNER JOIN TEAMMASTER TMA ON MPD.MATCHCODE = '%@' AND MPD.TEAMCODE = '%@' AND MPD.TEAMCODE = TMA.TEAMCODE INNER JOIN PLAYERMASTER PM ON MPD.PLAYERCODE = PM.PLAYERCODE WHERE PM.PLAYERCODE NOT IN (SELECT X.WICKETPLAYER AS WICKETPLAYER  FROM X LEFT JOIN X nex ON nex.WKTNO = X.WKTNO + 1 WHERE(X.WICKETTYPE  != 'MSC102' OR NEX.WICKETPLAYER IS NULL) AND  X.COMPETITIONCODE = '%@' AND X.MATCHCODE = '%@'  AND X.TEAMCODE = '%@'  AND X.INNINGSNO = %@   )  AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))  ORDER BY MPD.PLAYINGORDER",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,MATCHCODE,BATTINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                SelectPlayerRecord *player = [[SelectPlayerRecord alloc]init];
                player.playerCode =  [self getValueByNull:statement :0];
                player.playerName =  [self getValueByNull:statement :1];
                player.battingStyle =  [self getValueByNull:statement :2];
                [result addObject:player];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    
    
    return result;
    }
}



//SP_FETCHSEALLINNINGSSCOREDETAILS
-(NSMutableArray*)FETCHSEALLINNINGSSCOREDETAILS:(NSString*)COMPETITIONCODE MATCHCODE:(NSString*)MATCHCODE{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *inningsRecordArray = [[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"WITH A (COMPETITIONCODE,MATCHCODE,MATCHDATE,INNINGSNO, TEAMCODE, SHORTTEAMNAME, INNINGSTOTAL, INNINGSTOTALWICKETS, MATCHOVERS, TOTALSCORE, PENALTY, FOLLOWONPENALTY)AS ( SELECT MR.COMPETITIONCODE, MR.MATCHCODE, MR.MATCHDATE, INS.INNINGSNO, TM.TEAMCODE, TM.SHORTTEAMNAME, INS.INNINGSTOTAL, INS.INNINGSTOTALWICKETS, ( SELECT CAST ( (SUM(OVERS) + (SUM(BALLS) / 10) ) AS TEXT) FROM ( SELECT CAST (SUM(OVERS) AS FLOATFIELD ) OVERS, CAST (SUM(BALLS) AS FLOATFIELD ) BALLS FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = INS.INNINGSNO AND PARTIALOVERBALLS = 0 UNION ALL SELECT CAST (CAST ( (SUM(PARTIALOVERBALLS) + SUM(BALLS) ) / 6 AS FLOATFIELD ) + SUM(OVERS) AS FLOATFIELD ) OVERS, CAST ( ( (SUM(PARTIALOVERBALLS) + SUM(BALLS) ) %% 6) AS FLOATFIELD ) BALLS FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = INS.INNINGSNO AND PARTIALOVERBALLS <> 0 ) OVERS ) AS MATCHOVERS, ( SELECT SUM(INNINGSTOTAL) FROM INNINGSSUMMARY WHERE COMPETITIONCODE = COM.COMPETITIONCODE AND MATCHCODE = MR.MATCHCODE AND BATTINGTEAMCODE = TM.TEAMCODE ) TOTALSCORE, (CASE WHEN INS.INNINGSNO = 1 AND COM.MATCHTYPE IN ('MSC023', 'MSC114') THEN ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = INS.INNINGSNO AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC134' ) WHEN INS.INNINGSNO = 1 AND COM.MATCHTYPE NOT IN ('MSC023', 'MSC114') THEN ( ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = INS.INNINGSNO AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC134' )+ ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = 2 AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC135' ) ) WHEN INS.INNINGSNO = 2 THEN ( ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = INS.INNINGSNO AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC134' )+ ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = 1 AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC135' ) ) WHEN INS.INNINGSNO = 3 AND INEVS.ISFOLLOWON = 0 THEN ( ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = INS.INNINGSNO AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC134' )+ ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = 2 AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC135' )+ ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = 4 AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC135' ) ) WHEN INS.INNINGSNO = 3 AND INEVS.ISFOLLOWON = 1 THEN ( ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = INS.INNINGSNO AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC134' )+ ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = 4 AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC135' ) ) WHEN INS.INNINGSNO = 4 THEN ( ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = INS.INNINGSNO AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC134' )+ ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = 3 AND AWARDEDTOTEAMCODE = INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC135' ) ) ELSE 0 END) AS PENALTY, (CASE WHEN INS.INNINGSNO = 3 AND INEVS.ISFOLLOWON = 1 THEN ( ( SELECT IFNULL(SUM(PENALTYRUNS), 0) FROM PENALTYDETAILS WHERE COMPETITIONCODE = INS.COMPETITIONCODE AND MATCHCODE = INS.MATCHCODE AND INNINGSNO = 2 AND AWARDEDTOTEAMCODE != INS.BATTINGTEAMCODE AND PENALTYTYPECODE = 'MSC135' ) ) ELSE 0 END) AS FOLLOWONPENALTY FROM MATCHREGISTRATION MR INNER JOIN COMPETITION COM ON MR.COMPETITIONCODE = COM.COMPETITIONCODE INNER JOIN INNINGSSUMMARY INS ON MR.MATCHCODE = INS.MATCHCODE AND (CASE INS.BATTINGTEAMCODE WHEN MR.TEAMACODE THEN MR.TEAMACODE WHEN MR.TEAMBCODE THEN MR.TEAMBCODE END) = INS.BATTINGTEAMCODE INNER JOIN TEAMMASTER TM ON INS.BATTINGTEAMCODE = TM.TEAMCODE INNER JOIN INNINGSEVENTS INEVS ON INEVS.COMPETITIONCODE = INS.COMPETITIONCODE AND INEVS.MATCHCODE = INS.MATCHCODE AND INEVS.INNINGSNO = INS.INNINGSNO AND INEVS.BATTINGTEAMCODE = INS.BATTINGTEAMCODE LEFT JOIN TEAMMASTER TMRSLT ON MR.MATCHRESULTTEAMCODE = TMRSLT.TEAMCODE WHERE MR.COMPETITIONCODE = '%@' AND MR.MATCHCODE = '%@')SELECT COMPETITIONCODE, MATCHCODE, MATCHDATE, FIRSTINNINGSTOTAL, SECONDINNINGSTOTAL, THIRDINNINGSTOTAL, FOURTHINNINGSTOTAL, FIRSTINNINGSWICKET, SECONDINNINGSWICKET, THIRDINNINGSWICKET, FOURTHINNINGSWICKET, FIRSTINNINGSSCORE, SECONDINNINGSSCORE, THIRDINNINGSSCORE AS THIRDINNINGSSCORE, FOURTHINNINGSSCORE AS FOURTHINNINGSSCORE, FIRSTINNINGSOVERS, SECONDINNINGSOVERS, THIRDINNINGSOVERS AS THIRDINNINGSOVERS, FOURTHINNINGSOVERS AS FOURTHINNINGSOVERS, FIRSTINNINGSSHORTNAME, SECONDINNINGSSHORTNAME, THIRDINNINGSSHORTNAME AS THIRDINNINGSSHORTNAME, FOURTHINNINGSSHORTNAME AS FOURTHINNINGSSHORTNAME, CASE WHEN FIRSTINNINGSSHORTNAME = THIRDINNINGSSHORTNAME THEN CAST (FIRSTINNINGSTOTAL AS INTEGER) + CAST (THIRDINNINGSTOTAL AS INTEGER) ELSE CAST (FIRSTINNINGSTOTAL AS INTEGER) + CAST (FOURTHINNINGSTOTAL AS INTEGER) END AS AA, CASE WHEN SECONDINNINGSSHORTNAME = FOURTHINNINGSSHORTNAME THEN CAST (SECONDINNINGSTOTAL AS INTEGER) + CAST (FOURTHINNINGSTOTAL AS INTEGER) ELSE CAST (SECONDINNINGSTOTAL AS INTEGER) + CAST (THIRDINNINGSTOTAL AS INTEGER) END AS BB, CASE WHEN FIRSTINNINGSSHORTNAME = THIRDINNINGSSHORTNAME THEN CAST (FIRSTINNINGSWICKET AS INTEGER) + CAST (THIRDINNINGSWICKET AS INTEGER) ELSE CAST (FIRSTINNINGSWICKET AS INTEGER) + CAST (FOURTHINNINGSWICKET AS INTEGER) END AS AAWIC, CASE WHEN SECONDINNINGSSHORTNAME = FOURTHINNINGSSHORTNAME THEN CAST (SECONDINNINGSWICKET AS INTEGER) + CAST (FOURTHINNINGSWICKET AS INTEGER) ELSE CAST (SECONDINNINGSWICKET AS INTEGER) + CAST (THIRDINNINGSWICKET AS INTEGER) END AS BBWIC FROM ( SELECT COMPETITIONCODE, MATCHCODE, MATCHDATE, FIRSTINNINGSTOTAL, SECONDINNINGSTOTAL, THIRDINNINGSTOTAL, FOURTHINNINGSTOTAL, FIRSTINNINGSWICKET, SECONDINNINGSWICKET, THIRDINNINGSWICKET, FOURTHINNINGSWICKET, FIRSTINNINGSSCORE, SECONDINNINGSSCORE, THIRDINNINGSSCORE AS THIRDINNINGSSCORE, FOURTHINNINGSSCORE AS FOURTHINNINGSSCORE, FIRSTINNINGSOVERS, SECONDINNINGSOVERS, THIRDINNINGSOVERS AS THIRDINNINGSOVERS, FOURTHINNINGSOVERS AS FOURTHINNINGSOVERS, FIRSTINNINGSSHORTNAME, SECONDINNINGSSHORTNAME, THIRDINNINGSSHORTNAME AS THIRDINNINGSSHORTNAME, FOURTHINNINGSSHORTNAME AS FOURTHINNINGSSHORTNAME, CASE WHEN FIRSTINNINGSSHORTNAME = THIRDINNINGSSHORTNAME THEN CAST (FIRSTINNINGSTOTAL AS INTEGER) + CAST (THIRDINNINGSTOTAL AS INTEGER) ELSE CAST (FIRSTINNINGSTOTAL AS INTEGER) + CAST (FOURTHINNINGSTOTAL AS INTEGER) END AS AA, CASE WHEN SECONDINNINGSSHORTNAME = FOURTHINNINGSSHORTNAME THEN CAST (SECONDINNINGSTOTAL AS INTEGER) + CAST (FOURTHINNINGSTOTAL AS INTEGER) ELSE CAST (SECONDINNINGSTOTAL AS INTEGER) + CAST (THIRDINNINGSTOTAL AS INTEGER) END AS BB, CASE WHEN FIRSTINNINGSSHORTNAME = THIRDINNINGSSHORTNAME THEN CAST (FIRSTINNINGSWICKET AS INTEGER) + CAST (THIRDINNINGSWICKET AS INTEGER) ELSE CAST (FIRSTINNINGSWICKET AS INTEGER) + CAST (FOURTHINNINGSWICKET AS INTEGER) END AS AAWIC, CASE WHEN SECONDINNINGSSHORTNAME = FOURTHINNINGSSHORTNAME THEN CAST (SECONDINNINGSWICKET AS INTEGER) + CAST (FOURTHINNINGSWICKET AS INTEGER) ELSE CAST (SECONDINNINGSWICKET AS INTEGER) + CAST (THIRDINNINGSWICKET AS INTEGER) END AS BBWIC FROM ( SELECT COMPETITIONCODE, MATCHCODE, MATCHDATE, FIRSTINNINGSTOTAL, SECONDINNINGSTOTAL, THIRDINNINGSTOTAL, FOURTHINNINGSTOTAL, FIRSTINNINGSWICKET, SECONDINNINGSWICKET, THIRDINNINGSWICKET, FOURTHINNINGSWICKET, FIRSTINNINGSSCORE, SECONDINNINGSSCORE, THIRDINNINGSSCORE AS THIRDINNINGSSCORE, FOURTHINNINGSSCORE AS FOURTHINNINGSSCORE, FIRSTINNINGSOVERS, SECONDINNINGSOVERS, THIRDINNINGSOVERS AS THIRDINNINGSOVERS, FOURTHINNINGSOVERS AS FOURTHINNINGSOVERS, FIRSTINNINGSSHORTNAME, SECONDINNINGSSHORTNAME, THIRDINNINGSSHORTNAME AS THIRDINNINGSSHORTNAME, FOURTHINNINGSSHORTNAME AS FOURTHINNINGSSHORTNAME FROM ( SELECT COMPETITIONCODE COMPETITIONCODE, MATCHCODE MATCHCODE, MATCHDATE MATCHDATE, IFNULL(FIRSTINNINGSSHORTNAME, '') FIRSTINNINGSSHORTNAME, IFNULL(SECONDINNINGSSHORTNAME, '') SECONDINNINGSSHORTNAME, IFNULL(THIRDINNINGSSHORTNAME, '') THIRDINNINGSSHORTNAME, IFNULL(FOURTHINNINGSSHORTNAME, '') FOURTHINNINGSSHORTNAME, IFNULL(FIRSTINNINGSSCORE, 0) FIRSTINNINGSSCORE, IFNULL(FIRSTINNINGSOVERS, 0) FIRSTINNINGSOVERS, IFNULL(SECONDINNINGSSCORE, 0) SECONDINNINGSSCORE, IFNULL(SECONDINNINGSOVERS, 0) SECONDINNINGSOVERS, IFNULL(THIRDINNINGSSCORE, 0) THIRDINNINGSSCORE, IFNULL(FOURTHINNINGSOVERS, 0) FOURTHINNINGSOVERS, IFNULL(THIRDINNINGSOVERS, 0) THIRDINNINGSOVERS, IFNULL(FOURTHINNINGSSCORE, 0) FOURTHINNINGSSCORE, MAX(FIRSTINNINGSTOTAL) FIRSTINNINGSTOTAL, MAX(SECONDINNINGSTOTAL) SECONDINNINGSTOTAL, MAX(THIRDINNINGSTOTAL) THIRDINNINGSTOTAL, MAX(FOURTHINNINGSTOTAL) FOURTHINNINGSTOTAL, MAX(FIRSTINNINGSWICKET) FIRSTINNINGSWICKET, MAX(SECONDINNINGSWICKET) SECONDINNINGSWICKET, MAX(THIRDINNINGSWICKET) THIRDINNINGSWICKET, MAX(FOURTHINNINGSWICKET) FOURTHINNINGSWICKET FROM ( SELECT COMPETITIONCODE, MATCHCODE, MATCHDATE, MAX(FIRSTINNINGSTEAMNAME) AS FIRSTINNINGSSHORTNAME, IFNULL(MAX(FIRSTINNINGSTOTAL), 0) + '/' + IFNULL(MAX(FIRSTINNINGSTOTALWICKETS), 0) AS FIRSTINNINGSSCORE, IFNULL(MAX(FIRSTINNINGSTOTAL), 0) AS FIRSTINNINGSTOTAL, IFNULL(MAX(FIRSTINNINGSTOTALWICKETS), 0) AS FIRSTINNINGSWICKET, MAX(FIRSTINNINGSMATCHOVERS) AS FIRSTINNINGSOVERS, MAX(SECONDINNINGSTEAMNAME) AS SECONDINNINGSSHORTNAME, IFNULL(MAX(SECONDINNINGSTOTAL), 0) + '/' + IFNULL(MAX(SECONDINNINGSTOTALWICKETS), 0) AS SECONDINNINGSSCORE, IFNULL(MAX(SECONDINNINGSTOTAL), 0) AS SECONDINNINGSTOTAL, IFNULL(MAX(SECONDINNINGSTOTALWICKETS), 0) AS SECONDINNINGSWICKET, MAX(SECONDINNINGSMATCHOVERS) AS SECONDINNINGSOVERS, MAX(THIRDINNINGSTEAMNAME) AS THIRDINNINGSSHORTNAME, IFNULL(MAX(THIRDINNINGSTOTAL), 0) + '/' + IFNULL(MAX(THIRDINNINGSTOTALWICKETS), 0) AS THIRDINNINGSSCORE, IFNULL(MAX(THIRDINNINGSTOTAL), 0) AS THIRDINNINGSTOTAL, IFNULL(MAX(THIRDINNINGSTOTALWICKETS), 0) AS THIRDINNINGSWICKET, MAX(THIRDINNINGSMATCHOVERS) AS THIRDINNINGSOVERS, MAX(FOURTHINNINGSTEAMNAME) AS FOURTHINNINGSSHORTNAME, IFNULL(MAX(FOURTHINNINGSTOTAL), 0) + '/' + IFNULL(MAX(FOURTHINNINGSTOTALWICKETS), 0) AS FOURTHINNINGSSCORE, IFNULL(MAX(FOURTHINNINGSTOTAL), 0) AS FOURTHINNINGSTOTAL, IFNULL(MAX(FOURTHINNINGSTOTALWICKETS), 0) AS FOURTHINNINGSWICKET, MAX(FOURTHINNINGSMATCHOVERS) AS FOURTHINNINGSOVERS FROM ( SELECT COMPETITIONCODE, MATCHCODE, MATCHDATE, TEAMCODE, TOTALSCORE, CASE WHEN INNINGSNO = 1 THEN SHORTTEAMNAME ELSE NULL END FIRSTINNINGSTEAMNAME, SUM(CASE WHEN INNINGSNO = 1 THEN INNINGSTOTAL + PENALTY ELSE NULL END) FIRSTINNINGSTOTAL, SUM(CASE WHEN INNINGSNO = 1 THEN INNINGSTOTALWICKETS ELSE NULL END) FIRSTINNINGSTOTALWICKETS, CASE WHEN INNINGSNO = 1 THEN MATCHOVERS ELSE NULL END FIRSTINNINGSMATCHOVERS, CASE WHEN INNINGSNO = 2 THEN SHORTTEAMNAME ELSE NULL END SECONDINNINGSTEAMNAME, SUM(CASE WHEN INNINGSNO = 2 THEN INNINGSTOTAL + PENALTY ELSE NULL END) SECONDINNINGSTOTAL, SUM(CASE WHEN INNINGSNO = 2 THEN INNINGSTOTALWICKETS ELSE NULL END) SECONDINNINGSTOTALWICKETS, CASE WHEN INNINGSNO = 2 THEN MATCHOVERS ELSE NULL END SECONDINNINGSMATCHOVERS, CASE WHEN INNINGSNO = 3 THEN SHORTTEAMNAME ELSE NULL END THIRDINNINGSTEAMNAME, SUM(CASE WHEN INNINGSNO = 3 THEN INNINGSTOTAL + PENALTY ELSE NULL END) THIRDINNINGSTOTAL, SUM(CASE WHEN INNINGSNO = 3 THEN INNINGSTOTALWICKETS ELSE NULL END) THIRDINNINGSTOTALWICKETS, CASE WHEN INNINGSNO = 3 THEN MATCHOVERS ELSE NULL END THIRDINNINGSMATCHOVERS, CASE WHEN INNINGSNO = 4 THEN SHORTTEAMNAME ELSE NULL END FOURTHINNINGSTEAMNAME, SUM(CASE WHEN INNINGSNO = 4 THEN INNINGSTOTAL + PENALTY + FOLLOWONPENALTY ELSE NULL END) FOURTHINNINGSTOTAL, SUM(CASE WHEN INNINGSNO = 4 THEN INNINGSTOTALWICKETS ELSE NULL END) FOURTHINNINGSTOTALWICKETS, CASE WHEN INNINGSNO = 4 THEN MATCHOVERS ELSE NULL END FOURTHINNINGSMATCHOVERS FROM A GROUP BY COMPETITIONCODE, MATCHCODE, A.MATCHDATE, A.SHORTTEAMNAME, A.TEAMCODE, A.INNINGSNO, A.MATCHOVERS, A.TOTALSCORE ) DTLS GROUP BY COMPETITIONCODE, MATCHCODE, MATCHDATE ) DTLS GROUP BY COMPETITIONCODE, MATCHCODE, MATCHDATE, FIRSTINNINGSSCORE, FIRSTINNINGSOVERS, SECONDINNINGSSHORTNAME, SECONDINNINGSSCORE, SECONDINNINGSOVERS, FIRSTINNINGSSHORTNAME, THIRDINNINGSSHORTNAME, FOURTHINNINGSSHORTNAME, THIRDINNINGSSCORE, FOURTHINNINGSOVERS, THIRDINNINGSOVERS, FOURTHINNINGSSCORE, FIRSTINNINGSTOTAL, SECONDINNINGSTOTAL, THIRDINNINGSTOTAL, FOURTHINNINGSTOTAL, FIRSTINNINGSWICKET, SECONDINNINGSWICKET, THIRDINNINGSWICKET, FOURTHINNINGSWICKET ) AS TT ) FINAL ) AS FF ORDER BY MATCHDATE DESC;",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                FetchSEPageLoadRecord *inningsRecord = [[FetchSEPageLoadRecord alloc]init];
                
                inningsRecord.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                inningsRecord.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1)];
                inningsRecord.MATCHDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2)];
                inningsRecord.FIRSTINNINGSTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3)];
                inningsRecord.SECONDINNINGSTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4)];
                inningsRecord.THIRDINNINGSTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5)];
                inningsRecord.FOURTHINNINGSTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
                inningsRecord.FIRSTINNINGSWICKET=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7)];
                inningsRecord.SECONDINNINGSWICKET=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8)];
                inningsRecord.THIRDINNINGSWICKET=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9)];
                inningsRecord.FOURTHINNINGSWICKET=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10)];
                inningsRecord.FIRSTINNINGSSCORE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11)];
                inningsRecord.SECONDINNINGSSCORE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12)];
                inningsRecord.THIRDINNINGSSCORE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13)];
                inningsRecord.FOURTHINNINGSSCORE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14)];
                inningsRecord.FIRSTINNINGSOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15)];
                inningsRecord.SECONDINNINGSOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,16)];
                inningsRecord.THIRDINNINGSOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,17)];
                inningsRecord.FOURTHINNINGSOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,18)];
                inningsRecord.FIRSTINNINGSSHORTNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,19)];
                inningsRecord.SECONDINNINGSSHORTNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,20)];
                inningsRecord.THIRDINNINGSSHORTNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,21)];
                inningsRecord.FOURTHINNINGSSHORTNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,22)];
                inningsRecord.AA=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,23)];
                inningsRecord.BB=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,24)];
                inningsRecord.AAWIC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,25)];
                inningsRecord.BBWIC=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,26)];
                [inningsRecordArray addObject:inningsRecord];
                
                
                
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
    }
    return inningsRecordArray;
    }
}



//WICKETDETAILS
-(BOOL)getScoreingDetails:(NSString *)BATTEAMSHORTNAME BOWLTEAMSHORTNAME:(NSString *)BOWLTEAMSHORTNAME BATTEAMNAME:(NSString *)BATTEAMNAME BOWLTEAMNAME:(NSString *)BOWLTEAMNAME  BATTEAMLOGO:(NSString *)BATTEAMLOGO BOWLTEAMLOGO:(NSString *)BOWLTEAMLOGO BATTEAMRUNS:(NSString *)BATTEAMRUNS BATTEAMWICKETS:(NSString *)BATTEAMWICKETS ISOVERCOMPLETE:(NSString *)ISOVERCOMPLETE BATTEAMOVERS:(NSString *)BATTEAMOVERS BATTEAMOVRBALLS:(NSString *)BATTEAMOVRBALLS BATTEAMRUNRATE:(NSString *)BATTEAMRUNRATE TARGETRUNS:(NSString *)TARGETRUNS REQRUNRATE:(NSString *)REQRUNRATE  RUNSREQUIRED:(NSString *)RUNSREQUIRED REMBALLS:(NSString *)REMBALLS  ISPREVIOUSLEGALBALL:(NSString *)ISPREVIOUSLEGALBALL T_ATWOROTW:(NSString *)T_ATWOROTW T_BOWLINGEND:(NSString *)T_BOWLINGEND ISFREEHIT:(NSString *)ISFREEHIT  {
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT %@ AS BATTEAMSHORTNAME,%@ AS BOWLTEAMSHORTNAME, %@ AS BATTEAMNAME,%@ AS BOWLTEAMNAME,%@ AS BATTEAMLOGO, %@ AS BOWLTEAMLOGO, (CONVERT(VARCHAR,%@)+'/'+CONVERT(VARCHAR,%@)) AS SCORE,(CONVERT(VARCHAR,(CASE WHEN %@ = 1 THEN %@+1 ELSE %@ END))+'.'+CONVERT(VARCHAR,%@)) AS OVERS,%@ RUNRATE,%@ AS TARGETRUNS,%@ AS REQRUNRATE,%@ AS RUNSREQUIRED, %@ AS REMBALLS,%@ AS ISOVERCOMPLETE, %@ AS ISPREVIOUSLEGALBALL, %@ AS ATWOROTW, CASE WHEN (%@ IS NULL OR %@ = '') THEN 'MSC150' ELSE %@ END AS BOWLINGEND,%@ AS ISFREEHIT",BATTEAMSHORTNAME,BOWLTEAMSHORTNAME,BATTEAMNAME,BOWLTEAMNAME,BATTEAMLOGO,BOWLTEAMLOGO,BATTEAMRUNS,BATTEAMWICKETS,ISOVERCOMPLETE,BATTEAMOVERS,BATTEAMOVERS,BATTEAMOVRBALLS,BATTEAMRUNRATE,TARGETRUNS,REQRUNRATE,RUNSREQUIRED,REMBALLS,ISOVERCOMPLETE,ISPREVIOUSLEGALBALL,T_ATWOROTW,T_BOWLINGEND,T_BOWLINGEND,T_BOWLINGEND,ISFREEHIT];
        
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
                
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
    
}



//SELECT MATCHCODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE ='UCC0000080'  AND MATCHCODE='IMSC023B8975A8DCBBB00260' AND strftime('%s' ,MATCHDATE) <= strftime('%s' ,'2016-07-30 13:00:00')

//INSERT BREAK DETAILS

-(BOOL) GetMatchCodeForInsertBreaks:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHCODE,MATCHDATE FROM MATCHREGISTRATION WHERE COMPETITIONCODE ='%@'  AND MATCHCODE='%@' AND strftime('%%Y-%%m-%%d' ,MATCHDATE) <= strftime('%%Y-%%m-%%d' ,'%@')",COMPETITIONCODE,MATCHCODE,BREAKSTARTTIME ];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}


-(BOOL) GetCompetitionCodeForInsertBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) ISINCLUDEDURATION:(NSString*) BREAKNO : (NSString*) BREAKCOMMENTS
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM INNINGSBREAKEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE='%@' AND INNINGSNO = '%@' AND BREAKSTARTTIME='%@' AND BREAKENDTIME='%@' AND BREAKCOMMENTS ='%@' AND ISINCLUDEINPLAYERDURATION='%@' AND BREAKNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BREAKSTARTTIME,BREAKENDTIME,BREAKCOMMENTS,ISINCLUDEDURATION,BREAKNO];
        const char *insert_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
    }
}

-(BOOL) MatchCodeForInsertBreaks:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO;
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BREAKNO FROM INNINGSBREAKEVENTS WHERE (('%@'  <=  BREAKSTARTTIME AND '%@' >= BREAKSTARTTIME) OR ('%@'  <=  BREAKENDTIME   AND '%@' >= BREAKENDTIME)   OR  ('%@'  >=  BREAKSTARTTIME AND '%@' <= BREAKENDTIME))  AND COMPETITIONCODE = '%@' AND MATCHCODE='%@'  AND INNINGSNO = '%@'",BREAKSTARTTIME,BREAKENDTIME,BREAKSTARTTIME,BREAKSTARTTIME,BREAKENDTIME,BREAKENDTIME,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *insert_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AlertView"];
                
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}

-(BOOL) InsertInningsEvents:(NSString*) COMPETITIONCODE:(NSString*) INNINGSNO:(NSString*) MATCHCODE:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) BREAKCOMMENTS:(NSString*) BREAKNO:(NSString*) ISINCLUDEDURATION
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO INNINGSBREAKEVENTS(COMPETITIONCODE,INNINGSNO,MATCHCODE,BREAKSTARTTIME,BREAKENDTIME,BREAKCOMMENTS,BREAKNO,ISINCLUDEINPLAYERDURATION)VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",COMPETITIONCODE,INNINGSNO,MATCHCODE,BREAKSTARTTIME,BREAKENDTIME,BREAKCOMMENTS,BREAKNO,ISINCLUDEDURATION];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSBREAKEVENTS" :@"MSC250" :updateSQL];
                
                
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
}

-(NSMutableArray *) GetBreakDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *BreaksArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"select BREAKNO,BREAKSTARTTIME,BREAKENDTIME,(strftime('%%s', BREAKENDTIME) - strftime('%%s', BREAKSTARTTIME)) / 60 AS DURATION,ISINCLUDEINPLAYERDURATION,BREAKCOMMENTS from INNINGSBREAKEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                BreakEventRecords *record=[[BreakEventRecords alloc]init];
                record.BREAKNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BREAKSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.BREAKENDTIME=[self getValueByNull:statement :2];
                record.DURATION=[self getValueByNull:statement :3];
                record.ISINCLUDEINPLAYERDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.BREAKCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                [BreaksArray addObject:record];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return BreaksArray;
	}
}

-(NSString*) GetMaxBreakNoForInsertBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT (IFNULL(MAX(BREAKNO),0)+1) AS MAXBREAKNO FROM  INNINGSBREAKEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}



//UPDATE BREAK DETAILS

-(BOOL ) GetMatchCodeForUpdateBreaks:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHCODE,MATCHDATE FROM MATCHREGISTRATION WHERE COMPETITIONCODE ='%@'  AND MATCHCODE='%@' AND strftime('%%Y-%%m-%%d' ,MATCHDATE) <= strftime('%%Y-%%m-%%d' ,'%@')",COMPETITIONCODE,MATCHCODE,BREAKENDTIME];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}






-(BOOL) GetCompetitionCodeForUpdateBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) BREAKCOMMENTS:(NSString*) ISINCLUDEDURATION:(NSString*) BREAKNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM INNINGSBREAKEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE='%@' AND INNINGSNO = '%@' AND BREAKSTARTTIME='%@' AND BREAKENDTIME='%@'  AND BREAKCOMMENTS ='%@' AND ISINCLUDEINPLAYERDURATION='%@' AND BREAKNO<>'%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BREAKSTARTTIME,BREAKENDTIME,BREAKCOMMENTS,ISINCLUDEDURATION,BREAKNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}







-(BOOL) GetBreakNoForUpdateBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) BREAKNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BREAKNO FROM INNINGSBREAKEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE='%@' AND INNINGSNO = '%@' AND ((('%@'<=BREAKSTARTTIME AND '%@'>= BREAKSTARTTIME) OR ('%@' <=BREAKENDTIME AND '%@' >= BREAKENDTIME) OR ('%@'>=BREAKSTARTTIME AND '%@'<=BREAKENDTIME )))AND BREAKNO <> '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BREAKSTARTTIME,BREAKSTARTTIME,BREAKENDTIME,BREAKENDTIME,BREAKSTARTTIME,BREAKENDTIME,BREAKNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}




-(BOOL) UpdateInningsEvents:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) BREAKCOMMENTS:(NSString*) ISINCLUDEDURATION : (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*) INNINGSNO : (NSString*) BREAKNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSBREAKEVENTS SET BREAKSTARTTIME = '%@',BREAKENDTIME = '%@',BREAKCOMMENTS='%@',ISINCLUDEINPLAYERDURATION='%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE='%@'  AND INNINGSNO = '%@' AND BREAKNO='%@'",BREAKSTARTTIME,BREAKENDTIME,BREAKCOMMENTS,ISINCLUDEDURATION,COMPETITIONCODE,MATCHCODE,INNINGSNO,BREAKNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSBREAKEVENTS" :@"MSC251" :updateSQL];
                
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
}





-(NSMutableArray *) GetInningsBreakDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *UpdateBreaksArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"select BREAKNO,BREAKSTARTTIME,BREAKENDTIME,(strftime('%%s', BREAKENDTIME) - strftime('%%s', BREAKSTARTTIME)) / 60 AS DURATION,ISINCLUDEINPLAYERDURATION,BREAKCOMMENTS from INNINGSBREAKEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                UpdateBreaksArrayDetails *UpdateBreakDetails=[[UpdateBreaksArrayDetails alloc]init];
                UpdateBreakDetails.BREAKNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                UpdateBreakDetails.BREAKSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                UpdateBreakDetails.BREAKENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                UpdateBreakDetails.DURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                UpdateBreakDetails.ISINCLUDEINPLAYERDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                UpdateBreakDetails.BREAKCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                [UpdateBreaksArray addObject:UpdateBreakDetails];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return UpdateBreaksArray;
	}
}




-(NSString*) GetMaxBreakNoForUpdateBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BREAKNO),0) AS MAXBREAKNO FROM  INNINGSBREAKEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *BREAKNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    
                    return BREAKNO;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}


//DELETE BREAK DETAILS

-(BOOL) GetCompetitionCodeForDeleteBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BREAKNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM INNINGSBREAKEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE='%@' AND INNINGSNO = '%@' AND BREAKNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BREAKNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}


-(BOOL) DeleteInningsEvents:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO : (NSString*) BREAKNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM INNINGSBREAKEVENTS WHERE COMPETITIONCODE ='%@' AND MATCHCODE='%@' AND INNINGSNO ='%@' AND BREAKNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO,BREAKNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        //   sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSBREAKEVENTS" :@"MSC252" :updateSQL];
                
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
}




-(NSMutableArray*) InningsBreakDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *DeleteBreaksArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"select BREAKNO,BREAKSTARTTIME,BREAKENDTIME,(strftime('%%s', BREAKENDTIME) - strftime('%%s', BREAKSTARTTIME)) / 60 AS DURATION,ISINCLUDEINPLAYERDURATION,BREAKCOMMENTS from INNINGSBREAKEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    DeleteEventRecord *record=[[DeleteEventRecord alloc]init];
                    record.BREAKNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    record.BREAKSTARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    record.BREAKENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    record.DURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    record.ISINCLUDEINPLAYERDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    record.BREAKCOMMENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    
                    [DeleteBreaksArray addObject:record];
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return DeleteBreaksArray;
	}
}


-(NSString*) GetMaxBreakNoForDeleteBreaks:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BREAKNO),0) AS MAXBREAKNO FROM  INNINGSBREAKEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *BREAKNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return BREAKNO;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(BOOL) swapStrickerAndNonStricker:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                         INNINGSNO:(NSString *)INNINGSNO STRIKERCODE:(NSString *)STRIKERCODE NONSTRIKERCODE:(NSString *)NONSTRIKERCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET STRIKERCODE = '%@', NONSTRIKERCODE ='%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@; ",STRIKERCODE,NONSTRIKERCODE,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC251" :updateSQL];
                
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
}
-(BOOL) updateStricker:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
             INNINGSNO:(NSString *)INNINGSNO STRIKERCODE:(NSString *)STRIKERCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET STRIKERCODE = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@; ",STRIKERCODE,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC251" :updateSQL];
                
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
}

-(BOOL) updateNONSTRIKERCODE:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                   INNINGSNO:(NSString *)INNINGSNO NONSTRIKERCODE:(NSString *)NONSTRIKERCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET NONSTRIKERCODE = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@; ",NONSTRIKERCODE,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC251" :updateSQL];
                
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
}

-(BOOL) updateBOWLERCODE:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
               INNINGSNO:(NSString *)INNINGSNO BOWLERCODE:(NSString *)BOWLERCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET BOWLERCODE = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@; ",BOWLERCODE,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC251" :updateSQL];
                
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
}




-(NSString*) getBallNO:(NSString*) COMPETITIONCODE MATCHCODE:(NSString*) MATCHCODE INNINGSNO: (NSString*) INNINGSNO OVERNO: (NSString*) OVERNO{
    @synchronized ([Utitliy syncId]) {
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLNO) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%@ AND OVERNO=%@-1",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                
                NSString *BALLNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLNO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}


-(NSString*) getBallCount:(NSString*) COMPETITIONCODE MATCHCODE:(NSString*) MATCHCODE INNINGSNO: (NSString*) INNINGSNO OVERNO: (NSString*) OVERNO BALLNO: (NSString*) BALLNO{
    @synchronized ([Utitliy syncId]) {
    
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLCOUNT) FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%@ AND OVERNO=%@-1 AND BALLNO= %@",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BALLNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                
                NSString *BALLCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLCOUNT;
            }
            sqlite3_reset(statement);
            
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    return @"";
    
    }
}


-(NSString*) getLastBowlerCode:(NSString*) COMPETITIONCODE MATCHCODE:(NSString*) MATCHCODE INNINGSNO: (NSString*) INNINGSNO OVERNO: (NSString*) OVERNO BALLNO: (NSString*) BALLNO BALLCOUNT: (NSString*) BALLCOUNT{
    
  @synchronized ([Utitliy syncId]) {  
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=%@ AND OVERNO=%@-1 AND BALLNO= %@  AND BALLCOUNT= %@",COMPETITIONCODE,MATCHCODE,INNINGSNO,OVERNO,BALLNO,BALLCOUNT];
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                
                NSString *PLAYERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return PLAYERCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
    }
    return @"";
    }
    
}



//--------------------------------------------------------------------------------------------------------------------------

//SP_INITIALIZEINNINGSSCOREBOARD


// Delete Batting Summary
-(BOOL) deleteBattingSummary:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                   INNINGSNO:(NSNumber *)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@';",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *query_stmt = [query UTF8String];
        if(sqlite3_prepare_v2(dataBase, query_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC252" :query];
                
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
}


//	-- Clear Innings Summary for Particular Innings of the Match

-(BOOL) deleteInningsSummary:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                   INNINGSNO:(NSNumber *)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM INNINGSSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@';",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *query_stmt = [query UTF8String];
        if(sqlite3_prepare_v2(dataBase, query_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSSUMMARY" :@"MSC252" :query];
                
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
}



//Clear Bowling Card for Particular Innings of the Match
-(BOOL) deleteBowlingSummary:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                   INNINGSNO:(NSNumber *)INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"DELETE FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@';",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *query_stmt = [query UTF8String];
        if(sqlite3_prepare_v2(dataBase, query_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC252" :query];
                
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
}


//Insert data to batting summary

-(BOOL) insertBattingSummary:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
             BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE
                   INNINGSNO:(NSNumber *)INNINGSNO
                 STRIKERCODE:(NSString *)STRIKERCODE
{
@synchronized ([Utitliy syncId]) {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO BATTINGSUMMARY (COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTINGPOSITIONNO,BATSMANCODE,RUNS,BALLS,ONES,TWOS,THREES,FOURS,SIXES,DOTBALLS) VALUES ('%@','%@','%@','%@',1,'%@',0,0,0,0,0,0,0,0);",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE];
        const char *query_stmt = [query UTF8String];
        if(sqlite3_prepare_v2(dataBase, query_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC250" :query];
                
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
}


//-- Add Non-Striker details in Batting Card

-(BOOL) insertBattingSummaryNonStricker:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
                        BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE
                              INNINGSNO:(NSNumber *)INNINGSNO
                         NONSTRIKERCODE:(NSString *)NONSTRIKERCODE
{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO BATTINGSUMMARY (COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTINGPOSITIONNO,BATSMANCODE,RUNS,BALLS,ONES,TWOS,THREES,FOURS,SIXES,DOTBALLS) VALUES ('%@','%@','%@','%@',2,'%@',0,0,0,0,0,0,0,0);",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE];
        const char *query_stmt = [query UTF8String];
        if(sqlite3_prepare_v2(dataBase, query_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC250" :query];
                
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
}





//Add Innings Summary

-(BOOL) insertInningsSummary:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
             BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE
                   INNINGSNO:(NSNumber *)INNINGSNO

{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO INNINGSSUMMARY(COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BYES,LEGBYES,NOBALLS,WIDES,PENALTIES,INNINGSTOTAL,INNINGSTOTALWICKETS) VALUES ('%@','%@','%@','%@',0,0,0,0,0,0,0);",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *query_stmt = [query UTF8String];
        if(sqlite3_prepare_v2(dataBase, query_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSSUMMARY" :@"MSC250" :query];
                
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
}





//-- Add Bowler details in Bowling Card
-(BOOL) insertBowlingSummary:(NSString *)COMPETITIONCODE MATCHCODE:(NSString *)MATCHCODE
             BATTINGTEAMCODE:(NSString *)BATTINGTEAMCODE
                   INNINGSNO:(NSNumber *)INNINGSNO
                  BOWLERCODE:(NSString *)BOWLERCODE
{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *query = [NSString stringWithFormat:@"INSERT INTO BOWLINGSUMMARY(COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,BOWLINGPOSITIONNO,BOWLERCODE,OVERS,BALLS,PARTIALOVERBALLS,MAIDENS,RUNS,WICKETS,NOBALLS,WIDES,DOTBALLS,FOURS,SIXES) VALUES ('%@','%@','%@','%@',1,'%@',0,0,0,0,0,0,0,0,0,0,0);",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
        const char *query_stmt = [query UTF8String];
        if(sqlite3_prepare_v2(dataBase, query_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC250" :query];
                
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
    
}
//------------------------------------------------------------------------------------------
//SP_SBUPDATEPLAYERS
-(BOOL )  GetBallCodeForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *selectQry = [NSString stringWithFormat:@"SELECT BALLCODE  FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@'  AND MATCHCODE ='%@'  AND TEAMCODE = '%@' AND INNINGSNO = '%@' ", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *selectStmt = [selectQry UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}
//------------------------------------------------------------------------------------------
-(BOOL )  GetWicketTypeForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETTYPE  FROM WICKETEVENTS   WHERE COMPETITIONCODE ='%@' AND MATCHCODE = '%@'  AND TEAMCODE = '%@'  AND INNINGSNO ='%@'", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}

//------------------------------------------------------------------------------------------
-(BOOL) DeleteBattingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BATTINGSUMMARY  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'  AND BATTINGTEAMCODE =  '%@' AND INNINGSNO = '%@' AND BATSMANCODE IN (SELECT BE.BATSMANCODE FROM (SELECT BS.BATSMANCODE FROM BATTINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE AND BS.BATTINGTEAMCODE = BE.TEAMCODE AND BS.INNINGSNO = BE.INNINGSNO AND (BS.BATSMANCODE = BE.STRIKERCODE OR BS.BATSMANCODE = BE.NONSTRIKERCODE) WHERE BS.COMPETITIONCODE = '%@' AND BS.MATCHCODE = '%@' AND BS.BATTINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@'       AND BE.STRIKERCODE IS NULL) BE INNER JOIN (SELECT BS.BATSMANCODE FROM BATTINGSUMMARY BS LEFT JOIN WICKETEVENTS WE ON BS.COMPETITIONCODE = WE.COMPETITIONCODE AND BS.MATCHCODE = WE.MATCHCODE AND BS.BATTINGTEAMCODE = WE.TEAMCODE AND BS.INNINGSNO = WE.INNINGSNO AND BS.BATSMANCODE = WE.WICKETPLAYER WHERE BS.COMPETITIONCODE = '%@' AND BS.MATCHCODE =  '%@' AND BS.BATTINGTEAMCODE = '%@' AND BS.INNINGSNO =  '%@' AND WE.WICKETPLAYER IS NULL) WE ON BE.BATSMANCODE = WE.BATSMANCODE)",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC252" :updateSQL];
                
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
}

//---------------------------------------------------------------------------------------------------------------------------------------

-(BOOL )  DeleteBowlingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BOWLINGTEAMCODE :(NSString*) INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"DELETE FROM BOWLINGSUMMARY WHERE COMPETITIONCODE ='%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE IN (SELECT BS.BOWLERCODE FROM BOWLINGSUMMARY BS LEFT JOIN BALLEVENTS BE ON BS.COMPETITIONCODE = BE.COMPETITIONCODE AND BS.MATCHCODE = BE.MATCHCODE AND BS.INNINGSNO = BE.INNINGSNO      AND BS.BOWLERCODE = BE.BOWLERCODE WHERE BS.COMPETITIONCODE ='%@' AND BS.MATCHCODE ='%@' AND BS.BOWLINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@' AND BE.BOWLERCODE IS NULL)",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC252" :updateSQL];
                
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
}
//----------------------------------------------------------------------------------------------------------------------------------

-(BOOL) GetStrikerDetailBallCodeForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO : (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE {
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE ='%@'  AND TEAMCODE ='%@'  AND INNINGSNO ='%@'  AND (STRIKERCODE ='%@' OR NONSTRIKERCODE = '%@')", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE,STRIKERCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
    }
}

-(NSString*) GetStrikerDetailsBattingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) + 1 as BATSUMCOUNT  FROM BATTINGSUMMARY WHERE COMPETITIONCODE ='%@' AND MATCHCODE ='%@'  AND BATTINGTEAMCODE = '%@'  AND INNINGSNO = '%@' ", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *BATSUMCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return BATSUMCOUNT;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(BOOL)  InsertBattingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO :(NSString*) STRIKERPOSITIONNO : (NSString*) STRIKERCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BATTINGSUMMARY (COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO, BATTINGPOSITIONNO,BATSMANCODE,RUNS,BALLS,ONES,TWOS,THREES,FOURS,SIXES,DOTBALLS) VALUES ('%@','%@','%@','%@','%@','%@',0,0,0,0,       0,0,0,0)",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERPOSITIONNO,STRIKERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC250" :updateSQL];
                
                
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
    
}

-(BOOL)  GetBatsmanCodeForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO: (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BATSMANCODE FROM BATTINGSUMMARY  WHERE COMPETITIONCODE ='%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO ='%@' AND (BATSMANCODE ='%@' OR BATSMANCODE ='%@') AND WICKETTYPE = 'MSC102'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE,NONSTRIKERCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
    }
}

-(BOOL) UpdateBattingSummaryInStrickerDetailsForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO: (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BATTINGSUMMARY SET WICKETTYPE = ''  WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@' AND (BATSMANCODE ='%@' OR BATSMANCODE ='%@') AND WICKETTYPE = 'MSC102'", COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE,NONSTRIKERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC251" :updateSQL];
                
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
}


-(BOOL)  GetBatsmanCodeInUpdateBattingSummaryForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO: (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BS.BATSMANCODE FROM BATTINGSUMMARY BS INNER JOIN WICKETEVENTS WE   ON WE.COMPETITIONCODE = BS.COMPETITIONCODE AND WE.MATCHCODE = BS.MATCHCODE AND WE.TEAMCODE = BS.BATTINGTEAMCODE AND WE.INNINGSNO = BS.INNINGSNO AND WE.WICKETPLAYER = BS.BATSMANCODE WHERE BS.COMPETITIONCODE ='%@' AND BS.MATCHCODE = '%@' AND BS.BATTINGTEAMCODE ='%@' AND BS.INNINGSNO = '%@' AND (BS.BATSMANCODE !='%@' AND BS.BATSMANCODE != '%@') AND WE.WICKETTYPE = 'MSC102'  AND (BS.WICKETTYPE IS NULL OR BS.WICKETTYPE = '')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE,NONSTRIKERCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}

-(BOOL) UpdateBattingSummaryAndWicketEventInStrickerDetailsForUpdatePlayers:(NSString*) COMPETITIONCODE:(NSString*)
                                                                 MATCHCODE :(NSString*) BATTINGTEAMCODE :(NSString*) INNINGSNO: (NSString*) STRIKERCODE : (NSString*) NONSTRIKERCODE
{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BTS SET BTS.WICKETTYPE = 'MSC102' FROM BATTINGSUMMARY BTS INNER JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE = BTS.COMPETITIONCODE AND WE.MATCHCODE = BTS.MATCHCODE AND WE.TEAMCODE = BTS.BATTINGTEAMCODE AND WE.INNINGSNO = BTS.INNINGSNO AND WE.WICKETPLAYER = BTS.BATSMANCODE WHERE BTS.COMPETITIONCODE = '%@'      AND BTS.MATCHCODE = '%@' AND BTS.BATTINGTEAMCODE = '%@' AND BTS.INNINGSNO = '%@' AND (BTS.BATSMANCODE != '%@' AND BTS.BATSMANCODE != '%@') AND WE.WICKETTYPE = 'MSC102' AND (BTS.WICKETTYPE IS NULL OR BTS.WICKETTYPE = '')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE,NONSTRIKERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC251" :updateSQL];
                
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
}


-(BOOL) UpdateInningsEventsForPlayers:(NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSString*) BOWLERCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO
{
    @synchronized ([Utitliy syncId]) {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [ NSString stringWithFormat:@"UPDATE INNINGSEVENTS SET CURRENTSTRIKERCODE='%@',CURRENTNONSTRIKERCODE='%@',CURRENTBOWLERCODE='%@' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC251" :updateSQL];
                
                
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
    
}




-(BOOL) InsertBowlingSummaryForPlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) BOWLERPOSITIONNO:(NSString*) BOWLERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLINGSUMMARY(COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,BOWLINGPOSITIONNO,BOWLERCODE,OVERS,BALLS,PARTIALOVERBALLS,MAIDENS,RUNS,WICKETS,NOBALLS,WIDES,DOTBALLS,FOURS,SIXES)VALUES('%@','%@','%@','%@','%@','%@',0,0,0,0,0,0,0,0,0,0,0);",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,BOWLERPOSITIONNO,BOWLERCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC250" :updateSQL];
                
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
}


-(NSString*) GetBowlerDetailsForBowlingSummary:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BOWLINGTEAMCODE:(NSString*) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) + 1 AS COUNTBOWLINGSUMMARY FROM BOWLINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BOWLINGTEAMCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *COUNTBOWLINGSUMMARY =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return COUNTBOWLINGSUMMARY;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return @"";
	}
}


-(BOOL) GetBowlerDetailsForBallCode:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) BOWLERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND BOWLERCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
    }
}


-(BOOL) InsertBattingSummaryForPlayers:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) NONSTRIKERPOSITIONNO:(NSString*) NONSTRIKERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BATTINGSUMMARY(COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTINGPOSITIONNO,BATSMANCODE,RUNS,BALLS,ONES,TWOS,THREES,FOURS,SIXES,DOTBALLS)VALUES('%@','%@','%@','%@','%@','%@',0,0,0,0,0,0,0,0);",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERPOSITIONNO,NONSTRIKERCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BATTINGSUMMARY" :@"MSC250" :updateSQL];
                
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
}



-(NSString*) GetNonStrikerDetailsForBattingSummary:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO
{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) + 1 AS COUNTBATTINGSUMMARY  FROM BATTINGSUMMARY WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BATTINGTEAMCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *COUNTBATTINGSUMMARY =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return COUNTBATTINGSUMMARY;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return @"";
	}
}


-(BOOL) GetNonStrikerDetailsForBallCode:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSString*) INNINGSNO:(NSString*) NONSTRIKERCODE
{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND TEAMCODE = '%@' AND INNINGSNO = '%@' AND (STRIKERCODE = '%@' OR NONSTRIKERCODE = '%@')",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE,NONSTRIKERCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
	}
}


//Revised Overs

-(NSMutableArray *) RetrieveRevisedOverData:(NSString*)matchcode competitionCode:(NSString*) competitionCode recordstatus:(NSString*) recordstatus{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *revisedoverArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT MATCHOVERS,MATCHOVERCOMMENTS FROM MATCHREGISTRATION WHERE MATCHCODE ='%@' AND COMPETITIONCODE='%@'AND RECORDSTATUS='MSC001'",matchcode,competitionCode,recordstatus];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FixturesRecord *record=[[FixturesRecord alloc]init];
                
                
                record.overs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchovercomments=[self getValueByNull:statement :1];
                [revisedoverArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return revisedoverArray;
    }
}

//update matchovers and matchovercomments(Revised overs)
-(BOOL)updateRevisedOvers:(NSString*)overs comments:(NSString*)comments matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode  {
    @synchronized ([Utitliy syncId]) {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update MATCHREGISTRATION Set MATCHOVERS ='%@', MATCHOVERCOMMENTS = '%@' WHERE MATCHCODE='%@' AND COMPETITIONCODE='%@'",overs,comments,matchCode,competitionCode];
        const char *insert_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:matchCode :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
                
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
    
    
}

//Revised Target
//update matchovers,matchtarget and matchovercomments(Revised Target)

-(BOOL)updateRevisedTarget:(NSString*)targetovers runs:(NSString*)targetruns comments:(NSString*)targetcomments matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode  {
    @synchronized ([Utitliy syncId]) {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update MATCHEVENTS Set TARGETRUNS ='%@', TARGETOVERS = '%@',TARGETCOMMENTS = '%@' WHERE MATCHCODE='%@' AND COMPETITIONCODE='%@'",targetruns,targetovers,targetcomments,matchCode,competitionCode];
        const char *insert_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, insert_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:matchCode :@"MATCHEVENTS" :@"MSC251" :updateSQL];
                
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
    
    
}

-(NSMutableArray *) RetrieveRevisedTargetData:(NSString*)matchcode competitionCode:(NSString*) competitionCode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *revisedtargetArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT TARGETRUNS,TARGETOVERS,TARGETCOMMENTS FROM MATCHEVENTS WHERE MATCHCODE ='%@' AND COMPETITIONCODE='%@'",matchcode,competitionCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                MatcheventRecord *record=[[MatcheventRecord alloc]init];
                
                record.targetruns=[self getValueByNull:statement :0];
                record.targetovers=[self getValueByNull:statement :1];
                record.targetcomments=[self getValueByNull:statement :2];
                
                [revisedtargetArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return revisedtargetArray;
    }
}


-(NSMutableArray *)GetBolwerDetailsonEdit:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE:(NSString *) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray * BOWLERDETAILS =[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.BALLCODE,BWLR.PLAYERNAME BOWLER, STRKR.PLAYERNAME STRIKER, NSTRKR.PLAYERNAME NONSTRIKER,BT.BOWLTYPE BOWLTYPE, ST.SHOTNAME AS SHOTTYPE, BALL.TOTALRUNS, BALL.TOTALEXTRAS,BALL.OVERNO,BALL.BALLNO,BALL.BALLCOUNT,BALL.ISLEGALBALL,BALL.ISFOUR,BALL.ISSIX,BALL.RUNS,BALL.OVERTHROW,BALL.TOTALRUNS,BALL.WIDE,BALL.NOBALL,BALL.BYES,BALL.LEGBYES,IFNULL(WE.WICKETNO,0),WE.WICKETTYPE, PTY.PENALTYRUNS, PTY.PENALTYTYPECODE,BALL.GRANDTOTAL,BALL.MARKEDFOREDIT,BOWLERCODE FROM BALLEVENTS BALL INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE = BALL.COMPETITIONCODE AND MR.MATCHCODE = BALL.MATCHCODE INNER JOIN TEAMMASTER TM ON BALL.TEAMCODE = TM.TEAMCODE INNER JOIN PLAYERMASTER BWLR ON BALL.BOWLERCODE=BWLR.PLAYERCODE INNER JOIN PLAYERMASTER STRKR ON BALL.STRIKERCODE = STRKR.PLAYERCODE INNER JOIN PLAYERMASTER NSTRKR ON BALL.NONSTRIKERCODE = NSTRKR.PLAYERCODE LEFT JOIN BOWLTYPE BT ON BALL.BOWLTYPE = BT.BOWLTYPECODE LEFT JOIN SHOTTYPE ST ON BALL.SHOTTYPE = ST.SHOTCODE LEFT JOIN WICKETEVENTS WE ON BALL.BALLCODE = WE.BALLCODE AND WE.ISWICKET = 1 LEFT JOIN PENALTYDETAILS PTY ON BALL.BALLCODE = PTY.BALLCODE WHERE  BALL.COMPETITIONCODE='%@'AND BALL.MATCHCODE='%@'AND BALL.INNINGSNO='%@'ORDER BY BALL.COMPETITIONCODE,BALL.MATCHCODE,BALL.INNINGSNO, BALL.OVERNO, BALL.BALLNO, BALL.BALLCOUNT",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            int rowId = 0;
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                InningsBowlerDetailsRecord *objInningsBowlerDetailsRecord=[[InningsBowlerDetailsRecord alloc]init];
                objInningsBowlerDetailsRecord.ballCode=[self getValueByNull:statement :0];
                objInningsBowlerDetailsRecord.Playername=[self getValueByNull:statement :1];
                
                objInningsBowlerDetailsRecord.Striker=[self getValueByNull:statement :2];
                objInningsBowlerDetailsRecord.nonStriker=[self getValueByNull:statement :3];
                objInningsBowlerDetailsRecord.bowlerType=[self getValueByNull:statement :4];
                objInningsBowlerDetailsRecord.shorType=[self getValueByNull:statement :5];
                objInningsBowlerDetailsRecord.totalRuns=[self getValueByNull:statement :6];
                objInningsBowlerDetailsRecord.totalExtras=[self getValueByNull:statement :7];
                objInningsBowlerDetailsRecord.OverNo=[self getValueByNull:statement :8];
                objInningsBowlerDetailsRecord.ballNo=[self getValueByNull:statement :9];
                objInningsBowlerDetailsRecord.BallCount=[self getValueByNull:statement :10];
                objInningsBowlerDetailsRecord.islegalBall=[self getValueByNull:statement :11];
                objInningsBowlerDetailsRecord.isFour=[self getValueByNull:statement :12];
                objInningsBowlerDetailsRecord.isSix=[self getValueByNull:statement :13];
                objInningsBowlerDetailsRecord.Runs=[self getValueByNull:statement :14];
                objInningsBowlerDetailsRecord.overThrow=[self getValueByNull:statement :15];
                objInningsBowlerDetailsRecord.totalRuns=[self getValueByNull:statement :16];
                objInningsBowlerDetailsRecord.Wide=[self getValueByNull:statement :17];
                objInningsBowlerDetailsRecord.noBall=[self getValueByNull:statement :18];
                objInningsBowlerDetailsRecord.Byes=[self getValueByNull:statement :19];
                objInningsBowlerDetailsRecord.Legbyes=[self getValueByNull:statement :20];
                objInningsBowlerDetailsRecord.WicketNo=[self getValueByNull:statement :21];
                objInningsBowlerDetailsRecord.WicketType=[self getValueByNull:statement :22];
                objInningsBowlerDetailsRecord.penaltyRuns=[self getValueByNull:statement :23];
                objInningsBowlerDetailsRecord.penaltytypeCode=[self getValueByNull:statement :24];
                objInningsBowlerDetailsRecord.grandTotal=[self getValueByNull:statement :25];
                objInningsBowlerDetailsRecord.ismarkforedit=[self getValueByNull:statement :26];
                objInningsBowlerDetailsRecord.BowlerCode =[self getValueByNull:statement :27];
                objInningsBowlerDetailsRecord.rowId = [NSNumber numberWithInt:rowId];
                
                [BOWLERDETAILS addObject:objInningsBowlerDetailsRecord];
                rowId++;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
        
    }
    return BOWLERDETAILS;
	}
}



-(BOOL) UpdateInningsEventForInsertEndInninges:(NSString*) INNINGSSTARTTIME : (NSString*) INNINGSENDTIME :(NSString*) OLDTEAMCODE :(NSString*) TOTALRUNS : (NSString*) ENDOVER :(NSString*) TOTALWICKETS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE  INNINGSEVENTS  SET INNINGSSTARTTIME='%@',INNINGSENDTIME='%@',BATTINGTEAMCODE='%@',TOTALRUNS='%@',TOTALOVERS='%@',TOTALWICKETS='%@',INNINGSSTATUS='1' WHERE 	COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",INNINGSSTARTTIME,INNINGSENDTIME,OLDTEAMCODE,TOTALRUNS,ENDOVER,TOTALWICKETS,COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC251" :updateSQL];
                
                
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
}

-(NSString*) GetCompetitioncodeInAddOldInningsNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDTEAMCODE:(NSString*) OLDINNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"	SELECT COMPETITIONCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'+1 AND ISDECLARE=0 ",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSString *COMPETITIONCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    
                    return COMPETITIONCODE;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(NSString*) GetInningsCountForInsertEndInnings:(NSString*) MATCHCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    NSString *INNINGSCOUNT = [[NSString alloc]init];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(INNINGSNO) FROM INNINGSEVENTS WHERE MATCHCODE ='%@'",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    INNINGSCOUNT =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return INNINGSCOUNT;
                }
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(BOOL) UpdateMatchRegistrationForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET [MATCHSTATUS] = 'MSC125' ,[MODIFIEDBY] = 'USER' ,[MODIFIEDDATE] = GETDATE() WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"MATCHREGISTRATION" :@"MSC251" :updateSQL];
                
                return YES;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return NO;
    }
}

-(NSString*) GetMatchBasedSessionNoForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) SESSIONNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT SESSIONNO FROM SESSIONEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@' AND SESSIONNO='%@'",COMPETITIONCODE, MATCHCODE ,OLDINNINGSNO , DAYNO , SESSIONNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    NSString *SESSIONNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return SESSIONNO;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}


-(BOOL) InsertSessionEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) SESSIONNO: (NSString*) OLDTEAMCODE: (NSString*) STARTOVERBALLNO:(NSString*) ENDOVER:(NSString*) RUNSSCORED:(NSString*) TOTALWICKETS{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO SESSIONEVENTS ( COMPETITIONCODE, MATCHCODE,INNINGSNO,DAYNO,SESSIONNO,SESSIONSTARTTIME,SESSIONENDTIME,BATTINGTEAMCODE,STARTOVER,ENDOVER,TOTALRUNS,DOMINANTTEAMCODE,SESSIONSTATUS) VALUES  ( '%@', '%@','%@','%@','%@','','','%@','%@','%@','%@','%@','',0)",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,DAYNO,SESSIONNO,OLDTEAMCODE,STARTOVERBALLNO,ENDOVER,RUNSSCORED,TOTALWICKETS];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"SESSIONEVENTS" :@"MSC250" :updateSQL];
                
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
    
}

-(NSString*) GetDayNoInDayEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : OLDINNINGSNO: (NSString*) DAYNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT DAYNO FROM DAYEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@' AND DAYNO='%@'",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,DAYNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *DAYNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return DAYNO;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(BOOL) InsertDayEventForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDINNINGSNO: (NSString*) DAYNO: (NSString*) OLDTEAMCODE: (NSString*) TOTALRUNS:(NSString*) ENDOVER:(NSString*) TOTALWICKETS : (NSString*) SESSIONNO : (NSString*) STARTOVERBALLNO : (NSString*) RUNSSCORED{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO DAYEVENTS(COMPETITIONCODE,MATCHCODE,	INNINGSNO,STARTTIME,ENDTIME,DAYNO,BATTINGTEAMCODE,	TOTALRUNS,TOTALOVERS,TOTALWICKETS,COMMENTS,DAYSTATUS)  VALUES('%@','%@','%@','','','%@','%@','%@','%@','%@',''0);)",COMPETITIONCODE,MATCHCODE,OLDINNINGSNO,DAYNO,SESSIONNO,OLDTEAMCODE,STARTOVERBALLNO,ENDOVER,RUNSSCORED,TOTALWICKETS];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"DAYEVENTS" :@"MSC250" :updateSQL];
                
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
}

-(NSString*) GetCompetitioncodeInUpdateForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) OLDTEAMCODE:(NSString*) OLDINNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COMPETITIONCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND INNINGSSTATUS='1' ",COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *COMPETITIONCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return COMPETITIONCODE;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(BOOL) UpdateInningsEventInUpdateForInsertEndInninges:(NSString*) INNINGSSTARTTIME : (NSString*) INNINGSENDTIME :(NSString*) TOTALRUNS : (NSString*) ENDOVER :(NSString*) TOTALWICKETS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) OLDTEAMCODE: (NSString*) OLDINNINGSNO{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE  INNINGSEVENTS  SET	INNINGSSTARTTIME='%@',	INNINGSENDTIME='%@',TOTALRUNS='%@',TOTALOVERS='%@',TOTALWICKETS='%@'  WHERE COMPETITIONCODE='%@' AND  MATCHCODE='%@' AND TEAMCODE='%@' AND  INNINGSNO='%@' ",INNINGSSTARTTIME,INNINGSENDTIME,OLDTEAMCODE,TOTALRUNS,ENDOVER,TOTALWICKETS,COMPETITIONCODE,MATCHCODE,OLDTEAMCODE,OLDINNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"INNINGSEVENTS" :@"MSC251" :updateSQL];
                
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
}


-(NSString*) GetSecondTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=2",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        
        
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TEAMCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TEAMCODE;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
    
}

-(NSString*) GetThirdTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  TEAMCODE FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO=3",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TEAMCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TEAMCODE;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}


-(NSString*) GetSecondTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
   @synchronized ([Utitliy syncId]) { 
    
    NSString *databasePath = [self getDBPath];
    
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND (INNINGSNO=3 OR INNINGSNO=2)",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(NSString*) GetFirstTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSNO=1 ",COMPETITIONCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


-(NSNumber*) GetSecondTotalinSecondThirdTeamCodeForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSNO=2",COMPETITIONCODE,MATCHCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(NSNumber*) GetFirstThirdTotalForInsertEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    @synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) AS TOTAL FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND (INNINGSNO=1 OR INNINGSNO=3)",COMPETITIONCODE,MATCHCODE];
        
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    
                    NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    sqlite3_reset(statement);
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return TOTAL;
                }
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}


//--------------------------------------------------------------------------------------------------------
//SP_FETCHENDINNINGS

-(NSString *)GetTeamNameForFetchEndInnings:(NSString *)TEAMCODE
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT TEAMNAME FROM TEAMMASTER  WHERE TEAMCODE='%@'",TEAMCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *getInnings = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getInnings;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}



-(NSNumber *) GetpenaltyRunsForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) TEAMCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0) as PenaltyRuns FROM    PENALTYDETAILS WHERE COMPETITIONCODE = '%@' AND MATCHCODE ='%@' AND INNINGSNO IN ('%@', '%@' - 1)	AND AWARDEDTOTEAMCODE ='%@' AND (BALLCODE IS NULL OR INNINGSNO < '%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,INNINGSNO,TEAMCODE,INNINGSNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *TOTAL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TOTAL;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSNumber*) GetTotalRunsForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) AS TOTAL FROM   BALLEVENTS 	WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *TOTAL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TOTAL;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return 0;
	}
}

-(NSString*) GetOverNoForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    NSString *getOver = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(OVERNO) AS MAXOVER FROM BALLEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                getOver = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getOver;
                
                
            }
        }
        
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return 0;
    }
}

-(NSString*) GetBallNoForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString *)OVERNO:(NSString*) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    NSString *getMaxBall = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT MAX(BALLNO) AS BALLNO FROM BALLEVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'AND TEAMCODE='%@' AND OVERNO='%@' AND INNINGSNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,OVERNO,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                getMaxBall = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getMaxBall;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}


-(NSString*) GetOverStatusForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO:(NSString*) OVERNO
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    
    NSString *getOverStatus = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                getOverStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getOverStatus;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}





-(NSString*) GetWicketForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) INNINGSNO
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    
    NSString *getWkt = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT COUNT(WKT.BALLCODE) AS EXTRAWICKETCOUNT FROM BALLEVENTS BALL  LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE	WHERE BALL.COMPETITIONCODE='%@' AND BALL.MATCHCODE='%@' AND BALL.TEAMCODE='%@' AND BALL.INNINGSNO='%@'  AND BALL.INNINGSNO ='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                getWkt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getWkt;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}

-(NSMutableArray *) FetchEndInningsDetailsForFetchEndInnings:(NSString*) MATCHCODE
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *FetchEndInningsDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STARTTIME,ENDTIME,TEAMNAME,TOTALRUNS,TOTALOVERS,TOTALWICKETS,INNINGSNO,BATTINGTEAMCODE,DAYDURATION,INNINGSDURATION,CASE WHEN DAYDURATION IS NULL THEN CAST(INNINGSDURATION AS NVARCHAR)+' MINS'  ELSE CAST(DAYDURATION AS NVARCHAR)+' MINS' END AS DURATION FROM (SELECT IE.INNINGSSTARTTIME AS STARTTIME,IE.INNINGSENDTIME AS ENDTIME,DATEDIFF(MINUTE,IE.INNINGSSTARTTIME,IE.INNINGSENDTIME) AS INNINGSDURATION,CASE WHEN DE.STARTTIME!=NULL THEN SUM(DATEDIFF(MINUTE,DE.STARTTIME,DE.ENDTIME)) ELSE SUM(DATEDIFF(MINUTE,DE.STARTTIME,DE.ENDTIME)) END AS DAYDURATION,TM.TEAMNAME,IE.TOTALRUNS,IE.TOTALOVERS,IE.TOTALWICKETS,IE.INNINGSNO,IE.BATTINGTEAMCODE FROM   INNINGSEVENTS IE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=IE.BATTINGTEAMCODE LEFT JOIN DAYEVENTS DE ON DE.MATCHCODE=IE.MATCHCODE AND DE.BATTINGTEAMCODE=IE.BATTINGTEAMCODE AND DE.INNINGSNO=IE.INNINGSNO WHERE IE.MATCHCODE='%@' AND IE.INNINGSSTATUS='1' GROUP BY IE.INNINGSSTARTTIME, IE.INNINGSENDTIME,   TM.TEAMNAME, IE.TOTALRUNS,IE.TOTALOVERS,IE.TOTALWICKETS,IE.INNINGSNO,IE.BATTINGTEAMCODE) DETAILS ORDER BY INNINGSNO",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            {
                while(sqlite3_step(statement)==SQLITE_ROW){
                    EndInnings *record=[[EndInnings alloc]init];
                    record.STARTTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    record.ENDTIME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                    record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                    record.TOTALOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                    record.TOTALWICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                    record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                    record.BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                    record.DAYDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                    record.INNINGSDURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                    record.DURATION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                    [FetchEndInningsDetails addObject:record];
                }
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return FetchEndInningsDetails;
	}
}

-(NSString*)  GetMatchDateForFetchEndInnings:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    
    NSString *getWkt = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT MATCHDATE AS STARTDATE FROM   MATCHREGISTRATION WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@'",COMPETITIONCODE,MATCHCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                getWkt = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getWkt;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}

//-------------------------------------------------------------------------------------------------
-(NSMutableArray *)getBowlerOversorder :(NSString *) Competitioncode :(NSString *) Matchcode :(NSString *) inningsno
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray * BOWLEROVERSORDER =[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT group_concat(PLAYERNAME, ' + '),overno FROM (SELECT PM.PLAYERNAME,BE.OVERNO FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE = BE.BOWLERCODE WHERE BE.COMPETITIONCODE = '%@' AND BE.MATCHCODE = '%@' AND BE.INNINGSNO = '%@' GROUP BY PM.PLAYERNAME,BE.OVERNO)GROUP BY overno ORDER BY OVERNO;",Competitioncode,Matchcode,inningsno];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                OversorderRecord * objOversorderRecord=[[OversorderRecord alloc]init];
                //                objOversorderRecord.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                objOversorderRecord.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                objOversorderRecord.OversOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [BOWLEROVERSORDER addObject:objOversorderRecord];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
        
    }
    return BOWLEROVERSORDER;
	}
}



//get overStatus

-(NSString *)GETOVERSTATUS :(NSString *) Competitioncode :(NSString *) MatchCode :(NSString *) Teamcode :(NSString *)Inningsno :(NSString *) Overno
{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *databasePath =[self getDBPath];
    
    NSString *getoverStatus = [[NSString alloc]init];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT OVERSTATUS FROM OVEREVENTS WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO ='%@'",Competitioncode,MatchCode,Teamcode,Inningsno];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                getoverStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return getoverStatus;
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return getoverStatus;
   } 
}
-(NSMutableArray *)GETUMPIRE :(NSString *)Competitioncode :(NSString *) MatchCode
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *UMPIREDETAILS = [[NSMutableArray alloc]init];
    
    int retVal;
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT UMPIRE1CODE,UMPIRE2CODE,TEAMAWICKETKEEPER,TEAMBWICKETKEEPER FROM matchregistration WHERE  COMPETITIONCODE='%@' AND MATCHCODE='%@' ",Competitioncode,MatchCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSString *UMPIRE1CODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                NSString *UMPIRE2CODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *TeamAwicketKeeper = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString *TeamBwicketKeeper = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                
                [UMPIREDETAILS addObject:UMPIRE1CODE];
                [UMPIREDETAILS addObject:UMPIRE2CODE];
                [UMPIREDETAILS addObject:TeamAwicketKeeper];
                [UMPIREDETAILS addObject:TeamBwicketKeeper];
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return UMPIREDETAILS;
    }
}

//penality
-(NSMutableArray *)GetPenaltyReasonForPenalty:(NSString*)metadatasubcode{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *revisedtargetArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE AS PENALTYTYPECODE, METASUBCODEDESCRIPTION AS PENALTYTYPEDESCRIPTION FROM METADATA WHERE METADATATYPECODE = '%@'",metadatasubcode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                MetaDataRecord *record=[[MetaDataRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                record.metasubcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.metasubcodedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [revisedtargetArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return revisedtargetArray;
    }
}

//insert penaltydetails
-(BOOL) SetPenaltyDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) BALLCODE:(NSString*) PENALTYCODE:(NSString*) AWARDEDTOTEAMCODE:(NSString*) PENALTYRUNS:(NSString*) PENALTYTYPECODE:(NSString*) PENALTYREASONCODE{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO PENALTYDETAILS(COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE];
        
        //const char *insert_stmt = [SetPenaltyDetails UTF8String];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"PENALTYDETAILS" :@"MSC250" :updateSQL];
                
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
    
}

//penality pageload

-(NSMutableArray *) GetPenaltyDetailsForPageLoadPenalty:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *PenaltyDetailsArray=[[NSMutableArray alloc]init];
    //    NSString *databasePath = [self getDBPath];
    //    sqlite3_stmt *statement;
    //    sqlite3 *dataBase;
    //    const char *dbPath = [databasePath UTF8String];
    //    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    //    {
    //        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PD.COMPETITIONCODE,PD.MATCHCODE,PD.INNINGSNO,PD.BALLCODE,PD.PENALTYCODE,PD.AWARDEDTOTEAMCODE,PD.PENALTYRUNS,PD.PENALTYTYPECODE,MD.METASUBCODEDESCRIPTION AS PENALTYTYPEDESCRIPTION,PD.PENALTYREASONCODE,MDR.METASUBCODEDESCRIPTION AS PENALTYREASONDESCRIPTION FROM PENALTYDETAILS PD INNER JOIN METADATA MD ON PD.PENALTYTYPECODE = MD.METASUBCODE INNER JOIN METADATA MDR ON PD.PENALTYREASONCODE = MDR.METASUBCODE WHERE PD.COMPETITIONCODE = '%@' AND PD.MATCHCODE = '%@' AND PD.INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
    //
    //        const char *update_stmt = [updateSQL UTF8String];
    //        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
    //        {
    //            NSMutableArray * BOWLEROVERSORDER =[[NSMutableArray alloc]init];
    //            NSString *databasePath = [self getDBPath];
    //            sqlite3_stmt *statement;
    //            sqlite3 *dataBase;
    //            const char *dbPath = [databasePath UTF8String];
    //            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    //            {
    //                NSString *updateSQL = [NSString stringWithFormat:@"SELECT BE.BOWLERCODE,PM.PLAYERNAME,BE.OVERNO FROM BALLEVENTS BE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE = BE.BOWLERCODE WHERE BE.COMPETITIONCODE = '%@' AND BE.MATCHCODE = '%@' AND BE.INNINGSNO = '%@' GROUP BY BE.BOWLERCODE,PM.PLAYERNAME,BE.OVERNO ORDER BY BE.OVERNO",COMPETITIONCODE,MATCHCODE,INNINGSNO];
    //
    //                const char *update_stmt = [updateSQL UTF8String];
    //                if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
    //                {
    //                    while(sqlite3_step(statement)==SQLITE_ROW){
    //
    //                        OversorderRecord * objOversorderRecord=[[OversorderRecord alloc]init];
    //                        objOversorderRecord.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
    //                        objOversorderRecord.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
    //                        objOversorderRecord.OversOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
    //
    //                        [BOWLEROVERSORDER addObject:objOversorderRecord];
    //                    }
    //
    //                }
    //                sqlite3_close(dataBase);
    //
    //            }
    //            sqlite3_finalize(statement);
    //            sqlite3_close(dataBase);
    //            return BOWLEROVERSORDER;
    //        }
    //    }
    //    sqlite3_finalize(statement);
    //    sqlite3_close(dataBase);
    return PenaltyDetailsArray;
	}
}

-(NSMutableArray *) SetPenaltyDetailsForInsert:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *insertPenaltyDetailsArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PD.COMPETITIONCODE,PD.MATCHCODE,PD.INNINGSNO,PD.BALLCODE,PD.PENALTYCODE,PD.AWARDEDTOTEAMCODE,PD.PENALTYRUNS,PD.PENALTYTYPECODE,MD.METASUBCODEDESCRIPTION AS PENALTYTYPEDESCRIPTION,PD.PENALTYREASONCODE,MDR.METASUBCODEDESCRIPTION AS PENALTYREASONDESCRIPTION FROM PENALTYDETAILS PD INNER JOIN METADATA MD ON PD.PENALTYTYPECODE = MD.METASUBCODE INNER JOIN METADATA MDR ON PD.PENALTYREASONCODE = MDR.METASUBCODE WHERE PD.COMPETITIONCODE = '%@' AND PD.MATCHCODE = '%@' AND PD.INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                PenaltyDetailsRecord *record=[[PenaltyDetailsRecord alloc]init];
                record.competitioncode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchcode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                record.inningsno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                record.ballcode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.penaltycode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                record.awardedtoteamcode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                record.penaltyruns= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                record.penaltytypecode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                record.penaltytypedescription= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                record.penaltyreasoncode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
                
                record.penaltyreasondescription=[self getValueByNull:statement :10];
                
                [insertPenaltyDetailsArray addObject:record];
                
                
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return insertPenaltyDetailsArray;
	}
}


-(NSMutableArray *) GetPenaltyDetailsForUpdate:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) PENALTYCODE{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *UpdatePenaltyArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PD.COMPETITIONCODE,PD.MATCHCODE,PD.INNINGSNO,PD.BALLCODE,PD.PENALTYCODE,PD.AWARDEDTOTEAMCODE,PD.PENALTYRUNS,PD.PENALTYTYPECODE,MD.METASUBCODEDESCRIPTION AS PENALTYTYPEDESCRIPTION,PD.PENALTYREASONCODE,MDR.METASUBCODEDESCRIPTION AS PENALTYREASONDESCRIPTION FROM PENALTYDETAILS PD INNER JOIN METADATA MD ON PD.PENALTYTYPECODE = MD.METASUBCODE INNER JOIN METADATA MDR ON PD.PENALTYREASONCODE = MDR.METASUBCODE WHERE PD.COMPETITIONCODE = @COMPETITIONCODE AND PD.MATCHCODE = @MATCHCODE AND PD.INNINGSNO = @INNINGSNO AND PD.PENALTYCODE = @PENALTYCODE",COMPETITIONCODE,MATCHCODE,INNINGSNO,PENALTYCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                PenaltyDetailsRecord *record=[[PenaltyDetailsRecord alloc]init];
                record.competitioncode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchcode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                record.inningsno = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                record.ballcode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.penaltycode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                record.awardedtoteamcode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                record.penaltyruns= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                
                record.penaltytypecode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                record.penaltytypedescription= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                record.penaltyreasoncode= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
                
                record.penaltyreasondescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                [UpdatePenaltyArray addObject:record];
                
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return UpdatePenaltyArray;
	}
}


-(BOOL) GetUpdatePenaltyDetails:(NSString*) AWARDEDTOTEAMCODE:(NSNumber*) PENALTYRUNS:(NSString*) PENALTYTYPECODE :(NSString*) PENALTYREASONCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO:(NSString*) PENALTYCODE{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE PENALTYDETAILS SET AWARDEDTOTEAMCODE = '%@',PENALTYRUNS = '%@',PENALTYTYPECODE = '%@',PENALTYREASONCODE = '%@' WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND PENALTYCODE = '%@'",AWARDEDTOTEAMCODE,PENALTYRUNS,(PENALTYTYPECODE == nil || [PENALTYTYPECODE isEqualToString:@"(null)"]) ?@"":PENALTYTYPECODE,PENALTYREASONCODE,COMPETITIONCODE,MATCHCODE,INNINGSNO,PENALTYCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"PENALTYDETAILS" :@"MSC251" :updateSQL];
                
                
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
}


//powerplay
//insert powerplaydetails
-(BOOL) SetPowerPlayDetails:(NSString*) POWERPLAYCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO:(NSString*) STARTOVER:(NSString*) ENDOVER:(NSString*) POWERPLAYTYPE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO POWERPLAY(POWERPLAYCODE,MATCHCODE,INNINGSNO,STARTOVER,ENDOVER,POWERPLAYTYPE,RECORDSTATUS,CREATEDBY,CREATEDDATE,MODIFIEDBY,MODIFIEDDATE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@', current_timestamp,'%@', current_timestamp)",POWERPLAYCODE,MATCHCODE,INNINGSNO,STARTOVER,ENDOVER,POWERPLAYTYPE,RECORDSTATUS,CREATEDBY,MODIFIEDBY];
        
        //const char *insert_stmt = [SetPenaltyDetails UTF8String];
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"POWERPLAY" :@"MSC250" :updateSQL];
                
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
    
}

-(NSMutableArray *)fetchpowerplaytype{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *powerplayArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT POWERPLAYTYPECODE ,POWERPLAYTYPENAME,ISSYSTEMREFERENCE FROM POWERPLAYTYPE  WHERE RECORDSTATUS ='MSC001'"];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                PowerPlayRecord *record=[[PowerPlayRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                record.powerplaytypecode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.powerplaytypename=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.issystemreference=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                [powerplayArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return powerplayArray;
    }
}

-(NSMutableArray *)SetPowerPlayDetailsForInsert:(NSString *)MATCHCODE :(NSString *)INNINGSNO{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *powerplayArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT POWERPLAYCODE,STARTOVER,ENDOVER,(ENDOVER-STARTOVER)+1 TOTALOVER,POWERPLAYTYPENAME,POWERPLAYTYPE,PL.RECORDSTATUS,PL.CREATEDBY,PL.CREATEDDATE,PL.MODIFIEDBY,PL.MODIFIEDDATE  FROM POWERPLAY PL INNER JOIN POWERPLAYTYPE MD ON PL.POWERPLAYTYPE =MD.POWERPLAYTYPECODE WHERE MATCHCODE='%@' AND INNINGSNO='%@' AND PL.RECORDSTATUS='MSC001'",MATCHCODE,INNINGSNO];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                PowerPlayRecord *record=[[PowerPlayRecord alloc]init];
                
                record.powerplaycode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.startover=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.endover=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                record.totalovers=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.powerplaytypename=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.powerplaytype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.recordstatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.createdby=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.crateddate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.modifyby=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
                record.modifydate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                
                [powerplayArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return powerplayArray;
    }
}

-(BOOL) UpdatePowerPlay:(NSString*) INNINGSNO:(NSString*) STARTOVER:(NSString*) ENDOVER:(NSString*) MATCHDATE:(NSString*)POWERPLAYTYPE:(NSString*) RECORDSTATUS:(NSString*) MODIFIEDBY:(NSString*) POWERPLAYCODE:(NSString*) MATCHCODE{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE POWERPLAY SET INNINGSNO='%@',STARTOVER='%@',ENDOVER='%@',POWERPLAYTYPE='%@',RECORDSTATUS='%@',MODIFIEDBY='%@',MODIFIEDDATE= current_timestamp WHERE POWERPLAYCODE='%@' AND MATCHCODE='%@'",INNINGSNO,STARTOVER,ENDOVER,POWERPLAYTYPE,RECORDSTATUS,MODIFIEDBY,POWERPLAYCODE,MATCHCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK){
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"POWERPLAY" :@"MSC251" :updateSQL];
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
}

-(NSNumber *) SetMatchRegistration:(NSString*) MATCHCODE{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHOVERS FROM MATCHREGISTRATION WHERE MATCHCODE='%@' AND RECORDSTATUS = 'MSC001'",MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *MATCHOVERS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MATCHOVERS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}

-(NSNumber *) SetMatchRegistrationTarget:(NSString*)matchcode competitionCode:(NSString*) competitionCode{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHOVERS FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE='%@' ",competitionCode,matchcode];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *MATCHOVERS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return MATCHOVERS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
        
    }
    return @"";
	}
}


-(NSMutableArray *) getPlayedPlayersForPlayerXI:(NSString*)MATCHCODE COMPETITIOMCODE:(NSString*) COMPETITIOMCODE  OVERNO:(NSString*) OVERNO BALLNO:(NSString*) BALLNO{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *arrayResult = [[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME FROM(SELECT STRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' GROUP BY STRIKERCODE UNION ALL SELECT NONSTRIKERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' GROUP BY NONSTRIKERCODE UNION ALL SELECT BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' GROUP BY NONSTRIKERCODE UNION ALL SELECT  WICKETPLAYER AS STRIKERCODE FROM WICKETEVENTS WHERE MATCHCODE='%@' GROUP BY WICKETPLAYER) AS FIN INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=FIN.STRIKERCODE GROUP BY STRIKERCODE,PM.PLAYERNAME",COMPETITIOMCODE,MATCHCODE,COMPETITIOMCODE,MATCHCODE,COMPETITIOMCODE,MATCHCODE,MATCHCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                SelectPlayerRecord *selectedPlayerRec = [[SelectPlayerRecord alloc]init];
                selectedPlayerRec.playerCode =  [self getValueByNull:statement :0];
                selectedPlayerRec.playerName =  [self getValueByNull:statement :1];
                [arrayResult addObject:selectedPlayerRec];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
        
    }
    return arrayResult;
	}
}


//MAXID POWERPLAY
-(NSString *) getMAXIDPOWERPLAY{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT (IFNULL(MAX(SUBSTR(POWERPLAYCODE,4,10)),0)+1)MAXID  FROM POWERPLAY"];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *maxid=[self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return maxid;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    return @"0";
	}
}





-(NSMutableArray *)ArchivesFixturesData:(NSString*)competitionCode:(NSString*)userCode {
@synchronized ([Utitliy syncId]) {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        //
        NSString *query=[NSString stringWithFormat:@"SELECT MR.MATCHCODE,MR.MATCHNAME,MR.COMPETITIONCODE,MR.MATCHOVERCOMMENTS,MR.MATCHDATE,MR.GROUNDCODE,GM.GROUNDNAME,GM.CITY,MR.TEAMACODE,MR.TEAMBCODE ,TM.SHORTTEAMNAME AS TEAMANAME,TM1.SHORTTEAMNAME AS TEAMBNAME,MR.MATCHOVERS,MD.METASUBCODEDESCRIPTION AS MATCHTYPENAME, CP.MATCHTYPE AS MATCHTYPECODE, MR.MATCHSTATUS, (SELECT CASE WHEN COUNT(INNINGSSTATUS) > 0 THEN 0 ELSE 1 END FROM INNINGSEVENTS WHERE COMPETITIONCODE = MR.COMPETITIONCODE AND MATCHCODE = MR.MATCHCODE AND (INNINGSSTATUS = 0 OR (INNINGSNO = 2 AND MATCHTYPE NOT IN ('MSC023','MSC114')) OR (INNINGSNO = 4 AND MATCHTYPE IN ('MSC023','MSC114')))) AS INNINGSSTATUS FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MR.TEAMACODE INNER JOIN TEAMMASTER TM1 ON TM1.TEAMCODE = MR.TEAMBCODE INNER JOIN GROUNDMASTER GM ON GM.GROUNDCODE = MR.GROUNDCODE INNER JOIN COMPETITION CP ON CP.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN METADATA MD ON CP.MATCHTYPE = MD.METASUBCODE INNER JOIN  MATCHSCORERDETAILS MSD ON CP.COMPETITIONCODE = MSD.COMPETITIONCODE AND MSD.SCORERCODE = '%@' AND MSD.MATCHCODE = MR.MATCHCODE WHERE MR.COMPETITIONCODE='%@'AND MR.MATCHSTATUS not in ('MSC123','MSC281') GROUP BY MSD.MATCHCODE ORDER BY MATCHDATE ASC" ,userCode,competitionCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FixturesRecord *record=[[FixturesRecord alloc]init];
                //            record.id=(int)sqlite3_column_int(statement, 0);
                
                record.matchcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.competitioncode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                //        const  char mcod = *sqlite3_column_text(statement, 3);
                NSString* mCode=[NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, 3)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 3)]];
                // mCode = [mCode isEqual:@"(null)"]?@"":mCode;
                record.matchovercomments=mCode;
                record.matchdate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.groundcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.groundname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.city=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.teamAcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.teamBcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.teamAname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.teamBname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.overs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.matchTypeName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.matchTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.MatchStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.InningsStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    
    return eventArray;
    }
}

//MAXID POWERPLAY
-(NSString *) getMAXIDPENALTY{
@synchronized ([Utitliy syncId]) {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT (IFNULL(MAX(SUBSTR(PENALTYCODE,4,10)),0)+1)MAXID  FROM PENALTYDETAILS"];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *maxid=[self getValueByNull:statement :0];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return maxid;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(dataBase);
    }
    
    return @"0";
	}
}


-(BOOL)checkpowerplay: (NSString *) STARTOVER ENDOVER:(NSString*) ENDOVER MATCHCODE:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO{
   @synchronized ([Utitliy syncId]) {
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT POWERPLAYCODE FROM POWERPLAY WHERE (('%@'<= STARTOVER AND '%@' >= STARTOVER) OR ('%@'<= ENDOVER AND '%@'>= ENDOVER) OR ('%@'>=STARTOVER AND '%@'<= ENDOVER))AND  MATCHCODE='%@' AND INNINGSNO='%@'  AND RECORDSTATUS='MSC001' ",STARTOVER,ENDOVER,STARTOVER,ENDOVER,STARTOVER,ENDOVER,MATCHCODE,INNINGSNO];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

-(BOOL)getpowerplaytype:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO POWERPLAYTYPE:(NSString*) POWERPLAYTYPE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT POWERPLAYTYPE FROM POWERPLAY  WHERE MATCHCODE='%@' AND INNINGSNO='%@' AND POWERPLAYTYPE='%@' AND RECORDSTATUS ='MSC001'",MATCHCODE,INNINGSNO,POWERPLAYTYPE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
	}
}

//-(NSMutableArray *)getpowerplaytype:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO POWERPLAYTYPE:(NSString*) POWERPLAYTYPE{
//    NSMutableArray *powerplayArray=[[NSMutableArray alloc]init];
//    int retVal;
//    NSString *dbPath = [self getDBPath];
//    sqlite3 *dataBase;
//    const char *stmt;
//    sqlite3_stmt *statement;
//    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
//    if(retVal !=0){
//    }
//
//    NSString *query=[NSString stringWithFormat:@"SELECT POWERPLAYTYPE FROM POWERPLAY  WHERE MATCHODE='%@' AND INNINGSNO='%@' AND POWERPLAYTYPE='%@ AND'RECORDSTATUS ='MSC001'",MATCHCODE,INNINGSNO,POWERPLAYTYPE];
//    stmt=[query UTF8String];
//    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//    {
//        while(sqlite3_step(statement)==SQLITE_ROW){
//            PowerPlayRecord *record=[[PowerPlayRecord alloc]init];
//            //            record.id=(int)sqlite3_column_int(statement, 0);
//            record.powerplaytype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            [powerplayArray addObject:record];
//
//        }
//    }
//
//
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return powerplayArray;
//
//}
-(BOOL)checkpowerplayforupdate: (NSString *) STARTOVER ENDOVER:(NSString*) ENDOVER MATCHCODE:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO POWERPLAYCODE:(NSString*) POWERPLAYCODE{
@synchronized ([Utitliy syncId]) {
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString * query=[NSString stringWithFormat:@"SELECT * FROM POWERPLAY WHERE (('%@'<= STARTOVER AND '%@' >= STARTOVER) OR ('%@'<= ENDOVER AND '%@'>= ENDOVER) OR ('%@'>=STARTOVER AND '%@'<= ENDOVER))AND  MATCHCODE='%@' AND INNINGSNO='%@'AND POWERPLAYCODE<>'%@'  AND RECORDSTATUS='MSC001' ",STARTOVER,ENDOVER,STARTOVER,ENDOVER,STARTOVER,ENDOVER,MATCHCODE,INNINGSNO,POWERPLAYCODE];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return YES;
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return NO;
	}
}
-(NSMutableArray *)getpowerplaytypeforupdate:(NSString*) MATCHCODE INNINGSNO:(NSString*) INNINGSNO POWERPLAYTYPE:(NSString*) POWERPLAYTYPE POWERPLAYCODE:(NSString*) POWERPLAYCODE{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *powerplayArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT POWERPLAYTYPE FROM POWERPLAY  WHERE MATCHCODE='%@' AND INNINGSNO='%@' AND POWERPLAYTYPE='%@' AND POWERPLAYCODE<>'%@' AND RECORDSTATUS ='MSC001'",MATCHCODE,INNINGSNO,POWERPLAYTYPE,POWERPLAYCODE];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                PowerPlayRecord *record=[[PowerPlayRecord alloc]init];
                record.powerplaytype=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                [powerplayArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
    }
    return powerplayArray;
    }
}



@end
