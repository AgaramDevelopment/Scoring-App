//
//  DBManagerpitchmapReport.m
//  CAPScoringApp
//
//  Created by APPLE on 21/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerpitchmapReport.h"
#import "StrikerDetails.h"
#import "LineReportRecord.h"
#import "LengthReportRecord.h"
#import "PitchReportdetailRecord.h"
#import "Utitliy.h"



static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

@implementation DBManagerpitchmapReport

-(void)getPitchmapReport:(NSString *)MATCHTYPECODE:(NSString *) COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)TEAMCODE :(NSString *)INNINGSNO:(NSString *)SESSIONS:(NSString *)DAYS:(NSString *)STRIKER:(NSString *)NONSTRIKER:(NSString *)BOWLER :(NSString *)SHOT:(NSString *)REGION:(NSString *)RUNS:(NSString *)BOUNFOUR:(NSString *)BOUNSIX:(NSString *)WIDE:(NSString *)NOBALL:(NSString *)BYES:(NSString *)LEGBYES:(NSString *)ISAPPEAL:(NSString *)ISUNCOMFORATABLE:(NSString *)ISBEATEN:(NSString *)ISWICKETTAKINGBALL:(NSString *)ISRELEASESHOT:(NSString *)FROMOVER:(NSString *)TOOVER:(NSString *)SHOTTYPECATEGORY:(NSString *)BATTINGSTYLE:(NSString *)BOWLINGSTYLE:(NSString *)BOWLINGTYPE:(NSString *)WICKETTYPE:(NSString *)BOWLINGSPEC:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)VENUE
{
    NSNumber * V_FROMOVER =[NSNumber numberWithInt:0];
    NSNumber * V_TOOVER =[NSNumber numberWithInt:0];
    if([FROMOVER isEqualToString:@""] || FROMOVER == nil)
    {
        V_FROMOVER = [NSNumber numberWithInt:-1];
    }
    else
    {
        V_FROMOVER= [NSNumber numberWithInt:FROMOVER.intValue];
    }
    
    if([TOOVER isEqualToString:@""] || [TOOVER isEqualToString:nil])
    {
        V_TOOVER=[NSNumber numberWithInt:-1];
    }
    else
    {
        V_TOOVER= [NSNumber numberWithInt:TOOVER.intValue];
    }
    
    NSString * DEFAULT =[NSString stringWithFormat:@"0001-01-01"];
    
    if([STARTDATE isEqualToString:@""])
    {
        STARTDATE = [NSString stringWithFormat:@"%@",DEFAULT];
    }
    if([ENDDATE isEqualToString: @""])
    {
        ENDDATE =[NSString stringWithFormat:@"%@",DEFAULT];
    }
 //SP_SUMMARYANDEXTRAS
    
    int PENALTYRUNS =0;
    NSString * TEAMPENALITYRUNS =@"0";
    
    TEAMPENALITYRUNS =[self getPenaltyRuns:COMPETITIONCODE :MATCHCODE :INNINGSNO];
    NSMutableArray * objSummaryExtArray= [self getSummaryAndExtras: MATCHTYPECODE :COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :SESSIONS :DAYS :STRIKER :NONSTRIKER :BOWLER :SHOT :REGION :RUNS :BOUNFOUR :BOUNSIX :WIDE :NOBALL :BYES :LEGBYES :ISAPPEAL :ISUNCOMFORATABLE :ISBEATEN :ISWICKETTAKINGBALL :ISRELEASESHOT :FROMOVER :TOOVER :SHOTTYPECATEGORY :BATTINGSTYLE :BOWLINGSTYLE :BOWLINGTYPE :WICKETTYPE :BOWLINGSPEC :STARTDATE :ENDDATE :VENUE:TEAMPENALITYRUNS :DEFAULT];
    
    
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

-(NSString *)getPenaltyRuns:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)INNINGSNO
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(PENALTYRUNS) PENALTYRUNS  FROM PENALTYDETAILS WHERE BALLCODE IS NULL AND (@COMPETITIONCODE='' OR COMPETITIONCODE IN (SELECT ID FROM DBO.SPLIT('%@'))) AND (@MATCHCODE='' OR MATCHCODE IN (SELECT ID FROM DBO.SPLIT('%@')))   AND (CAST(@INNINGSNO AS NVARCHAR)='' OR CAST(INNINGSNO AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *penaltyRun =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return penaltyRun;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"";

}

-(NSMutableArray *)getSummaryAndExtras:(NSString *) MATCHTYPECODE:(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE:(NSString *) TEAMCODE :(NSString *) INNINGSNO:(NSString *) SESSIONS:(NSString *) DAYS:(NSString *) STRIKER:(NSString *) NONSTRIKER:(NSString *) BOWLER :(NSString *) SHOT:(NSString *)REGION:(NSString *) RUNS:(NSString *) BOUNFOUR:(NSString *) BOUNSIX:(NSString *) WIDE:(NSString *)NOBALL:(NSString *) BYES:(NSString *) LEGBYES:(NSString *) ISAPPEAL:(NSString *) ISUNCOMFORATABLE:(NSString *) ISBEATEN:(NSString *) ISWICKETTAKINGBALL:(NSString *) ISRELEASESHOT:(NSString *) FROMOVER:(NSString *) TOOVER:(NSString *) SHOTTYPECATEGORY:(NSString *) BATTINGSTYLE:(NSString *) BOWLINGSTYLE:(NSString *) BOWLINGTYPE:(NSString *) WICKETTYPE:(NSString *) BOWLINGSPEC:(NSString *)STARTDATE:(NSString *) ENDDATE:(NSString *) VENUE:(NSString *) TEAMPENALITYRUNS :(NSString *) DEFAULT
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
    
        NSString *query=[NSString stringWithFormat:@"SELECT BE.GRANDTOTALRUNS,BE.SUMRUNS,BE.BALLS,BE.BALLCOUNT,BE.DOTBALLS,BE.SCORINGBALLS,BE.BOUNDARY4S,BE.BOUNDARY6S,BE.ONES,BE.TWOS,BE.THREES,BE.FOURS,BE.FIVES,BE.SIXES,BE.NOBALLS,BE.WIDEBALLS,BE.BYES,BE.LEGBYES,BE.PENALTY,BE.TOTALEXTRAS,CASE WHEN BALLCOUNT IS NULL OR BE.BALLCOUNT=0 THEN 0 ELSE ROUND(((CAST (BE.DOTBALLS AS  FLOAT )       /  CAST(BE.BALLCOUNT AS FLOAT) )*100),2) END AS DOTBALLSPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.SCORINGBALLS AS  FLOAT )   /  CAST(BE.BALLCOUNT AS FLOAT) )*100),2) END AS SCORINGBALLSPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.BOUNDARY4S AS  FLOAT ) * 4 /  CAST(BE.SUMRUNS AS FLOAT) )*100),2)   END AS BOUNDARY4SPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.BOUNDARY6S AS  FLOAT ) * 6 /  CAST(BE.SUMRUNS AS FLOAT) )*100),2)   END AS BOUNDARY6SPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.ONES AS  FLOAT )   * 1 /  CAST(BE.SUMRUNS AS FLOAT) )*100),2)		  END AS ONESPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.TWOS AS  FLOAT )   * 2 /  CAST(BE.SUMRUNS AS FLOAT) )*100),2)		  END AS TWOSPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.THREES AS  FLOAT ) * 3 /  CAST(BE.SUMRUNS AS FLOAT) )*100),2)  END AS THREESPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.FOURS AS  FLOAT )  * 4 /  CAST(BE.SUMRUNS AS FLOAT) )*100),2)		  END AS FOURSSPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.FIVES AS  FLOAT )  * 5 /  CAST(BE.SUMRUNS AS FLOAT) )*100),2)		  END AS FIVESSPERCENT,CASE WHEN SUMRUNS IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.SIXES AS  FLOAT )  * 6 /  CAST(BE.SUMRUNS AS FLOAT) )*100),2)		  END  AS SIXESPERCENT,CASE WHEN NOBALLS IS NULL OR CALCULATEGRANDTOTAL=0 THEN 0 ELSE ROUND(((CAST (BE.NOBALLS AS  FLOAT )   /  CAST(BE.CALCULATEGRANDTOTAL AS FLOAT) )*100),2) END AS NOBALLSPERCENT,CASE WHEN WIDEBALLS IS NULL OR CALCULATEGRANDTOTAL=0 THEN 0 ELSE ROUND(((CAST (BE.WIDEBALLS AS  FLOAT ) /  CAST(BE.CALCULATEGRANDTOTAL AS FLOAT) )*100),2) END AS WIDEBALLSPERCENT,CASE WHEN BYES IS NULL OR CALCULATEGRANDTOTAL=0 THEN 0 ELSE ROUND(((CAST (BE.BYES AS  FLOAT )      /  CAST(BE.CALCULATEGRANDTOTAL AS FLOAT) )*100),2) END  AS BYESPERCENT,CASE WHEN LEGBYES IS NULL OR CALCULATEGRANDTOTAL=0 THEN 0 ELSE ROUND(((CAST (BE.LEGBYES AS  FLOAT )   /  CAST(BE.CALCULATEGRANDTOTAL AS FLOAT) )*100),2) END  AS LEGBYESPERCENT,CASE WHEN PENALTY IS NULL OR SUMRUNS=0 THEN 0 ELSE ROUND(((CAST (BE.PENALTY AS  FLOAT )   /  CAST(BE.SUMRUNS AS FLOAT) )*100),2) END  AS PENALTYPERCENT FROM (SELECT CASE  WHEN SUM(GRANDTOTAL)IS NULL THEN 0 ELSE (CASE WHEN (@STRIKER!='' OR @NONSTRIKER!='') THEN   SUM(RUNS + (CASE WHEN (BYES = 0 AND LEGBYES = 0 AND WIDE=0 ) THEN OVERTHROW ELSE 0 END)) WHEN @BOWLER!='' THEN SUM(RUNS + WIDE+ NOBALL + (CASE WHEN BYES = 0 AND LEGBYES = 0 THEN OVERTHROW ELSE 0 END)) ELSE SUM(GRANDTOTAL)+ISNULL(@TEAMPENALITYRUNS,0) END ) END AS GRANDTOTALRUNS,CASE  WHEN COUNT(BALLCOUNT) IS NULL THEN 0 ELSE (CASE WHEN '%@'!='' OR '%@'!='' THEN (CAST (COUNT(CASE WHEN ISLEGALBALL!=0 OR NOBALL=1 THEN 1  END) AS FLOAT)) WHEN @BOWLER!='' THEN (CAST (COUNT(CASE WHEN ISLEGALBALL!=0 THEN 1  END) AS FLOAT)) ELSE COUNT(BALLCOUNT) END ) END AS BALLS,CASE WHEN ('%@'='' AND '%@'='' AND '%@'='') THEN SUM(CASE WHEN RUNS = 0 AND ISLEGALBALL=1 AND (BYES+LEGBYES)=0 THEN 1 ELSE 0 END) ELSE SUM(CASE WHEN RUNS = 0 AND ISLEGALBALL=1  THEN 1 ELSE 0 END) END AS DOTBALLS,COUNT(BALLCOUNT) AS BALLCOUNT,SUM(RUNS) AS SUMRUNS,SUM(GRANDTOTAL) AS CALCULATEGRANDTOTAL, SUM(CASE WHEN RUNS > 0 THEN 1 ELSE 0 END) SCORINGBALLS, SUM(CASE WHEN ISFOUR = 1 AND LEGBYES=0 AND BYES=0 AND WIDE=0 THEN 1 ELSE 0 END) BOUNDARY4S, SUM(CASE WHEN ISSIX = 1 AND LEGBYES=0 AND BYES=0 AND WIDE=0  THEN 1 ELSE 0 END) BOUNDARY6S, SUM(CASE WHEN RUNS = 1 THEN 1 ELSE 0 END) ONES, SUM(CASE WHEN RUNS = 2 THEN 1 ELSE 0 END) TWOS, SUM(CASE WHEN RUNS = 3 THEN 1 ELSE 0 END) THREES, SUM(CASE WHEN RUNS = 4 AND ISFOUR=0  THEN 1 ELSE 0 END) FOURS, SUM(CASE WHEN RUNS = 5 THEN 1 ELSE 0 END) FIVES, SUM(CASE WHEN RUNS = 6 AND ISSIX=0  THEN 1 ELSE 0 END) SIXES, CASE WHEN ('%@'='' AND '%@'='' AND '%@'='') THEN SUM(CASE WHEN (NOBALL > 0 AND ((BYES+LEGBYES)>0)) THEN NOBALL+BYES+LEGBYES ELSE NOBALL END) ELSE SUM(CASE WHEN NOBALL > 0 THEN NOBALL ELSE 0 END) END AS NOBALLS, SUM(CASE WHEN WIDE > 0 THEN WIDE ELSE 0 END) WIDEBALLS, CASE WHEN ('%@'='' AND '%@'='' AND '%@'='') THEN SUM(CASE WHEN (NOBALL > 0 AND BYES>0) THEN 0 ELSE BYES END) ELSE SUM(CASE WHEN BYES > 0 THEN 0 ELSE 0 END) END AS BYES, CASE WHEN ('%@'='' AND '%@'='' AND '%@'='') THEN SUM(CASE WHEN (NOBALL > 0 AND LEGBYES>0) THEN 0 ELSE LEGBYES END) ELSE SUM(CASE WHEN LEGBYES > 0 THEN 0 ELSE 0 END) END AS LEGBYES, CASE WHEN ('%@'='' AND '%@'='' AND '%@'='') THEN (SUM(CASE WHEN PENALTY > 0 THEN PENALTY ELSE 0 END)+ISNULL('%@',0)) ELSE 0 END AS PENALTY, CASE WHEN ('%@'='' AND '%@'='' AND '%@'='') THEN (SUM(CASE WHEN TOTALEXTRAS > 0 THEN TOTALEXTRAS ELSE 0 END)+ISNULL('%@',0)) ELSE (SUM(CASE WHEN TOTALEXTRAS > 0 AND BYES=0 AND LEGBYES=0 AND PENALTY=0 THEN TOTALEXTRAS ELSE 0 END)+ISNULL('%@',0))  END TOTALEXTRAS FROM			BALLEVENTS BE INNER JOIN MATCHREGISTRATION MRM ON MRM.MATCHCODE = BE.MATCHCODE AND MRM.RECORDSTATUS='MSC001' INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MRM.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001' INNER JOIN PLAYERMASTER PM ON BE.STRIKERCODE = PM.PLAYERCODE AND PM.RECORDSTATUS='MSC001'  INNER JOIN PLAYERMASTER PM1 ON BE.BOWLERCODE = PM1.PLAYERCODE AND PM1.RECORDSTATUS='MSC001' LEFT JOIN WICKETEVENTS WKT ON  BE.COMPETITIONCODE	 =	WKT.COMPETITIONCODE AND BE.MATCHCODE			 =	WKT.MATCHCODE AND BE.INNINGSNO			 =	WKT.INNINGSNO AND BE.BALLCODE			 =	WKT.BALLCODE WHERE          ('%@'='' OR CM.MATCHTYPE IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.COMPETITIONCODE IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.MATCHCODE IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.TEAMCODE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND (CAST('%@' AS NVARCHAR)='' OR CAST(BE.INNINGSNO AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR CAST(BE.DAYNO AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR CAST(BE.SESSIONNO AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.STRIKERCODE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.NONSTRIKERCODE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.BOWLERCODE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.SHOTTYPE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR WWREGION IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'=''OR ((CAST(BE.RUNS AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))  AND BE.ISFOUR=0 AND BE.ISSIX=0) OR ('%@' = '1' AND BE.ISFOUR = 1) OR ('%@' = '1' AND BE.ISSIX = 1))) AND ('%@' = -1 OR BE.OVERNO >= '%@') AND ('%@' = -1 OR BE.OVERNO  <= '%@') AND (('%@' = '0' AND '%@' = '0' AND '%@'='0' AND '%@'='0' ) OR ('%@' = '1' AND WIDE > 0) OR ('%@' = '1' AND NOBALL > 0) OR ('%@' = '1' AND BYES > 0) OR ('%@' = '1' AND LEGBYES > 0)) AND (( '%@'='0' AND '%@'='0' AND '%@'='0' AND '%@'='0' AND '%@'='0') OR ('%@' = '1' AND CAST(ISAPPEAL AS NVARCHAR)= '%@') OR ('%@' = '1' AND CAST(ISBEATEN AS NVARCHAR)= '%@') OR ('%@' = '1' AND CAST(ISWTB AS NVARCHAR)= '%@') OR ('%@' = '1' AND CAST(ISUNCOMFORT AS NVARCHAR)= '%@') OR ('%@' = '1' AND CAST(ISRELEASESHOT AS NVARCHAR) = '%@')) AND ( '%@'='' OR PM.BATTINGSTYLE  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ( '%@'='' OR PM1.BOWLINGSTYLE  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ( '%@'='' OR PM1.BOWLINGTYPE  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@' = NULL OR '%@'='' OR BE.SHOTTYPECATEGORY  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ( '%@' = NULL OR '%@'='' OR WKT.WICKETTYPE  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ( '%@'='' OR PM1.BOWLINGSPECIALIZATION IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@' ='%@' OR CAST(MRM.MATCHDATE AS DATE) >=CAST('%@' AS DATE)) AND ('%@' ='%@' OR CAST(MRM.MATCHDATE AS DATE) <=CAST('%@' AS DATE)) AND ('%@' =''OR MRM.GROUNDCODE IN (SELECT ID FROM DBO.SPLIT('%@')))" ,STRIKER,NONSTRIKER,STRIKER,NONSTRIKER,BOWLER,STRIKER,NONSTRIKER,BOWLER,STRIKER,NONSTRIKER,BOWLER,STRIKER,NONSTRIKER,BOWLER,STRIKER,NONSTRIKER,BOWLER,TEAMPENALITYRUNS,STRIKER,NONSTRIKER,BOWLER,TEAMPENALITYRUNS,TEAMPENALITYRUNS,MATCHTYPECODE,MATCHTYPECODE,COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO,DAYS,DAYS,SESSIONS,SESSIONS,STRIKER,STRIKER,NONSTRIKER,NONSTRIKER,BOWLER,BOWLER,SHOT,SHOT,REGION,REGION,RUNS,RUNS,BOUNFOUR,BOUNSIX,FROMOVER,FROMOVER,TOOVER,TOOVER,WIDE,NOBALL,BYES,LEGBYES,WIDE,NOBALL,BYES,LEGBYES,ISAPPEAL,ISBEATEN,ISWICKETTAKINGBALL,ISUNCOMFORATABLE,ISRELEASESHOT,ISAPPEAL,ISAPPEAL,ISBEATEN,ISBEATEN,ISWICKETTAKINGBALL,ISWICKETTAKINGBALL,ISUNCOMFORATABLE,ISUNCOMFORATABLE,ISRELEASESHOT,ISRELEASESHOT,BATTINGSTYLE,BATTINGSTYLE,BOWLINGSTYLE,BOWLINGSTYLE,BOWLINGTYPE,BOWLINGTYPE,SHOTTYPECATEGORY,SHOTTYPECATEGORY,SHOTTYPECATEGORY,WICKETTYPE,WICKETTYPE,WICKETTYPE,BOWLINGSPEC,BOWLINGSPEC,STARTDATE,DEFAULT,STARTDATE,ENDDATE,DEFAULT,ENDDATE,VENUE,VENUE];
        
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
//                ResultReportRecord *record=[[ResultReportRecord alloc]init];
//                
//                record.matchCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.matchName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                record.competitionCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                NSString* mCode=[NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, 3)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, 3)]];
//                record.matchOverComments=mCode;
//                record.matchDate=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                record.groundCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                record.groundName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//                record.city=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//                record.teamAcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
//                record.teamBcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
//                record.teamAname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
//                record.teamBname=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
//                record.teamAshortName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
//                record.teamBshortName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
//                record.matchOvers=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
//                record.matchTypeName=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
//                record.matchTypeCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
//                record.matchStatus = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
//                record.comments = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
//                
//                [eventArray addObject:record];
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    

}

-(NSMutableArray *)getWicketcount:(NSString *)MATCHTYPECODE:(NSString *) COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)TEAMCODE :(NSString *)INNINGSNO:(NSString *)SESSIONS:(NSString *)DAYS:(NSString *)STRIKER:(NSString *)NONSTRIKER:(NSString *)BOWLER :(NSString *)SHOT:(NSString *)REGION:(NSString *)RUNS:(NSString *)BOUNFOUR:(NSString *)BOUNSIX:(NSString *)WIDE:(NSString *)NOBALL:(NSString *)BYES:(NSString *)LEGBYES:(NSString *)ISAPPEAL:(NSString *)ISUNCOMFORATABLE:(NSString *)ISBEATEN:(NSString *)ISWICKETTAKINGBALL:(NSString *)ISRELEASESHOT:(NSString *)FROMOVER:(NSString *)TOOVER:(NSString *)SHOTTYPECATEGORY:(NSString *)BATTINGSTYLE:(NSString *)BOWLINGSTYLE:(NSString *)BOWLINGTYPE:(NSString *)WICKETTYPE:(NSString *)BOWLINGSPEC:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)VENUE :(NSString *) DEFAULT
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT	COUNT(WICKETNO) AS WICKETS FROM	WICKETEVENTS WE INNER JOIN BALLEVENTS BE ON BE.BALLCODE=WE.BALLCODE INNER JOIN MATCHREGISTRATION MR ON MR.COMPETITIONCODE=WE.COMPETITIONCODE AND MR.MATCHCODE=WE.MATCHCODE  AND MR.RECORDSTATUS='MSC001' INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MR.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001' INNER JOIN PLAYERMASTER PM ON BE.STRIKERCODE = PM.PLAYERCODE AND PM.RECORDSTATUS='MSC001' INNER JOIN PLAYERMASTER PM1 ON BE.BOWLERCODE = PM1.PLAYERCODE AND PM1.RECORDSTATUS='MSC001' WHERE ('%@'='' OR CM.MATCHTYPE IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.COMPETITIONCODE IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.MATCHCODE IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.TEAMCODE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND (CAST('%@' AS NVARCHAR)='' OR CAST(BE.INNINGSNO AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR CAST(BE.DAYNO AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR CAST(BE.SESSIONNO AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.STRIKERCODE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.NONSTRIKERCODE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR (BE.BOWLERCODE IN(SELECT ID FROM DBO.SPLIT('%@')) AND WE.WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095'))) AND ('%@'='' OR BE.SHOTTYPE IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'='' OR BE.WWREGION IN(SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@'=''OR ((CAST(BE.RUNS AS NVARCHAR) IN(SELECT ID FROM DBO.SPLIT('%@'))  AND BE.ISFOUR=0 AND BE.ISSIX=0) OR ('%@' = '1' AND BE.ISFOUR = 1) OR ('%@' = '1' AND BE.ISSIX = 1))) AND ('%@' = -1 OR BE.OVERNO >= '%@') AND ('%@' = -1 OR BE.OVERNO  <= '%@') AND ( ('%@' = '0' AND '%@' = '0' AND '%@'='0' AND '%@'='0' ) OR ('%@' = '1' AND BE.WIDE > 0) OR ('%@' = '1' AND BE.NOBALL > 0) OR ('%@' = '1' AND BE.BYES > 0) OR ('%@' = '1' AND BE.LEGBYES > 0)) AND (( '%@'='0' AND '%@'='0' AND '%@'='0' AND '%@'='0' AND '%@'='0') OR ('%@' = '1' AND CAST(BE.ISAPPEAL AS NVARCHAR) = '%@') OR ('%@' = '1' AND CAST(BE.ISBEATEN AS NVARCHAR) = '%@') OR ('%@' = '1' AND CAST(BE.ISWTB AS NVARCHAR) = '%@') OR ('%@' = '1' AND CAST(BE.ISUNCOMFORT AS NVARCHAR) = '%@') OR ('%@' = '1' AND CAST(BE.ISRELEASESHOT AS NVARCHAR) = '%@')) AND ( '%@'='' OR PM.BATTINGSTYLE  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ( '%@'='' OR PM1.BOWLINGSTYLE  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ( '%@'='' OR PM1.BOWLINGTYPE  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ( '%@' = NULL OR '%@'='' OR BE.SHOTTYPECATEGORY  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND (' %@' = NULL OR '%@'='' OR WE.WICKETTYPE  IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ( '%@'='' OR PM1.BOWLINGSPECIALIZATION IN (SELECT ID FROM DBO.SPLIT('%@'))) AND ('%@' ='%@' OR CAST(MR.MATCHDATE AS DATE) >=CAST('%@' AS DATE)) AND ('%@' ='%@' OR CAST(MR.MATCHDATE AS DATE) <=CAST('%@' AS DATE)) AND ('%@' =''OR MR.GROUNDCODE IN (SELECT ID FROM DBO.SPLIT('%@'))) AND WE.WICKETTYPE NOT IN ('MSC102')" ,MATCHTYPECODE,MATCHTYPECODE,COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO,DAYS,DAYS,SESSIONS,SESSIONS,STRIKER,STRIKER,NONSTRIKER,NONSTRIKER,BOWLER,BOWLER,SHOT,SHOT,REGION,REGION,RUNS,RUNS,BOUNFOUR,BOUNSIX,FROMOVER,FROMOVER,TOOVER,TOOVER,WIDE,NOBALL,BYES,LEGBYES,WIDE,NOBALL,BYES,LEGBYES,ISAPPEAL,ISBEATEN,ISWICKETTAKINGBALL,ISUNCOMFORATABLE,ISRELEASESHOT,ISAPPEAL,ISAPPEAL,ISBEATEN,ISBEATEN,ISWICKETTAKINGBALL,ISWICKETTAKINGBALL,ISUNCOMFORATABLE,ISUNCOMFORATABLE,ISRELEASESHOT,ISRELEASESHOT,BATTINGSTYLE,BATTINGSTYLE,BOWLINGSTYLE,BOWLINGSTYLE,BOWLINGTYPE,BOWLINGTYPE,SHOTTYPECATEGORY,SHOTTYPECATEGORY,SHOTTYPECATEGORY,WICKETTYPE,WICKETTYPE,WICKETTYPE,BOWLINGSPEC,BOWLINGSPEC,STARTDATE,DEFAULT,STARTDATE,ENDDATE,DEFAULT,ENDDATE,VENUE,VENUE];
        
        
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
    

}

// pitchmap detail

-(NSMutableArray *)getPitchmapdetails:(NSString *) MATCHTYPECODE :(NSString *) COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *) TEAMCODE :(NSString *) INNINGSNO:(NSString *) STRIKER:(NSString *) RUNS :(NSString *)lengthcode :(NSString *) linecode
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString * query=[NSString stringWithFormat:@"SELECT BALL.PMLINECODE,MDLIN.METASUBCODEDESCRIPTION PMLINENAME,BALL.PMLENGTHCODE,MDLEN.METASUBCODEDESCRIPTION PMLENGTHNAME,BALL.PMX2,BALL.PMY2,BALL.RUNS + BALL.OVERTHROW AS RUNS,STKR.BATTINGSTYLE,(CASE WHEN (BALL.RUNS + (CASE WHEN BALL.BYES = 0 AND  BALL.LEGBYES = 0 THEN BALL.OVERTHROW ELSE 0 END) + BALL.WIDE) = 0 THEN 1 ELSE 0 END) ISDOTBALL,(CASE WHEN WKT.WICKETTYPE IS NULL THEN 0 ELSE 1 END) ISWICKET,MRM.MATCHNAME AS MATCHNAME,(BALL.OVERNO) + '.' + (BALL.BALLNO) AS BALLNO,(PM1.PLAYERNAME + ' TO ' + STKR.PLAYERNAME) AS PLAYERDETAIL,('LINE: ' + ME.METASUBCODEDESCRIPTION) AS LINE,('LENGTH: ' + ME1.METASUBCODEDESCRIPTION) AS LENGTH,('BOWL TYPE: ' + ME.METASUBCODEDESCRIPTION) AS LINETYPE,('SHOT TYPE: ' + ME1.METASUBCODEDESCRIPTION) AS SHOTYPE,'RUNS: ' + (BALL.RUNS + BALL.OVERTHROW) AS BALLRUNS,CASE WKT.WICKETTYPE WHEN 'MSC095' THEN 'c ' + FLDRC.PLAYERNAME + ' b ' + PM1.PLAYERNAME WHEN 'MSC096' THEN 'b ' + PM1.PLAYERNAME WHEN 'MSC097' THEN 'run out ' + FLDRC.PLAYERNAME WHEN 'MSC104' THEN 'st ' + FLDRC.PLAYERNAME + ' b ' + PM1.PLAYERNAME WHEN 'MSC098' THEN 'lbw ' + PM1.PLAYERNAME WHEN 'MSC099' THEN 'hit wicket' + ' ' + PM1.PLAYERNAME WHEN 'MSC100' THEN 'Handled the ball' WHEN 'MSC105' THEN 'c & b' + ' ' + PM1.PLAYERNAME WHEN 'MSC101' THEN 'Timed Out' WHEN 'MSC102' THEN 'Retired Hurt' WHEN 'MSC103' THEN 'Hitting Twice' WHEN 'MSC107' THEN 'Mankading' WHEN 'MSC108' THEN 'Retired Out' WHEN 'MSC106' THEN 'Obstructing the field' WHEN 'MSC133' THEN 'Absent Hurt' ELSE 'Not Out' END AS WICKETTYPE FROM BALLEVENTS BALL INNER JOIN MATCHREGISTRATION MRM ON MRM.MATCHCODE = BALL.MATCHCODE AND MRM.RECORDSTATUS = 'MSC001' INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE = MRM.COMPETITIONCODE AND CM.RECORDSTATUS = 'MSC001' INNER JOIN PLAYERMASTER STKR ON BALL.STRIKERCODE = STKR.PLAYERCODE AND STKR.RECORDSTATUS = 'MSC001' LEFT JOIN METADATA MDLIN ON BALL.PMLINECODE = MDLIN.METASUBCODE LEFT JOIN METADATA MDLEN ON BALL.PMLENGTHCODE = MDLEN.METASUBCODE LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE INNER JOIN PLAYERMASTER PM1 ON BALL.BOWLERCODE = PM1.PLAYERCODE AND PM1.RECORDSTATUS = 'MSC001' LEFT JOIN METADATA ME ON ME.METASUBCODE = BALL.PMLINECODE LEFT JOIN METADATA ME1 ON ME1.METASUBCODE = BALL.PMLENGTHCODE LEFT JOIN PLAYERMASTER FLDRC ON FLDRC.PLAYERCODE = WKT.FIELDINGPLAYER AND FLDRC.RECORDSTATUS = 'MSC001' WHERE ('%@' = '' OR CM.MATCHTYPE = '%@') AND ('%@' = '' OR BALL.COMPETITIONCODE = '%@') AND ('%@' = '' OR BALL.MATCHCODE = '%@') AND ('%@' = '' OR BALL.TEAMCODE = '%@') AND( ('%@' = '' OR BALL.INNINGSNO = '%@') ) AND ('%@' = '' OR BALL.STRIKERCODE = '%@') AND ('%@' = '' OR BALL.RUNS = '%@') AND ('%@' = '' OR BALL.PMLINECODE = '%@') AND ('%@' = '' OR BALL.PMLengthcode = '%@')   AND ('0' = '0' OR (CASE WHEN (BALL.RUNS + (CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 THEN BALL.OVERTHROW ELSE 0 END) + BALL.WIDE) = 0 THEN 1 ELSE 0 END) = '0') AND ('0' = '0' OR (CASE WHEN WKT.WICKETTYPE IS NULL THEN 0 ELSE 1 END) = '0');",MATCHTYPECODE,MATCHTYPECODE,COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO,STRIKER,STRIKER,RUNS,RUNS,linecode,linecode,lengthcode,lengthcode];
                
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
            PitchReportdetailRecord *record=[[PitchReportdetailRecord alloc]init];
                
           record.PMlineCode=[self getValueByNull:statement :0];
           record.PMlineName=[self getValueByNull:statement :1];
           record.PMlengthcode=[self getValueByNull:statement :2];
           record.PMLengthName = [self getValueByNull:statement :3];
           record.PMX2 = [Utitliy getPitchMapXAxisForDevice:[self getValueByNull:statement :4]];
           record.PMY2 = [Utitliy getPitchMapYAxisForDevice:[self getValueByNull:statement :5]];
          
           record.Runs=[self getValueByNull:statement :6];
           record.BattingStyle=[self getValueByNull:statement :7];
           record.IsDotBall=[self getValueByNull:statement :8];
           record.IsWicket=[self getValueByNull:statement :9];
           record.matchName=[self getValueByNull:statement :10];
           record.ballno=[self getValueByNull:statement :11];
           record.playerdetail = [self getValueByNull:statement :12];
           record.line = [self getValueByNull:statement :13];
           record.length=[self getValueByNull:statement :14];
           record.lineType=[self getValueByNull:statement :15];
           record.shotType = [self getValueByNull:statement :16];
           record.BallRuns = [self getValueByNull:statement :17];
            record.WicketType = [self getValueByNull:statement :18];
                                
            [eventArray addObject:record];

                
        }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
}

-(NSMutableArray *) getLine
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE,METASUBCODEDESCRIPTION FROM METADATA WHERE  METADATATYPECODE='MDT011'" ];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                LineReportRecord *record=[[LineReportRecord alloc]init];
                
                record.metasubcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.metasubcodedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [eventArray addObject:record];
             
                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;
}

-(NSMutableArray *)getLength
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT METASUBCODE,METASUBCODEDESCRIPTION FROM METADATA WHERE  METADATATYPECODE='MDT010' AND METASUBCODE!='MSC038'" ];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW)
            {
                LengthReportRecord *record=[[LengthReportRecord alloc]init];
                
                record.metasubcode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.metasubcodedescription=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                [eventArray addObject:record];
                

                
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        
        sqlite3_close(dataBase);
        
    }
    return eventArray;

}

-(NSString *)getTeamCode:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)INNINGSNO
{
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"select teamcode from inningsevents where competitioncode='%@' and  matchcode ='%@' and inningsno='%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *TOTAL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
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
-(NSMutableArray *) getStrickerdetail :(NSString *) matchCode :(NSString * )Teamcode
{
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT PM.PLAYERNAME,PM.PLAYERCODE, COUNT (CASE WHEN MP.PLAYINGORDER <11 THEN 'PLAYED' END) PLAYER FROM MATCHTEAMPLAYERDETAILS AS MP INNER JOIN PLAYERMASTER AS PM ON PM.PLAYERCODE = MP.PLAYERCODE INNER JOIN TEAMMASTER AT ON AT.TEAMCODE = MP.TEAMCODE INNER JOIN METADATA ME ON ME.METASUBCODE = PM.PLAYERROLE WHERE MP.RECORDSTATUS = 'MSC001' AND PM.RECORDSTATUS = 'MSC001' AND MP.MATCHCODE = '%@' AND MP.TEAMCODE = '%@' GROUP BY PLAYINGORDER, PM.PLAYERNAME,MP.TEAMCODE,AT.TEAMNAME,ME.METASUBCODEDESCRIPTION ORDER BY MP.TEAMCODE",matchCode,Teamcode ];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                StrikerDetails *record=[[StrikerDetails alloc]init];
        
                record.playername=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.playercode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
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
