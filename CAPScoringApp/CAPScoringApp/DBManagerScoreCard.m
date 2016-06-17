//
//  DBManagerScoreCard.m
//  CAPScoringApp
//
//  Created by APPLE on 15/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerScoreCard.h"
#import "BowlingSummaryElseDetailsForScoreBoard.h"
#import "BowlingSummaryDetailsForScoreBoard.h"
#import "BatPlayerDetailsForScoreBoard.h"
#import "InningsSummaryDetailsForScoreBoard.h"
#import "MatchOverandBallDetailsForScoreBoard.h"
#import "BattingSummaryDetailsForScoreBoard.h"
#import "MatchRegistrationDetailsForScoreBoard.h"

@implementation DBManagerScoreCard

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




+(NSMutableArray *) GetMatchRegistrationForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO
{
    NSMutableArray *MatchRegistrationForScoreBoard=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MI.MATCHCODE, MI.MATCHNAME, MATCHDATE, MI.MATCHOVERS   , MI.UMPIRE1CODE, MI.UMPIRE1NAME, MI.UMPIRE2CODE, MI.UMPIRE2NAME, MI.MATCHREFEREECODE, MI.MATCHREFEREENAME   , MI.TOSSWONTEAMCODE, TMTOSS.TEAMNAME TOSSWONTEAMNAME, MI.ELECTEDTO, MI.ELECTEDTODESCRIPTION   , MI.BATTINGTEAMCODE, TMBAT.TEAMNAME BATTINGTEAMNAME, TMBAT.TEAMLOGO BATTINGTEAMLOGO  , MI.BOWLINGTEAMCODE, TMBOWL.TEAMNAME BOWLINGTEAMNAME, TMBOWL.TEAMLOGO BOWLINGTEAMLOGO   FROM    (    SELECT MR.MATCHCODE, MR.MATCHNAME, MR.MATCHDATE, MR.MATCHOVERS    , MR.UMPIRE1CODE, OM1.NAME UMPIRE1NAME, MR.UMPIRE2CODE, OM2.NAME UMPIRE2NAME, MR.MATCHREFEREECODE, RFREE.NAME MATCHREFEREENAME   , ME.TOSSWONTEAMCODE, ME.ELECTEDTO, META.METASUBCODEDESCRIPTION ELECTEDTODESCRIPTION     , IE.BATTINGTEAMCODE, CASE WHEN IE.BATTINGTEAMCODE = MR.TEAMACODE THEN MR.TEAMBCODE ELSE MR.TEAMACODE END BOWLINGTEAMCODE   FROM MATCHREGISTRATION MR    INNER JOIN MATCHEVENTS ME    ON MR.COMPETITIONCODE = ME.COMPETITIONCODE    AND MR.MATCHCODE = ME.MATCHCODE    INNER JOIN INNINGSEVENTS IE   ON MR.COMPETITIONCODE = IE.COMPETITIONCODE  AND MR.MATCHCODE = IE.MATCHCODE  INNER JOIN OFFICIALSMASTER OM1 ON MR.UMPIRE1CODE = OM1.OFFICIALSCODE  INNER JOIN OFFICIALSMASTER OM2 ON MR.UMPIRE2CODE = OM2.OFFICIALSCODE LEFT JOIN OFFICIALSMASTER RFREE  ON MR.MATCHREFEREECODE = RFREE.OFFICIALSCODE  INNER JOIN METADATA META ON ME.ELECTEDTO = META.METASUBCODE WHERE MR.COMPETITIONCODE = '%@' AND MR.MATCHCODE ='%@' AND IE.INNINGSNO = '%@' ) MI  INNER JOIN TEAMMASTER TMTOSS  ON MI.TOSSWONTEAMCODE = TMTOSS.TEAMCODE   INNER JOIN TEAMMASTER TMBAT  ON MI.BATTINGTEAMCODE = TMBAT.TEAMCODE  INNER JOIN TEAMMASTER TMBOWL ON MI.BOWLINGTEAMCODE = TMBOWL.TEAMCODE ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
       
                MatchRegistrationDetailsForScoreBoard *record=[[MatchRegistrationDetailsForScoreBoard alloc]init];
                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.MATCHNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.MATCHDATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.MATCHOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.UMPIRE1CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.UMPIRE1NAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.UMPIRE2CODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.UMPIRE2NAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.MATCHREFEREECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.MATCHREFEREENAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.TOSSWONTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.TOSSWONTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.ELECTEDTO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.ELECTEDTODESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.BATTINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.BATTINGTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.BATTINGTEAMLOGO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.BOWLINGTEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.BOWLINGTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                record.BOWLINGTEAMLOGO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                
                
                [MatchRegistrationForScoreBoard addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return MatchRegistrationForScoreBoard;
}


+(NSMutableArray *) GetBattingSummaryForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO
{
    NSMutableArray *BattingSummaryForScoreBoard=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BATSMANCODE   , BATSMANNAME , BATTINGSTYLE, BOWLERCODE, BOWLERNAME, FIELDERNAME      , RUNS, BALLS, MINS, ONES, TWOS, THREES, FOURS, SIXES, STRIKERATE, DOTBALLS, DOTBALLPERCENTAGE, RUNSPERSCORINGSHOTS      , WICKETDESCRIPTION, WICKETNO, WICKETOVERNO, WICKETBALLNO, WICKETSCORE, WICKETTYPE, WICKETTYPEDESCRIPTION       FROM      (        SELECT BS.BATTINGPOSITIONNO     , BS.BATSMANCODE     ,CASE WHEN MR.TEAMACAPTAIN=BS.BATSMANCODE OR MR.TEAMBCAPTAIN=BS.BATSMANCODE THEN  BMC.PLAYERNAME ||' *'    		WHEN MR.TEAMAWICKETKEEPER=BS.BATSMANCODE  OR MR.TEAMBWICKETKEEPER=BS.BATSMANCODE THEN  BMC.PLAYERNAME ||' +'   		ELSE BMC.PLAYERNAME END BATSMANNAME     , BMC.BATTINGSTYLE, BMRD.PLAYERCODE, BMRD.PLAYINGORDER, BS.BOWLERCODE, BWLC.PLAYERNAME BOWLERNAME  , BS.FIELDERCODE, FLDRC.PLAYERNAME FIELDERNAME       , CAST(BS.RUNS AS NVARCHAR) RUNS       , CAST(BS.BALLS AS NVARCHAR) BALLS       , julianday(PIOT.INTIME) - julianday(PIOT.OUTTIME) MINS       , CAST(BS.ONES AS NVARCHAR) ONES       , CAST(BS.TWOS AS NVARCHAR) TWOS       , CAST(BS.THREES AS NVARCHAR) THREES       , CAST(BS.FOURS AS NVARCHAR) FOURS       , CAST(BS.SIXES AS NVARCHAR) SIXES       , CAST(CAST((CASE WHEN BS.BALLS = 0 THEN 0 ELSE ((BS.RUNS/(BS.BALLS*1.0))*100) END) AS NUMERIC(6,2)) AS NVARCHAR) STRIKERATE       , CAST(BS.DOTBALLS AS NVARCHAR) DOTBALLS       , CAST(CAST((CASE WHEN BS.BALLS = 0 THEN 0 ELSE ((BS.DOTBALLS/(BS.BALLS*1.0))*100) END) AS NUMERIC(6,2)) AS NVARCHAR) DOTBALLPERCENTAGE       , CAST(CAST((CASE WHEN (BS.BALLS-BS.DOTBALLS) = 0 THEN 0 ELSE (BS.RUNS/(BS.BALLS-BS.DOTBALLS*1.0)) END) AS NUMERIC(6,2)) AS NVARCHAR) RUNSPERSCORINGSHOTS       , CASE BS.WICKETTYPE            WHEN 'MSC095' THEN    'C ' ||(    								CASE WHEN (FLMRD.PLAYERCODE=BS.FIELDERCODE AND FLMRD.PLAYINGORDER <= 11)THEN (   									 CASE WHEN MR.TEAMACAPTAIN=BS.FIELDERCODE  OR MR.TEAMBCAPTAIN=BS.FIELDERCODE THEN FLDRC.PLAYERNAME  ||'*'                                        WHEN MR.TEAMAWICKETKEEPER=BS.FIELDERCODE  OR MR.TEAMBWICKETKEEPER=BS.FIELDERCODE THEN FLDRC.PLAYERNAME  ||' +' ELSE FLDRC.PLAYERNAME END                                        )ELSE FLDRC.PLAYERNAME||'(SUB)' END)                         ||' B ' ||(                            								CASE WHEN (BMRD.PLAYERCODE=BS.BOWLERCODE AND BMRD.PLAYINGORDER <= 11)THEN (                         									CASE WHEN MR.TEAMACAPTAIN=BS.BOWLERCODE  OR MR.TEAMBCAPTAIN=BS.BOWLERCODE THEN BWLC.PLAYERNAME ||' *'   									WHEN MR.TEAMAWICKETKEEPER=BS.BOWLERCODE  OR MR.TEAMBWICKETKEEPER=BS.BOWLERCODE THEN BWLC.PLAYERNAME  ||' +' ELSE  BWLC.PLAYERNAME END    									)ELSE  BWLC.PLAYERNAME||' (SUB)'  END)          WHEN 'MSC096' THEN     						CASE WHEN (BMRD.PLAYERCODE=BS.BOWLERCODE AND BMRD.PLAYINGORDER <= 11)THEN (   							CASE WHEN MR.TEAMACAPTAIN=BS.BOWLERCODE  OR MR.TEAMBCAPTAIN=BS.BOWLERCODE THEN 'B ' || BWLC.PLAYERNAME ||' *'    							WHEN MR.TEAMAWICKETKEEPER=BS.BOWLERCODE  OR MR.TEAMBWICKETKEEPER=BS.BOWLERCODE THEN 'B ' || BWLC.PLAYERNAME||' +' ELSE 'B ' || BWLC.PLAYERNAME  END   							) ELSE 'B'||BWLC.PLAYERNAME||'(SUB)' END         WHEN 'MSC097' THEN   						CASE WHEN (FLMRD.PLAYERCODE=BS.FIELDERCODE AND FLMRD.PLAYINGORDER <= 11)THEN (   							CASE WHEN MR.TEAMACAPTAIN=BS.FIELDERCODE  OR MR.TEAMBCAPTAIN=BS.FIELDERCODE then  'run Out ' || FLDRC.PLAYERNAME  ||'*'   							WHEN  MR.TEAMAWICKETKEEPER=BS.FIELDERCODE  OR MR.TEAMBWICKETKEEPER=BS.FIELDERCODE THEN  'run Out ' || FLDRC.PLAYERNAME ||'+'   							ELSE  'run Out ' || FLDRC.PLAYERNAME end   							)ELSE 'run Out ' || FLDRC.PLAYERNAME|| '(SUB)' END          WHEN 'MSC104' THEN 'ST '||(   						 CASE WHEN (FLMRD.PLAYERCODE=BS.FIELDERCODE AND FLMRD.PLAYINGORDER <= 11)THEN (   									 CASE WHEN MR.TEAMACAPTAIN=BS.FIELDERCODE  OR MR.TEAMBCAPTAIN=BS.FIELDERCODE THEN FLDRC.PLAYERNAME  ||'*'                                        WHEN MR.TEAMAWICKETKEEPER=BS.FIELDERCODE  OR MR.TEAMBWICKETKEEPER=BS.FIELDERCODE THEN FLDRC.PLAYERNAME  ||'+' ELSE FLDRC.PLAYERNAME END                                        )ELSE FLDRC.PLAYERNAME||'(SUB)' END)        				|| ' B '|| (CASE WHEN (BMRD.PLAYERCODE=BS.BOWLERCODE AND BMRD.PLAYINGORDER <= 11)THEN (                         									CASE WHEN MR.TEAMACAPTAIN=BS.BOWLERCODE  OR MR.TEAMBCAPTAIN=BS.BOWLERCODE THEN BWLC.PLAYERNAME  ||'*'   									WHEN MR.TEAMAWICKETKEEPER=BS.BOWLERCODE  OR MR.TEAMBWICKETKEEPER=BS.BOWLERCODE THEN BWLC.PLAYERNAME  ||'+' ELSE  BWLC.PLAYERNAME END    									)ELSE  BWLC.PLAYERNAME||'(SUB)'  END)             WHEN 'MSC098' THEN     					 CASE WHEN (BMRD.PLAYERCODE=BS.BOWLERCODE AND BMRD.PLAYINGORDER <= 11)THEN (   							CASE WHEN MR.TEAMACAPTAIN=BS.BOWLERCODE  OR MR.TEAMBCAPTAIN=BS.BOWLERCODE THEN 'lbw ' || BWLC.PLAYERNAME  ||'*'   							 WHEN   MR.TEAMAWICKETKEEPER=BS.BOWLERCODE  OR MR.TEAMBWICKETKEEPER=BS.BOWLERCODE THEN 'lBW ' || BWLC.PLAYERNAME  ||'+' ELSE 'lBW ' || BWLC.PLAYERNAME  END   							)ELSE 'lbw ' || BWLC.PLAYERNAME||'(SUB)' END   							     WHEN 'MSC099' THEN     					 CASE WHEN (BMRD.PLAYERCODE=BS.BOWLERCODE AND BMRD.PLAYINGORDER <= 11)THEN (   							CASE WHEN MR.TEAMACAPTAIN=BS.BOWLERCODE  OR MR.TEAMBCAPTAIN=BS.BOWLERCODE THEN 'Hit Wicket' ||' '|| BWLC.PLAYERNAME || '*'     							WHEN   MR.TEAMAWICKETKEEPER=BS.BOWLERCODE  OR MR.TEAMBWICKETKEEPER=BS.BOWLERCODE THEN 'Hit Wicket' ||' '|| BWLC.PLAYERNAME ||''   ELSE 'Hit Wicket' ||' '|| BWLC.PLAYERNAME END   							)ELSE 'Hit Wicket' || BWLC.PLAYERNAME||'(SUB)' END   							     WHEN 'MSC100' THEN 'HANDLED THE BALL'             WHEN 'MSC105' THEN    					 CASE WHEN (BMRD.PLAYERCODE=BS.BOWLERCODE AND BMRD.PLAYINGORDER <= 11)THEN (   							CASE WHEN MR.TEAMACAPTAIN=BS.BOWLERCODE  OR MR.TEAMBCAPTAIN=BS.BOWLERCODE THEN  'C & B' ||' '|| BWLC.PLAYERNAME  ||'*'   							WHEN MR.TEAMAWICKETKEEPER=BS.BOWLERCODE  OR MR.TEAMBWICKETKEEPER=BS.BOWLERCODE THEN  'C & B' ||' '|| BWLC.PLAYERNAME  ||'+' ELSE  'C & B' ||' '|| BWLC.PLAYERNAME END    							)ELSE  'C & B' || BWLC.PLAYERNAME||'(SUB)' END     WHEN 'MSC101' THEN 'TIMED OUT'        WHEN 'MSC102' THEN 'RETIRED HURT'       WHEN 'MSC103' THEN 'HITTING TWICE'       WHEN 'MSC107' THEN 'MANKADING'       WHEN 'MSC108' THEN 'RETIRED OUT'       WHEN 'MSC106' THEN 'OBSTRUCTING THE FIELD'       WHEN 'MSC133' THEN 'ABSENT HURT'       ELSE 'NOT OUT'       END AS WICKETDESCRIPTION         , BS.WICKETNO WICKETNO       , CAST(BS.WICKETOVERNO AS NVARCHAR) WICKETOVERNO       , CAST(BS.WICKETBALLNO AS NVARCHAR) WICKETBALLNO       , CAST(BS.WICKETSCORE AS NVARCHAR) WICKETSCORE       , BS.WICKETTYPE       , MDWT.METASUBCODEDESCRIPTION WICKETTYPEDESCRIPTION       FROM BATTINGSUMMARY BS       INNER JOIN PLAYERMASTER BMC       ON BMC.PLAYERCODE = BS.BATSMANCODE       LEFT JOIN PLAYERINOUTTIME PIOT       ON PIOT.PLAYERCODE = BS.BATSMANCODE       AND PIOT.COMPETITIONCODE = BS.COMPETITIONCODE       AND PIOT.MATCHCODE = BS.MATCHCODE       AND PIOT.TEAMCODE  = BS.BATTINGTEAMCODE       AND PIOT.INNINGSNO = BS.INNINGSNO       LEFT JOIN PLAYERMASTER BWLC       ON BWLC.PLAYERCODE = BS.BOWLERCODE       LEFT JOIN PLAYERMASTER FLDRC       ON FLDRC.PLAYERCODE = BS.FIELDERCODE       LEFT JOIN METADATA MDWT       ON BS.WICKETTYPE = MDWT.METASUBCODE       INNER JOIN MATCHREGISTRATION MR     ON MR.MATCHCODE=BS.MATCHCODE     AND MR.COMPETITIONCODE=BS.COMPETITIONCODE     LEFT JOIN MATCHTEAMPLAYERDETAILS BMRD     ON BMRD.MATCHCODE=BS.MATCHCODE     AND BMRD.PLAYERCODE=BS.BOWLERCODE     LEFT JOIN MATCHTEAMPLAYERDETAILS FLMRD     ON FLMRD.MATCHCODE=BS.MATCHCODE     AND FLMRD.PLAYERCODE=BS.FIELDERCODE     WHERE BS.COMPETITIONCODE =  '%@' AND BS.MATCHCODE = '%@'   AND BS.INNINGSNO = %@     GROUP BY BS.BATSMANCODE, BMC.PLAYERNAME, BMC.BATTINGSTYLE, BS.BOWLERCODE, BWLC.PLAYERNAME , BS.FIELDERCODE, FLDRC.PLAYERNAME , BS.RUNS, BS.BALLS     , BS.ONES, BS.TWOS, BS.THREES, BS.FOURS, BS.SIXES, BS.DOTBALLS , BS.WICKETTYPE, BS.WICKETNO, BS.WICKETOVERNO, BS.WICKETBALLNO, BS.WICKETSCORE       , FLDRC.PLAYERNAME, BWLC.PLAYERNAME, BS.BATTINGPOSITIONNO, MDWT.METASUBCODEDESCRIPTION  ,MR.TEAMACAPTAIN,MR.TEAMBCAPTAIN,MR.TEAMAWICKETKEEPER,MR.TEAMBWICKETKEEPER     ,BMRD.PLAYERCODE,BMRD.PLAYINGORDER,FLMRD.PLAYERCODE,FLMRD.PLAYINGORDER     ) BAT  GROUP BY BATSMANCODE      , BATSMANNAME , BATTINGSTYLE, BOWLERCODE, BOWLERNAME, FIELDERNAME , RUNS, BALLS, MINS, ONES, TWOS, THREES, FOURS, SIXES, STRIKERATE    , DOTBALLS, DOTBALLPERCENTAGE, RUNSPERSCORINGSHOTS, WICKETDESCRIPTION,BATTINGPOSITIONNO, WICKETNO, WICKETOVERNO, WICKETBALLNO    , WICKETSCORE, WICKETTYPE, WICKETTYPEDESCRIPTION         ORDER BY BATTINGPOSITIONNO;",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                BattingSummaryDetailsForScoreBoard *record=[[BattingSummaryDetailsForScoreBoard alloc]init];
                record.BATSMANCODE=[self getValueByNull:statement :0];
                record.BATSMANNAME=[self getValueByNull:statement :1];
                record.BATTINGSTYLE=[self getValueByNull:statement :2];
                record.BOWLERCODE=[self getValueByNull:statement :3];
                record.BOWLERNAME=[self getValueByNull:statement :4];
                record.FIELDERNAME=[self getValueByNull:statement :5];
                record.RUNS=[self getValueByNull:statement :6];
                record.BALLS=[self getValueByNull:statement :7];
                record.MINS=[self getValueByNull:statement :8];
                record.ONES=[self getValueByNull:statement :9];
                record.TWOS=[self getValueByNull:statement :10];
                record.THREES=[self getValueByNull:statement :11];
                record.FOURS=[self getValueByNull:statement :12];
                record.SIXES=[self getValueByNull:statement :13];
                record.STRIKERATE=[self getValueByNull:statement :14];
                record.DOTBALLS=[self getValueByNull:statement :15];
                record.DOTBALLPERCENTAGE=[self getValueByNull:statement :16];
                record.RUNSPERSCORINGSHOTS=[self getValueByNull:statement :17];
                record.WICKETDESCRIPTION=[self getValueByNull:statement :18];
                record.WICKETNO=[self getValueByNull:statement :19];
                record.WICKETOVERNO=[self getValueByNull:statement :20];
                record.WICKETBALLNO=[self getValueByNull:statement :21];
                record.WICKETSCORE=[self getValueByNull:statement :22];
                record.WICKETTYPE=[self getValueByNull:statement :23];
                record.WICKETTYPEDESCRIPTION=[self getValueByNull:statement :24];
                
                
                [BattingSummaryForScoreBoard addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return BattingSummaryForScoreBoard;
}

+(NSNumber*) GetInningsStatusForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT INNINGSSTATUS  FROM INNINGSEVENTS   WHERE COMPETITIONCODE = '%@'   AND MATCHCODE ='%@'  AND INNINGSNO ='%@'  ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        
        
        const char *update_stmt = [updateSQL UTF8String];
      //  sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSNumber *INNINGSSTATUS = [NSNumber numberWithInteger: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] integerValue]];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return INNINGSSTATUS;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return 0;
        }
    }
    sqlite3_reset(statement);
    return 0;
}



+(NSMutableArray *) GetMatchOverForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) INNINGSNO
{
    NSMutableArray *MatchOverandBallForScoreBoard=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  (SUM(OVERS) + (SUM(BALLS)/10)) as MATCHOVERS  , ((SUM(OVERS) * 6) + SUM(BALLS)) as MATCHBALLS    FROM   (  SELECT CAST(SUM(OVERS) AS NUMERIC(5,1)) OVERS, CAST(SUM(BALLS) AS NUMERIC(6,1)) BALLS      FROM BOWLINGSUMMARY      WHERE COMPETITIONCODE = '%@'     AND MATCHCODE ='%@'     AND INNINGSNO ='%@'    AND PARTIALOVERBALLS = 0      UNION ALL      SELECT CAST(CAST((SUM(PARTIALOVERBALLS) + SUM(BALLS)) / 6 AS INTEGER) + SUM(OVERS) AS NUMERIC(6,1)) OVERS      , CAST(((SUM(PARTIALOVERBALLS) + SUM(BALLS)) %% 6) AS NUMERIC(6,1)) BALLS      FROM BOWLINGSUMMARY      WHERE COMPETITIONCODE ='%@'     AND MATCHCODE ='%@'      AND INNINGSNO = '%@'      AND PARTIALOVERBALLS <> 0     ) MO;   ",COMPETITIONCODE,MATCHCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
      //  sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                //MatchOverandBallDetailsForScoreBoard *record=[[MatchOverandBallDetailsForScoreBoard alloc]init];
              //  record.MATCHBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                [MatchOverandBallForScoreBoard addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                  [MatchOverandBallForScoreBoard addObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return MatchOverandBallForScoreBoard;
}

+(NSNumber*) GetFinalInningsForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT MAX(INNINGSNO) as INNINGSNO    FROM INNINGSEVENTS    WHERE COMPETITIONCODE = '%@'     AND MATCHCODE ='%@' ; ",COMPETITIONCODE,MATCHCODE];
        
        
        
        const char *update_stmt = [updateSQL UTF8String];
      //  sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumber *INNINGSNO = [NSNumber numberWithInteger: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] integerValue]];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return INNINGSNO;
            }
            
        }
        else {
            sqlite3_reset(statement);
            
            return 0;
        }
    }
    sqlite3_reset(statement);
    return 0;
}

+(NSString*) GetBattingteamCodeForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT BATTINGTEAMCODE  FROM INNINGSEVENTS  WHERE COMPETITIONCODE ='%@' AND MATCHCODE ='%@'  AND INNINGSNO = '%@'  ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
      //  sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *BATTINGTEAMCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BATTINGTEAMCODE;
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

+(NSString*) GetBowlingteamCodeForScoreBoard:(NSString*) BATTINGTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN TEAMACODE ='%@' THEN TEAMBCODE ELSE TEAMACODE END  FROM MATCHREGISTRATION  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' ",BATTINGTEAMCODE,COMPETITIONCODE,MATCHCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        //sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                              NSString *TEAMACODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);

                return TEAMACODE;
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
+(NSString*) GetIsFollowOnForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISFOLLOWON FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO ='%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *ISFOLLOWON =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return ISFOLLOWON;
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
+(NSString*) GetIsFollowOnInMinusForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) INNINGSNO{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISFOLLOWON FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO =  %@- 1 ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                NSString *ISFOLLOWON =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return ISFOLLOWON;
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

+(NSString*) GetTempBatTeamPenaltyForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT IFNULL(SUM(PENALTYRUNS),0) as PENALTYRUNS  FROM PENALTYDETAILS  WHERE COMPETITIONCODE ='%@'  AND MATCHCODE = '%@'  AND INNINGSNO IN (2, 3)  AND AWARDEDTOTEAMCODE ='%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
               NSString *PENALTYRUNS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return PENALTYRUNS;
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

+(NSString*) TempBatTeamPenaltyForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO : (NSString*) BATTINGTEAMCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0) as PENALTYRUNS FROM PENALTYDETAILS  WHERE COMPETITIONCODE ='%@'  AND MATCHCODE ='%@'  AND INNINGSNO IN (%@, %@ - 1)  AND AWARDEDTOTEAMCODE ='%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO,INNINGSNO,BATTINGTEAMCODE];
        
        
        const char *update_stmt = [updateSQL UTF8String];
        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *PENALTYRUNS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return PENALTYRUNS;
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

+(NSMutableArray *) GetInningsSummaryForScoreBoard:(NSString*) TEMPBATTEAMPENALTY: (NSString*) MATCHOVERS: (NSString*) MATCHBALLS: (NSString*) FINALINNINGS: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*) BATTINGTEAMCODE : (NSString*) INNINGSNO
{
    NSMutableArray *InningsSummaryForScoreBoard=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" SELECT ISMRY.BYES, ISMRY.LEGBYES, ISMRY.NOBALLS, ISMRY.WIDES, ISMRY.PENALTIES + IFNULL(@TEMPBATTEAMPENALTY, 0) AS PENALTIES    , (ISMRY.BYES + ISMRY.LEGBYES + ISMRY.NOBALLS + ISMRY.WIDES + ISMRY.PENALTIES + IFNULL(%@, 0)) TOTALEXTRAS    , ISMRY.INNINGSTOTAL + IFNULL(%@, 0) AS INNINGSTOTAL, ISMRY.INNINGSTOTALWICKETS, %@ MATCHOVERS, CAST(CASE WHEN %@=0 THEN 0 ELSE ((ISMRY.INNINGSTOTAL / %@) * 6) END AS NUMERIC(5,2)) INNINGSRUNRATE    , '%@' FINALINNINGS, IEVNTS.ISDECLARE, IEVNTS.ISFOLLOWON    FROM INNINGSSUMMARY ISMRY    INNER JOIN INNINGSEVENTS IEVNTS    ON ISMRY.COMPETITIONCODE = IEVNTS.COMPETITIONCODE    AND ISMRY.MATCHCODE = IEVNTS.MATCHCODE    AND ISMRY.INNINGSNO = IEVNTS.INNINGSNO    WHERE ISMRY.COMPETITIONCODE ='%@'   AND ISMRY.MATCHCODE = '%@'   AND ISMRY.INNINGSNO ='%@'  ",TEMPBATTEAMPENALTY,TEMPBATTEAMPENALTY,MATCHOVERS,MATCHBALLS,MATCHBALLS,FINALINNINGS,COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        //sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                InningsSummaryDetailsForScoreBoard *record=[[InningsSummaryDetailsForScoreBoard alloc]init];
                record.BYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.LEGBYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.NOBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.PENALTIES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.TOTALEXTRAS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.INNINGSTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.INNINGSTOTALWICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.MATCHOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.INNINGSRUNRATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.FINALINNINGS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.ISDECLARE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.ISFOLLOWON=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                
                
                
                [InningsSummaryForScoreBoard addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return InningsSummaryForScoreBoard;
}

+(NSMutableArray *) GetBatPlayerForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE : (NSString*) INNINGSNO
{
    NSMutableArray *GetBatPlayerDetailsForScoreBoard=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL =  [NSString stringWithFormat:@" SELECT BMC.PLAYERCODE BATSMANCODE, BMC.PLAYERNAME BATSMANNAME    FROM MATCHREGISTRATION MR    INNER JOIN MATCHTEAMPLAYERDETAILS MTP    ON MR.MATCHCODE = MTP.MATCHCODE    INNER JOIN PLAYERMASTER BMC    ON MTP.PLAYERCODE = BMC.PLAYERCODE    INNER JOIN COMPETITION CM    ON MR.COMPETITIONCODE = CM.COMPETITIONCODE    WHERE MR.COMPETITIONCODE = '%@'    AND MR.MATCHCODE ='%@'   AND MTP.TEAMCODE = '%@'  AND MTP.RECORDSTATUS = 'MSC001'    AND (CM.ISOTHERSMATCHTYPE = 'MSC117' OR MTP.PLAYINGORDER <= 11)  AND BMC.PLAYERCODE NOT IN ( SELECT BATSMANCODE   FROM BATTINGSUMMARY  WHERE COMPETITIONCODE ='%@' AND MATCHCODE ='%@'  AND BATTINGTEAMCODE ='%@'  AND INNINGSNO ='%@' ); ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
      //  sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                BatPlayerDetailsForScoreBoard *record=[[BatPlayerDetailsForScoreBoard alloc]init];
                record.BATSMANCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BATSMANNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                
                
                
                [GetBatPlayerDetailsForScoreBoard addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetBatPlayerDetailsForScoreBoard;
}

+(NSNumber*) GetIsTimeShowForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
    
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(BOWLCOMPUTESHOW,0) FROM MATCHEVENTS WHERE COMPETITIONCODE ='%@' AND MATCHCODE = '%@'; ",COMPETITIONCODE,MATCHCODE];
        
        
        
        const char *update_stmt = [updateSQL UTF8String];
       // sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
               
                NSNumber *BOWLCOMPUTESHOW = [NSNumber numberWithInteger: [[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)] integerValue]];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BOWLCOMPUTESHOW;
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

+(NSMutableArray *) GetBowlingSummaryForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO
{
    NSMutableArray *BowlingSummaryForScoreBoard=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE, BOWLERNAME, TOTALMINUTES , CASE WHEN PARTIALOVERBALLS > 0   THEN CAST(((((OVERS * 6) + BALLS) / 6) + ((((OVERS * 6) + BALLS) %% 6)/10)) AS NUMERIC(6,1))  ELSE CAST((OVERS + (BALLS/10)) AS NUMERIC(6,1))  END OVERS  , MAIDENS, RUNS, WICKETS, NOBALLS, WIDES, DOTBALLS, FOURS, SIXES    , CAST((CASE WHEN ((OVERS * 6) + BALLS) = 0 THEN 0 ELSE ((RUNS / ((OVERS * 6) + BALLS)) * 6) END) AS NUMERIC (6,2)) ECONOMY  FROM ( SELECT BS.BOWLINGPOSITIONNO, BS.BOWLERCODE, BC.PLAYERNAME BOWLERNAME,julianday(BIOT.STARTTIME) - julianday(BIOT.ENDTIME)  TOTALMINUTES  , BS.OVERS  , (BS.BALLS + BS.PARTIALOVERBALLS) BALLS , BS.PARTIALOVERBALLS  , BS.MAIDENS , BS.RUNS, BS.WICKETS, BS.NOBALLS, BS.WIDES, BS.DOTBALLS, BS.FOURS, BS.SIXES  FROM BOWLINGSUMMARY BS     INNER JOIN PLAYERMASTER BC     ON BC.PLAYERCODE = BS.BOWLERCODE     LEFT JOIN BOWLEROVERDETAILS BIOT     ON BIOT.BOWLERCODE = BS.BOWLERCODE     AND BIOT.COMPETITIONCODE = BS.COMPETITIONCODE     AND BIOT.MATCHCODE = BS.MATCHCODE     AND BIOT.INNINGSNO = BS.INNINGSNO  WHERE BS.COMPETITIONCODE ='%@'  AND BS.MATCHCODE = '%@' AND BS.INNINGSNO = '%@'     GROUP BY BS.BOWLINGPOSITIONNO, BS.BOWLERCODE, BC.PLAYERNAME, BS.OVERS, BS.BALLS, BS.PARTIALOVERBALLS, BS.MAIDENS , BS.RUNS,BS.WICKETS, BS.NOBALLS, BS.WIDES, BS.DOTBALLS, BS.FOURS, BS.SIXES    ) BOWLINGCARD    ORDER BY BOWLINGPOSITIONNO  ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
       // sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                BowlingSummaryDetailsForScoreBoard *record=[[BowlingSummaryDetailsForScoreBoard alloc]init];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TOTALMINUTES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.MAIDENS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.WICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.NOBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.DOTBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.ECONOMY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                
                
                
                [BowlingSummaryForScoreBoard addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return BowlingSummaryForScoreBoard;
}


+(NSMutableArray *) GetBowlingSummaryInElseForScoreBoard:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE :(NSString*) INNINGSNO
{
    NSMutableArray *BowlingSummaryInElseForScoreBoard=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE, BOWLERNAME, TOTALMINUTES =''  , CASE WHEN PARTIALOVERBALLS > 0       THEN CAST(((((OVERS * 6) + BALLS) / 6) + ((((OVERS * 6) + BALLS) %% 6)/10)) AS NUMERIC(6,1))       ELSE CAST((OVERS + (BALLS/10)) AS NUMERIC(6,1))      END OVERS    , MAIDENS, RUNS, WICKETS, NOBALLS, WIDES, DOTBALLS, FOURS, SIXES    , CAST((CASE WHEN ((OVERS * 6) + BALLS) = 0 THEN 0 ELSE ((RUNS / ((OVERS * 6) + BALLS)) * 6) END) AS NUMERIC (6,2)) ECONOMY    FROM    (     SELECT BS.BOWLINGPOSITIONNO, BS.BOWLERCODE, BC.PLAYERNAME BOWLERNAME,  julianday(BIOT.STARTTIME) - julianday(BIOT.ENDTIME)  TOTALMINUTES     , BS.OVERS     , (BS.BALLS + BS.PARTIALOVERBALLS) BALLS     , BS.PARTIALOVERBALLS     , BS.MAIDENS , BS.RUNS, BS.WICKETS, BS.NOBALLS, BS.WIDES, BS.DOTBALLS, BS.FOURS, BS.SIXES     FROM BOWLINGSUMMARY BS     INNER JOIN PLAYERMASTER BC     ON BC.PLAYERCODE = BS.BOWLERCODE     LEFT JOIN BOWLEROVERDETAILS BIOT     ON BIOT.BOWLERCODE = BS.BOWLERCODE     AND BIOT.COMPETITIONCODE = BS.COMPETITIONCODE     AND BIOT.MATCHCODE = BS.MATCHCODE     AND BIOT.INNINGSNO = BS.INNINGSNO     WHERE BS.COMPETITIONCODE = '%@'     AND BS.MATCHCODE ='%@' AND BS.INNINGSNO ='%@'     GROUP BY BS.BOWLINGPOSITIONNO, BS.BOWLERCODE, BC.PLAYERNAME, BS.OVERS, BS.BALLS, BS.PARTIALOVERBALLS, BS.MAIDENS , BS.RUNS,BS.WICKETS, BS.NOBALLS, BS.WIDES, BS.DOTBALLS, BS.FOURS, BS.SIXES    ) BOWLINGCARD    ORDER BY BOWLINGPOSITIONNO  ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        //sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
//                BowlingSummaryElseDetailsForScoreBoard *record=[[BowlingSummaryElseDetailsForScoreBoard alloc]init];
//                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                record.TOTALMINUTES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                record.MAIDENS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                record.WICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//                record.NOBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//                record.WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
//                record.DOTBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
//                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
//                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
//                record.ECONOMY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                BowlingSummaryDetailsForScoreBoard *record=[[BowlingSummaryDetailsForScoreBoard alloc]init];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.TOTALMINUTES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.MAIDENS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.WICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.NOBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.WIDES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.DOTBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.ECONOMY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                
                
                [BowlingSummaryInElseForScoreBoard addObject:record];
            }
            
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return BowlingSummaryInElseForScoreBoard;
}


+(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}


@end
