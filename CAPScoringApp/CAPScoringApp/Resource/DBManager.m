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

@implementation DBManager

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




+(NSMutableArray *)RetrieveEventData{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"select * FROM COMPETITION"];
    stmt=[query UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            EventRecord *record=[[EventRecord alloc]init];
            //            record.id=(int)sqlite3_column_int(statement, 0);
            record.competitioncode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            record.competitionname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            record.recordstatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
            [eventArray addObject:record];
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
}




+(BOOL)checkExpiryDate: (NSString *) userId{
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT  *  FROM Userdetails WHERE  strftime('%%Y-%%m-%%d-', EXPIRYDATE) >= CURRENT_DATE AND USERCODE = '%@'",userId];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);

                return YES;
                
            }
        }
       
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return NO;
}

+(NSMutableArray *)checkUserLogin: (NSString *) userName password: (NSString *) password{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT  USERCODE,USERNAME  FROM Userdetails WHERE  USERNAME = '%@' AND PASSWORD = '%@' AND RECORDSTATUS = 'MSC001'",userName,password];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                UserRecord *record=[[UserRecord alloc]init];
                record.userCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.userName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [eventArray addObject:record];
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return eventArray;
}





+(NSMutableArray *)checkTossDetailsWonby: (NSString *) MATCHCODE{
    NSMutableArray *TOSSWonArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT MR.TEAMACODE AS TEAMCODE,TMA.TEAMNAME AS TEAMNAME FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TMA ON TMA.TEAMCODE = MR.TEAMACODE WHERE MR.MATCHCODE = '%@' UNION SELECT MR.TEAMBCODE AS TEAMCODE,TMB.TEAMNAME AS TEAMNAME  FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TMB ON TMB.TEAMCODE = MR.TEAMBCODE WHERE MR.MATCHCODE = '%@'", MATCHCODE,MATCHCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                EventRecord *record=[[EventRecord alloc]init];
                //need to edit
                record.TEAMCODE_TOSSWONBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMNAME_TOSSWONBY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [TOSSWonArray addObject:record];
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return TOSSWonArray;
}




+(NSMutableArray *)Electedto{
    NSMutableArray *electedeventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
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
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return electedeventArray;
    
}




+(NSMutableArray *)StrikerNonstriker: (NSString *) MATCHCODE :(NSString *) TeamCODE{
    NSMutableArray *SrikerEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME   FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE WHERE MTP.MATCHCODE='%@'  AND MTP.TEAMCODE='%@'", MATCHCODE,TeamCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                TossDeatilsEvent *record=[[TossDeatilsEvent alloc]init];
                //need to edit
                record.PlaercodeStrike_nonStrike=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.PlaerNameStrike_nonStrike=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                //TEAMCODE_TOSSWONBY
                [SrikerEventArray addObject:record];
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return SrikerEventArray;
}




+(NSMutableArray *)Bowler: (NSString *) MATCHCODE :(NSString *) TeamCODE{
    NSMutableArray *BowlerEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        //(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE INNER JOIN MATCHREGISTRATION MR ON MR.MATCHCODE=MTP.MATCHCODE WHERE MTP.MATCHCODE='%@'  AND MTP.TEAMCODE='%@'", MATCHCODE,TeamCODE];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BowlerEvent *record=[[BowlerEvent alloc]init];
                //need to edit
                record.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                //TEAMCODE_TOSSWONBY
                [BowlerEventArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return BowlerEventArray;
}




// fixtures

+(NSMutableArray *)RetrieveFixturesData:(NSString*)competitionCode {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    //
    NSString *query=[NSString stringWithFormat:@"SELECT MR.MATCHCODE,MR.MATCHNAME,MR.COMPETITIONCODE,MR.MATCHOVERCOMMENTS,MR.MATCHDATE,MR.GROUNDCODE,GM.GROUNDNAME,GM.CITY,MR.TEAMACODE,MR.TEAMBCODE ,TM.SHORTTEAMNAME AS TEAMANAME,TM1.SHORTTEAMNAME AS TEAMBNAME,MR.MATCHOVERS,MD.METASUBCODEDESCRIPTION AS MATCHTYPENAME, CP.MATCHTYPE AS MATCHTYPECODE, MR.MATCHSTATUS FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MR.TEAMACODE INNER JOIN TEAMMASTER TM1 ON TM1.TEAMCODE = MR.TEAMBCODE INNER JOIN GROUNDMASTER GM ON GM.GROUNDCODE = MR.GROUNDCODE INNER JOIN COMPETITION CP ON CP.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN METADATA MD ON CP.MATCHTYPE = MD.METASUBCODE WHERE MR.COMPETITIONCODE='%@'" ,competitionCode];
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
            record.teamBcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
            record.teamAcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            record.teamAname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
            record.teamBname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
            record.overs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
            record.matchTypeName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
            record.matchTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
            record.MatchStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
            
            [eventArray addObject:record];
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
}

//Update match overs in match registration
+(BOOL)updateOverInfo:(NSString*)overs matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode  {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update MATCHREGISTRATION Set MATCHOVERS = '%@',MODIFIEDDATE = CURRENT_TIMESTAMP WHERE MATCHCODE='%@' AND COMPETITIONCODE='%@'",overs,matchCode,competitionCode];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
    
}




+(BOOL)updateFixtureInfo:(NSString*)comments matchCode:(NSString*) matchCode competitionCode:(NSString*)competitionCode  {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    
    
    
    
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"update MATCHREGISTRATION Set MATCHOVERCOMMENTS = '%@' WHERE MATCHCODE='%@' AND COMPETITIONCODE='%@'",comments,matchCode,competitionCode];
        const char *insert_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
    
    
    
}



+(NSMutableArray *)RetrieveOfficalMasterData:(NSString*) matchCode competitionCode:(NSString*)competitionCode{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    //    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"SELECT MR.UMPIRE1CODE ,OM.NAME AS  UMPIRE1NAME, MR.UMPIRE2CODE,OM1.NAME AS UMPIRE2NAME,MR.UMPIRE3CODE,OM2.NAME AS UMPIRE3NAME,MR.MATCHREFEREECODE ,OM3.NAME AS MATCHREFEREENAME FROM MATCHREGISTRATION MR INNER JOIN OFFICIALSMASTER OM ON MR.UMPIRE1CODE= OM.OFFICIALSCODE INNER JOIN OFFICIALSMASTER OM1 ON MR.UMPIRE2CODE= OM1.OFFICIALSCODE INNER JOIN OFFICIALSMASTER OM2 ON MR.UMPIRE3CODE= OM2.OFFICIALSCODE INNER JOIN OFFICIALSMASTER OM3 ON MR.MATCHREFEREECODE= OM3.OFFICIALSCODE MATCHCODE='%@' AND COMPETITIONCODE='%@'",matchCode,competitionCode];
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
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
}



//select count team A and B players
+(NSMutableArray *)SelectTeamPlayers:(NSString*) matchCode teamCode:(NSString*)teamCode  {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
   // NSString *count = [[NSString alloc]init];
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT COUNT(*) AS COUNT FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND TEAMCODE = '%@' AND RECORDSTATUS = 'MSC001'",matchCode,teamCode];
    stmt=[selectPlayersSQL UTF8String];
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            FixturesRecord *record=[[FixturesRecord alloc]init];
            record.count=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
           [eventArray addObject:record];
            
        }
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
}

//Fetch active players based on team code
+(NSMutableArray *)getSelectingPlayerArray: (NSString *) teamCode matchCode:(NSString *) matchCode{
    NSMutableArray *selectPlayerArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    //NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME,MTPD.RECORDSTATUS,MTPD.PLAYINGORDER  FROM PLAYERTEAMDETAILS AS PTD INNER JOIN PLAYERMASTER AS PM ON PTD.PLAYERCODE = PM.PLAYERCODE INNER JOIN MATCHTEAMPLAYERDETAILS MTPD ON MTPD.PLAYERCODE = PTD.PLAYERCODE  WHERE PM.RECORDSTATUS = 'MSC001' AND PTD.RECORDSTATUS = 'MSC001'  AND PTD.TEAMCODE = '%@' AND MTPD.MATCHCODE = '%@'  ORDER BY MTPD.RECORDSTATUS",teamCode,matchCode];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                SelectPlayerRecord *record=[[SelectPlayerRecord alloc]init];
                record.playerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                NSString *recordStatus=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.playerOrder=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                
                //Set selected based on record status
                record.isSelected = [NSNumber numberWithInteger:[recordStatus isEqual:@"MSC001"]?1:0];
                
                [selectPlayerArray addObject:record];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return selectPlayerArray;
}

//Update selected player record status
+(BOOL)updateSelectedPlayersResultCode:(NSString*)playerCode matchCode:(NSString*) matchCode recordStatus:(NSString*)recordStatus  {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHTEAMPLAYERDETAILS SET RECORDSTATUS = '%@' WHERE PLAYERCODE='%@' AND MATCHCODE='%@'",recordStatus,playerCode,matchCode];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
}


+ (BOOL) saveBallEventData:(BallEventRecord *) ballEventData
{
    
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *mySqliteDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO BALLEVENTS(BALLCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,DAYNO,INNINGSNO,OVERNO,BALLNO,BALLCOUNT,OVERBALLCOUNT,SESSIONNO,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE,UMPIRE2CODE,ATWOROTW,BOWLINGEND,BOWLTYPE,SHOTTYPE,ISLEGALBALL,ISFOUR,ISSIX,RUNS,OVERTHROW,TOTALRUNS,WIDE,NOBALL,BYES,LEGBYES,PENALTY,TOTALEXTRAS,GRANDTOTAL,RBW,PMLINECODE,PMLENGTHCODE,PMX1,PMY1,PMX2,PMY3,WWREGION,WWX1,WWY1,WWX2,WWY2,BALLDURATION,ISAPPEAL,ISBEATEN,ISUNCOMFORT,ISWTB,ISRELEASESHOT,MARKEDFOREDIT,REMARKS,VIDEOFILENAME,SHOTTYPECATEGORY,PMSTRIKEPOINT,PMSTRIKEPOINTLINECODE,BALLSPEED,UNCOMFORTCLASSIFCATION) VALUES (\"%@\",\"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"0\",\"1\",\"1\",\"1\",\" %@\",\"PYC0000007\",\"PYC0000008\",\"PYC0000027\",\"PYC0000146\",\"OFC0000001\",\"OFC0000002\",\"%@\",\"BWT0000009\",\"%@\",\"%@\",\"1\",\"0\",\"1\",\"4\",\"5\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"5\",\"0\",\"MSC031\",\"MSC032\",\"%@\",\"%@\",\"%@\",\"%@\",1,\"MSC197\",\"157\",\"125\",\"107\",1,1,1,1,1,1,1,1,1,1,1,2,2,2,2)",ballEventData.objBallcode,ballEventData.objcompetitioncode,ballEventData.objmatchcode,ballEventData.objTeamcode,ballEventData.objDayno,ballEventData.objInningsno,ballEventData.objSessionno,ballEventData.objAtworotw,ballEventData.objBowltype,ballEventData.objShottype,ballEventData.objPMX1,ballEventData.objPMY1,ballEventData.objPMX2,ballEventData.objPMY2];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
    
    
}

+ (BOOL) insertBallCodeAppealEvent:(BallEventRecord *) ballEvent
{
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *mySqliteDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO APPEALEVENTS(BALLCODE,APPEALTYPECODE,APPEALSYSTEMCODE,APPEALCOMPONENTCODE,UMPIRECODE,BATSMANCODE,ISREFERRED,APPEALDECISION,APPEALCOMMENTS,FIELDERCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO) VALUES (\"%@\",\"MSC104\",\"MSC218\",\"MSC219\",\"OFC0000001\",\"PYC0000359\",\"MSC118\",\"MSC236\",\"PYC0000148\",\"UCC0000004\",\"%@\",\"%@\",\"%@\",\"%@\")",ballEvent.objBallcode,ballEvent.objcompetitioncode,ballEvent.objmatchcode,ballEvent.objTeamcode,ballEvent.objInningsno];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
    
}

+ (BOOL) insertBallCodeFieldEvent :(BallEventRecord *) ballEvent bowlerEvent:(BowlerEvent *)bowlerEvent fieldingFactor:(FieldingFactorRecord *) fieldingFactor nrs:(NSString *) nrs;



{
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *mySqliteDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO FIELDINGEVENTS(BALLCODE,FIELDERCODE,ISSUBSTITUTE,FIELDINGFACTORCODE,NRS,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO) VALUES (\"%@\",\"%@\",\"MSC218\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",ballEvent.objBallcode,bowlerEvent.BowlerCode,fieldingFactor.fieldingfactorcode,nrs,ballEvent.objcompetitioncode,ballEvent.objmatchcode,ballEvent.objTeamcode,ballEvent.objInningsno];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
    
}

+ (BOOL) insertBallCodeWicketEvent :(BallEventRecord *) ballEvent
{
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *mySqliteDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO WICKETEVENTS(BALLCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,ISWICKET,WICKETNO,WICKETTYPE,WICKETPLAYER,FIELDINGPLAYER,VIDEOLOCATION,WICKETEVENT) VALUES (\"%@\",\"%@\",\"%@\",\"MSC219\",\"OFC0000001\",\"PYC0000359\",\"MSC118\",\"MSC236\",\"PYC0000148\",\"\",\"\",\"\")",ballEvent.objBallcode,ballEvent.objcompetitioncode,ballEvent.objmatchcode];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
    
    
}


+ (NSMutableArray *) getballcodemethod
{
    
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
        NSString *sqlStatement_userInfo =[NSString stringWithFormat:@"Select BALLCODE from BALLEVENTS"];
        sqlite3_stmt *compiledStatement;
        if(sqlite3_prepare_v2(database2, [sqlStatement_userInfo UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK)
        {
            // Loop through the results and add them to the feeds array
            while(sqlite3_step(compiledStatement) == SQLITE_ROW)
            {
                
                NSString *recordParentID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
                
                [ModiArray addObject:recordParentID];
            }
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database2);
    
    return ModiArray;
    
}

+ (NSMutableArray *) getTeamCodemethod
{
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
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database2);
    
    return ModiArray;
    
}

+ (NSMutableArray *) getInningsNomethod
{
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
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database2);
    
    return ModiArray;
}
+ (NSMutableArray *) getDayNomethod
{
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
        }
        else
        {
            NSLog(@"No Data Found");
        }
        // Release the compiled statement from memory
        sqlite3_finalize(compiledStatement);
    }
    sqlite3_close(database2);
    
    return ModiArray;
    
}


//  Appeal Database

+(NSMutableArray *)AppealRetrieveEventData{
    NSMutableArray *AppealeventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
  //  const char *dbpath = [databasePath UTF8String];

    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
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
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return AppealeventArray;
    
}

+(NSMutableArray *)getOtwRtw{
    NSMutableArray *OtwRtwArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
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
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return OtwRtwArray;
    
}

//Bowl Type for Spin
+(NSMutableArray *)getBowlType {
    NSMutableArray *bowlTypeArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT BOWLTYPECODE,BOWLTYPE FROM BOWLTYPE WHERE BOWLERTYPE = 'MSC016' AND RECORDSTATUS = 'MSC001'"];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BowlAndShotTypeRecords *bowlTypeRecord = [[BowlAndShotTypeRecords alloc]init];
                bowlTypeRecord.BowlTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                bowlTypeRecord.BowlType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [bowlTypeArray addObject:bowlTypeRecord];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return bowlTypeArray;
}


//Bowl Type for Fast
+(NSMutableArray *)getBowlFastType {
    NSMutableArray *fastBowlTypeArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT BOWLTYPECODE,BOWLTYPE FROM BOWLTYPE WHERE BOWLERTYPE = 'MSC015' AND RECORDSTATUS = 'MSC001'"];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BowlAndShotTypeRecords *bowlTypeRecord = [[BowlAndShotTypeRecords alloc]init];
                bowlTypeRecord.BowlTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                bowlTypeRecord.BowlType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [fastBowlTypeArray addObject:bowlTypeRecord];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return fastBowlTypeArray;
}

//Aggressive Shot Type
+(NSMutableArray *)getAggressiveShotType {
    NSMutableArray *aggressiveShotType=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT SHOTCODE,SHOTNAME FROM SHOTTYPE WHERE SHOTTYPE = 'MSC005' AND RECORDSTATUS = 'MSC001'"];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BowlAndShotTypeRecords *shotTypeRecord = [[BowlAndShotTypeRecords alloc]init];
                shotTypeRecord.ShotTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                shotTypeRecord.ShotType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [aggressiveShotType addObject:shotTypeRecord];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return aggressiveShotType;
}


//Defence Shot Type
+(NSMutableArray *)getDefenceShotType {
    NSMutableArray *defenceShotType=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT SHOTCODE,SHOTNAME FROM SHOTTYPE WHERE SHOTTYPE = 'MSC006' AND RECORDSTATUS = 'MSC001'"];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BowlAndShotTypeRecords *shotTypeRecord = [[BowlAndShotTypeRecords alloc]init];
                shotTypeRecord.ShotTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                shotTypeRecord.ShotType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                [defenceShotType addObject:shotTypeRecord];
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return defenceShotType;
}

//Retrieve FieldingFactor
+(NSMutableArray *)RetrieveFieldingFactorData{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query=[NSString stringWithFormat:@"select * FROM FIELDINGFACTOR"];
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
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    
}

////Retrieve FieldingFactor
//+(NSMutableArray *)RetrieveFieldingFactorData{
//    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
//    int retVal;
//    NSString *dbPath = [self getDBPath];
//    sqlite3 *dataBase;
//    const char *stmt;
//    sqlite3_stmt *statement;
//    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
//    if(retVal ==0){
//        
//        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE INNER JOIN MATCHREGISTRATION MR ON MR.MATCHCODE=MTP.MATCHCODE WHERE MTP.MATCHCODE='IMSC0221C6F6595E95A00001'AND MTP.TEAMCODE=(CASE WHEN MR.TEAMACODE='TEA0000006' THEN MR.TEAMBCODE=''ELSE MR.TEAMACODE END)"];
//        NSLog(@"%@",query);
//        stmt=[query UTF8String];
//        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                NSLog(@"Success");
//                
//                BowlerEvent *record=[[BowlerEvent alloc]init];
//                //need to edit
//                record.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                
//                //TEAMCODE_TOSSWONBY
//                [BowlerEventArray addObject:record];
//                
//                
//                
//            }
//        }
//        sqlite3_finalize(statement);
//        sqlite3_close(dataBase);
//    }
//    return BowlerEventArray;
//}

+(NSMutableArray *)RetrieveFieldingPlayerData{
    NSMutableArray *BowlerEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE INNER JOIN MATCHREGISTRATION MR ON MR.MATCHCODE=MTP.MATCHCODE WHERE MTP.MATCHCODE='IMSC0221C6F6595E95A00001'AND MTP.TEAMCODE=(CASE WHEN MR.TEAMACODE='TEA0000006' THEN MR.TEAMBCODE=''ELSE MR.TEAMACODE END)"];
        NSLog(@"%@",query);
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSLog(@"Success");
                
                BowlerEvent *record=[[BowlerEvent alloc]init];
                //need to edit
                record.BowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                //TEAMCODE_TOSSWONBY
                [BowlerEventArray addObject:record];
                
                
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return BowlerEventArray;
}


//proceed save action




+(NSString *) TossSaveDetails:(NSString*) MATCHCODE:(NSString*)COMPETITIONCODE{
   // NSMutableArray *TossArray=[[NSMutableArray alloc]init];
    NSString *count = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
  NSString *query = [NSString stringWithFormat:@"SELECT count(*) FROM MATCHEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE ='%@'",COMPETITIONCODE,MATCHCODE];
    stmt=[query UTF8String];
    
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
           // MatcheventRecord *matchrecord=[[MatcheventRecord alloc]init];
            
            count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
           
            
            //[TossArray addObject:matchrecord];
            
        }
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return count;
    
}

+ (BOOL) insertMatchEvent :(NSString*) COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)selectTeamcode :(NSString*)electedcode:(NSString*)teamCode:(NSString*)teambCode;
{
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *mySqliteDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO  MATCHEVENTS (COMPETITIONCODE,MATCHCODE,TOSSWONTEAMCODE,ELECTEDTO,BATTINGTEAMCODE,BOWLINGTEAMCODE,BOWLCOMPUTESHOW)  VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'1')",COMPETITIONCODE,MATCHCODE,selectTeamcode,electedcode,teamCode,teambCode];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        
         NSLog(@"%s", sqlite3_errmsg(mySqliteDB));
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
    
    
    
}



+(NSString *) getMaxInningsNumber : (NSString*) MATCHCODE : (NSString*)COMPETITIONCODE{
    // NSMutableArray *TossArray=[[NSMutableArray alloc]init];
    NSString *maxInnNo = [[NSString alloc]init];
    int retVal;
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *query = [NSString stringWithFormat:@"SELECT  IFNULL(MAX(INNINGSNO),0)+1 from INNINGSEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE ='%@'",COMPETITIONCODE,MATCHCODE];
    stmt=[query UTF8String];
    
    if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            // MatcheventRecord *matchrecord=[[MatcheventRecord alloc]init];
            
            maxInnNo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            
            //[TossArray addObject:matchrecord];
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return maxInnNo;
    
}




+ (BOOL) inserMaxInningsEvent : (NSString*) CompetitionCode :(NSString*) MATCHCODE :(NSString*) teamaCode :(NSString*) maxInnNo :(NSString*) StrikerCode :(NSString*) NonStrikerCode :(NSString*) selectBowlerCode :(NSString*) StrikerCode : (NSString*) NonStrikerCode : (NSString*)selectBowlerCode : (NSString*) teamaCode :(NSString*) inningsStatus : (NSString*)BowlingEnd
{
    BOOL success = false;
    NSString *databasePath =[self getDBPath];
    sqlite3 *mySqliteDB;
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &mySqliteDB) == SQLITE_OK)
    {
        
        NSString *insertBallevent = [NSString stringWithFormat:@"INSERT INTO  INNINGSEVENTS (COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,CURRENTSTRIKERCODE,CURRENTNONSTRIKERCODE,CURRENTBOWLERCODE,BATTINGTEAMCODE,INNINGSSTATUS,BOWLINGEND)  VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",'%@','%@')",CompetitionCode,MATCHCODE ,teamaCode,maxInnNo ,StrikerCode,NonStrikerCode ,selectBowlerCode,StrikerCode ,NonStrikerCode ,selectBowlerCode,teamaCode,inningsStatus,BowlingEnd];
        
        const char *insert_stmt = [insertBallevent UTF8String];
        sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        
        NSLog(@"%s", sqlite3_errmsg(mySqliteDB));
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
    
    
    
}

+(BOOL)updateProcced:(NSString*)CompetitionCode:(NSString*)MATCHCODE  {
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHSTATUS = (CASE WHEN MATCHSTATUS = 'MSC123' THEN 'MSC240' ELSE MATCHSTATUS END) WHERE COMPETITIONCODE ='%@' AND MATCHCODE ='%@';",CompetitionCode,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    sqlite3_reset(statement);
    return NO;
    
}



//Appeal


+(NSMutableArray *)AppealSystemRetrieveEventData{
    NSMutableArray *AppealSyetemeventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
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
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return AppealSyetemeventArray;
    
}




+(NSMutableArray *)AppealComponentRetrieveEventData{
    NSMutableArray *AppealComponenteventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
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
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return AppealComponenteventArray;
    
}



+(NSMutableArray *) AppealUmpireRetrieveEventData:(NSString*) COMPETITIONCODE:(NSString*)MATCHCODE{
    NSMutableArray *AppealUmpireEventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *databasePath =[self getDBPath];
    //  const char *dbpath = [databasePath UTF8String];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
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
    }
    
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return AppealUmpireEventArray;
    
}
+(BOOL)updatePlayerorder:(NSString *) matchCode :(NSString *) teamcode PlayerCode:(NSString *)playerCode PlayerOrder:(NSString *)playerorder
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
          
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHTEAMPLAYERDETAILS SET PLAYINGORDER='%@' WHERE TEAMCODE=  '%@' AND MATCHCODE ='%@' AND PLAYERCODE='%@'",playerorder,teamcode,matchCode,playerCode];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
       
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
        }
    
    sqlite3_reset(statement);
    return NO;

}

+(BOOL)updateCapitainWicketkeeper:(NSString *) compatitioncode :(NSString *) matchCode capitainAteam:(NSString *)capitainAteam capitainBteam:(NSString *)capitainBteam wicketkeeperAteam:(NSString *)wicketkeeperAteam  wicketkeeperBteam:(NSString *)wicketkeeperBteam
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET TEAMACAPTAIN='%@' ,TEAMBCAPTAIN='%@',TEAMAWICKETKEEPER='%@',TEAMBWICKETKEEPER='%@' WHERE COMPETITIONCODE=  '%@' AND MATCHCODE ='%@'",capitainAteam,capitainBteam,wicketkeeperAteam,wicketkeeperBteam,compatitioncode,matchCode];
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            
            return YES;
            
        }
        else {
            sqlite3_reset(statement);
            
            return NO;
        }
    }
    
    sqlite3_reset(statement);
    return NO;
}
+(NSMutableArray *)getTeamCaptainandTeamwicketkeeper:(NSString*) competitioncode :(NSString*) matchcode
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    // NSString *count = [[NSString alloc]init];
    
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
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
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
    

}

+(NSMutableArray *)GetBallDetails: (NSString*) competitioncode : (NSString*) matchcode
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;

    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
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
    }
    
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return eventArray;
}

@end
