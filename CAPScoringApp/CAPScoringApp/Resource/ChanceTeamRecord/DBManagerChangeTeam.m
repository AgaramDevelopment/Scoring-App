//
//  ChanceTeamRecord.m
//  CAPScoringApp
//
//  Created by APPLE on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerChangeTeam.h"
#import "ChangeTeamRecord.h"
#import "DBManagerChangeTeamInsert.h"
#import "InitializeInningsScoreBoardRecord.h"
#import "DBManagerChangeToss.h"
#import <sqlite3.h>

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

@implementation DBManagerChangeTeam

-(NSString *) getDBPath
{
    [self copyDatabaseIfNotExist];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:SQLITE_FILE_NAME];
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




-(NSString*)  GetMatchmaxInningsForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE {
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MAX(INNINGSNO) AS INNINGSNO  FROM INNINGSEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'  AND INNINGSSTATUS='1'",COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *INNINGSNO =  [self getValueByNull:statement :0];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return INNINGSNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    
    sqlite3_reset(statement);
    return @"";
}

-(NSString*)  GetBattingTeamCodeForFetchChangeTeam:(NSString*)
                                   COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) MATCHMAXINNINGS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  TEAMCODE   FROM INNINGSEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND INNINGSNO='%@'  GROUP BY TEAMCODE",COMPETITIONCODE,MATCHCODE,MATCHMAXINNINGS];
        const char *update_stmt = [updateSQL UTF8String];
       if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TEAMCODE =  [self getValueByNull:statement :0];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return TEAMCODE;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}

-(NSString*)  GetBowlingTeamCodeForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES{
    
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN TEAMACODE = '%@' THEN TEAMBCODE ELSE TEAMACODE END BOWLINGTEAM   FROM MATCHREGISTRATION  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' ",BATTINGTEAMCODES,COMPETITIONCODE,MATCHCODE];
        const char *update_stmt = [updateSQL UTF8String];
        if (sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
       
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLINGTEAM =  [self getValueByNull:statement :0];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BOWLINGTEAM;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}

-(NSString*)  GetLastOverForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  MAX(OVERNO)AS OVERNO  FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@'  AND INNINGSNO='%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODES,MATCHMAXINNINGS];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *OVERNO =  [self getValueByNull:statement :0];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return OVERNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}

-(NSString*)  GetLastBallForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS: (NSString*) LASTOVER{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  MAX(BALLNO)AS BALLNO  FROM BALLEVENTS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@'  AND INNINGSNO='%@' AND OVERNO='%@'  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODES,MATCHMAXINNINGS,LASTOVER];
        const char *update_stmt = [updateSQL UTF8String];
       if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
       
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLNO =  [self getValueByNull:statement :0];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}

-(NSString*)  GetLastBallCountForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS: (NSString*) LASTOVER : (NSString*) LASTBALL{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  MAX(BALLCOUNT)AS BALLCOUNT  FROM BALLEVENTS   WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@'  AND INNINGSNO='%@' AND OVERNO='%@' AND BALLNO='%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODES,MATCHMAXINNINGS,LASTOVER,LASTBALL];
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
        
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCOUNT =  [self getValueByNull:statement :0];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCOUNT;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return @"";
        }
    }
    sqlite3_reset(statement);
    return @"";
}


-(NSMutableArray *) GetFullDetailsForFetchChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS: (NSString*) LASTOVER : (NSString*) LASTBALL : (NSString*) LASTBALLCOUNT;
{
    NSMutableArray *GetFulldetailsDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TM.TEAMNAME,TM.TEAMCODE,INNINGSNO,BE.STRIKERCODE ,PM.PLAYERNAME STRIKERNAME,BE.NONSTRIKERCODE,PM1.PLAYERNAME AS NONSTRIKERNAME,BE.BOWLERCODE,PM2.PLAYERNAME AS BOWLERNAME FROM BALLEVENTS BE INNER JOIN TEAMMASTER TM ON TM.TEAMCODE=BE.TEAMCODE INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE=BE.STRIKERCODE INNER JOIN PLAYERMASTER PM1 ON PM1.PLAYERCODE=BE.NONSTRIKERCODE INNER JOIN PLAYERMASTER PM2 ON PM2.PLAYERCODE=BE.BOWLERCODE WHERE BE.COMPETITIONCODE='%@' AND BE.MATCHCODE='%@' 		AND BE.TEAMCODE='%@' AND BE.INNINGSNO='%@' AND BE.OVERNO='%@' AND BE.BALLCOUNT='%@' AND BE.BALLNO='%@' ",COMPETITIONCODE,MATCHCODE , BATTINGTEAMCODES , MATCHMAXINNINGS , LASTOVER , LASTBALLCOUNT , LASTBALL];
                               
                               const char *update_stmt = [updateSQL UTF8String];
                               if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
                               
                               {
                                   while(sqlite3_step(statement)==SQLITE_ROW){
                                       ChangeTeamRecord *record=[[ChangeTeamRecord alloc]init];
                                       record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                                       record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                                       record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                                       record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                                       record.STRIKERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                                       record.NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                                       record.NONSTRIKERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                                       record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                                       record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                                       
                                       
                                       [GetFulldetailsDetails addObject:record];
                                   }
                                   
                               }
                               }
                               sqlite3_finalize(statement);
                               sqlite3_close(dataBase);
                               return GetFulldetailsDetails;
                               }
-(NSMutableArray*)  GetBattingteamAndBowlteamForFetchChangeTeam: (NSString*) BATTINGTEAMCODES ;
        {
            NSMutableArray *GetBatAndBowlTeamdetailsDetails=[[NSMutableArray alloc]init];
            NSString *databasePath = [self getDBPath];
            sqlite3_stmt *statement;
            sqlite3 *dataBase;
            const char *dbPath = [databasePath UTF8String];
            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
            {
                NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMNAME,TEAMCODE FROM TEAMMASTER WHERE TEAMCODE='%@'",BATTINGTEAMCODES];
                                       
                                       const char *update_stmt = [updateSQL UTF8String];
                                      if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
                                      
                                       {
                                           while(sqlite3_step(statement)==SQLITE_ROW){
                                               ChangeTeamRecord *record=[[ChangeTeamRecord alloc]init];
                                               record.TEAMNAME=[self getValueByNull:statement :0];
                                               record.TEAMCODE=[self getValueByNull:statement :1];
                                               
                                               [GetBatAndBowlTeamdetailsDetails addObject:record];
                                           }
                                           
                                       }
                                       }
                                       sqlite3_finalize(statement);
                                       sqlite3_close(dataBase);
                                       return GetBatAndBowlTeamdetailsDetails;
                                       }
-(NSMutableArray*)  GetStickerNonStrickerNamesdetailsDetails:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODES : (NSString*) MATCHMAXINNINGS;
                {
NSMutableArray *GetStickerNonStrickerDetails=[[NSMutableArray alloc]init];
NSString *databasePath = [self getDBPath];
sqlite3_stmt *statement;
sqlite3 *dataBase;
const char *dbPath = [databasePath UTF8String];
if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
{
NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME 	FROM MATCHREGISTRATION MR	INNER JOIN MATCHTEAMPLAYERDETAILS MPD	ON MR.MATCHCODE = MPD.MATCHCODE	INNER JOIN COMPETITION COM 	ON COM.COMPETITIONCODE = MR.COMPETITIONCODE	INNER JOIN TEAMMASTER TMA	ON MPD.MATCHCODE = '%@'	AND	MPD.TEAMCODE = '%@'	AND MPD.TEAMCODE = TMA.TEAMCODE	INNER JOIN PLAYERMASTER PM	ON MPD.PLAYERCODE = PM.PLAYERCODE	WHERE PM.PLAYERCODE NOT IN 	(			SELECT WKT.WICKETPLAYER		FROM WICKETEVENTS WKT 		INNER JOIN BALLEVENTS BL		ON WKT.BALLCODE = BL.BALLCODE		AND BL.COMPETITIONCODE = '%@'		AND BL.MATCHCODE = '%@'		AND	BL.TEAMCODE = '%@'		AND WKT.WICKETTYPE != 'MSC102'		AND WKT.INNINGSNO = '%@' 	)	AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))	ORDER BY MPD.PLAYINGORDER",MATCHCODE,BATTINGTEAMCODES,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODES,MATCHMAXINNINGS];
    const char *update_stmt = [updateSQL UTF8String];
    if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
    
    {
        while(sqlite3_step(statement)==SQLITE_ROW){
            ChangeTeamRecord *record=[[ChangeTeamRecord alloc]init];
            record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            [GetStickerNonStrickerDetails addObject:record];
        }
    }
}
                    sqlite3_finalize(statement);
                    sqlite3_close(dataBase);
                    return GetStickerNonStrickerDetails;

}
-(NSMutableArray*)  GetBowlingTeamNamesdetailsDetails: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BOWLINGTEAMCODE : (NSString*) MATCHMAXINNINGS
   {
       
        NSMutableArray *GetBowlingTDetails=[[NSMutableArray alloc]init];
        NSString *databasePath = [self getDBPath];
        sqlite3_stmt *statement;
        sqlite3 *dataBase;
        const char *dbPath = [databasePath UTF8String];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME FROM MATCHREGISTRATION MR	INNER JOIN MATCHTEAMPLAYERDETAILS MPD	ON MR.MATCHCODE = MPD.MATCHCODE	INNER JOIN COMPETITION COM 	ON COM.COMPETITIONCODE = MR.COMPETITIONCODE	INNER JOIN TEAMMASTER TMA	ON MPD.MATCHCODE = '%@'	AND	MPD.TEAMCODE = '%@'	AND MPD.TEAMCODE = TMA.TEAMCODE	INNER JOIN PLAYERMASTER PM	ON MPD.PLAYERCODE = PM.PLAYERCODE	WHERE PM.BOWLINGSTYLE IN ('MSC131','MSC132')--MSC131-Right Arm,MSC132-Left Arm	AND MPD.PLAYERCODE != (CASE WHEN MR.TEAMACODE = @BOWLINGTEAMCODE THEN MR.TEAMAWICKETKEEPER ELSE MR.TEAMBWICKETKEEPER END)	AND PM.PLAYERCODE NOT IN 	(		SELECT BOWLERCODE FROM BALLEVENTS 		WHERE COMPETITIONCODE = '%@' 		AND MATCHCODE = '%@'		AND TEAMCODE = '%@' 		AND INNINGSNO = '%@' 	)	AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))",MATCHCODE,BOWLINGTEAMCODE,BOWLINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,MATCHMAXINNINGS];
                                                       
                const char *update_stmt = [updateSQL UTF8String];
                if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
                
                {
                    while(sqlite3_step(statement)==SQLITE_ROW){
                    ChangeTeamRecord *record=[[ChangeTeamRecord alloc]init];
                    record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                    record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                    [GetBowlingTDetails addObject:record];
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
        return GetBowlingTDetails;
    }

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}
+(void) InsertChangeTeam:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE:(NSNumber*) INNINGSNO:(NSString*) STRIKERCODE:(NSString*) NONSTRIKERCODE:(NSString*) BOWLERCODE:(NSNumber*) CURRENTINNINGSNO:(NSString*) CURRENTBATTINGTEAM:(NSString*) ELECTEDTO:(NSString*) BOWLINGEND
{
    if(![DBManagerChangeTeamInsert SetBallCodeForChangeTeam : COMPETITIONCODE : MATCHCODE : CURRENTBATTINGTEAM : CURRENTINNINGSNO] )
    {
        if(INNINGSNO.intValue ==1 && CURRENTINNINGSNO.intValue ==1)
        {
            if(![DBManagerChangeTeamInsert SetBallCodeForInsertChangeTeam : COMPETITIONCODE : MATCHCODE : CURRENTINNINGSNO])
            {
                [DBManagerChangeTeamInsert DeleteInningsBreaksEventsForChangeTeam : COMPETITIONCODE :MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteBallEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteBattingSummaryForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteOverEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteBowlingSummaryForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteBowlingMaidenSummaryForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteBowlerOverDetailsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteFieldingEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteDayEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteSessionEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteAppealEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteWicketEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeletePowerplayForChangeTeam : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeletePlayerInOutTimeForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeletePenaltyDetailsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteMatchEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteInningsSummaryForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                [DBManagerChangeTeamInsert DeleteInningsEventsForChangeTeam : COMPETITIONCODE : MATCHCODE];
                
                
                 [DBManagerChangeToss InsertTossDetails : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : ELECTEDTO : STRIKERCODE : NONSTRIKERCODE : BOWLERCODE : BOWLINGEND];
                
            }
            else
            {
                
                [DBManagerChangeTeamInsert UpadateInningsEventsForChangeTeam : STRIKERCODE : NONSTRIKERCODE : BOWLERCODE : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO];
                
                [DBManagerChangeTeamInsert DeleteInningsEventsForInsertChangeTeam : COMPETITIONCODE : MATCHCODE : INNINGSNO];
                
                NSNumber*INNINGSSCORECARD=[[NSNumber alloc]init];
                
                INNINGSSCORECARD=[NSNumber numberWithInt:INNINGSNO.intValue + 1];
                
                [InitializeInningsScoreBoardRecord InitializeInningsScoreBoard :COMPETITIONCODE : MATCHCODE :@"" :@"" : [NSNumber numberWithInt:INNINGSNO.intValue+1] : @"" :@"" :@"" : [NSNumber numberWithInt:1]];
                
                
            }
            
        }
        
    }
    
}



@end
