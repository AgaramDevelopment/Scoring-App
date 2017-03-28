//
//  DBManagerSpiderWagonReport.m
//  CAPScoringApp
//
//  Created by Raja sssss on 21/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerSpiderWagonReport.h"
#import "SpiderWagonRecords.h"
#import "Utitliy.h"

@implementation DBManagerSpiderWagonReport


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


//----------------------------------------------------------------------------------------------------------------------------------

//Spider Wagon Wheel
-(NSMutableArray *)getSpiderWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)STRIKERCODE:(NSString*)BOWLERCODE:(NSString*)RUNS:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)ISONSIDE

{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *spiderArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
         NSString *filter = [NSString stringWithFormat:@" as A WHERE ISONSIDE = %@ ",ISONSIDE ];
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT * FROM (SELECT BALL.WWREGION, (BALL.WWX1 ) WWX1, (BALL.WWY1 ) WWY1,(BALL.WWX2) WWX2,(BALL.WWY2 ) WWY2,(BALL.RUNS + CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 THEN BALL.OVERTHROW ELSE 0 END) RUNS, BALL.ISFOUR, BALL.ISSIX, CASE WHEN BALL.WWREGION IN ('MSC152', 'MSC153', 'MSC154', 'MSC180', 'MSC181', 'MSC182', 'MSC183', 'MSC184', 'MSC185', 'MSC186', 'MSC187', 'MSC188', 'MSC189', 'MSC190', 'MSC191', 'MSC192', 'MSC193', 'MSC194', 'MSC195', 'MSC196', 'MSC197', 'MSC198', 'MSC199', 'MSC200', 'MSC201', 'MSC202', 'MSC203', 'MSC204', 'MSC205', 'MSC206', 'MSC207', 'MSC208', 'MSC209', 'MSC210', 'MSC211', 'MSC212', 'MSC213', 'MSC214', 'MSC215', 'MSC216', 'MSC217', 'MSC241')THEN 0 WHEN BALL.WWREGION IN ('MSC155', 'MSC156', 'MSC157', 'MSC158', 'MSC159', 'MSC160', 'MSC161', 'MSC162', 'MSC163', 'MSC164', 'MSC165', 'MSC166', 'MSC167', 'MSC168', 'MSC169', 'MSC170', 'MSC171', 'MSC172', 'MSC173', 'MSC174', 'MSC175', 'MSC176', 'MSC177', 'MSC178', 'MSC179', 'MSC242', 'MSC243', 'MSC244')THEN 1 ELSE -1 END ISONSIDE, META.METADATATYPECODE SECTORREGIONCODE, META.METADATATYPEDESCRIPTION SECTORREGIONNAME, STKR.BATTINGSTYLE, PM.PLAYERCODE STRIKERCODE,PM.PLAYERNAME STRIKER,PM1.PLAYERCODE NONSTRIKERCODE,PM1.PLAYERNAME NONSTRIKER,PM2.PLAYERCODE BOWLERCODE,PM2.PLAYERNAME BOWLER,IFNULL((ME.METASUBCODEDESCRIPTION),0) AS LINE, IFNULL((ME1.METASUBCODEDESCRIPTION),0) AS LENGTH, IFNULL((BT.BOWLTYPE),0) AS BOWLTYPE, MRM.MATCHNAME AS MATCHNAME, IFNULL((CASE WHEN IFNULL(SHOTTYPECATEGORY,'') <> '' AND IFNULL(BALL.SHOTTYPE,'') <> ''THEN MDSHOTTYPE.SHOTNAME+' '+MDSHOTTYPECAT.METASUBCODEDESCRIPTION ELSE MDSHOTTYPE.SHOTNAME END),0) AS SHOTTYPE , MDRE.METADATATYPEDESCRIPTION SECTORREGION, BALL.BALLCODE, ((BALL.OVERNO)+'.'+ (BALL.BALLNO)) AS BALLNO, BALL.OVERNO , BALL.BALLNO AS BALLNO1,BALL.BALLCOUNT,BALL.ISLEGALBALL,BALL.ISFOUR,BALL.ISSIX,BALL.RUNS,BALL.OVERTHROW,BALL.WIDE,BALL.NOBALL, BALL.BYES,BALL.LEGBYES,BALL.TOTALEXTRAS, BALL.GRANDTOTAL,IFNULL((WKT.WICKETNO),0) AS WICKETNO, BALL.MARKEDFOREDIT, IFNULL((PTY.PENALTYRUNS),0) AS PENALTYRUNS, IFNULL((PTY.PENALTYTYPECODE),0) AS PENALTYTYPECODE, CASE WKT.WICKETTYPE WHEN 'MSC095' THEN 'c ' + FLDRC.PLAYERNAME + ' b ' + PM2.PLAYERNAME WHEN 'MSC096' THEN 'b ' + PM2.PLAYERNAME WHEN 'MSC097' THEN 'run out ' + FLDRC.PLAYERNAME WHEN 'MSC104' THEN 'st ' + FLDRC.PLAYERNAME + ' b '+ PM2.PLAYERNAME WHEN 'MSC098' THEN 'lbw ' + PM2.PLAYERNAME WHEN 'MSC099' THEN 'hit wicket' +' '+ PM2.PLAYERNAME WHEN 'MSC100' THEN 'Handled the ball' WHEN 'MSC105' THEN 'c & b' +' '+ PM2.PLAYERNAME WHEN 'MSC101' THEN 'Timed Out' WHEN 'MSC102' THEN 'Retired Hurt' WHEN 'MSC103' THEN 'Hitting Twice' WHEN 'MSC107' THEN 'Mankading' WHEN 'MSC108' THEN 'Retired Out' WHEN 'MSC106' THEN 'Obstructing the field' WHEN 'MSC133' THEN 'Absent Hurt' ELSE 'Not Out' END AS WICKETTYPE FROM BALLEVENTS BALL INNER JOIN METADATA META ON BALL.WWREGION = META.METASUBCODE INNER JOIN PLAYERMASTER STKR ON BALL.STRIKERCODE = STKR.PLAYERCODE AND STKR.RECORDSTATUS='MSC001' INNER JOIN MATCHREGISTRATION MRM ON MRM.MATCHCODE = BALL.MATCHCODE AND MRM.RECORDSTATUS='MSC001' INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MRM.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001' LEFT JOIN WICKETEVENTS WKT ON  BALL.COMPETITIONCODE	 =	WKT.COMPETITIONCODE AND BALL.MATCHCODE			 =	WKT.MATCHCODE AND BALL.INNINGSNO			 =	WKT.INNINGSNO AND BALL.BALLCODE			 =	WKT.BALLCODE LEFT JOIN PENALTYDETAILS PTY ON BALL.BALLCODE = PTY.BALLCODE INNER JOIN  PLAYERMASTER PM ON PM.PLAYERCODE=BALL.STRIKERCODE AND PM.RECORDSTATUS='MSC001' INNER JOIN  PLAYERMASTER PM1 ON PM1.PLAYERCODE=BALL.NONSTRIKERCODE AND PM1.RECORDSTATUS='MSC001' INNER JOIN  PLAYERMASTER PM2 ON PM2.PLAYERCODE=BALL.BOWLERCODE AND PM2.RECORDSTATUS='MSC001' LEFT JOIN  METADATA ME ON ME.METASUBCODE=BALL.PMLINECODE LEFT JOIN  METADATA ME1 ON ME1.METASUBCODE=BALL.PMLENGTHCODE LEFT JOIN   BOWLTYPE BT ON BT.BOWLTYPECODE=BALL.BOWLTYPE AND BT.RECORDSTATUS='MSC001' LEFT JOIN METADATA MDSHOTTYPECAT ON MDSHOTTYPECAT.METASUBCODE=BALL.SHOTTYPECATEGORY LEFT JOIN SHOTTYPE MDSHOTTYPE ON MDSHOTTYPE.SHOTCODE=BALL.SHOTTYPE AND MDSHOTTYPE.RECORDSTATUS='MSC001' INNER JOIN  METADATA MDRE ON MDRE.METASUBCODE=BALL.WWREGION LEFT JOIN METADATA MDWIC ON MDWIC.METASUBCODE=WKT.WICKETTYPE LEFT JOIN PLAYERMASTER FLDRC   ON FLDRC.PLAYERCODE = WKT.FIELDINGPLAYER WHERE ('%@'='' OR CM.MATCHTYPE = '%@') AND ('%@'='' OR BALL.COMPETITIONCODE = '%@') AND ('%@'='' OR BALL.MATCHCODE = '%@') AND ('%@'='' OR BALL.TEAMCODE = '%@') AND ('%@'='' OR BALL.INNINGSNO = '%@') AND ('%@'='' OR BALL.STRIKERCODE = '%@') AND ('%@'='' OR BALL.BOWLERCODE = '%@') AND ('%@'=''OR BALL.RUNS = '%@') ORDER BY  BALL.BALLCODE) %@",MATCHTYPECODE,MATCHTYPECODE,COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO,STRIKERCODE,STRIKERCODE,BOWLERCODE,BOWLERCODE,RUNS,RUNS,[ISONSIDE isEqual:@""]?@"":filter];
        
        
        
        
        const char *update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                SpiderWagonRecords *record=[[SpiderWagonRecords alloc]init];
   
                record.WWREGION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                record.WWX1 = [Utitliy getWagonWheelXAxisForReportDevice:[self getValueByNull:statement :1]];
                record.WWY1 =[Utitliy getWagonWheelYAxisForReportDevice:[self getValueByNull:statement :2]];
                record.WWX2   =[Utitliy getWagonWheelXAxisForReportDevice:[self getValueByNull:statement :3]];
                record.WWY2       =[Utitliy getWagonWheelYAxisForReportDevice:[self getValueByNull:statement :4]];

                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.ISFOUR=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.ISSIX=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.ISONSIDE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.SECTORREGIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.SECTORREGIONNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                record.STRIKER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                
                record.NONSTRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                
                record.NONSTRIKER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                
                record.BOWLER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                record.LINE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                record.LENGTH=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                record.BOWLTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 19)];
                record.MATCHNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 20)];
                record.SHOTTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 21)];
                record.SECTORREGION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 22)];
                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 23)];
                record.BALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 24)];
                record.OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 25)];
                record.BALLNO1=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 26)];
                record.BALLCOUNT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 27)];
                record.ISLEGALBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 28)];
                record.OVERTHROW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 29)];
                record.WIDE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 30)];
                record.NOBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 31)];
                record.BYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 32)];
                record.LEGBYES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 33)];
                record.TOTALEXTRAS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 34)];
                record.GRANDTOTAL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 35)];
                record.MARKEDFOREDIT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 36)];
                record.PENALTYRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 37)];
                record.PENALTYTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 38)];
                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 39)];

               
                
       
                [spiderArray addObject:record];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return spiderArray;
    }
}


//Sector Wagon Wheel
-(NSMutableArray *)getSectorWagon:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)STRIKERCODE:(NSString*)BOWLERCODE:(NSString*)RUNS:(NSString*)ISFOUR:(NSString*)ISSIX:(NSString*)ISONSIDE

{
    
    @synchronized ([Utitliy syncId])  {
        
    NSMutableArray *spiderArray=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *filter = [NSString stringWithFormat:@" as A WHERE ISONSIDE = %@ ",ISONSIDE ];
        
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT * FROM (SELECT BALL.WWREGION, (BALL.WWX1 ) WWX1, (BALL.WWY1 ) WWY1,(BALL.WWX2) WWX2,(BALL.WWY2 ) WWY2, (BALL.RUNS + CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 THEN BALL.OVERTHROW ELSE 0 END) RUNS,BALL.ISFOUR, BALL.ISSIX , CASE WHEN BALL.WWREGION IN ('MSC152', 'MSC153', 'MSC154', 'MSC180', 'MSC181', 'MSC182', 'MSC183', 'MSC184', 'MSC185', 'MSC186', 'MSC187', 'MSC188', 'MSC189', 'MSC190', 'MSC191', 'MSC192', 'MSC193', 'MSC194', 'MSC195', 'MSC196', 'MSC197', 'MSC198', 'MSC199', 'MSC200', 'MSC201', 'MSC202', 'MSC203', 'MSC204', 'MSC205', 'MSC206', 'MSC207', 'MSC208', 'MSC209', 'MSC210', 'MSC211', 'MSC212', 'MSC213', 'MSC214', 'MSC215', 'MSC216', 'MSC217', 'MSC241') THEN 0  WHEN BALL.WWREGION IN ('MSC155', 'MSC156', 'MSC157', 'MSC158', 'MSC159', 'MSC160', 'MSC161', 'MSC162', 'MSC163', 'MSC164', 'MSC165', 'MSC166', 'MSC167', 'MSC168', 'MSC169', 'MSC170', 'MSC171', 'MSC172', 'MSC173', 'MSC174', 'MSC175', 'MSC176', 'MSC177', 'MSC178', 'MSC179', 'MSC242', 'MSC243', 'MSC244') THEN 1  ELSE -1 END ISONSIDE, META.METADATATYPECODE SECTORREGIONCODE, META.METADATATYPEDESCRIPTION SECTORREGIONNAME, STKR.BATTINGSTYLE FROM BALLEVENTS BALL INNER JOIN MATCHREGISTRATION MRM ON MRM.MATCHCODE = BALL.MATCHCODE AND MRM.RECORDSTATUS='MSC001' INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MRM.COMPETITIONCODE  AND CM.RECORDSTATUS='MSC001' INNER JOIN METADATA META ON BALL.WWREGION = META.METASUBCODE INNER JOIN PLAYERMASTER STKR ON BALL.STRIKERCODE = STKR.PLAYERCODE AND STKR.RECORDSTATUS='MSC001' INNER JOIN PLAYERMASTER PM1 ON BALL.BOWLERCODE = PM1.PLAYERCODE AND PM1.RECORDSTATUS='MSC001' LEFT JOIN WICKETEVENTS WKT ON  BALL.COMPETITIONCODE	 =	WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.BALLCODE = WKT.BALLCODE WHERE ('%@'='' OR CM.MATCHTYPE = '%@') AND ('%@'='' OR BALL.COMPETITIONCODE = '%@') AND ('%@'='' OR BALL.MATCHCODE = '%@') AND ('%@'='' OR BALL.TEAMCODE = '%@') AND ('%@'='' OR BALL.INNINGSNO = '%@') AND ('%@'='' OR BALL.STRIKERCODE = '%@') AND ('%@'='' OR BALL.BOWLERCODE = '%@') AND ('%@'=''OR BALL.RUNS = '%@') ORDER BY  BALL.BALLCODE) %@",MATCHTYPECODE,MATCHTYPECODE,COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO,STRIKERCODE,STRIKERCODE,BOWLERCODE,BOWLERCODE,RUNS,RUNS,[ISONSIDE isEqual:@""]?@"":filter];
    
        const char *update_stmt = [updateSQL UTF8String];
        
        if (sqlite3_prepare(dataBase, update_stmt,-1, &statement, NULL)== SQLITE_OK)
        {
            
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                SpiderWagonRecords *record=[[SpiderWagonRecords alloc]init];
                
                record.WWREGION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
                record.WWX1 = [Utitliy getWagonWheelXAxisForReportDevice:[self getValueByNull:statement :1]];
                record.WWY1 =[Utitliy getWagonWheelYAxisForReportDevice:[self getValueByNull:statement :2]];
                record.WWX2   =[Utitliy getWagonWheelXAxisForReportDevice:[self getValueByNull:statement :3]];
                record.WWY2       =[Utitliy getWagonWheelYAxisForReportDevice:[self getValueByNull:statement :4]];
                
                record.RUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.ISFOUR=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.ISSIX=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                record.ISONSIDE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                record.SECTORREGIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                record.SECTORREGIONNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                
                [spiderArray addObject:record];
            }
            
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(dataBase);
    }
    return spiderArray;
    }
}


-(NSMutableArray *) getStrickerdetail :(NSString *) matchCode :(NSString * )Teamcode
{
  @synchronized ([Utitliy syncId])  {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT PM.PLAYERNAME,PM.PLAYERCODE,PM.BATTINGSTYLE, COUNT (CASE WHEN MP.PLAYINGORDER <11 THEN 'PLAYED' END) PLAYER FROM MATCHTEAMPLAYERDETAILS AS MP INNER JOIN PLAYERMASTER AS PM ON PM.PLAYERCODE = MP.PLAYERCODE INNER JOIN TEAMMASTER AT ON AT.TEAMCODE = MP.TEAMCODE INNER JOIN METADATA ME ON ME.METASUBCODE = PM.PLAYERROLE WHERE MP.RECORDSTATUS = 'MSC001' AND PM.RECORDSTATUS = 'MSC001' AND MP.MATCHCODE = '%@' AND MP.TEAMCODE = '%@' GROUP BY PLAYINGORDER, PM.PLAYERNAME,MP.TEAMCODE,AT.TEAMNAME,ME.METASUBCODEDESCRIPTION ORDER BY MP.TEAMCODE",matchCode,Teamcode ];
        
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                SpiderWagonRecords *record=[[SpiderWagonRecords alloc]init];
                
                record.STRIKERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
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


-(NSMutableArray *) getBowlerdetail :(NSString *) matchCode :(NSString * )Teamcode:(NSString * )InningsNo
{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];
    
    NSString *dbPath = [self getDBPath];
    
    sqlite3 *dataBase;
    const char *stmt;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String], &dataBase) == SQLITE_OK)
    {
        
        NSString *query=[NSString stringWithFormat:@"SELECT PM.PLAYERNAME,PM.PLAYERCODE FROM BOWLINGSUMMARY BS INNER JOIN PLAYERMASTER AS PM ON PM.PLAYERCODE = BS.BOWLERCODE WHERE BS.MATCHCODE = '%@' AND BS.BOWLINGTEAMCODE = '%@' AND BS.INNINGSNO = '%@'",matchCode,Teamcode,InningsNo];
    
        stmt=[query UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                SpiderWagonRecords *record=[[SpiderWagonRecords alloc]init];
                
                record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
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

-(NSString *) getTeamBCode:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TEAMBCODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
                               
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
        NSString *teamBCode =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return teamBCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
}




-(NSString *) getTotalRuns:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(BALL.RUNS + CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 THEN BALL.OVERTHROW ELSE 0 END),0) RUNS FROM BALLEVENTS BALL INNER JOIN MATCHREGISTRATION MRM ON MRM.MATCHCODE = BALL.MATCHCODE AND MRM.RECORDSTATUS='MSC001' INNER JOIN COMPETITION CM ON CM.COMPETITIONCODE=MRM.COMPETITIONCODE AND CM.RECORDSTATUS='MSC001' WHERE ('%@'='' OR CM.MATCHTYPE = '%@') AND ('%@'='' OR BALL.COMPETITIONCODE = '%@') AND ('%@'='' OR BALL.MATCHCODE = '%@') AND ('%@'='' OR BALL.TEAMCODE = '%@') AND ('%@'='' OR BALL.INNINGSNO = '%@')ORDER BY  BALL.BALLCODE",MATCHTYPECODE,MATCHTYPECODE,COMPETITIONCODE,COMPETITIONCODE,MATCHCODE,MATCHCODE,TEAMCODE,TEAMCODE,INNINGSNO,INNINGSNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *teamBCode =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return teamBCode;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
        
    }
    return @"";
    }
    
}


@end
