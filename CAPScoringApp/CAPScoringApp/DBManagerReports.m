//
//  DBManagerReports.m
//  CAPScoringApp
//
//  Created by Raja sssss on 18/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerReports.h"
#import "FixturesRecord.h"
#import "LiveReportRecord.h"
#import "FixtureReportRecord.h"
#import "LiveReportRecord.h"
#import "ResultReportRecord.h"
#import "PlayingSquadRecords.h"
#import "EventRecord.h"
#import "CommentaryReport.h"
#import "BvsBBowler.h"
#import "BvsBBatsman.h"
#import "WormRecord.h"
#import "WormWicketRecord.h"
@implementation DBManagerReports


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



//-------------------------------------------------------------------------------------------------

//Fixtures
-(NSMutableArray *)FixturesData:(NSString*)competitionCode :(NSString*)userCode {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
  
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *filter =[NSString stringWithFormat:@"MR.COMPETITIONCODE='%@' AND",competitionCode];
        
        NSString *query=[NSString stringWithFormat:@"SELECT MR.MATCHCODE,MR.MATCHNAME,MR.COMPETITIONCODE,MR.MATCHOVERCOMMENTS,MR.MATCHDATE,MR.GROUNDCODE,GM.GROUNDNAME,GM.CITY,MR.TEAMACODE,MR.TEAMBCODE ,TM.TEAMNAME AS TEAMANAME,TM1.TEAMNAME AS TEAMBNAME,TM.SHORTTEAMNAME AS TEAMASHORTNAME,TM1.SHORTTEAMNAME AS TEAMBSHORTNAME,MR.MATCHOVERS,MD.METASUBCODEDESCRIPTION AS MATCHTYPENAME, CP.MATCHTYPE AS MATCHTYPECODE, MR.MATCHSTATUS FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MR.TEAMACODE INNER JOIN TEAMMASTER TM1 ON TM1.TEAMCODE = MR.TEAMBCODE INNER JOIN GROUNDMASTER GM ON GM.GROUNDCODE = MR.GROUNDCODE INNER JOIN COMPETITION CP ON CP.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN METADATA MD ON CP.MATCHTYPE = MD.METASUBCODE INNER JOIN  MATCHSCORERDETAILS MSD ON CP.COMPETITIONCODE = MSD.COMPETITIONCODE AND MSD.SCORERCODE = '%@' AND MSD.MATCHCODE = MR.MATCHCODE WHERE %@ MR.MATCHSTATUS in ('MSC123','MSC281') GROUP BY MSD.MATCHCODE ORDER BY MATCHDATE ASC",userCode, [competitionCode isEqual:@"" ]?@"":filter];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                FixtureReportRecord *record=[[FixtureReportRecord alloc]init];
                

                record.matchCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.competitionCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString* mCode=[NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, 3)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 3)]];
                record.matchOverComments=mCode;
                record.matchDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.groundCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.groundName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.city=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.teamAcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.teamBcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.teamAname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.teamBname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.teamAshortName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.teamBshortName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.matchOvers = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.matchTypeName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                
                record.matchTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.matchStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}


// Live

-(NSMutableArray *)fetchLiveMatches:(NSString*)competitionCode :(NSString*)userCode {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *filter = [NSString stringWithFormat:@" MR.COMPETITIONCODE='%@' AND ",competitionCode ];
        
        NSString *query=[NSString stringWithFormat:@"SELECT MR.MATCHCODE,MR.MATCHNAME,MR.COMPETITIONCODE,MR.MATCHOVERCOMMENTS,MR.MATCHDATE,MR.GROUNDCODE,GM.GROUNDNAME,GM.CITY,MR.TEAMACODE,MR.TEAMBCODE ,TM.TEAMNAME AS TEAMANAME, TM1.TEAMNAME AS TEAMBNAME,TM.SHORTTEAMNAME AS TEAMASHORTNAME, TM1.SHORTTEAMNAME AS TEAMBSHORTNAME, MR.MATCHOVERS,MD.METASUBCODEDESCRIPTION AS MATCHTYPENAME, CP.MATCHTYPE AS MATCHTYPECODE, MR.MATCHSTATUS FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MR.TEAMACODE INNER JOIN TEAMMASTER TM1 ON TM1.TEAMCODE = MR.TEAMBCODE INNER JOIN GROUNDMASTER GM ON GM.GROUNDCODE = MR.GROUNDCODE INNER JOIN COMPETITION CP ON CP.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN METADATA MD ON CP.MATCHTYPE = MD.METASUBCODE INNER JOIN  MATCHSCORERDETAILS MSD ON CP.COMPETITIONCODE = MSD.COMPETITIONCODE AND MSD.SCORERCODE = '%@' AND MSD.MATCHCODE = MR.MATCHCODE WHERE %@  MR.MATCHSTATUS in ('MSC124','MSC240') GROUP BY MSD.MATCHCODE ORDER BY MATCHDATE ASC" ,userCode,[competitionCode isEqual:@""]?@"":filter];
        
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                LiveReportRecord *record=[[LiveReportRecord alloc]init];
                
                record.matchCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.competitionCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString* mCode=[NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, 3)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 3)]];
                record.matchOverComments=mCode;
                record.matchDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.groundCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.groundName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.city=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.teamAcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.teamBcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.teamAname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.teamBname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.teamAshortName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.teamBshortName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.matchOvers=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.matchTypeName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.matchTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.matchStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}


// Result

-(NSMutableArray *)fetchResultsMatches:(NSString*)competitionCode :(NSString*)userCode {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
        NSString *filter = [NSString stringWithFormat:@" MR.COMPETITIONCODE='%@' AND ",competitionCode ];
        
        NSString *query=[NSString stringWithFormat:@"SELECT MR.MATCHCODE,MR.MATCHNAME,MR.COMPETITIONCODE,MR.MATCHOVERCOMMENTS,MR.MATCHDATE,MR.GROUNDCODE,GM.GROUNDNAME,GM.CITY,MR.TEAMACODE,MR.TEAMBCODE ,TM.TEAMNAME AS TEAMANAME, TM1.TEAMNAME AS TEAMBNAME,TM.SHORTTEAMNAME AS TEAMASHORTNAME, TM1.SHORTTEAMNAME AS TEAMBSHORTNAME, MR.MATCHOVERS,MD.METASUBCODEDESCRIPTION AS MATCHTYPENAME, CP.MATCHTYPE AS MATCHTYPECODE, MR.MATCHSTATUS ,MRT.COMMENTS FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = MR.TEAMACODE INNER JOIN TEAMMASTER TM1 ON TM1.TEAMCODE = MR.TEAMBCODE INNER JOIN GROUNDMASTER GM ON GM.GROUNDCODE = MR.GROUNDCODE INNER JOIN COMPETITION CP ON CP.COMPETITIONCODE = MR.COMPETITIONCODE INNER JOIN METADATA MD ON CP.MATCHTYPE = MD.METASUBCODE INNER JOIN  MATCHSCORERDETAILS MSD ON CP.COMPETITIONCODE = MSD.COMPETITIONCODE AND MSD.SCORERCODE = '%@' AND MSD.MATCHCODE = MR.MATCHCODE INNER JOIN  MATCHRESULT MRT ON CP.COMPETITIONCODE = MRT.COMPETITIONCODE  AND MRT.MATCHCODE = MR.MATCHCODE WHERE %@  MR.MATCHSTATUS in ('MSC125') GROUP BY MSD.MATCHCODE ORDER BY MATCHDATE ASC" ,userCode,[competitionCode isEqual:@""]?@"":filter];
        
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                ResultReportRecord *record=[[ResultReportRecord alloc]init];
                
                record.matchCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.matchName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.competitionCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                NSString* mCode=[NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, 3)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 3)]];
                record.matchOverComments=mCode;
                record.matchDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.groundCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.groundName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.city=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.teamAcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.teamBcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.teamAname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.teamBname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.teamAshortName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.teamBshortName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.matchOvers=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.matchTypeName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.matchTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.matchStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.comments = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}

//Playing Squad------------------------------------------------------------------------------------

-(NSMutableArray *)fetchPlayers:(NSString*)matchCode :(NSString*)teamCode  {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        
    NSString *query=[NSString stringWithFormat:@"SELECT PM.PLAYERNAME,MP.TEAMCODE,AT.TEAMNAME, ME.METASUBCODEDESCRIPTION AS PLAYERROLE, COUNT (CASE WHEN MP.PLAYINGORDER <11 THEN 'PLAYED' END) PLAYER FROM MATCHTEAMPLAYERDETAILS AS MP INNER JOIN PLAYERMASTER AS PM ON PM.PLAYERCODE = MP.PLAYERCODE INNER JOIN TEAMMASTER AT ON AT.TEAMCODE = MP.TEAMCODE INNER JOIN METADATA ME ON ME.METASUBCODE = PM.PLAYERROLE WHERE MP.RECORDSTATUS = 'MSC001' AND PM.RECORDSTATUS = 'MSC001' AND MP.MATCHCODE = '%@' AND MP.TEAMCODE = '%@' GROUP BY PLAYINGORDER, PM.PLAYERNAME,MP.TEAMCODE,AT.TEAMNAME,ME.METASUBCODEDESCRIPTION ORDER BY MP.TEAMCODE",matchCode,teamCode];
        
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                PlayingSquadRecords *record=[[PlayingSquadRecords alloc]init];
                
                record.playerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.teamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.teamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
    
                record.playerRole=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.player=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}

-(NSMutableArray *)retrieveTorunamentData: (NSString *) userCode{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    EventRecord *allEvent=[[EventRecord alloc]init];
    //            record.id=(int)sqlite3_column_int(statement, 0);
    allEvent.competitioncode=@"";
    allEvent.competitionname=@"All";
    allEvent.recordstatus=@"";
    [eventArray addObject:allEvent];

    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        //AND MATCHSTATUS IN('MSC123','MSC281')
        
        NSString *query=[NSString stringWithFormat:@"SELECT  COM.COMPETITIONCODE,COM.COMPETITIONNAME,COM.RECORDSTATUS FROM COMPETITION COM INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE=COM.COMPETITIONCODE INNER JOIN MATCHSCORERDETAILS MATSC ON MR.COMPETITIONCODE=MATSC.COMPETITIONCODE AND MR.MATCHCODE=MATSC.MATCHCODE WHERE   MATSC.SCORERCODE='%@' GROUP BY   COM.COMPETITIONCODE,COM.COMPETITIONNAME,COM.RECORDSTATUS",userCode];
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

-(NSMutableArray *)retrieveCommentaryData: (NSString *) matchCode : (NSString *) inningsNo {
    NSMutableArray *commentaryArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        //AND MATCHSTATUS IN('MSC123','MSC281')
        
        NSString *query=[NSString stringWithFormat:@"SELECT  		 OVERSEV.TEAMCODE,OVERSEV.INNINGSNO,INNEVE.INNINGSSTATUS, OVERSEV.OVERS AS OVERNO,   'OVER '|| OVERSEV.OVERS   AS OVERSTRING  , BE.OVERNO || '.' || BE.BALLNO AS BALLNO, 		 BE.BALLCOUNT,OVERSEV.RUNS 		,PM.PLAYERNAME AS STRIKERNAME,PM2.PLAYERNAME AS BOWLERNAME, 			PM2.PLAYERNAME ||' to '|| 				CASE WHEN PM.PLAYERCODE  =   (SELECT  TEAMACAPTAIN FROM MATCHREGISTRATION WHERE MATCHCODE = '%@') OR PM.PLAYERCODE = (SELECT  TEAMBCAPTAIN FROM MATCHREGISTRATION WHERE MATCHCODE = '%@')  					THEN 						PM.PLAYERNAME || '*' 					WHEN PM.PLAYERCODE = (SELECT   TEAMAWICKETKEEPER FROM MATCHREGISTRATION WHERE MATCHCODE = '%@') OR PM.PLAYERCODE =  (SELECT   TEAMBWICKETKEEPER FROM MATCHREGISTRATION WHERE MATCHCODE = '%@') 					THEN 						PM.PLAYERNAME || '+' 				ELSE PM.PLAYERNAME END 			 AS STRIKERANDNONSTRIKER, 		 OVERSEV.SHORTTEAMNAME,BE.RUNS AS OVERRUNS,OVERSEV.TEAMSCORE,OVERSEV.WICKET AS WICKET,OVERSEV.TEAMTOTAL, 		CASE WHEN BE.ISFOUR=1 OR BE.ISSIX=1 THEN 1 ELSE 0 END AS BOUNDARIES, 		 BE.ISFOUR,BE.ISSIX,BE.NOBALL,BE.WIDE,BE.LEGBYES,BE.BYES,BE.STRIKERCODE,BE.BOWLERCODE,(MRM.VIDEOLOCATION || '' || BE.VIDEOFILENAME) VIDEOFILENAME , 50 AS TOTALWIDTH,'TRANSPARENT' AS BORDERBRUSH,'TRANSPARENT' AS BACKGROUND,'TRANSPARENT' AS FOREGROUND,WKT.ISWICKET WICKETNO, 		BE.OVERTHROW,BE.PENALTY,'1' AS BALLTEXT,PTY.PENALTYRUNS,PENALTYTYPECODE,WKT.WICKETTYPE, 		         REPLACE(REPLACE(REPLACE(REPLACE( 		 (CASE WHEN (WKT.ISWICKET <= 1) 		      THEN (',OUT ! '|| MDWKT.METASUBCODEDESCRIPTION||', '||'Wicket Player is '||PMWKT.PLAYERNAME||',' 					||''|| IFNULL((CASE WHEN MDLN.METASUBCODEDESCRIPTION !=NULL THEN ','|| MDLN.METASUBCODEDESCRIPTION ||' '|| MDLEN.METASUBCODEDESCRIPTION END),'') 					||' '|| IFNULL (BT.BOWLTYPE,'') 					||','|| IFNULL (CASE WHEN IFNULL(SHOTTYPECATEGORY,'') != '' AND SHOTTYPECATEGORY != '(null)' AND IFNULL(BE.SHOTTYPE,'') != '' AND  BE.SHOTTYPE != 'null' 								THEN 									MDSHOTTYPECAT.METASUBCODEDESCRIPTION||' '||SM.SHOTNAME 								 ELSE 									 SM.SHOTNAME 								END,'' ) 					||' '|| 					IFNULL( 					RTRIM( 					LTRIM(CASE WHEN ISAPPEAL=1 THEN ' Appeal,' ELSE '' END || 							CASE WHEN ISWTB=1 THEN ' WTB,' ELSE '' END || 							CASE WHEN ISUNCOMFORT=1 THEN ' , Uncomfortable,' ELSE '' END || 							CASE WHEN ISBEATEN=1 THEN ' Beaten,' ELSE '' END || 							CASE WHEN ISRELEASESHOT=1 THEN ' Releaseshot,' ELSE '' END),',') 							 ,'')						 							||' '||','||  IFNULL( (SELECT  group_concat(FFNAME.PLAYERNAME || ' goes up for an ' || MD.METASUBCODEDESCRIPTION ||' appeal,') FROM APPEALEVENTS APP  LEFT JOIN PLAYERMASTER FFNAME ON FFNAME.PLAYERCODE = APP.BATSMANCODE 	 						 INNER JOIN METADATA MD ON MD.METASUBCODE=APP.APPEALTYPECODE 	 						 WHERE APP.BALLCODE = APP.BALLCODE 	 GROUP BY APP.BALLCODE,APP.BATSMANCODE,APP.APPEALTYPECODE ),'') 	   ||' '||IFNULL(MD1.METASUBCODEDESCRIPTION,'') ||',' 					||' '|| IFNULL(CASE WHEN BE.TOTALEXTRAS > 0 THEN  BE.TOTALEXTRAS ||' Run,'END,'') 					||' '|| IFNULL(CASE WHEN BE.WIDE>0 THEN 'Wide Ball,' WHEN BE.NOBALL>0 THEN 'No Ball,'WHEN BE.BYES>0 THEN 'Byes,'WHEN BE.LEGBYES>0 THEN 'Leg Byes,' END,'') 					||' '|| IFNULL( CASE WHEN BE.RUNS> 0 THEN  BE.RUNS||'Run' END,'') 					||' '|| IFNULL(CASE WHEN BE.OVERTHROW >0 THEN ',Over Throw '||BE.OVERTHROW||' Run' END ,'') 					||' '||IFNULL((SELECT ( SELECT group_concat( CASE WHEN FFNAME.PLAYERCODE IN (SELECT PLAYERCODE   FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND PLAYINGORDER > 11) 																					THEN 																						FFNAME.PLAYERNAME || '(SUB) ' 																					ELSE 																						 FFNAME.PLAYERNAME 																					END ||  ' Fielding ' || FIELDINGFACTOR) FROM FIELDINGEVENTS A				 							LEFT JOIN FIELDINGFACTOR FF ON FF.FIELDINGFACTORCODE=A.FIELDINGFACTORCODE 							LEFT JOIN PLAYERMASTER FFNAME ON FFNAME.PLAYERCODE = A.FIELDERCODE AND FFNAME.RECORDSTATUS='MSC001' 							WHERE B.BALLCODE = A.BALLCODE)  Members 							FROM FIELDINGEVENTS B		 							WHERE B.BALLCODE = BE.BALLCODE 							GROUP BY B.BALLCODE),'') 					) 			 				WHEN (BE.PENALTY > 0) OR ( BE.OVERTHROW > 0) OR(BE.TOTALEXTRAS>0) THEN  (  				IFNULL((CASE WHEN MDLN.METASUBCODEDESCRIPTION !=NULL THEN ','||MDLN.METASUBCODEDESCRIPTION||' '||MDLEN.METASUBCODEDESCRIPTION END),'') 					||','|| IFNULL (BT.BOWLTYPE,'') ||',' 					||' '|| IFNULL (CASE WHEN IFNULL(SHOTTYPECATEGORY,'') != '' AND SHOTTYPECATEGORY != '(null)' AND IFNULL(BE.SHOTTYPE,'') != '' AND  BE.SHOTTYPE != 'null' 								THEN 									MDSHOTTYPECAT.METASUBCODEDESCRIPTION||' '||SM.SHOTNAME 								 ELSE 									 SM.SHOTNAME 								END,'' ) 					||' '|| 					 					 IFNULL( 				 					RTRIM( 					LTRIM( 					CASE WHEN ISAPPEAL=1 THEN ' Appeal,' ELSE '' END || 							CASE WHEN ISWTB=1 THEN ' WTB,' ELSE '' END || 							CASE WHEN ISUNCOMFORT=1 THEN ' , Uncomfortable,' ELSE '' END || 							CASE WHEN ISBEATEN=1 THEN ' Beaten,' ELSE '' END || 							CASE WHEN ISRELEASESHOT=1 THEN ' Releaseshot,' ELSE '' END 						) 						,',') 						 						 						,'') 							||' '||','||  IFNULL( (SELECT  group_concat(CASE WHEN FFNAME.PLAYERCODE IN (SELECT PLAYERCODE   FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND PLAYINGORDER > 11) THEN FFNAME.PLAYERNAME || '(SUB) ' ELSE 																						 FFNAME.PLAYERNAME END || ' goes up for an ' || MD.METASUBCODEDESCRIPTION ||' appeal,') FROM APPEALEVENTS APP  LEFT JOIN PLAYERMASTER FFNAME ON FFNAME.PLAYERCODE = APP.BATSMANCODE 	 						 INNER JOIN METADATA MD ON MD.METASUBCODE=APP.APPEALTYPECODE 	 						 WHERE APP.BALLCODE = APP.BALLCODE 	 GROUP BY APP.BALLCODE,APP.BATSMANCODE,APP.APPEALTYPECODE ),'') 	  || '' || CASE WHEN BE.WIDE>0 OR BE.NOBALL>0 OR  BE.BYES>0 OR BE.LEGBYES>0 THEN  IFNULL(CASE WHEN BE.TOTALEXTRAS > 0 THEN BE.TOTALEXTRAS ||' Run'END,'') ELSE '' END 					||' '|| IFNULL(CASE WHEN BE.WIDE>0 THEN ',Wide Ball,' WHEN BE.NOBALL>0 THEN ',No Ball,'WHEN BE.BYES>0 THEN ',Byes,'WHEN BE.LEGBYES>0 THEN ',Leg Byes,' END,'') 					||' '|| IFNULL( CASE WHEN BE.RUNS> 0 THEN  BE.RUNS||'Run' END,'') 					||' '|| IFNULL( CASE WHEN BE.OVERTHROW > 0 THEN ',Over Throw '|| BE.OVERTHROW||' Runs' END,'') 					||','|| IFNULL(CASE WHEN BE.PENALTY>0 THEN 'Penalty '|| BE.PENALTY || ' Run' END,'') 					||' '||IFNULL((SELECT ( SELECT  group_concat(CASE WHEN FFNAME.PLAYERCODE IN (SELECT PLAYERCODE   FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND PLAYINGORDER > 11) 																					THEN 																						FFNAME.PLAYERNAME || '(SUB) ' 																					ELSE 																						 FFNAME.PLAYERNAME 																					END ||' Fielding '|| FIELDINGFACTOR) FROM FIELDINGEVENTS A				 							LEFT JOIN FIELDINGFACTOR FF ON FF.FIELDINGFACTORCODE=A.FIELDINGFACTORCODE 							LEFT JOIN PLAYERMASTER FFNAME ON FFNAME.PLAYERCODE = A.FIELDERCODE AND FFNAME.RECORDSTATUS='MSC001' 							WHERE B.BALLCODE = A.BALLCODE)  Members 							FROM FIELDINGEVENTS B		 							WHERE B.BALLCODE = BE.BALLCODE 							GROUP BY B.BALLCODE),'') 					) 				WHEN BE.TOTALRUNS>0 THEN  ( IFNULL((CASE WHEN MDLN.METASUBCODEDESCRIPTION !=NULL THEN','||MDLN.METASUBCODEDESCRIPTION||' '||MDLEN.METASUBCODEDESCRIPTION END),'') 					||' '|| IFNULL (BT.BOWLTYPE,'') 					||','|| IFNULL (CASE WHEN IFNULL(SHOTTYPECATEGORY,'') != '' AND SHOTTYPECATEGORY != '(null)' AND IFNULL(BE.SHOTTYPE,'') != '' AND  BE.SHOTTYPE != 'null' 								THEN 									MDSHOTTYPECAT.METASUBCODEDESCRIPTION||' '||SM.SHOTNAME 								 ELSE 									 SM.SHOTNAME 								END,'' ) 					||' '|| 					 					IFNULL( 					 RTRIM( 					 					 					LTRIM( 					CASE WHEN ISAPPEAL=1 THEN ' ,Appeal,' ELSE '' END || 							CASE WHEN ISWTB=1 THEN ' ,WTB,' ELSE '' END || 							CASE WHEN ISUNCOMFORT=1 THEN ' , Uncomfortable,' ELSE '' END || 							CASE WHEN ISBEATEN=1 THEN ' ,Beaten,' ELSE '' END || 							CASE WHEN ISRELEASESHOT=1 THEN ' ,Releaseshot,' ELSE '' END) 							 							,',') 							 							,'') 							||' '||','||   IFNULL( (SELECT  group_concat(CASE WHEN FFNAME.PLAYERCODE IN (SELECT PLAYERCODE   FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND PLAYINGORDER > 11) THEN FFNAME.PLAYERNAME || '(SUB) ' ELSE 																						 FFNAME.PLAYERNAME END || ' goes up for an ' || MD.METASUBCODEDESCRIPTION ||' appeal,') FROM APPEALEVENTS APP  LEFT JOIN PLAYERMASTER FFNAME ON FFNAME.PLAYERCODE = APP.BATSMANCODE 	 						 INNER JOIN METADATA MD ON MD.METASUBCODE=APP.APPEALTYPECODE 	 						 WHERE APP.BALLCODE = APP.BALLCODE 	 GROUP BY APP.BALLCODE,APP.BATSMANCODE,APP.APPEALTYPECODE ),'') 					||' '||IFNULL(MD1.METASUBCODEDESCRIPTION,'') ||',' 					||' '|| IFNULL(CASE WHEN BE.TOTALEXTRAS > 0 THEN  BE.TOTALEXTRAS ||' Run,'END,'') 					||' '|| IFNULL(CASE WHEN BE.WIDE>0 THEN 'Wide Ball,' WHEN BE.NOBALL>0 THEN 'No Ball,'WHEN BE.BYES>0 THEN 'Byes,'WHEN BE.LEGBYES>0 THEN 'Leg Byes,' END,'') 					||' '|| IFNULL( CASE WHEN BE.RUNS> 0 THEN  BE.RUNS||' Run,' END,'') 					||' '||  IFNULL(CASE WHEN BE.OVERTHROW>0 THEN 'Ball Thrown and got '|| ' '||BE.OVERTHROW||' Run 'END,'') 					||' '||IFNULL((SELECT ( SELECT group_concat(CASE WHEN FFNAME.PLAYERCODE IN (SELECT PLAYERCODE   FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND PLAYINGORDER > 11) 																					THEN 																						FFNAME.PLAYERNAME || '(SUB) ' 																					ELSE 																						 FFNAME.PLAYERNAME 																					END || ' has a ' || FIELDINGFACTOR) FROM FIELDINGEVENTS A				 							LEFT JOIN FIELDINGFACTOR FF ON FF.FIELDINGFACTORCODE=A.FIELDINGFACTORCODE 							LEFT JOIN PLAYERMASTER FFNAME ON FFNAME.PLAYERCODE = A.FIELDERCODE AND FFNAME.RECORDSTATUS='MSC001' 							WHERE B.BALLCODE = A.BALLCODE )  Members 							FROM FIELDINGEVENTS B		 							WHERE B.BALLCODE = BE.BALLCODE 							GROUP BY B.BALLCODE),'') 					) ELSE  ('No Runs ,' 					||' '|| IFNULL((CASE WHEN MDLN.METASUBCODEDESCRIPTION !=NULL THEN ','||MDLN.METASUBCODEDESCRIPTION||' '|| MDLEN.METASUBCODEDESCRIPTION||',' END),'') 					||' '|| IFNULL (BT.BOWLTYPE,'') 					||' '|| IFNULL (CASE WHEN IFNULL(SHOTTYPECATEGORY,'') != '' AND SHOTTYPECATEGORY != '(null)' AND IFNULL(BE.SHOTTYPE,'') != '' AND  BE.SHOTTYPE != 'null' 								THEN 									','||MDSHOTTYPECAT.METASUBCODEDESCRIPTION||' '|| SM.SHOTNAME 								 ELSE 									','|| SM.SHOTNAME 								END,'' ) 					||' '|| 					IFNULL( 					 					RTRIM( 					 LTRIM( 					CASE WHEN ISAPPEAL=1 THEN ' ,Appeal,' ELSE '' END || 							CASE WHEN ISWTB=1 THEN ' ,WTB,' ELSE '' END || 							CASE WHEN ISUNCOMFORT=1 THEN ' ,Uncomfortable,' ELSE '' END || 							CASE WHEN ISBEATEN=1 THEN ' Beaten,' ELSE '' END || 							CASE WHEN ISRELEASESHOT=1 THEN ' ,Releaseshot,' ELSE '' END) 							 							,',') 							 							,'') 							||' '||','||   IFNULL( (SELECT  group_concat(CASE WHEN FFNAME.PLAYERCODE IN (SELECT PLAYERCODE   FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND PLAYINGORDER > 11) THEN FFNAME.PLAYERNAME || '(SUB) ' ELSE 																						 FFNAME.PLAYERNAME END || ' goes up for an ' || MD.METASUBCODEDESCRIPTION ||' appeal,') FROM APPEALEVENTS APP  LEFT JOIN PLAYERMASTER FFNAME ON FFNAME.PLAYERCODE = APP.BATSMANCODE 	 						 INNER JOIN METADATA MD ON MD.METASUBCODE=APP.APPEALTYPECODE 	 						 WHERE APP.BALLCODE = APP.BALLCODE 	 GROUP BY APP.BALLCODE,APP.BATSMANCODE,APP.APPEALTYPECODE ),'')  				 					||' '|| IFNULL(CASE WHEN BE.TOTALEXTRAS > 0 THEN BE.TOTALEXTRAS ||' Run,'END,'') 					||' '|| IFNULL(CASE WHEN BE.WIDE>0 THEN 'Wide Ball,' WHEN BE.NOBALL>0 THEN 'No Ball,'WHEN BE.BYES>0 THEN 'Byes,'WHEN BE.LEGBYES>0 THEN 'Leg Byes,' END,'') 					||' '|| IFNULL( CASE WHEN BE.RUNS> 0 THEN  BE.RUNS||' Run,' END,'') 					||' '||IFNULL(CASE WHEN BE.OVERTHROW>0 THEN ',Ball Thrown and got'||BE.OVERTHROW||' '||'Run,' END,'') 					||' '||IFNULL((SELECT ( SELECT group_concat(CASE WHEN FFNAME.PLAYERCODE IN (SELECT PLAYERCODE   FROM MATCHTEAMPLAYERDETAILS WHERE MATCHCODE = '%@' AND PLAYINGORDER > 11) 																					THEN 																						FFNAME.PLAYERNAME || '(SUB) ' 																					ELSE 																						 FFNAME.PLAYERNAME 																					END  || ' has a ' || FIELDINGFACTOR) FROM FIELDINGEVENTS A				 							LEFT JOIN FIELDINGFACTOR FF ON FF.FIELDINGFACTORCODE=A.FIELDINGFACTORCODE 							LEFT JOIN PLAYERMASTER FFNAME ON FFNAME.PLAYERCODE = A.FIELDERCODE AND FFNAME.RECORDSTATUS='MSC001' 							WHERE B.BALLCODE = A.BALLCODE)  Members 							FROM FIELDINGEVENTS B		 							WHERE B.BALLCODE = BE.BALLCODE 							GROUP BY B.BALLCODE),'') 						) 			    END ) 				 				,' ','<>'),'><',''),'<>',' '),', ,',',')AS COMMENTRY 	            		FROM BALLEVENTS BE 		INNER JOIN MATCHREGISTRATION MRM ON MRM.MATCHCODE = BE.MATCHCODE AND MRM.RECORDSTATUS='MSC001' 		INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE = MRM.COMPETITIONCODE AND CM.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER PM ON PM.PLAYERCODE = BE.STRIKERCODE AND PM.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER PM1 ON PM1.PLAYERCODE = BE.NONSTRIKERCODE AND PM1.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER PM2 ON PM2.PLAYERCODE = BE.BOWLERCODE AND PM2.RECORDSTATUS='MSC001' 		LEFT  JOIN  BOWLTYPE BT ON BE.BOWLTYPE = BT.BOWLTYPECODE AND BT.RECORDSTATUS='MSC001' 		LEFT JOIN METADATA MDBOWL ON BT.BOWLERTYPE=MDBOWL.METASUBCODE 		LEFT JOIN METADATA MDLN ON BE.PMLINECODE=MDLN.METASUBCODE 		LEFT JOIN METADATA MDLEN ON BE.PMLENGTHCODE=MDLEN.METASUBCODE 		LEFT JOIN SHOTTYPE SM ON SM.SHOTCODE = BE.SHOTTYPE AND SM.RECORDSTATUS='MSC001' 		LEFT JOIN METADATA MDSHOT ON SM.SHOTTYPE=MDSHOT.METASUBCODE 		LEFT JOIN METADATA MDSHOTTYPECAT ON MDSHOTTYPECAT.METASUBCODE=BE.SHOTTYPECATEGORY 		LEFT JOIN METADATA MD1 ON BE.WWREGION = MD1.METASUBCODE 		LEFT JOIN WICKETEVENTS WKT ON  BE.COMPETITIONCODE	 =	 WKT.COMPETITIONCODE 							AND BE.MATCHCODE =	WKT.MATCHCODE 							AND BE.INNINGSNO =	WKT.INNINGSNO 							AND BE.BALLCODE  =	WKT.BALLCODE 		LEFT JOIN PLAYERMASTER PMWKT ON PMWKT.PLAYERCODE=WKT.WICKETPLAYER							 		LEFT JOIN  METADATA MDWKT ON MDWKT.METASUBCODE=WKT.WICKETTYPE	 		LEFT JOIN PENALTYDETAILS PTY ON BE.BALLCODE = PTY.BALLCODE 		LEFT JOIN METADATA MDWIC ON MDWIC.METASUBCODE=WKT.WICKETTYPE 		INNER JOIN PLAYERMASTER PMWKEEPER ON PMWKEEPER.PLAYERCODE = BE.WICKETKEEPERCODE AND PMWKEEPER.RECORDSTATUS='MSC001' 		LEFT JOIN OFFICIALSMASTER OFUMPIRENAME1 ON OFUMPIRENAME1.OFFICIALSCODE = BE.UMPIRE1CODE AND OFUMPIRENAME1.RECORDSTATUS='MSC001' 		LEFT JOIN OFFICIALSMASTER OFUMPIRENAME2 ON OFUMPIRENAME2.OFFICIALSCODE = BE.UMPIRE2CODE AND OFUMPIRENAME2.RECORDSTATUS='MSC001' 		LEFT JOIN	METADATA MDATW ON MDATW.METASUBCODE=BE.ATWOROTW 		LEFT JOIN	METADATA MDBEND ON MDBEND.METASUBCODE=BE.BOWLINGEND 		LEFT JOIN INNINGSEVENTS INNEVE ON INNEVE.INNINGSNO = BE.INNINGSNO AND INNEVE.COMPETITIONCODE = BE.COMPETITIONCODE AND INNEVE.MATCHCODE = BE.MATCHCODE 		INNER JOIN 		 		(SELECT	 A.COMPETITIONCODE,A.MATCHCODE,A.INNINGSNO,A.TEAMCODE,A.SHORTTEAMNAME,A.OVERS 				,A.RUNS,A.WICKET AS WICKET,SUM(B.RUNS) AS TEAMSCORE,SUM(B.WICKET)AS TEAMWICKET 		 ,(A.SHORTTEAMNAME||','||IFNULL(SUM(B.RUNS),0)||'/'||IFNULL(SUM(B.WICKET),0) ) AS TEAMTOTAL 		FROM 			( 				SELECT 				 BE.COMPETITIONCODE,BE.MATCHCODE,BE.INNINGSNO,BE.TEAMCODE, 				BE.OVERNO+1 AS OVERS 				,SUM(BE.GRANDTOTAL) AS RUNS 				,COUNT(WKT.ISWICKET) AS WICKET 				 ,TM.SHORTTEAMNAME 				FROM BALLEVENTS BE 				LEFT JOIN WICKETEVENTS WKT ON  BE.COMPETITIONCODE	 =	WKT.COMPETITIONCODE 						AND BE.MATCHCODE =	 WKT.MATCHCODE 						AND BE.INNINGSNO =	WKT.INNINGSNO 						AND BE.BALLCODE  =	WKT.BALLCODE 				INNER JOIN TEAMMASTER TM 				ON TM.TEAMCODE=BE.TEAMCODE 				WHERE BE.MATCHCODE='%@' 				GROUP BY  BE.OVERNO,BE.INNINGSNO,TM.SHORTTEAMNAME,BE.COMPETITIONCODE,BE.MATCHCODE,BE.TEAMCODE  		) AS A 		INNER JOIN 		( 				SELECT 				BE.OVERNO+1 AS OVERS 				,BE.INNINGSNO 				,SUM(BE.GRANDTOTAL) AS RUNS 				,COUNT(WKT.ISWICKET) AS WICKET 				 ,BE.TEAMCODE 				,TM.SHORTTEAMNAME 				FROM BALLEVENTS BE 				LEFT JOIN WICKETEVENTS WKT ON  BE.COMPETITIONCODE	 =	WKT.COMPETITIONCODE 						AND BE.MATCHCODE =	 WKT.MATCHCODE 						AND BE.INNINGSNO =	WKT.INNINGSNO 						AND BE.BALLCODE  =	WKT.BALLCODE 				INNER JOIN TEAMMASTER TM 				ON TM.TEAMCODE=BE.TEAMCODE 				WHERE BE.MATCHCODE='%@' 				GROUP BY  BE.OVERNO,BE.INNINGSNO,BE.TEAMCODE,TM.SHORTTEAMNAME 			 		) AS B 		ON A.OVERS>=B.OVERS AND A.INNINGSNO=B.INNINGSNO 		GROUP BY A.OVERS,A.RUNS,A.WICKET,A.INNINGSNO,A.SHORTTEAMNAME,A.TEAMCODE,A.COMPETITIONCODE,A.MATCHCODE 		) OVERSEV 		 		 		ON OVERSEV.COMPETITIONCODE =BE.COMPETITIONCODE AND OVERSEV.MATCHCODE=BE.MATCHCODE AND OVERSEV.INNINGSNO=BE.INNINGSNO AND OVERSEV.OVERS=BE.OVERNO+1 AND OVERSEV.INNINGSNO = %@	 WHERE  			    ('%@'='' OR BE.MATCHCODE = '%@') 			ORDER BY BE.INNINGSNO,BE.OVERNO DESC, BE.BALLNO DESC,BE.BALLCOUNT DESC ; 	 ",matchCode,matchCode,matchCode,matchCode,matchCode,matchCode,matchCode,matchCode,matchCode,matchCode,matchCode,matchCode,matchCode,inningsNo,matchCode,matchCode];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            
            NSString *currentOver= @"";
            while(sqlite3_step(statement)==SQLITE_ROW){
                CommentaryReport *record=[[CommentaryReport alloc]init];

                record.teamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.innNo=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.overNo=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.overString=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                record.ballNo=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.overRuns=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];

                record.sAndNsName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.teamShortName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];

                record.runs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                record.wicket=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.teamTotal=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                

                record.isFour=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.isSix=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                record.noBall=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record.wide=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                record.legbyes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                record.byes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                record.wicketNo=[self getValueByNull:statement :30];
                record.overThrow=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                record.objPenalty=[self getValueByNull:statement :34];
                record.objPenaltytypecode=[self getValueByNull:statement :35];
                record.wicketType=[self getValueByNull:statement :36];
                record.commentary=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)];
                
                record.isHeader = (![currentOver isEqualToString:record.overNo])?@"1":@"0";
                
                currentOver = record.overNo;
                
                [commentaryArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return commentaryArray;
    
}


//Batsman Vs Bowler

-(NSMutableArray *)retrieveBatVsBowlBowlersList: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@" SELECT  BE.COMPETITIONCODE, BE.MATCHCODE, BE.STRIKERCODE, BE.BOWLERCODE, MR.MATCHNAME, 'Batsman: ' || SC.PLAYERNAME BATSMANNAME,BE.INNINGSNO,BC.PLAYERNAME BOWLERNAME,TM.TEAMNAME AS BATTINGTEAMNAME 		,(SELECT TM.SHORTTEAMNAME FROM MATCHREGISTRATION MR INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = (CASE BE.TEAMCODE WHEN MR.TEAMACODE THEN MR.TEAMBCODE ELSE MR.TEAMACODE END) WHERE MR.MATCHCODE = BE.MATCHCODE) AS TEAMNAME 		,MAX(MDWT.METASUBCODEDESCRIPTION) WICKETTYPE 		,COUNT(BALLCOUNT)BALLS, SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 THEN RUNS + OVERTHROW ELSE RUNS END)AS RUNS 		,SUM(CASE WHEN RUNS = 0 AND ISLEGALBALL=1 THEN 1 ELSE 0 END)AS DOTS 		,SUM(CASE WHEN RUNS = 1 THEN 1 ELSE 0 END)AS ONES 		,SUM(CASE WHEN RUNS = 2 THEN 1 ELSE 0 END)AS TWOS 		,SUM(CASE WHEN RUNS = 3 THEN 1 ELSE 0 END)AS THREES 		,SUM(CASE WHEN RUNS = 4 AND ISFOUR =0 THEN 1 ELSE 0 END)AS FOURS 		,SUM(CASE WHEN RUNS = 5 THEN 1 ELSE 0 END)AS FIVES 		,SUM(CASE WHEN RUNS = 6 AND ISSIX = 0 THEN 1 ELSE 0 END)AS SIXES 		, SUM(CASE WHEN ISFOUR = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0  THEN 1 ELSE 0 END) BOUNDARY4S 		, SUM(CASE WHEN ISSIX = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) BOUNDARY6S 		,SUM(CASE WHEN RUNS = 7 THEN 1 ELSE 0 END)AS SEVEN 		,SUM(CASE WHEN ISUNCOMFORT = 1 THEN 1 ELSE 0 END)AS UNCOMFORTABLE 		,SUM(CASE WHEN ISBEATEN = 1 THEN 1 ELSE 0 END)AS BEATEN 		,SUM(CASE WHEN ISWTB = 1 THEN 1 ELSE 0 END)AS WTB 		,CAST(CAST((SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 THEN RUNS + OVERTHROW ELSE RUNS END)/COUNT(BALLCOUNT))*100 AS NUMERIC(8,2))AS VARCHAR) STRIKERATE 		 FROM    BALLEVENTS BE 		INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE = BE.COMPETITIONCODE AND MR.MATCHCODE = BE.MATCHCODE AND MR.RECORDSTATUS='MSC001' 		INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MR.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001'	 		INNER JOIN PLAYERMASTER SC ON SC.PLAYERCODE = BE.STRIKERCODE AND SC.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER BC ON BC.PLAYERCODE = BE.BOWLERCODE AND BC.RECORDSTATUS='MSC001' 		INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = BE.TEAMCODE  AND TM.RECORDSTATUS='MSC001' 		LEFT JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE = BE.COMPETITIONCODE 				AND WE.MATCHCODE = BE.MATCHCODE 				AND WE.TEAMCODE = BE.TEAMCODE 				AND WE.BALLCODE = BE.BALLCODE 		LEFT JOIN METADATA MDWT ON  WE.WICKETTYPE = MDWT.METASUBCODE AND WE.WICKETTYPE IN('MSC095','MSC096','MSC104','MSC098','MSC099','MSC105') WHERE	 		 BE.COMPETITIONCODE = '%@' 		AND BE.MATCHCODE = '%@' 		AND BE.INNINGSNO = %@ 				 GROUP BY BE.COMPETITIONCODE, BE.STRIKERCODE, BE.BOWLERCODE, MR.MATCHNAME, 'Batsman: ' + SC.PLAYERNAME,BE.INNINGSNO,BC.PLAYERNAME,TM.TEAMNAME,BE.TEAMCODE,BE.BOWLERCODE,BE.MATCHCODE  ORDER BY BE.MATCHCODE        ",competitionCode,matchCode,inningsNo];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
           
                
                BvsBBowler *record=[[BvsBBowler alloc]init];
                record.strickerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.bowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.teamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.wicketType=[self getValueByNull:statement :10];
                record.balls=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.runs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.dots=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.ones=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.twos=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.threes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.bFours=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                record.bSixes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                record.uncomfort=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                record.beaten=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                record.wtb=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}


-(NSMutableArray *)retrieveBatVsBowlBatsmanList: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@" SELECT BE.STRIKERCODE,BE.BATSMANNAME,BE.TOTALMATCH,BE.RUNS,BE.DOTS,BE.ONES,BE.TWOS,BE.THREES,BE.FOURS,BE.FIVES,BE.SIXES,BE.SEVEN,BE.BALLS 		,BE.BOUNDARY4S,BE.BOUNDARY6S,BE.BEATEN,BE.WTB,BE.STRIKERATE,BE.	WICKETTYPE,BE.UNCOMFORTABLE, 		 		(SELECT COUNT(INNINGSNO) FROM BATTINGSUMMARY BS 						INNER JOIN MATCHREGISTRATION MR ON BS.COMPETITIONCODE=MR.COMPETITIONCODE AND MR.MATCHCODE=BS.MATCHCODE AND MR.RECORDSTATUS='MSC001' 						WHERE BS.COMPETITIONCODE = '%@' 							AND BS.MATCHCODE = '%@' 							AND BS.INNINGSNO = %@ 							AND ( BS.BATSMANCODE = BE.STRIKERCODE) AND (BS.BALLS+BS.RUNS)!=0) AS TOTALINNINGS  FROM ( SELECT    BE.STRIKERCODE , SC.PLAYERNAME BATSMANNAME 		,COUNT (DISTINCT  BE.MATCHCODE) TOTALMATCH 		,COUNT(BALLCOUNT)BALLS, SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 THEN RUNS + OVERTHROW ELSE RUNS END)AS RUNS 		,SUM(CASE WHEN RUNS = 0 AND ISLEGALBALL=1 THEN 1 ELSE 0 END)AS DOTS 		,SUM(CASE WHEN RUNS = 1 THEN 1 ELSE 0 END)AS ONES 		,SUM(CASE WHEN RUNS = 2 THEN 1 ELSE 0 END)AS TWOS 		,SUM(CASE WHEN RUNS = 3 THEN 1 ELSE 0 END)AS THREES 		,SUM(CASE WHEN RUNS = 4 AND ISFOUR =0 THEN 1 ELSE 0 END)AS FOURS 		,SUM(CASE WHEN RUNS = 5 THEN 1 ELSE 0 END)AS FIVES 		,SUM(CASE WHEN RUNS = 6 AND ISSIX = 0 THEN 1 ELSE 0 END)AS SIXES 		, SUM(CASE WHEN ISFOUR = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0  THEN 1 ELSE 0 END) BOUNDARY4S 		, SUM(CASE WHEN ISSIX = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) BOUNDARY6S 		,SUM(CASE WHEN RUNS = 7 THEN 1 ELSE 0 END)AS SEVEN 		,SUM(CASE WHEN ISUNCOMFORT = 1 THEN 1 ELSE 0 END)AS UNCOMFORTABLE 		,SUM(CASE WHEN ISBEATEN = 1 THEN 1 ELSE 0 END)AS BEATEN 		,SUM(CASE WHEN ISWTB = 1 THEN 1 ELSE 0 END)AS WTB 		,(SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 THEN RUNS + OVERTHROW ELSE RUNS END)*1.0/COUNT(BALLCOUNT)*1.0)*100.0 STRIKERATE 		,REPLACE(REPLACE(REPLACE((SELECT group_concat(DISTINCT MDWT.METASUBCODEDESCRIPTION) WICKETTYPE FROM WICKETEVENTS  WE 		  LEFT JOIN METADATA MDWT ON  WE.WICKETTYPE = MDWT.METASUBCODE AND WE.WICKETTYPE IN('MSC095','MSC096','MSC104','MSC098','MSC099','MSC105')  	       WHERE WE.WICKETPLAYER= STRIKERCODE),'<WICKETTYPE>',''),'</WICKETTYPE>',' ,'),'&amp;','&') AS WICKETTYPE 		 FROM    BALLEVENTS BE 		INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE = BE.COMPETITIONCODE AND MR.MATCHCODE = BE.MATCHCODE AND MR.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER SC ON SC.PLAYERCODE = BE.STRIKERCODE AND SC.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER BC ON BC.PLAYERCODE = BE.BOWLERCODE AND BC.RECORDSTATUS='MSC001' 		LEFT JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE = BE.COMPETITIONCODE 		AND WE.MATCHCODE = BE.MATCHCODE 		AND WE.TEAMCODE = BE.TEAMCODE 		AND WE.BALLCODE = BE.BALLCODE 		INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MR.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001'	 		 WHERE   		BE.COMPETITIONCODE = '%@' 		AND  BE.MATCHCODE = '%@' 		AND BE.INNINGSNO = %@ 		 GROUP BY BE.STRIKERCODE,    SC.PLAYERNAME ) AS BE GROUP BY BE.STRIKERCODE,BE.BATSMANNAME,BE.TOTALMATCH,BE.RUNS,BE.ONES,BE.DOTS,BE.BALLS,BE.UNCOMFORTABLE ,BE.TWOS,BE.THREES,BE.FOURS,BE.FIVES,BE.SIXES,BE.SEVEN,BE.BOUNDARY4S,BE.BOUNDARY6S,BE.BEATEN,BE.WTB,BE.STRIKERATE,BE.WICKETTYPE ",competitionCode,matchCode,inningsNo,competitionCode,matchCode,inningsNo];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
               
                
                BvsBBatsman *record=[[BvsBBatsman alloc]init];
                record.strickerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.runs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.dots=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.ones=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.twos=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.threes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.fours=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.fives=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.sixes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.sevens=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.balls=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                
                record.bFours=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.bSixes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                
                record.beaten=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.wtb=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.sr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.uncomfort=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}

// Bowler Vs Batsman

-(NSMutableArray *)retrieveBowVsBatsBowlersList: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"  SELECT  BE.BOWLERCODE,BC.PLAYERNAME BOWLERNAME 		,SUM(CASE WHEN ((ISLEGALBALL = 1) OR (NOBALL=1 AND WIDE=0)) THEN 1 ELSE 0 END)AS BALLS 		,SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 AND WIDE=0 THEN BE.RUNS + OVERTHROW ELSE BE.RUNS END)AS RUNS  		,SUM(CASE WHEN BE.RUNS = 0 AND ISLEGALBALL=1 THEN 1 ELSE 0 END)AS DOTS 		,SUM(CASE WHEN BE.RUNS = 1 THEN 1 ELSE 0 END)AS ONES 		,SUM(CASE WHEN BE.RUNS = 2 THEN 1 ELSE 0 END)AS TWOS 		,SUM(CASE WHEN BE.RUNS = 3 THEN 1 ELSE 0 END)AS THREES 		,SUM(CASE WHEN BE.RUNS = 4 AND ISFOUR =0 THEN 1 ELSE 0 END)AS FOURS 		,SUM(CASE WHEN BE.RUNS = 5 THEN 1 ELSE 0 END)AS FIVES 		,SUM(CASE WHEN BE.RUNS = 6 AND ISSIX = 0 THEN 1 ELSE 0 END)AS SIXES 		,SUM(CASE WHEN BE.RUNS = 7 THEN 1 ELSE 0 END)AS SEVEN 		,SUM(CASE WHEN ISFOUR = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) BOUNDARY4S 		,SUM(CASE WHEN ISSIX = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) BOUNDARY6S 		,SUM(CASE WHEN ISUNCOMFORT = 1 THEN 1 ELSE 0 END)AS UNCOMFORTABLE 		,SUM(CASE WHEN ISBEATEN = 1 THEN 1 ELSE 0 END)AS BEATEN 		,SUM(CASE WHEN ISWTB = 1 THEN 1 ELSE 0 END)AS WTB 		,(SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 AND WIDE=0 THEN BE.RUNS + OVERTHROW ELSE BE.RUNS END)*1.0/COUNT(BALLCOUNT)*1.0 )*100  STRIKERATE 		,COUNT (DISTINCT  BE.MATCHCODE) TOTALMATCH 		,(SELECT COUNT(INNINGSNO) FROM BOWLINGSUMMARY BS 						INNER JOIN MATCHREGISTRATION MR ON BS.COMPETITIONCODE=MR.COMPETITIONCODE AND MR.MATCHCODE=BS.MATCHCODE AND MR.RECORDSTATUS='MSC001' 						WHERE  BS.COMPETITIONCODE = '%@' 							AND BS.MATCHCODE = '%@' 							AND BS.INNINGSNO = %@ 							AND ( BS.BOWLERCODE = BE.BOWLERCODE) AND (OVERS+ RUNS+BALLS)!=0) AS TOTALINNINGS 		 FROM    BALLEVENTS BE 		INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE = BE.COMPETITIONCODE  AND MR.MATCHCODE = BE.MATCHCODE AND MR.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER SC ON SC.PLAYERCODE = BE.STRIKERCODE AND SC.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER BC ON BC.PLAYERCODE = BE.BOWLERCODE AND BC.RECORDSTATUS='MSC001' 		INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = BE.TEAMCODE  AND TM.RECORDSTATUS='MSC001' 		INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MR.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001' 		LEFT JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE = BE.COMPETITIONCODE 					AND WE.MATCHCODE = BE.MATCHCODE 					AND WE.TEAMCODE = BE.TEAMCODE 					AND WE.BALLCODE = BE.BALLCODE 		LEFT JOIN METADATA MDWT ON WE.WICKETTYPE = MDWT.METASUBCODE  AND WE.WICKETTYPE IN('MSC095','MSC096','MSC104','MSC098','MSC099','MSC105') 		 		 WHERE	 BE.COMPETITIONCODE ='%@' 		AND BE.MATCHCODE = '%@' 		AND BE.INNINGSNO = %@ 		 		 GROUP BY  BE.BOWLERCODE,   BC.PLAYERNAME	  ORDER BY  BC.PLAYERNAME   ",competitionCode,matchCode,inningsNo,competitionCode,matchCode,inningsNo];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                
                BvsBBowler *record=[[BvsBBowler alloc]init];
                
                
                record.bowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.balls=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.runs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.dots=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.ones=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.twos=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.threes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.fours=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.fives=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.sixes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.sevens=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                
                record.bFours=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.bSixes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.uncomfort=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];

                record.beaten=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.wtb=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.sr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}


-(NSMutableArray *)retrieveBowVsBatsBatsmanList: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"SELECT   BE.COMPETITIONCODE, BE.MATCHCODE, BE.STRIKERCODE, BE.BOWLERCODE, MR.MATCHNAME,SC.PLAYERNAME BATSMANNAME,BE.INNINGSNO,  BC.PLAYERNAME BOWLERNAME,TM.SHORTTEAMNAME 		,MAX(MDWT.METASUBCODEDESCRIPTION) WICKETTYPE 		,SUM(CASE WHEN ((ISLEGALBALL = 1) OR (NOBALL=1 AND WIDE=0)) THEN 1 ELSE 0 END)AS BALLS 		,SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 AND WIDE=0 THEN RUNS + OVERTHROW ELSE RUNS END)AS RUNS  		,SUM(CASE WHEN RUNS = 0 AND ISLEGALBALL=1 THEN 1 ELSE 0 END)AS DOTS 		,SUM(CASE WHEN RUNS = 1 THEN 1 ELSE 0 END)AS ONES 		,SUM(CASE WHEN RUNS = 2 THEN 1 ELSE 0 END)AS TWOS 		,SUM(CASE WHEN RUNS = 3 THEN 1 ELSE 0 END)AS THREES 		,SUM(CASE WHEN RUNS = 4 AND ISFOUR =0 THEN 1 ELSE 0 END)AS FOURS 		,SUM(CASE WHEN RUNS = 5 THEN 1 ELSE 0 END)AS FIVES 		,SUM(CASE WHEN RUNS = 6 AND ISSIX = 0 THEN 1 ELSE 0 END)AS SIXES 		,SUM(CASE WHEN RUNS = 7 THEN 1 ELSE 0 END)AS SEVEN 		,SUM(CASE WHEN ISFOUR = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) BOUNDARY4S 		,SUM(CASE WHEN ISSIX = 1 AND BE.BYES = 0 AND BE.LEGBYES = 0 THEN 1 ELSE 0 END) BOUNDARY6S 		,SUM(CASE WHEN ISUNCOMFORT = 1 THEN 1 ELSE 0 END)AS UNCOMFORTABLE 		,SUM(CASE WHEN ISBEATEN = 1 THEN 1 ELSE 0 END)AS BEATEN 		,SUM(CASE WHEN ISWTB = 1 THEN 1 ELSE 0 END)AS WTB 		,(SUM(CASE WHEN BYES = 0 AND LEGBYES = 0 THEN RUNS + OVERTHROW ELSE RUNS END)*1.0/COUNT(BALLCOUNT)*1.0)*100 STRIKERATE 		 FROM    BALLEVENTS BE 		INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE = BE.COMPETITIONCODE  AND MR.MATCHCODE = BE.MATCHCODE AND MR.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER SC ON SC.PLAYERCODE = BE.STRIKERCODE AND SC.RECORDSTATUS='MSC001' 		INNER JOIN PLAYERMASTER BC ON BC.PLAYERCODE = BE.BOWLERCODE AND BC.RECORDSTATUS='MSC001' 		INNER JOIN TEAMMASTER TM ON TM.TEAMCODE = BE.TEAMCODE  AND TM.RECORDSTATUS='MSC001' 		INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MR.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001' 		LEFT JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE = BE.COMPETITIONCODE 					AND WE.MATCHCODE = BE.MATCHCODE 					AND WE.TEAMCODE = BE.TEAMCODE 					AND WE.BALLCODE = BE.BALLCODE 		LEFT JOIN METADATA MDWT ON WE.WICKETTYPE = MDWT.METASUBCODE  AND WE.WICKETTYPE IN('MSC095','MSC096','MSC104','MSC098','MSC099','MSC105') 		 WHERE	 BE.COMPETITIONCODE = '%@' 		AND  BE.MATCHCODE ='%@' 		AND BE.INNINGSNO = %@ 		 GROUP BY BE.COMPETITIONCODE, BE.MATCHCODE, BE.STRIKERCODE, BE.BOWLERCODE, MR.MATCHNAME,SC.PLAYERNAME,BE.INNINGSNO,  BC.PLAYERNAME,TM.TEAMNAME  ",competitionCode,matchCode,inningsNo];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BvsBBatsman *record=[[BvsBBatsman alloc]init];
                
                record.strickerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.bowlerCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.name=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.teamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.wicketType=[self getValueByNull:statement :9];
                record.balls=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.runs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.dots=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.ones=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                record.twos=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                record.threes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                record.bFours=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                record.bSixes=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                record.uncomfort=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                record.beaten=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                record.wtb=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                record.sr=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];

                
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}


//Worm Chart


-(NSMutableArray *)retrieveWormChartDetails: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@"WITH WORMCHART 	AS 	( 	 		SELECT   CASE WHEN COM.MATCHTYPE = 'MSC023' OR COM.MATCHTYPE = 'MSC114' THEN 1 ELSE 0 END ISMULTIDAY 		, BE.TEAMCODE, TM.TEAMNAME TEAMNAME, BE.INNINGSNO,(BE.OVERNO + 1) OVERNO, SUM(BE.GRANDTOTAL) SCORE 		, SUM(BE.RUNS) RUNS , BE.MATCHCODE 		FROM    BALLEVENTS BE 				INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE 				INNER JOIN COMPETITION COM ON BE.COMPETITIONCODE = COM.COMPETITIONCODE 				 		WHERE  BE.COMPETITIONCODE = '%@' 				AND BE.MATCHCODE = '%@' 				AND BE.INNINGSNO = %@ 				 		GROUP BY COM.MATCHTYPE, BE.TEAMCODE, TM.TEAMNAME, BE.INNINGSNO, BE.OVERNO, BE.MATCHCODE 		 		 	),WICKETSDETAILS AS 	( 		SELECT   BE.TEAMCODE, BE.INNINGSNO,(BE.OVERNO + 1) OVERNO, WE.WICKETNO WICKETS 		FROM    BALLEVENTS BE 				INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE 				INNER JOIN COMPETITION COM ON BE.COMPETITIONCODE = COM.COMPETITIONCODE 				INNER JOIN  WICKETEVENTS WE ON WE.COMPETITIONCODE = BE.COMPETITIONCODE 							AND WE.MATCHCODE = BE.MATCHCODE 							AND WE.TEAMCODE = BE.TEAMCODE 							AND WE.BALLCODE = BE.BALLCODE AND WE.WICKETTYPE NOT IN ('MSC102') 				 		WHERE  BE.COMPETITIONCODE = '%@' 				AND BE.MATCHCODE = '%@' 				AND BE.INNINGSNO = %@ 				 		GROUP BY BE.TEAMCODE, BE.INNINGSNO, BE.OVERNO, WE.WICKETNO 	) 	SELECT   CHARTDATA.MATCHCODE,CHARTDATA.ISMULTIDAY, CHARTDATA.TEAMCODE, CHARTDATA.TEAMNAME, CHARTDATA.INNINGSNO, CHARTDATA.OVERNO, IFNULL((WKT.WICKETS),0) WICKETS, CHARTDATA.RUNS, CHARTDATA.SCORE 	, CASE  WHEN PP.POWERPLAYCODE IS NOT NULL THEN 1 ELSE 0 END AS ISPOWERPLAY ,PP.POWERPLAYTYPE 	FROM 	( 		SELECT   WCI.MATCHCODE,WCI.ISMULTIDAY, WCI.TEAMCODE, WCI.TEAMNAME, WCI.INNINGSNO, WCI.OVERNO, WCI.RUNS, SUM(WCA.SCORE) SCORE  		FROM	 WORMCHART WCI 				INNER JOIN WORMCHART WCA ON WCI.TEAMCODE = WCA.TEAMCODE AND WCI.INNINGSNO = WCA.INNINGSNO AND WCA.OVERNO <= WCI.OVERNO 				 				 		GROUP BY WCI.ISMULTIDAY, WCI.TEAMCODE, WCI.TEAMNAME, WCI.INNINGSNO, WCI.OVERNO, WCI.RUNS,WCI.MATCHCODE 	)CHARTDATA 	LEFT JOIN POWERPLAY PP ON 	CHARTDATA.OVERNO BETWEEN PP.STARTOVER AND PP.ENDOVER AND CHARTDATA.MATCHCODE = PP.MATCHCODE AND CHARTDATA.INNINGSNO=PP.INNINGSNO AND PP.RECORDSTATUS='MSC001' 	LEFT JOIN WICKETSDETAILS WKT ON WKT.TEAMCODE = CHARTDATA.TEAMCODE AND WKT.INNINGSNO = CHARTDATA.INNINGSNO AND WKT.OVERNO = CHARTDATA.OVERNO 	ORDER BY CHARTDATA.INNINGSNO, CHARTDATA.OVERNO",competitionCode,matchCode,inningsNo,competitionCode,matchCode,inningsNo];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                WormRecord *record=[[WormRecord alloc]init];
            
                record.teamCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.teamName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.innsNo=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.over=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.wicket=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.runs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.score=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                [eventArray addObject:record];
    
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}

-(NSMutableArray *)retrieveWormWicketDetails: (NSString *) matchCode : (NSString *) competitionCode : (NSString *) inningsNo{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    NSString *dbPath = [self getDBPath];
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *query=[NSString stringWithFormat:@" SELECT   BAT.INNINGSNO, BAT.BATSMANCODE  , BAT.BOWLERCODE, BATSMANNAME , BAT.RUNS, BALLS , BOWLERNAME 	   , WICKETDESCRIPTION, WICKETNO, (BE.BALLNO) AS WICKETBALLNO, WICKETSCORE, WICKETTYPEDESCRIPTION ,(BE.OVERNO+1) AS WICKETOVERNO FROM   (     SELECT BS.BATTINGPOSITIONNO, BS.BATSMANCODE, BMC.PLAYERNAME BATSMANNAME,BS.BOWLERCODE, BWLC.PLAYERNAME BOWLERNAME  		  , CAST(BS.RUNS AS NVARCHAR) RUNS  		  , CAST(BS.BALLS AS NVARCHAR) BALLS  		  , CASE BS.WICKETTYPE   				  WHEN 'MSC095' THEN 'c ' + FLDRC.PLAYERNAME + ' b ' + BWLC.PLAYERNAME  				  WHEN 'MSC096' THEN 'b ' + BWLC.PLAYERNAME  				  WHEN 'MSC097' THEN 'run out ' + FLDRC.PLAYERNAME  				  WHEN 'MSC104' THEN 'st ' + FLDRC.PLAYERNAME + ' b '+ BWLC.PLAYERNAME  				  WHEN 'MSC098' THEN 'lbw ' + BWLC.PLAYERNAME   				  WHEN 'MSC099' THEN 'hit wicket' +' '+ BWLC.PLAYERNAME   				  WHEN 'MSC100' THEN 'Handled the ball'    				  WHEN 'MSC105' THEN 'c & b' +' '+ BWLC.PLAYERNAME  				  WHEN 'MSC101' THEN 'Timed Out'   				  WHEN 'MSC102' THEN 'Retired Hurt'  				  WHEN 'MSC103' THEN 'Hitting Twice'  				  WHEN 'MSC107' THEN 'Mankading'  				  WHEN 'MSC108' THEN 'Retired Out'  				  WHEN 'MSC106' THEN 'Obstructing the field'  				  WHEN 'MSC133' THEN 'Absent Hurt'  				  ELSE 'Not Out'  			END AS WICKETDESCRIPTION    		  , BS.WICKETNO WICKETNO  		  , CAST(BS.WICKETOVERNO AS NVARCHAR)+1 WICKETOVERNO  		  , CAST(BS.WICKETBALLNO AS NVARCHAR) WICKETBALLNO  		  , CAST(BS.WICKETSCORE AS NVARCHAR) WICKETSCORE  		  , MDWT.METASUBCODEDESCRIPTION WICKETTYPEDESCRIPTION  		  , BS.INNINGSNO 		  ,WE.BALLCODE AS BALLCODE 		    FROM	  BATTINGSUMMARY BS  		  INNER JOIN PLAYERMASTER BMC  ON BMC.PLAYERCODE = BS.BATSMANCODE  		  LEFT JOIN PLAYERMASTER BWLC   ON BWLC.PLAYERCODE = BS.BOWLERCODE  		  LEFT JOIN PLAYERMASTER FLDRC   ON FLDRC.PLAYERCODE = BS.FIELDERCODE  		  LEFT JOIN METADATA MDWT   ON BS.WICKETTYPE = MDWT.METASUBCODE 		  LEFT JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE=BS.COMPETITIONCODE  AND WE.MATCHCODE=BS.MATCHCODE AND WE.INNINGSNO =BS.INNINGSNO  AND WE.WICKETPLAYER=BS.BATSMANCODE    WHERE 		   BS.COMPETITIONCODE = '%@' AND 		   BS.MATCHCODE = '%@' AND BS.INNINGSNO = %@ AND  		   BS.WICKETNO IS NOT NULL 		     GROUP BY BS.BATSMANCODE, BMC.PLAYERNAME, BS.BOWLERCODE,BS.RUNS, BS.BALLS, BS.WICKETTYPE, BS.WICKETNO, BS.WICKETOVERNO, BS.WICKETBALLNO, BS.WICKETSCORE  		  , FLDRC.PLAYERNAME, BWLC.PLAYERNAME, BS.BATTINGPOSITIONNO, MDWT.METASUBCODEDESCRIPTION  , BS.INNINGSNO 		  ,WE.BALLCODE  ) BAT   INNER JOIN BALLEVENTS BE ON  BE.BALLCODE =BAT.BALLCODE  ORDER BY WICKETNO;  ",competitionCode,matchCode,inningsNo];
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                WormWicketRecord *record=[[WormWicketRecord alloc]init];
                
                record.batsmanName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.runs=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.bowlerName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.wicketNo=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.wicketScore=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.wicketDesc=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                record.wicketOver=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                
                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    
}

@end
