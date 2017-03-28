//
//  BattingPlayerStatistics.m
//  CAPScoringApp
//
//  Created by APPLE on 08/09/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BattingPlayerStatistics.h"
#import <sqlite3.h>
#import "BattingPayerStatisticsRecord.h"
#import "BattingStatisticsPitchRecord.h"
#import "Utitliy.h"


static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";

@implementation BattingPlayerStatistics


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
-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}




-(NSMutableArray*)  GetFETCHSBBATTINGPLAYERSTATISTICSWagon :(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE : (NSString *) INNINGSNO : (NSString*) PLAYERCODE
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *GetBowlingTDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.WWREGION, (BALL.WWX1 - 24) WWX1, (BALL.WWY1 + 2) WWY1, (BALL.WWX2 - 24) WWX2, (BALL.WWY2 + 2) WWY2, (BALL.RUNS + (CASE WHEN BYES = 0 AND LEGBYES = 0 THEN OVERTHROW ELSE 0 END)) RUNS, BALL.ISFOUR, BALL.ISSIX, CASE WHEN BALL.WWREGION IN ('MSC152', 'MSC153', 'MSC154', 'MSC180', 'MSC181', 'MSC182', 'MSC183', 'MSC184', 'MSC185', 'MSC186', 'MSC187','MSC188', 'MSC189', 'MSC190', 'MSC191', 'MSC192', 'MSC193', 'MSC194', 'MSC195', 'MSC196', 'MSC197', 'MSC198', 'MSC199', 'MSC200', 'MSC201','MSC202', 'MSC203', 'MSC204', 'MSC205', 'MSC206', 'MSC207', 'MSC208', 'MSC209', 'MSC210', 'MSC211', 'MSC212', 'MSC213', 'MSC214', 'MSC215','MSC216', 'MSC217', 'MSC241')THEN 0 WHEN BALL.WWREGION IN ('MSC155', 'MSC156', 'MSC157', 'MSC158', 'MSC159', 'MSC160', 'MSC161', 'MSC162', 'MSC163', 'MSC164', 'MSC165', 'MSC166','MSC167', 'MSC168', 'MSC169', 'MSC170', 'MSC171', 'MSC172', 'MSC173', 'MSC174', 'MSC175', 'MSC176', 'MSC177', 'MSC178', 'MSC179', 'MSC242','MSC243', 'MSC244')THEN 1  ELSE -1  END ISONSIDE, META.METADATATYPECODE SECTORREGIONCODE, META.METADATATYPEDESCRIPTION SECTORREGIONNAME, CASE WHEN BYES = 0 AND LEGBYES = 0 THEN 0 ELSE 1 END OTHERRUNS FROM BALLEVENTS BALL left JOIN METADATA META ON BALL.WWREGION = META.METASUBCODE WHERE BALL.COMPETITIONCODE	= '%@' AND   BALL.MATCHCODE			= '%@'AND   BALL.INNINGSNO			= '%@' AND   BALL.STRIKERCODE		= '%@' AND   BALL.WIDE         = 0; ",COMPETITIONCODE,MATCHCODE,INNINGSNO,PLAYERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){

                BattingPayerStatisticsRecord *record=[[BattingPayerStatisticsRecord alloc]init];
                record.WWRegion=[self getValueByNull:statement :0];
//                record.WWX1=[self getValueByNull:statement :1];
//                
//                record.WWY1=[self getValueByNull:statement :2];
//                
//                record.WWX2=[self getValueByNull:statement :3];
//                
//                record.WWY2=[self getValueByNull:statement :4];
//                
                
                
                
                record.WWX1 = [Utitliy getWagonWheelXAxisForDevice:[self getValueByNull:statement :1]];
                record.WWY1 =[Utitliy getWagonWheelYAxisForDevice:[self getValueByNull:statement :2]];
                record.WWX2   =[Utitliy getWagonWheelXAxisForDevice:[self getValueByNull:statement :3]];
                record.WWY2       =[Utitliy getWagonWheelYAxisForDevice:[self getValueByNull:statement :4]];
                
                

                
                record.RUNS=[self getValueByNull:statement :5];
                
                record.ISFOUR=[self getValueByNull:statement :6];
                
                record.ISSIX=[self getValueByNull:statement :7];
                
                record.ISONSIDE=[self getValueByNull:statement :8];
                
                record.SECTORREGIONCODE=[self getValueByNull:statement :9];
                
                record.SECTORREGIONNAME=[self getValueByNull:statement :10];
                
                record.OTHERRUNS=[self getValueByNull:statement :11];
                
                
                [GetBowlingTDetails addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return GetBowlingTDetails;
	}
}


-(NSMutableArray*)  GetFETCHSBBATTINGPLAYERSTATISTICSPitch :(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE : (NSString *) INNINGSNO : (NSString*) PLAYERCODE
{
@synchronized ([Utitliy syncId]) {
    NSMutableArray *GetBowlingTDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.PMLINECODE,MDLIN.METASUBCODEDESCRIPTION PMLINENAME,BALL.PMLENGTHCODE,MDLEN.METASUBCODEDESCRIPTION PMLENGTHNAME,BALL.PMX2,BALL.PMY2,STKR.BATTINGSTYLE,(BALL.RUNS + (CASE WHEN BYES = 0 AND LEGBYES = 0 THEN OVERTHROW ELSE 0 END)) RUNS,(CASE WHEN (BALL.RUNS + (CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 THEN BALL.OVERTHROW ELSE 0 END) + BALL.WIDE) = 0 THEN 1 ELSE 0 END) ISDOTBALL,(CASE WHEN WKT.WICKETTYPE IS NULL THEN 0 ELSE 1 END) ISWICKET,CASE WHEN BALL.WWREGION IN ('MSC152', 'MSC153', 'MSC154', 'MSC180', 'MSC181', 'MSC182', 'MSC183', 'MSC184', 'MSC185', 'MSC186', 'MSC187', 'MSC188','MSC189', 'MSC190', 'MSC191', 'MSC192', 'MSC193', 'MSC194', 'MSC195', 'MSC196', 'MSC197', 'MSC198', 'MSC199', 'MSC200', 'MSC201', 'MSC202','MSC203', 'MSC204', 'MSC205', 'MSC206', 'MSC207', 'MSC208', 'MSC209', 'MSC210', 'MSC211', 'MSC212', 'MSC213', 'MSC214', 'MSC215', 'MSC216','MSC217', 'MSC241') THEN 0 WHEN BALL.WWREGION IN ('MSC155', 'MSC156', 'MSC157', 'MSC158', 'MSC159', 'MSC160', 'MSC161', 'MSC162', 'MSC163', 'MSC164', 'MSC165', 'MSC166', 'MSC167','MSC168', 'MSC169', 'MSC170', 'MSC171', 'MSC172', 'MSC173', 'MSC174', 'MSC175', 'MSC176', 'MSC177', 'MSC178', 'MSC179', 'MSC242', 'MSC243', 'MSC244') THEN 1 ELSE -1 END ISONSIDE FROM BALLEVENTS BALL INNER JOIN PLAYERMASTER STKR ON BALL.STRIKERCODE = STKR.PLAYERCODE LEFT JOIN METADATA MDLIN ON BALL.PMLINECODE = MDLIN.METASUBCODE LEFT JOIN METADATA MDLEN ON BALL.PMLENGTHCODE = MDLEN.METASUBCODE LEFT JOIN WICKETEVENTS WKT ON BALL.COMPETITIONCODE = WKT.COMPETITIONCODE AND BALL.MATCHCODE = WKT.MATCHCODE AND BALL.INNINGSNO = WKT.INNINGSNO AND BALL.TEAMCODE = WKT.TEAMCODE AND BALL.BALLCODE = WKT.BALLCODE WHERE BALL.COMPETITIONCODE	= '%@' AND   BALL.MATCHCODE		= '%@' AND   BALL.INNINGSNO	= '%@' AND   BALL.STRIKERCODE = '%@' AND   BALL.WIDE = 0",COMPETITIONCODE,MATCHCODE,INNINGSNO,PLAYERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){

                BattingStatisticsPitchRecord *record=[[BattingStatisticsPitchRecord alloc]init];
                record.PMLinecode=[self getValueByNull:statement :0];
                record.PMLineName=[self getValueByNull:statement :1];
                record.PMLengthCode=[self getValueByNull:statement :2];
                record.PMLengthName=[self getValueByNull:statement :3];
                //record.PMX2=[self getValueByNull:statement :4];
                //record.PMy2=[self getValueByNull:statement :5];
                
                record.PMX2 = [Utitliy getPitchMapXAxisForDevice:[self getValueByNull:statement :4]];
                record.PMy2 = [Utitliy getPitchMapYAxisForDevice:[self getValueByNull:statement :5]];
                
                
                record.BattingStyle=[self getValueByNull:statement :6];
                record.Runs=[self getValueByNull:statement :7];
                record.isDontBall=[self getValueByNull:statement :8];
                record.IsWicket=[self getValueByNull:statement :9];
                record.IsonSide=[self getValueByNull:statement :10];
                [GetBowlingTDetails addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return GetBowlingTDetails;
}
}

-(NSMutableArray*) GetBATSMANTIMEDETAILS :(NSString *) COMPETITIONCODE:(NSString *) MATCHCODE : (NSString *) INNINGSNO : (NSString*) PLAYERCODE
{
    @synchronized ([Utitliy syncId]) {
    NSMutableArray *GetBowlingTDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CONVERT(VARCHAR(5),INTIME,108) INTIME, CONVERT(VARCHAR(5),OUTTIME,108) OUTTIME FROM PLAYERINOUTTIME WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND PLAYERCODE = '%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO,PLAYERCODE];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK){
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //                ChangeTeamRecord *record=[[ChangeTeamRecord alloc]init];
                //                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                //                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                //                [GetBowlingTDetails addObject:record];
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_close(dataBase);
    }
    return GetBowlingTDetails;
    }
}


@end
