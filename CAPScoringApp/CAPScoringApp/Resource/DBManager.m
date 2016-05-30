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
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
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
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
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
                
                return YES;
                
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    return NO;
}

+(NSMutableArray *)checkUserLogin: (NSString *) userName password: (NSString *) password{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    int retVal;
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
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
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
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
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
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
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
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
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"TNCA_DATABASE.sqlite"];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([dbPath UTF8String], &dataBase);
    if(retVal ==0){
        
        NSString *query=[NSString stringWithFormat:@"SELECT MTP.PLAYERCODE ,PM.PLAYERNAME FROM MATCHTEAMPLAYERDETAILS  MTP INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=MTP.PLAYERCODE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=MTP.TEAMCODE INNER JOIN MATCHREGISTRATION MR ON MR.MATCHCODE=MTP.MATCHCODE WHERE MTP.MATCHCODE='%@'  AND MTP.TEAMCODE=(CASE WHEN MR.TEAMACODE='%@' THEN MR.TEAMBCODE ELSE MR.TEAMACODE END)", MATCHCODE,TeamCODE];
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
    NSString *query=[NSString stringWithFormat:@"SELECT MR.MATCHCODE,MR.MATCHNAME,MR.COMPETITIONCODE,MR.MATCHOVERCOMMENTS,MR.MATCHDATE,MR.GROUNDCODE,GM.GROUNDNAME,GM.CITY,MR.TEAMACODE,MR.TEAMBCODE ,TM.SHORTTEAMNAME AS TEAMANAME,TM1.SHORTTEAMNAME AS TEAMBNAME,MR.MATCHOVERS,MD.METASUBCODEDESCRIPTION AS MATCHTYPENAME, CP.MATCHTYPE AS MATCHTYPECODE FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MR.TEAMACODE INNER JOIN TEAMMASTER TM1 ON TM1.TEAMCODE = MR.TEAMBCODE INNER JOIN GROUNDMASTER GM ON GM.GROUNDCODE = MR.GROUNDCODE INNER JOIN COMPETITION CP ON CP.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN METADATA MD ON CP.MATCHTYPE = MD.METASUBCODE WHERE MR.COMPETITIONCODE='%@'" ,competitionCode];
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



+(NSMutableArray *)RetrieveOfficalMasterData{
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
    
    NSString *query=[NSString stringWithFormat:@"SELECT MR.UMPIRE1CODE ,OM.NAME AS  UMPIRE1NAME, MR.UMPIRE2CODE,OM1.NAME AS UMPIRE2NAME,MR.UMPIRE3CODE,OM2.NAME AS UMPIRE3NAME,MR.MATCHREFEREECODE ,OM3.NAME AS MATCHREFEREENAME FROM MATCHREGISTRATION MR INNER JOIN OFFICIALSMASTER OM ON MR.UMPIRE1CODE= OM.OFFICIALSCODE INNER JOIN OFFICIALSMASTER OM1 ON MR.UMPIRE2CODE= OM1.OFFICIALSCODE INNER JOIN OFFICIALSMASTER OM2 ON MR.UMPIRE3CODE= OM2.OFFICIALSCODE INNER JOIN OFFICIALSMASTER OM3 ON MR.MATCHREFEREECODE= OM3.OFFICIALSCODE WHERE MATCHCODE ='IMSC0221C6F6595E95A00002'"];
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
    int retVal;
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    retVal=sqlite3_open([databasePath UTF8String], &dataBase);
    if(retVal !=0){
    }
    
    NSString *selectPlayersSQL = [NSString stringWithFormat:@"SELECT COUNT(*) AS COUNT FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND TEAMCODE = '%@' AND RECORDSTATUS = @'MSC001'",matchCode,teamCode];
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
        
        
        
        NSString *query=[NSString stringWithFormat:@"SELECT PM.PLAYERCODE, PM.PLAYERNAME,MTPD.RECORDSTATUS  FROM PLAYERTEAMDETAILS AS PTD INNER JOIN PLAYERMASTER AS PM ON PTD.PLAYERCODE = PM.PLAYERCODE INNER JOIN MATCHTEAMPLAYERDETAILS MTPD ON MTPD.PLAYERCODE = PTD.PLAYERCODE  WHERE PM.RECORDSTATUS = 'MSC001' AND PTD.RECORDSTATUS = 'MSC001'  AND PTD.TEAMCODE = '%@' AND MTPD.MATCHCODE = '%@'  ORDER BY MTPD.RECORDSTATUS",teamCode,matchCode];
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
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO BALLEVENTS(BALLCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,DAYNO,INNINGSNO,OVERNO,BALLNO,BALLCOUNT,OVERBALLCOUNT,SESSIONNO,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE,UMPIRE2CODE,ATWOROTW,BOWLINGEND,BOWLTYPE,SHOTTYPE,ISLEGALBALL,ISFOUR,ISSIX,RUNS,OVERTHROW,TOTALRUNS,WIDE,NOBALL,BYES,LEGBYES,PENALTY,TOTALEXTRAS,GRANDTOTAL,RBW,PMLINECODE,PMLENGTHCODE,PMX1,PMY1,PMX2,PMY3,WWREGION,WWX1,WWY1,WWX2,WWY2,BALLDURATION,ISAPPEAL,ISBEATEN,ISUNCOMFORT,ISWTB,ISRELEASESHOT,MARKEDFOREDIT,REMARKS,VIDEOFILENAME,SHOTTYPECATEGORY,PMSTRIKEPOINT,PMSTRIKEPOINTLINECODE,BALLSPEED,UNCOMFORTCLASSIFCATION) VALUES (\"DMSC1144C72B9B1FDDA000200000000001\",\"UCC0000001\", \"DMSC1144C72B9B1FDDA00020\", \"TEA0000001\",\"1\",\"1\",\"0\",\"1\",\"1\",\"1\",\"1 \",\"PYC0000007\",\"PYC0000008\",\"PYC0000027\",\"PYC0000146\",\"OFC0000001\",\"OFC0000002\",\"MSC150\",\"BWT0000009\",\"UCH0000001\",\"1\",\"1\",\"0\",\"1\",\"4\",\"5\",\"0\",\"0\",\"0\",\"0\",\"0\",\"0\",\"5\",\"0\",\"MSC031\",\"MSC032\",\"1\",\"1\",\"113\",\"214\",1,\"MSC197\",\"157\",\"125\",\"107\",1,1,1,1,1,1,1,1,1,1,1,2,2,2,2)"];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(mySqliteDB, insert_stmt, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            success = true;
        }
        // }
        
        sqlite3_finalize(statement);
        sqlite3_close(mySqliteDB);
        
    }
    
    return success;
    
    
}


@end
