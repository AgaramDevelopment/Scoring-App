//
//  DBManagerInsertScoreEngine.m
//  CAPScoringApp
//
//  Created by Stephen on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DBManagerInsertScoreEngine.h"
#import "OverBallCountRecord.h"
#import "UpdateScoreEngineRecord.h"
#import "PushSyncDBMANAGER.h"
#import "Utitliy.h"


#import <sqlite3.h>

@implementation DBManagerInsertScoreEngine

static NSString *SQLITE_FILE_NAME = @"TNCA_DATABASE.sqlite";


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


-(NSString*) GetBallCodeForInsertScoreEngine:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE{
 
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    
    if(sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
    }
    return @"";
    }
}


-(NSString*) getBowlingCode:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE : (NSString*)TEAMCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN TEAMACODE = '%@' THEN TEAMBCODE ELSE TEAMACODE END  AS BOWLINGCODE FROM MATCHREGISTRATION WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",TEAMCODE,COMPETITIONCODE,MATCHCODE];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return @"";
    }
}




-(BOOL) UpdateMatchStatusForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE{
    
  @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE MATCHREGISTRATION SET MATCHSTATUS = 'MSC124' 	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'",COMPETITIONCODE, MATCHCODE];
        
        const char *selectStmt = [updateSQL UTF8String];
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
  }
}

-(NSNumber*) GetBallCountForInsertScoreEngine:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSNumber*) INNINGSNO : (NSNumber*) OVERNO:(NSNumber*) BALLNO{
  @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLCOUNT),0) + 1   as BALLCOUNT FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@' AND BALLNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE, INNINGSNO, OVERNO,BALLNO];
        
        stmt=[updateSQL UTF8String];
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
-(NSString*) GetBallCodesForInsertScoreEngine:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE: (NSString*) TEAMCODE:(NSNumber*) INNINGSNO : (NSNumber*) OVERNO:(NSNumber*) BALLNO:(NSNumber*) BALLCOUNT{
    
   
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCODE FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@' AND BALLNO='%@' AND BALLCOUNT='%@' ",COMPETITIONCODE,MATCHCODE,TEAMCODE, INNINGSNO, OVERNO,BALLNO,BALLCOUNT];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return BALLCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
    }
    return @"";
    }
}



-(NSString*)  GetMaxIdForInsertScoreEngine:(NSString*) MATCHCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT '%@' || substr(replace(substr(quote(zeroblob((10 + 1) / 2)), 3, 10), '0', '0') || cast(IFNULL(MAX(cast(substr(BALLCODE,-10) as text)),0) + 1 as text),-10)  FROM BALLEVENTS WHERE MATCHCODE = '%@' ",MATCHCODE,MATCHCODE];
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


-(NSMutableArray*) GetInsertTypeGreaterthanZeroDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) BALLCODE
{
    
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *GetInsertTypeGreaterthanZeroDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT INNINGSNO, TEAMCODE, OVERNO,  BALLNO, BALLCOUNT,ISLEGALBALL, STRIKERCODE,BOWLERCODE FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND BALLCODE = '%@' ",COMPETITIONCODE, MATCHCODE,BALLCODE ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                GetInsertTypeGreaterthanZeroDetail *record=[[GetInsertTypeGreaterthanZeroDetail alloc]init];
                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                record.OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                record.BALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                record.BALLCOUNT=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                record.ISLEGALBALL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                record.STRIKERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
                [GetInsertTypeGreaterthanZeroDetails addObject:record];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetInsertTypeGreaterthanZeroDetails;
    }
}
-(BOOL)  UpdateBallEventtableForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) TEAMCODE: (NSNumber*) T_OVERNO : (NSNumber*) T_BALLNO{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND TEAMCODE = '%@' AND OVERNO = %@ AND BALLNO >= %@",COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMCODE , T_OVERNO , T_BALLNO];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
}

-(BOOL)  UpdateBallEventtableForAfterInsert: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) TEAMCODE: (NSNumber*) T_OVERNO : (NSNumber*) T_BALLNO{
    
   @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLNO = BALLNO + 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = %@ AND TEAMCODE = '%@' AND OVERNO = %@ AND BALLNO > %@",COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMCODE , T_OVERNO , T_BALLNO];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
   }
}



-(BOOL)  UpdateBallEventtablesForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) TEAMCODE: (NSNumber*) T_OVERNO : (NSNumber*) T_BALLNO:(NSNumber*) T_BALLCOUNT{
    
  @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET BALLCOUNT = (BALLCOUNT - '%@') + 1	, BALLNO = BALLNO + 1	WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'	AND INNINGSNO = '%@' AND TEAMCODE = '%@' AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT >= '%@'",T_BALLCOUNT,COMPETITIONCODE, MATCHCODE,INNINGSNO ,TEAMCODE  ,T_OVERNO , T_BALLNO,T_BALLCOUNT];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
  }
}

-(BOOL)   UpdateBallEventtablesInAddBallNoForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) TEAMCODE: (NSNumber*) T_OVERNO : (NSNumber*) T_BALLNO:(NSNumber*) T_BALLCOUNT{
    
  @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS  SET BALLCOUNT = (BALLCOUNT - '%@'), BALLNO = BALLNO + 1 WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND TEAMCODE = '%@' AND OVERNO = '%@' AND BALLNO = '%@' AND BALLCOUNT > '%@'",T_BALLCOUNT,COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMCODE, T_OVERNO , T_BALLNO,T_BALLCOUNT];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
  }
}

-(BOOL)   InsertBallEventForInsertScoreEngine:(NSString*) BALLCODENO:(NSNumber*) N_BALLNO: (NSNumber*) N_BALLCOUNT: (NSNumber*) BALLSPEED: (NSNumber*) UNCOMFORTCLASSIFCATION:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) INNINGSNO : (NSString*) TEAMCODE:(NSString*) BALLCODE {
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BALLEVENTS (BALLCODE , COMPETITIONCODE , MATCHCODE, TEAMCODE ,INNINGSNO,DAYNO ,OVERNO ,BALLNO ,BALLCOUNT ,SESSIONNO ,STRIKERCODE, NONSTRIKERCODE,BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE, UMPIRE2CODE , ATWOROTW,BOWLINGEND ,BOWLTYPE ,SHOTTYPE , SHOTTYPECATEGORY , ISLEGALBALL ,ISFOUR ,ISSIX ,  RUNS ,OVERTHROW ,TOTALRUNS , WIDE , NOBALL ,BYES ,LEGBYES , PENALTY ,TOTALEXTRAS ,GRANDTOTAL ,RBW ,PMLINECODE ,PMLENGTHCODE , PMSTRIKEPOINT ,PMSTRIKEPOINTLINECODE ,PMX1 , PMY1 ,PMX2 , PMY2 ,PMX3 ,PMY3 , WWREGION,WWX1 , WWY1 , WWX2 , WWY2 ,BALLDURATION ,ISAPPEAL ,ISBEATEN , ISUNCOMFORT ,ISWTB ,ISRELEASESHOT ,MARKEDFOREDIT ,REMARKS ,BALLSPEED ,UNCOMFORTCLASSIFCATION)SELECT '%@',  COMPETITIONCODE,   MATCHCODE, TEAMCODE, INNINGSNO,DAYNO,  OVERNO,'%@','%@', SESSIONNO,  STRIKERCODE, 	NONSTRIKERCODE, BOWLERCODE, WICKETKEEPERCODE, UMPIRE1CODE, UMPIRE2CODE, ATWOROTW,BOWLINGEND, NULL, NULL,  NULL, 1, 0, 0, 0,0,0,0, 0, 0,0,0,0, 0, 0, NULL, NULL,NULL,NULL, 1,1,1,1,1,1,NULL, 165,124, 165, 124, 0,0,0, 0, 0, 0, 0, NULL, '%@', '%@' FROM BALLEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND TEAMCODE = '%@' AND BALLCODE ='%@'",BALLCODENO,N_BALLNO,N_BALLCOUNT,BALLSPEED,UNCOMFORTCLASSIFCATION,COMPETITIONCODE,MATCHCODE,INNINGSNO,TEAMCODE,BALLCODE];
        
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC250" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
}
//-(BOOL)  UpdateOverBallCountInBallEventtForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) T_OVERNO{
//
//
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET OVERBALLCOUNT = SEQNO 	FROM 	(SELECT ROW_NUMBER() OVER (ORDER BY BALLNO, BALLCOUNT) SEQNO, BALLCODE AS BALLID 				FROM BALLEVENTS BE 				WHERE COMPETITIONCODE = '%@'				AND MATCHCODE = '%@'				AND INNINGSNO = '%@'				AND TEAMCODE = '%@'				AND OVERNO = '%@'			) AS BALL			WHERE BALLCODE = BALL.BALLID			AND COMPETITIONCODE = '%@'			AND MATCHCODE = '%@'			AND INNINGSNO = '%@'			AND TEAMCODE = '%@'			AND OVERNO = '%@'",COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMCODE, T_OVERNO ,COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMCODE, T_OVERNO ];
//
//        const char *selectStmt = [updateSQL UTF8String];
//
//        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
//        {
//            while(sqlite3_step(statement)==SQLITE_DONE){
//                sqlite3_reset(statement);
//                return YES;
//            }
//        }
//    }
//    sqlite3_reset(statement);
//    return NO;
//
//}


-(BOOL)  UpdateOverBallCountInBallEventtForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) T_OVERNO

{
    @synchronized ([Utitliy syncId])  {
    
    NSMutableArray *ballEventArray = [[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BM.BALLCODE, BM.COMPETITIONCODE, BM.MATCHCODE, BM.TEAMCODE, BM.INNINGSNO, BM.OVERNO, BM.BALLNO, BM.BALLCOUNT, (SELECT COUNT(1) FROM BALLEVENTS BEVNT WHERE BEVNT.COMPETITIONCODE = BM.COMPETITIONCODE AND BEVNT.MATCHCODE = BM.MATCHCODE AND BEVNT.TEAMCODE = BM.TEAMCODE AND BEVNT.INNINGSNO = BM.INNINGSNO AND BEVNT.OVERNO = BM.OVERNO AND (BEVNT.OVERNO || '.' || BEVNT.BALLNO || BEVNT.BALLCOUNT) <= (BM.OVERNO || '.' || BM.BALLNO || BM.BALLCOUNT)) OVERBALLCOUNT FROM (SELECT BE.BALLCODE, BE.COMPETITIONCODE, BE.MATCHCODE, BE.TEAMCODE, BE.INNINGSNO, BE.OVERNO, BE.BALLNO, BE.BALLCOUNT FROM BALLEVENTS BE WHERE BE.COMPETITIONCODE = '%@' AND BE.MATCHCODE = '%@' AND BE.TEAMCODE = '%@' AND BE.INNINGSNO = '%@' AND BE.OVERNO = '%@') BM",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,T_OVERNO];
        
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                BallEventSummaryRecord *record = [[BallEventSummaryRecord alloc]init];
                
                record.BALLCODE = [self getValueByNull: statement:0];
                record.COMPETITIONCODE = [self getValueByNull: statement:1];
                record.MATCHCODE = [self getValueByNull: statement:2];
                record.TEAMCODE = [self getValueByNull: statement:3];
                record.INNINGSNO = [self getValueByNull: statement:4];
                record.OVERNO = [self getValueByNull: statement:5];
                record.BALLNO = [self getValueByNull: statement:6];
                record.BALLCOUNT = [self getValueByNull: statement:7];
                record.OVERBALLCOUNT = [self getValueByNull: statement:8];
                
                [ballEventArray addObject:record];
                
            }
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    
    
    
    
    for(int i =0;i<ballEventArray.count;i++){
        
        BallEventSummaryRecord *record = [ballEventArray objectAtIndex:i];
        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
        {
            NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET OVERBALLCOUNT = '%@' 	 WHERE BALLCODE = '%@' AND COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND TEAMCODE = '%@' AND OVERNO = '%@'",record.OVERBALLCOUNT,record.BALLCODE, record.COMPETITIONCODE,record.MATCHCODE,record.INNINGSNO, record.TEAMCODE ,record.OVERNO];
            const char *update_stmt = [updateSQL UTF8String];
            sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                //ADDED
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:record.MATCHCODE :@"BALLEVENTS" :@"MSC251" :updateSQL];
            }
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(dataBase);
    }
    
    return  YES;
    }
}


//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BALLEVENTS SET OVERBALLCOUNT = SEQNO 	FROM 	(SELECT ROW_NUMBER() OVER (ORDER BY BALLNO, BALLCOUNT) SEQNO, BALLCODE AS BALLID FROM BALLEVENTS BE WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@' AND TEAMCODE = '%@'	AND OVERNO = '%@') AS BALL WHERE BALLCODE = BALL.BALLID AND COMPETITIONCODE = '%@' AND MATCHCODE = '%@ AND INNINGSNO = '%@' AND TEAMCODE = '%@' AND OVERNO = '%@'",COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMCODE, T_OVERNO ,COMPETITIONCODE, MATCHCODE,INNINGSNO,TEAMCODE, T_OVERNO ];
//
//        const char *selectStmt = [updateSQL UTF8String];
//
//        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
//        {
//            while(sqlite3_step(statement)==SQLITE_DONE){
//                sqlite3_reset(statement);
//                return YES;
//            }
//        }
//    }
//    sqlite3_reset(statement);
//    return NO;

//}

-(BOOL)  UpdateBEForInsertScoreEngine:(NSString*) MATCHCODE:(NSNumber*) INNINGSNO : (NSNumber*) T_OVERNO{
    
   @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BE  SET VIDEOFILENAME = (UPPER(MR.MATCHNAME + '-' + TM.SHORTTEAMNAME	+ '-INN' + CAST(BE.INNINGSNO AS NVARCHAR)+ '-OVER'+ CAST((BE.OVERNO + 1) AS NVARCHAR) + '-BALL'+CAST(BE.OVERBALLCOUNT AS NVARCHAR)))	+ '.' + (SELECT TOP 1 LOWER(VIDEOFORMAT) FROM VIDEOSETTINGS) FROM BALLEVENTS BE INNER JOIN MATCHREGISTRATION MR ON BE.COMPETITIONCODE = MR.COMPETITIONCODE AND BE.MATCHCODE = MR.MATCHCODE	INNER JOIN TEAMMASTER TM ON BE.TEAMCODE = TM.TEAMCODE WHERE BE.MATCHCODE = '%@' AND INNINGSNO = '%@' AND OVERNO = '%@'", MATCHCODE,INNINGSNO,T_OVERNO];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BE" :@"MSC250" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
   }
}


-(NSString*) GetmaxPenaltyIdForInsertScoreEngine{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  IFNULL(MAX(SUBSTR(PENALTYCODE,4,7)),0)+1 as MAXPENALTYID  FROM PENALTYDETAILS "];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MAXPENALTYID =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MAXPENALTYID;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
        
    }
    
    return @"";
    }
}

-(BOOL)  InsertPenaltyDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) INNINGSNO : (NSNumber*) BALLCODENO : (NSNumber*) PENALTYCODE: (NSNumber*) AWARDEDTOTEAMCODE: (NSNumber*) PENALTYRUNS: (NSNumber*) PENALTYTYPECODE: (NSNumber*) PENALTYREASONCODE{
    
   @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO PENALTYDETAILS 	(COMPETITIONCODE,MATCHCODE,INNINGSNO,BALLCODE,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE)VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@')",COMPETITIONCODE, MATCHCODE,INNINGSNO,BALLCODENO,PENALTYCODE,AWARDEDTOTEAMCODE,PENALTYRUNS,PENALTYTYPECODE,PENALTYREASONCODE];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
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
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
   }
}

-(NSString*) GetPrevoiusBallCodeForInsertScoreEngine : (NSNumber*) OVERNO: (NSNumber*) BALLNO:(NSNumber*) BALLCOUNT : (NSString*) MATCHCODE : (NSString*) INNINGSNO{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  BALLCODE FROM BALLEVENTS WHERE OVERNO = '%@' AND BALLNO = (CASE WHEN %@ > 1 THEN %@ ELSE %@ - 1 END) AND BALLCOUNT = (CASE WHEN %@ > 1 THEN %@ - 1 ELSE %@ END) AND MATCHCODE= '%@' AND INNINGSNO='%@'",OVERNO,BALLCOUNT,BALLNO,BALLNO,BALLCOUNT,BALLCOUNT,BALLCOUNT,MATCHCODE,INNINGSNO];
        const char *update_stmt = [updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, update_stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BALLCODE =  [self getValueByNull:statement :0];
      
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return BALLCODE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
            
        }
        sqlite3_close(dataBase);
    }
    
    return @"";
    }
}

-(NSString *) getValueByNull: (sqlite3_stmt *) statement : (int) position{
    return [ NSString stringWithFormat:@"%@",((const char*)sqlite3_column_text(statement, position)==nil)?@"":[NSString stringWithFormat:@"%s",(const char*)sqlite3_column_text(statement, position)]];
}

-(NSMutableArray *) getOverBallCountDetails :(NSString *) CommpitionCode :(NSString *) matchCode:(NSString*) overNo :(NSString *) Inningsno
{
    @synchronized ([Utitliy syncId])  {
    NSMutableArray *GetInsertTypeGreaterthanZeroDetails=[[NSMutableArray alloc]init];
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"select rowid,ballcode, runs, ballno,ballcount,overballcount from ballevents where competitioncode  = '%@'  and matchcode = '%@' and overno = '%@' and inningsno = '%@' ",CommpitionCode, matchCode,overNo,Inningsno ];
        
        const char *update_stmt = [updateSQL UTF8String];
        if( sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                OverBallCountRecord *objOverBallCountRecord=[[OverBallCountRecord alloc]init];
                objOverBallCountRecord.objRowid=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                objOverBallCountRecord.objBallCode=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                objOverBallCountRecord.objRun=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                objOverBallCountRecord.objBallno=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                objOverBallCountRecord.objBallCount=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                objOverBallCountRecord.objoverBallCount=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
                
                [GetInsertTypeGreaterthanZeroDetails addObject:objOverBallCountRecord];
            }
            sqlite3_reset(statement);
        }
    }
    sqlite3_finalize(statement);
    sqlite3_close(dataBase);
    return GetInsertTypeGreaterthanZeroDetails;
    }
}

//Duplicate
//-(NSString*) GetPrevoiusBallCodeForInsertScoreEngine : (NSNumber*) OVERNO: (NSNumber*) BALLNO:(NSNumber*) BALLCOUNT : (NSString*) MATCHCODE : (NSString*) INNINGSNO{
//                                                                  NSString *databasePath = [self getDBPath];
//                                                                  sqlite3_stmt *statement;
//                                                                  sqlite3 *dataBase;
//                                                                  const char *dbPath = [databasePath UTF8String];
//                                                                  if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                  {
//                                                                      NSString *updateSQL = [NSString stringWithFormat:@"SELECT  BALLCODE FROM BALLEVENTS WHERE OVERNO = '%@'   AND BALLNO = (CASE WHEN '%@' > 1 THEN '%@' ELSE '%@' - 1 END)    AND BALLCOUNT = (CASE WHEN '%@' > 1 THEN '%@' - 1 ELSE '%@' END)      AND MATCHCODE='%@' AND INNINGSNO='%@'",OVERNO,BALLCOUNT,BALLNO,BALLNO,BALLCOUNT,BALLCOUNT,BALLCOUNT,MATCHCODE,INNINGSNO];
//                                                                      const char *update_stmt = [updateSQL UTF8String];
//                                                                      sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                      if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                      {
//                                                                          while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                              NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                              sqlite3_finalize(statement);
//                                                                              sqlite3_close(dataBase);
//                                                                              return BALLCODE;
//                                                                          }
//
//                                                                      }
//                                                                      else {
//                                                                          sqlite3_reset(statement);
//
//                                                                          return @"";
//                                                                      }
//                                                                  }
//                                                                  sqlite3_reset(statement);
//                                                                  return @"";
//                                                              }

-(NSNumber*) GetBallcodeInBallEventForInsertScoreEngine : (NSString*) PREVIOUSBALLCODE: (NSString*) BOWLERCODE{
    
   @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALLCODE) FROM BALLEVENTS WHERE BALLCODE = '%@' AND BOWLERCODE != '%@'",PREVIOUSBALLCODE,BOWLERCODE];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
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

-(NSString*) GetPrevoiusBowlerCodeForInsertScoreEngine : (NSString*) PREVIOUSBALLCODE{
   
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE FROM BALLEVENTS WHERE BALLCODE = '%@'",PREVIOUSBALLCODE];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
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


-(BOOL)  UpdateBolwerOverDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE : (NSString*) INNINGSNO : (NSNumber*) OVERNO : (NSString*) PREVIOUSBOWLERCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
      //  NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLEROVERDETAILS SET ENDTIME = datetime('now','localtime') WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@' AND BOWLERCODE = '%@'",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,PREVIOUSBOWLERCODE];
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLEROVERDETAILS SET ENDTIME = '%@' WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@' AND OVERNO='%@' AND BOWLERCODE = '%@'",[dateFormatter stringFromDate:[NSDate date]],COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,PREVIOUSBOWLERCODE];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLEROVERDETAILS" :@"MSC251" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
}

-(BOOL)  UpdateBolwlingSummaryForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) INNINGSNO : (NSString*) PREVIOUSBOWLERCODE{
    
   @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BOWLINGSUMMARY   SET BALLS = 0  , PARTIALOVERBALLS = PARTIALOVERBALLS + BALLS  WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@'       AND INNINGSNO='%@' AND BOWLERCODE = '%@'",COMPETITIONCODE, MATCHCODE,INNINGSNO,PREVIOUSBOWLERCODE];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLINGSUMMARY" :@"MSC251" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
   }
}

-(BOOL)  InsertBowlerOverDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO: (NSNumber*) OVERNO: (NSString*) BOWLERCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
       // NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLEROVERDETAILS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE,STARTTIME,ENDTIME)     VALUES('%@','%@','%@','%@','%@','%@',datetime('now','localtime'),'')",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE];
        
        NSString *updateSQL = [NSString stringWithFormat:@"INSERT INTO BOWLEROVERDETAILS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE,STARTTIME,ENDTIME)     VALUES('%@','%@','%@','%@','%@','%@','%@','')",COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,OVERNO,BOWLERCODE,[dateFormatter stringFromDate:[NSDate date]]];
        
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)       {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLEROVERDETAILS" :@"MSC250" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
}

-(NSNumber*) GetBallCodeForUpdateBowlerOverDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO  : (NSNumber*) OVERNO{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALLCODE) as BALLCODE FROM BALLEVENTS WHERE OVERNO = '%@' AND COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'",OVERNO,COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *BALLCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
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

-(BOOL)  UpdateBowlerDetailsForInsertScoreEngine:(NSString*) BOWLERCODE:  (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO: (NSNumber*) OVERNO{
    
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *selectQry = [NSString stringWithFormat:@"UPDATE BOWLEROVERDETAILS SET BOWLERCODE = '%@'    WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@' AND INNINGSNO='%@'  AND OVERNO='%@'",BOWLERCODE,COMPETITIONCODE, MATCHCODE,TEAMCODE,INNINGSNO,OVERNO];
        
        const char *selectStmt = [selectQry UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)       {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BOWLEROVERDETAILS" :@"MSC251" :selectQry];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
}

-(NSNumber*) GetOverBallCountForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO : (NSNumber*) OVERNO{
 
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  IFNULL(MAX(OVERBALLCOUNT),0) + 1  as OVERBALLCOUNT FROM BALLEVENTS WHERE COMPETITIONCODE='%@' AND MATCHCODE='%@' AND TEAMCODE='%@'      AND INNINGSNO='%@' AND OVERNO='%@'",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,OVERNO];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *OVERBALLCOUNT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return OVERBALLCOUNT;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}

// [Utitliy getPitchMapXAxisForDB:PMX2] ,  [Utitliy getPitchMapYAxisForDB:PMY2]
//[Utitliy getWagonWheelXAxisForDB: WWX1],[Utitliy getWagonWheelYAxisForDB: WWY1],[Utitliy getWagonWheelXAxisForDB: WWX2],[Utitliy getWagonWheelYAxisForDB: WWY2]

//WWX1       , WWY1       , WWX2       , WWY2

-(BOOL)  InsertBallEventsForInsertScoreEngine:(NSNumber*) BALLCODENO:  (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO: (NSNumber*) DAYNO:(NSNumber*) OVERNO:  (NSNumber*) BALLNO: (NSNumber*) BALLCOUNT: (NSNumber*) OVERBALLCOUNT : (NSString*) SESSIONNO: (NSString*) STRIKERCODE :(NSString*) NONSTRIKERCODE:  (NSString*) BOWLERCODE: (NSString*) WICKETKEEPERCODE: (NSString*) UMPIRE1CODE : (NSString*) UMPIRE2CODE: (NSString*) ATWOROTW:(NSString*) BOWLINGEND:  (NSString*) BOWLTYPE: (NSString*) SHOTTYPE: (NSString*) SHOTTYPECATEGORY : (NSNumber*) ISLEGALBALL: (NSNumber*) ISFOUR:(NSNumber*) ISSIX:  (NSNumber*) RUNS: (NSNumber*) OVERTHROW: (NSNumber*) TOTALRUNS : (NSNumber*) WIDE: (NSNumber*) NOBALL : (NSString*) BYES:  (NSString*) LEGBYES: (NSNumber*) PENALTY: (NSNumber*) TOTALEXTRAS : (NSNumber*) GRANDTOTAL: (NSNumber*) RBW:(NSString*) PMLINECODE:  (NSString*) PMLENGTHCODE: (NSNumber*) PMSTRIKEPOINT: (NSString*) PMSTRIKEPOINTLINECODE : (NSNumber*) PMX1: (NSNumber*) PMY1:(NSNumber*) PMX2:  (NSNumber*) PMY2: (NSNumber*) PMX3: (NSNumber*) PMY3 : (NSNumber*) WWREGION: (NSNumber*) WWX1:(NSNumber*) WWY1:  (NSNumber*) WWX2: (NSNumber*) WWY2: (NSString*) BALLDURATION : (NSString*) ISAPPEAL: (NSString*) ISBEATEN:(NSString*) ISUNCOMFORT:  (NSString*) ISWTB: (NSString*) ISRELEASESHOT: (NSString*) MARKEDFOREDIT : (NSString*) REMARKS: (NSString*) VIDEOFILENAME:(NSString*) BALLSPEED:  (NSString*) UNCOMFORTCLASSIFCATION{
    
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        
        NSString *updateSQL = [NSString stringWithFormat:@" INSERT INTO BALLEVENTS ( BALLCODE,COMPETITIONCODE,MATCHCODE,TEAMCODE,DAYNO,INNINGSNO,OVERNO,BALLNO,BALLCOUNT,OVERBALLCOUNT,SESSIONNO,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE,UMPIRE2CODE,ATWOROTW,BOWLINGEND,BOWLTYPE,SHOTTYPE,ISLEGALBALL,ISFOUR,ISSIX,RUNS,OVERTHROW,TOTALRUNS,WIDE,NOBALL,BYES,LEGBYES,PENALTY,TOTALEXTRAS,GRANDTOTAL,RBW,PMLINECODE,PMLENGTHCODE,PMX1,PMY1,PMX2,PMY2,PMX3,PMY3,WWREGION,WWX1,WWY1,WWX2,WWY2,BALLDURATION,ISAPPEAL,ISBEATEN,ISUNCOMFORT,ISWTB,ISRELEASESHOT,MARKEDFOREDIT,REMARKS,VIDEOFILENAME,SHOTTYPECATEGORY,PMSTRIKEPOINT,PMSTRIKEPOINTLINECODE,BALLSPEED,UNCOMFORTCLASSIFCATION ) VALUES      ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@') ",BALLCODENO,COMPETITIONCODE,MATCHCODE,TEAMCODE,DAYNO,INNINGSNO,OVERNO,BALLNO,BALLCOUNT,OVERBALLCOUNT,SESSIONNO,STRIKERCODE,NONSTRIKERCODE,BOWLERCODE,WICKETKEEPERCODE,UMPIRE1CODE,UMPIRE2CODE,ATWOROTW,BOWLINGEND,BOWLTYPE,SHOTTYPE,ISLEGALBALL,ISFOUR,ISSIX,RUNS,OVERTHROW,TOTALRUNS,WIDE,NOBALL,BYES,LEGBYES,PENALTY,TOTALEXTRAS,GRANDTOTAL,RBW,PMLINECODE,PMLENGTHCODE,PMX1,PMY1,[Utitliy getPitchMapXAxisForDB:PMX2],[Utitliy getPitchMapYAxisForDB:PMY2],PMX3,PMY3,WWREGION,[Utitliy getWagonWheelXAxisForDB: WWX1],[Utitliy getWagonWheelYAxisForDB: WWY1],[Utitliy getWagonWheelXAxisForDB: WWX2],[Utitliy getWagonWheelYAxisForDB: WWY2],BALLDURATION,ISAPPEAL,ISBEATEN,ISUNCOMFORT,ISWTB,ISRELEASESHOT,MARKEDFOREDIT,REMARKS,VIDEOFILENAME,SHOTTYPECATEGORY,PMSTRIKEPOINT,PMSTRIKEPOINTLINECODE,BALLSPEED,UNCOMFORTCLASSIFCATION];

        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"BALLEVENTS" :@"MSC250" :updateSQL];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
}



//
//NSString *updateSQL = [NSString stringWithFormat:@" INSERT INTO BALLEVENTS      (     BALLCODE       ,COMPETITIONCODE       ,MATCHCODE       ,TEAMCODE       ,INNINGSNO       ,DAYNO       ,OVERNO       ,BALLNO       ,BALLCOUNT       ,OVERBALLCOUNT       ,SESSIONNO       ,STRIKERCODE       ,NONSTRIKERCODE       ,BOWLERCODE       ,WICKETKEEPERCODE       ,UMPIRE1CODE       ,UMPIRE2CODE       ,ATWOROTW       ,BOWLINGEND       ,BOWLTYPE       ,SHOTTYPE       ,SHOTTYPECATEGORY       ,ISLEGALBALL       ,ISFOUR       ,ISSIX       ,RUNS       ,OVERTHROW       ,TOTALRUNS       ,WIDE       ,NOBALL       ,BYES       ,LEGBYES       ,PENALTY       ,TOTALEXTRAS       ,GRANDTOTAL       ,RBW       ,PMLINECODE       ,PMLENGTHCODE       ,PMSTRIKEPOINT       ,PMSTRIKEPOINTLINECODE       ,PMX1       ,PMY1       ,PMX2       ,PMY2       ,PMX3       ,PMY3       ,WWREGION       ,WWX1       ,WWY1       ,WWX2       ,WWY2       ,BALLDURATION       ,ISAPPEAL       ,ISBEATEN       ,ISUNCOMFORT       ,ISWTB       ,ISRELEASESHOT       ,MARKEDFOREDIT       ,REMARKS       ,VIDEOFILENAME       ,BALLSPEED       ,UNCOMFORTCLASSIFCATION      )      VALUES      (          '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'       , '%@'     ) ",  BALLCODENO       , COMPETITIONCODE       , MATCHCODE       , TEAMCODE       , INNINGSNO       , DAYNO       , OVERNO       , BALLNO       , BALLCOUNT       , OVERBALLCOUNT       , SESSIONNO       , STRIKERCODE       , NONSTRIKERCODE       , BOWLERCODE       , WICKETKEEPERCODE       , UMPIRE1CODE       , UMPIRE2CODE       , ATWOROTW       , BOWLINGEND       , BOWLTYPE       , SHOTTYPE       , SHOTTYPECATEGORY       , ISLEGALBALL       , ISFOUR       , ISSIX       , RUNS       , OVERTHROW       , TOTALRUNS       , WIDE       , NOBALL       , BYES       , LEGBYES       , PENALTY       , TOTALEXTRAS       , GRANDTOTAL       , RBW       , PMLINECODE       , PMLENGTHCODE       , PMSTRIKEPOINT       , PMSTRIKEPOINTLINECODE       , PMX1       , PMY1       ,
//                       [Utitliy getPitchMapXAxisForDB:PMX2] ,
//                       [Utitliy getPitchMapYAxisForDB:PMY2]       ,
//                       PMX3       ,
//                       PMY3       , WWREGION       ,
//                       [Utitliy getWagonWheelXAxisForDB: WWX1],
//                       [Utitliy getWagonWheelYAxisForDB: WWY1],
//                       [Utitliy getWagonWheelXAxisForDB: WWX2],
//                       [Utitliy getWagonWheelYAxisForDB: WWY2]       , BALLDURATION       , ISAPPEAL       , ISBEATEN       , ISUNCOMFORT       , ISWTB       , ISRELEASESHOT       , MARKEDFOREDIT       , REMARKS       , VIDEOFILENAME       , BALLSPEED       , UNCOMFORTCLASSIFCATION ] ;



-(BOOL)  UpdateInningsEventEventsForInsertScoreEngine:(NSString*) T_STRIKERCODE:(NSString*) T_NONSTRIKERCODE: (NSString*) BOWLERCODE:   (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO{
    
  @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE INNINGSEVENTS   SET CURRENTSTRIKERCODE = '%@',   CURRENTNONSTRIKERCODE = '%@',   CURRENTBOWLERCODE = '%@'   WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'     AND TEAMCODE = '%@'     AND INNINGSNO = '%@'"      , T_STRIKERCODE       , T_NONSTRIKERCODE       , BOWLERCODE       , COMPETITIONCODE       , MATCHCODE,TEAMCODE, INNINGSNO ];
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
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
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
  }
}


-(BOOL)  InsertWicketEventsForInsertScoreEngine:(NSNumber*) BALLCODENO: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) TEAMCODE : (NSNumber*) INNINGSNO:(NSString*) ISWICKET :(NSString*) WICKETTYPE :(NSString*) WICKETPLAYER :(NSString*) FIELDINGPLAYER :(NSString*) WICKETEVENT{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@" INSERT INTO WICKETEVENTS  (    BALLCODE,   COMPETITIONCODE,   MATCHCODE,   TEAMCODE,  INNINGSNO,   ISWICKET,   WICKETNO,   WICKETTYPE,    WICKETPLAYER,     FIELDINGPLAYER,     VIDEOLOCATION,     WICKETEVENT     )    VALUES    (     '%@',     '%@',     '%@',     '%@',     '%@',     '%@',     (      SELECT IFNULL(COUNT(WKT.WICKETNO),0) + 1      FROM WICKETEVENTS WKT      WHERE WKT.COMPETITIONCODE = '%@'       AND WKT.MATCHCODE = '%@'      AND WKT.TEAMCODE = '%@'       AND WKT.INNINGSNO = '%@'      AND WKT.WICKETTYPE != 'MSC102'    ),     '%@',     '%@',     '%@',     '',     '%@'    )  "      , BALLCODENO, COMPETITIONCODE  , MATCHCODE,TEAMCODE, INNINGSNO,ISWICKET,COMPETITIONCODE  , MATCHCODE,TEAMCODE, INNINGSNO,WICKETTYPE, WICKETPLAYER,FIELDINGPLAYER,WICKETEVENT];
        
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
            
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                
                NSString *updateSQLForOnline = [NSString stringWithFormat:@" INSERT INTO WICKETEVENTS  (    BALLCODE,   COMPETITIONCODE,   MATCHCODE,   TEAMCODE,  INNINGSNO,   ISWICKET,   WICKETNO,   WICKETTYPE,    WICKETPLAYER,     FIELDINGPLAYER,     VIDEOLOCATION,     WICKETEVENT     )    VALUES    (     '%@',     '%@',     '%@',     '%@',     '%@',     '%@',     (      SELECT ISNULL(COUNT(WKT.WICKETNO),0) + 1      FROM WICKETEVENTS WKT      WHERE WKT.COMPETITIONCODE = '%@'       AND WKT.MATCHCODE = '%@'      AND WKT.TEAMCODE = '%@'       AND WKT.INNINGSNO = '%@'      AND WKT.WICKETTYPE != 'MSC102'    ),     '%@',     '%@',     '%@',     '',     '%@'    )  "      , BALLCODENO, COMPETITIONCODE  , MATCHCODE,TEAMCODE, INNINGSNO,ISWICKET,COMPETITIONCODE  , MATCHCODE,TEAMCODE, INNINGSNO,WICKETTYPE, WICKETPLAYER,FIELDINGPLAYER,WICKETEVENT];
                
                
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"WICKETEVENTS" :@"MSC250" :updateSQLForOnline];
                return YES;
                
            }
            else {
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
    }
}
//Missing Bowling Team Select

-(NSString*) GetmatchtypeForInsertScoreEngine : (NSString*) COMPETITIONCODE{
   
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHTYPE FROM COMPETITION WHERE COMPETITIONCODE = '%@'",COMPETITIONCODE];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSString *MATCHTYPE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return MATCHTYPE;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}




-(NSString*) GetInningsStatusForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) INNINGSNO{
    
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  INNINGSSTATUS FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO = '%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO];
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                
                NSString *INNINGSSTATUS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                return INNINGSSTATUS;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}


-(NSNumber*) GetbatTeamRunsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE{
    
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath =[self getDBPath];
    sqlite3 *dataBase;
    const char *stmt = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) as  GRANDTOTAL  FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'  AND TEAMCODE = '%@'    AND INNINGSNO = '%@'  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
        
        stmt=[updateSQL UTF8String];
        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
        {
            while(sqlite3_step(statement)==SQLITE_ROW){
                
                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                f.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *GRANDTOTAL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                
                return GRANDTOTAL;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(dataBase);
    }
    return 0;
    }
}




//-(NSMutableArray*) GetBattingShortnameForInsertScoreEngine: (NSString*) BATTINGTEAMCODE
//
//{
//    NSMutableArray *GetBattingShortnameDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  SHORTTEAMNAME,  TEAMNAME,  TEAMLOGO FROM TEAMMASTER   WHERE TEAMCODE = '%@'",BATTINGTEAMCODE];
//
//        const char *update_stmt = [updateSQL UTF8String];
//        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                GetBattingShortnameDetail *record=[[GetBattingShortnameDetail alloc]init];
//                record.SHORTTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                record.TEAMLOGO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//
//
//
//                [GetBattingShortnameDetails addObject:record];
//            }
//
//        }
//    }
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return GetBattingShortnameDetails;
//}
//
//-(NSMutableArray*) GetBowlingShortnameForInsertScoreEngine: (NSString*) BOWLINGTEAMCODE;
//
//{
//    NSMutableArray *GetBowlingShortnameDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT  SHORTTEAMNAME,  TEAMNAME,  TEAMLOGO FROM TEAMMASTER   WHERE TEAMCODE = '%@'",BOWLINGTEAMCODE];
//
//        const char *update_stmt = [updateSQL UTF8String];
//        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                GetBowlingShortnameDetail *record=[[GetBowlingShortnameDetail alloc]init];
//                record.SHORTTEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                record.TEAMLOGO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//
//
//
//                [GetBowlingShortnameDetails addObject:record];
//            }
//
//        }
//    }
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return GetBowlingShortnameDetails;
//}

//-(NSMutableArray*) GettargetDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE
//{
//    NSMutableArray *GetTarGetDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TARGETRUNS,  TARGETOVERS FROM MATCHEVENTS  WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
//
//        const char *update_stmt = [updateSQL UTF8String];
//        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                GetTarGetDetail *record=[[GetTarGetDetail alloc]init];
//                record.TARGETRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.TARGETOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//
//
//
//                [GetTarGetDetails addObject:record];
//            }
//
//        }
//    }
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return GetTarGetDetails;
//}
//
//-(NSMutableArray*) GetmatchDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE
//{
//    NSMutableArray *GetMatchDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TARGETRUNS,  TARGETOVERS FROM MATCHEVENTS  WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
//
//        const char *update_stmt = [updateSQL UTF8String];
//        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                GetMatchDetail *record=[[GetMatchDetail alloc]init];
//                record.TEAMAWICKETKEEPER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.TEAMBWICKETKEEPER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                record.TEAMACAPTAIN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                record.TEAMBCAPTAIN=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                record.TEAMACODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                record.TEAMBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                record.ISDEFAULTORLASTINSTANCE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//
//
//
//                [GetMatchDetails addObject:record];
//            }
//
//        }
//    }
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return GetMatchDetails;
//}
//
//-(NSMutableArray*) GetBowltypeDetailsForInsertScoreEngine;
//{
//    NSMutableArray *GetBowlDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT TARGETRUNS,  TARGETOVERS FROM MATCHEVENTS  WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'",COMPETITIONCODE,MATCHCODE];
//
//        const char *update_stmt = [updateSQL UTF8String];
//        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                GetBowlDetail *record=[[GetBowlDetail alloc]init];
//                record.BOWLTYPECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.BOWLTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                record.METASUBCODEDESCRIPTION=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                record.METASUBCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//
//
//                [GetBowlDetails addObject:record];
//            }
//
//        }
//    }
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return GetBowlDetails;
//}
//-(NSMutableArray*) GetShotTypeDetailsForInsertScoreEngine;
//{
//    NSMutableArray *GetShotTypeDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT ST.SHOTCODE, ST.SHOTNAME, ST.SHOTTYPE FROM SHOTTYPE ST  WHERE ST.RECORDSTATUS = 'MSC001'  ORDER BY ST.SHOTTYPE , ST.DISPLAYORDER"];
//
//        const char *update_stmt = [updateSQL UTF8String];
//        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                GetShotTypeDetail *record=[[GetShotTypeDetail alloc]init];
//                record.SHOTCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.SHOTNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                record.SHOTTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//
//
//
//                [GetShotTypeDetails addObject:record];
//            }
//
//        }
//    }
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return GetShotTypeDetails;
//}
//
//-(NSMutableArray*) GetRowNumberForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO
//{
//    NSMutableArray *GetRowNumberDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT rownum = ROW_NUMBER() OVER (ORDER BY WKT.MATCHCODE),WKT.WICKETPLAYER,WKT.WICKETTYPE,WKT.BALLCODE,WKT.COMPETITIONCODE,     WKT.MATCHCODE,WKT.TEAMCODE,WKT.INNINGSNO      FROM WICKETEVENTS WKT WHERE      WKT.COMPETITIONCODE = '%@'    AND WKT.MATCHCODE =   '%@'    AND WKT.TEAMCODE =   '%@'    AND WKT.INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
//
//        const char *update_stmt = [updateSQL UTF8String];
//        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            while(sqlite3_step(statement)==SQLITE_ROW){
//                GetRowNumberDetail *record=[[GetRowNumberDetail alloc]init];
//                record.rownum=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                record.COMPETITIONCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                record.MATCHCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//                record.INNINGSNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//
//
//
//                [GetRowNumberDetails addObject:record];
//            }
//
//        }
//    }
//    sqlite3_finalize(statement);
//    sqlite3_close(dataBase);
//    return GetRowNumberDetails;
//}
//
//-(NSMutableArray*)  GetPlayerDetailsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO
//{
//    NSMutableArray *GetPlayerDetails=[[NSMutableArray alloc]init];
//    NSString *databasePath = [self getDBPath];
//    sqlite3_stmt *statement;
//    sqlite3 *dataBase;
//    const char *dbPath = [databasePath UTF8String];
//    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//    {
//        NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME, PM.BATTINGSTYLE   FROM MATCHREGISTRATION MR   INNER JOIN MATCHTEAMPLAYERDETAILS MPD   ON MR.MATCHCODE = MPD.MATCHCODE   INNER JOIN COMPETITION COM    ON COM.COMPETITIONCODE = MR.COMPETITIONCODE   INNER JOIN TEAMMASTER TMA   ON MPD.MATCHCODE = '%@'    AND MPD.TEAMCODE = '%@'    AND MPD.TEAMCODE = TMA.TEAMCODE   INNER JOIN PLAYERMASTER PM   ON MPD.PLAYERCODE = PM.PLAYERCODE   WHERE PM.PLAYERCODE NOT IN    (        SELECT X.WICKETPLAYER AS WICKETPLAYER  FROM X LEFT JOIN X nex ON nex.rownum = X.rownum + 1 WHERE     (X.WICKETTYPE  != 'MSC102' OR NEX.WICKETPLAYER IS NULL) AND    X.COMPETITIONCODE = '%@'    AND X.MATCHCODE = '%@'     AND X.TEAMCODE = '%@'     AND X.INNINGSNO = '%@'     )   AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))   ORDER BY MPD.PLAYINGORDER",MATCHCODE,BATTINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
//
//                               const char *update_stmt = [updateSQL UTF8String];
//                               sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                               if (sqlite3_step(statement) == SQLITE_DONE)
//                               {
//                                   while(sqlite3_step(statement)==SQLITE_ROW){
//                                       GetPlayerDetail *record=[[GetPlayerDetail alloc]init];
//                                       record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                       record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                       record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//
//
//
//                                       [GetPlayerDetails addObject:record];
//                                   }
//
//                               }
//                               }
//                               sqlite3_finalize(statement);
//                               sqlite3_close(dataBase);
//                               return GetPlayerDetails;
//                               }
//

//
//                               -(NSNumber*) GetIsFollowOnForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISFOLLOWON FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *ISFOLLOWON = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return ISFOLLOWON;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber*) GetIsFollowOnInElseIfForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISFOLLOWON FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO = '%@' - 1",COMPETITIONCODE,MATCHCODE,INNINGSNO];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *ISFOLLOWON = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return ISFOLLOWON;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//                               -(NSString*) GetTeamTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE{
//                                   NSString *databasePath = [self getDBPath];
//                                   sqlite3_stmt *statement;
//                                   sqlite3 *dataBase;
//                                   const char *dbPath = [databasePath UTF8String];
//                                   if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                   {
//                                       NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0) as  PENALTYRUNS   FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'    AND INNINGSNO IN (2, 3)    AND AWARDEDTOTEAMCODE = '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
//                                       const char *update_stmt = [updateSQL UTF8String];
//                                       sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                       if (sqlite3_step(statement) == SQLITE_DONE)
//                                       {
//                                           while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                               NSString *PENALTYRUNS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                               sqlite3_finalize(statement);
//                                               sqlite3_close(dataBase);
//                                               return PENALTYRUNS;
//                                           }
//
//                                       }
//                                       else {
//                                           sqlite3_reset(statement);
//
//                                           return @"";
//                                       }
//                                   }
//                                   sqlite3_reset(statement);
//                                   return @"";
//                               }
//
//                               -(NSString*) GetTeamTeampenaltyInelseForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE{
//                                   NSString *databasePath = [self getDBPath];
//                                   sqlite3_stmt *statement;
//                                   sqlite3 *dataBase;
//                                   const char *dbPath = [databasePath UTF8String];
//                                   if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                   {
//                                       NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)  as PENALTYRUNS  FROM PENALTYDETAILS    WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'     AND INNINGSNO IN ('%@', '%@' - 1)     AND AWARDEDTOTEAMCODE = '%@'     AND (BALLCODE IS NULL OR INNINGSNO = '%@' - 1)  ",COMPETITIONCODE,MATCHCODE,INNINGSNO,INNINGSNO,BATTINGTEAMCODE,INNINGSNO];
//                                       const char *update_stmt = [updateSQL UTF8String];
//                                       sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                       if (sqlite3_step(statement) == SQLITE_DONE)
//                                       {
//                                           while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                               NSString *PENALTYRUNS =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                               sqlite3_finalize(statement);
//                                               sqlite3_close(dataBase);
//                                               return PENALTYRUNS;
//                                           }
//
//                                       }
//                                       else {
//                                           sqlite3_reset(statement);
//
//                                           return @"";
//                                       }
//                                   }
//                                   sqlite3_reset(statement);
//                                   return @"";
//                               }
//                               -(NSNumber*) GetbatTeamRunsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(GRANDTOTAL),0) as  GRANDTOTAL  FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'  AND TEAMCODE = '%@'    AND INNINGSNO = '%@'  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *GRANDTOTAL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return GRANDTOTAL;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber*) GetbatTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@" SELECT IFNULL(SUM(PENALTYRUNS),0)  as  PENALTYRUNS    FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'      AND MATCHCODE = '%@'     AND INNINGSNO = 1     AND AWARDEDTOTEAMCODE = '%@'     AND BALLCODE IS NULL ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
//
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetbatTeampenaltyInElseForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@" SELECT IFNULL(SUM(PENALTYRUNS),0) as  PENALTYRUNS  FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'     AND INNINGSNO <= '%@'     AND AWARDEDTOTEAMCODE = '%@'     AND (BALLCODE IS NULL OR INNINGSNO < @INNINGSNO)  ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE,INNINGSNO];
//
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetBowlingTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BOWLINGTEAMCODE;{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@" SELECT IFNULL(SUM(PENALTYRUNS),0) as PENALTYRUNS    FROM PENALTYDETAILS     WHERE COMPETITIONCODE = '%@'      AND MATCHCODE = '%@'     AND INNINGSNO = '%@' - 1     AND AWARDEDTOTEAMCODE = '%@'     AND BALLCODE IS NULL  ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLINGTEAMCODE];
//
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetBowlingTeampenaltyInElseForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BOWLINGTEAMCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)  as PENALTYRUNS   FROM PENALTYDETAILS    WHERE COMPETITIONCODE = '%@'       AND MATCHCODE = '%@'      AND INNINGSNO <= '%@'      AND AWARDEDTOTEAMCODE = '%@'      AND (BALLCODE IS NULL OR PENALTYTYPECODE = 'MSC135') ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLINGTEAMCODE];
//
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//
//                               -(NSNumber*) GetIsFollowOnDetailForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISFOLLOWON FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@'  AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *ISFOLLOWON = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return ISFOLLOWON;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//                               -(NSNumber*) GetBattingTeampenaltysForInsertScoreEngine	: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0) as  PENALTYRUNS   FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'      AND INNINGSNO = '%@'      AND AWARDEDTOTEAMCODE = '%@'      AND BALLCODE IS NULL ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//                               -(NSNumber*) GetBattingTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@" SELECT IFNULL(SUM(PENALTYRUNS),0) as  PENALTYRUNS   FROM PENALTYDETAILS    WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'     AND INNINGSNO <= '%@'      AND AWARDEDTOTEAMCODE = '%@'      AND ((INNINGSNO = '%@' AND BALLCODE IS NULL) OR ((INNINGSNO < '%@' AND BALLCODE IS NULL) OR PENALTYTYPECODE = 'MSC135'))  ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE,INNINGSNO,INNINGSNO];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//                               -(NSNumber*) GetBowlTeampenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO :  (NSString*) BOWLINGTEAMCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)  as PENALTYRUNS   FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'    AND INNINGSNO <= '%@' - 1    AND AWARDEDTOTEAMCODE = '%@'    AND (BALLCODE IS NULL OR (INNINGSNO <= '%@' - 1 AND PENALTYTYPECODE = 'MSC135'))",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLINGTEAMCODE,INNINGSNO];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber*) GetBattingTeampenaltyInn4ForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSString*) BATTINGTEAMCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0) as   PENALTYRUNS   FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'     AND INNINGSNO > 1      AND AWARDEDTOTEAMCODE = '%@'      AND (BALLCODE IS NULL OR (INNINGSNO IN (2,3) AND BALLCODE IS NULL))",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber*) GetbatTeampenaltyInn4InElseForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BATTINGTEAMCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISNULL(SUM(PENALTYRUNS),0)  as  PENALTYRUNS  FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'   AND INNINGSNO <= '%@'      AND AWARDEDTOTEAMCODE = '%@'      AND ((INNINGSNO = '%@' AND BALLCODE IS NULL) OR ((INNINGSNO < '%@' AND BALLCODE IS NULL) OR PENALTYTYPECODE = 'MSC135'))  ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE,INNINGSNO,INNINGSNO];
//
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber*) GetBowlingTeampenaltyInn4ForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO: (NSString*) BOWLINGTEAMCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(SUM(PENALTYRUNS),0)  as PENALTYRUNS  FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'   AND INNINGSNO <= '%@'    AND AWARDEDTOTEAMCODE = '%@'     AND (BALLCODE IS NULL OR (INNINGSNO <= '%@' AND PENALTYTYPECODE = 'MSC135'))  ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLINGTEAMCODE,INNINGSNO];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return PENALTYRUNS;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetBatTeamWicketForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(COUNT(WKT.WICKETNO),0)  as WICKETNO FROM WICKETEVENTS WKT  WHERE WKT.COMPETITIONCODE = '%@'  AND WKT.MATCHCODE = '%@'     ND WKT.TEAMCODE = '%@'        AND WKT.INNINGSNO = '%@'       AND WKT.WICKETTYPE != 'MSC102' ",COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *WICKETNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return WICKETNO;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetBatTeamOverForInsertScoreEngine: (NSNumber*) BALLCODENO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERNO FROM BALLEVENTS  WHERE BALLCODE = '%@' ",BALLCODENO];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return OVERNO;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetBatTeamOverBallForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO: (NSNumber*) BATTEAMOVERS{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT IFNULL(MAX(BALLNO),0) as BALLNO  FROM BALLEVENTS   WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'    AND TEAMCODE = '%@'     AND INNINGSNO = '%@'     AND OVERNO = '%@'    AND ISLEGALBALL = 1  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return BALLNO;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetBatTeamOverWithExtraBallForInsertScoreEngine:  (NSNumber*) BALLCODENO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLNO  FROM BALLEVENTS    WHERE BALLCODE = '%@'   ",BALLCODENO];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return BALLNO;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetBatTeamOverWithExtraBallCountForInsertScoreEngine:  (NSNumber*) BALLCODENO{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALLCOUNT  FROM BALLEVENTS   WHERE BALLCODE = '%@'  ",BALLCODENO];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *BALLCOUNT = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return BALLCOUNT;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetIslegalBallCountForInsertScoreEngine:  (NSNumber*) LASTBALLCODE{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISLEGALBALL FROM BALLEVENTS WHERE BALLCODE = '%@' ",LASTBALLCODE];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *ISLEGALBALL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return ISLEGALBALL;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSNumber * ) GetOverNoForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) BATTEAMOVERS{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVR.OVERNO FROM OVEREVENTS OVR WHERE OVR.COMPETITIONCODE = '%@' AND OVR.MATCHCODE = '%@' AND OVR.TEAMCODE = '%@' AND OVR.INNINGSNO = '%@' AND OVR.OVERNO = '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return OVERNO;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//                               -(NSNumber * ) GetOverNosForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) BATTEAMOVERS{
//                                   int retVal;
//                                   NSString *databasePath =[self getDBPath];
//                                   sqlite3 *dataBase;
//                                      const char *stmt = [databasePath UTF8String];
//                                   sqlite3_stmt *statement;
//                                   retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                   if(retVal !=0){
//                                   }
//
//                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVR.OVERNO FROM OVEREVENTS OVR WHERE OVR.COMPETITIONCODE = '%@' AND OVR.MATCHCODE = '%@' AND OVR.TEAMCODE = '%@' AND OVR.INNINGSNO = '%@' AND OVR.OVERNO = '%@' AND OVR.OVERSTATUS = 0",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS];
//                                   stmt=[query UTF8String];
//                                   if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                   {
//                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                           NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                           f.numberStyle = NSNumberFormatterDecimalStyle;
//                                           NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                           sqlite3_finalize(statement);
//                                           sqlite3_close(dataBase);
//
//                                           return OVERNO;
//                                       }
//                                   }
//
//                                   sqlite3_finalize(statement);
//                                   sqlite3_close(dataBase);
//                                   return 0;
//                               }
//
//                               -(NSString * ) GetBowlerCodeForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) ISOVERCOMPLETE :(NSString*) BATTEAMOVERS{
//                                   NSString *databasePath = [self getDBPath];
//                                   sqlite3_stmt *statement;
//                                   sqlite3 *dataBase;
//                                   const char *dbPath = [databasePath UTF8String];
//                                   if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                   {
//                                       NSString *updateSQL = [NSString stringWithFormat:@"SELECT TOP 1 BOWLERCODE FROM BALLEVENTS   WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'  AND TEAMCODE = '%@'   AND INNINGSNO = '%@'     AND OVERNO = (CASE WHEN '%@' = 1 THEN '%@' - 1 ELSE @BATTEAMOVERS - 2 END)",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,ISOVERCOMPLETE,BATTEAMOVERS,BATTEAMOVERS];
//                                       const char *update_stmt = [updateSQL UTF8String];
//                                       sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                       if (sqlite3_step(statement) == SQLITE_DONE)
//                                       {
//                                           while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                               NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                               sqlite3_finalize(statement);
//                                               sqlite3_close(dataBase);
//                                               return BOWLERCODE;
//                                           }
//
//                                       }
//                                       else {
//                                           sqlite3_reset(statement);
//
//                                           return @"";
//                                       }
//                                   }
//                                   sqlite3_reset(statement);
//                                   return @"";
//                               }
//
//
//
//                               -(NSMutableArray*) GetBowlingTeamPlayersForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) BATTINGTEAMCODE: (NSNumber*) INNINGSNO:(NSString*) ISOVERCOMPLETE :(NSString*) BATTEAMOVERS
//                               {
//                                   NSMutableArray *GetBowlPlayerDetails=[[NSMutableArray alloc]init];
//                                   NSString *databasePath = [self getDBPath];
//                                   sqlite3_stmt *statement;
//                                   sqlite3 *dataBase;
//                                   const char *dbPath = [databasePath UTF8String];
//                                   if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                   {
//                                       NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT PM.PLAYERCODE PLAYERCODE, PM.PLAYERNAME PLAYERNAME, PM.BOWLINGTYPE, PM.BOWLINGSTYLE, @PENULTIMATEBOWLERCODE AS PENULTIMATEBOWLERCODE   FROM MATCHREGISTRATION MR   INNER JOIN MATCHTEAMPLAYERDETAILS MPD   ON MR.MATCHCODE = MPD.MATCHCODE   INNER JOIN COMPETITION COM    ON COM.COMPETITIONCODE = MR.COMPETITIONCODE   INNER JOIN TEAMMASTER TMA   ON MPD.MATCHCODE = '%@'   AND MPD.TEAMCODE = '%@'   AND MPD.TEAMCODE = TMA.TEAMCODE   INNER JOIN PLAYERMASTER PM   ON MPD.PLAYERCODE = PM.PLAYERCODE   WHERE     MPD.PLAYERCODE != (CASE WHEN MR.TEAMACODE = '%@' THEN MR.TEAMAWICKETKEEPER ELSE MR.TEAMBWICKETKEEPER END)   AND PM.PLAYERCODE NOT IN    (    SELECT BOWLERCODE FROM BALLEVENTS     WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'    AND TEAMCODE = '%@'     AND INNINGSNO = '%@'     AND OVERNO = (CASE WHEN '%@' = 1 THEN '%@' ELSE '%@' - 1 END)   )   AND (COM.ISOTHERSMATCHTYPE = 'MSC117' Or (MPD.PLAYINGORDER <= 11))",MATCHCODE,BOWLINGTEAMCODE,BOWLINGTEAMCODE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,ISOVERCOMPLETE,BATTEAMOVERS,BATTEAMOVERS];
//
//                                                              const char *update_stmt = [updateSQL UTF8String];
//                                                              sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                              if (sqlite3_step(statement) == SQLITE_DONE)
//                                                              {
//                                                                  while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                      GetBowlPlayerDetail *record=[[GetBowlPlayerDetail alloc]init];
//                                                                      record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                      record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                      record.BOWLINGTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                                                                      record.BOWLINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                                                                      record.PENULTIMATEBOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//
//
//
//
//                                                                      [GetBowlPlayerDetails addObject:record];
//                                                                  }
//
//                                                              }
//                                                              }
//                                                              sqlite3_finalize(statement);
//                                                              sqlite3_close(dataBase);
//                                                              return GetBowlPlayerDetails;
//                                                              }
//
//                                                              -(NSNumber * ) GetCompletedInningsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE{
//                                                                  int retVal;
//                                                                  NSString *databasePath =[self getDBPath];
//                                                                  sqlite3 *dataBase;
//                                                                     const char *stmt = [databasePath UTF8String];
//                                                                  sqlite3_stmt *statement;
//                                                                  retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                  if(retVal !=0){
//                                                                  }
//
//                                                                  NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(1) as Count FROM INNINGSEVENTS WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSSTATUS = 1",COMPETITIONCODE,MATCHCODE];
//                                                                  stmt=[query UTF8String];
//                                                                  if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                  {
//                                                                      while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                          NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                          f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                          NSNumber *Count = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                          sqlite3_finalize(statement);
//                                                                          sqlite3_close(dataBase);
//
//                                                                          return Count;
//                                                                      }
//                                                                  }
//
//                                                                  sqlite3_finalize(statement);
//                                                                  sqlite3_close(dataBase);
//                                                                  return 0;
//                                                              }
//                                                              -(NSNumber * ) GetTotalBatteamRunsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE :(NSString*) BATTINGTEAMCODE{
//                                                                  int retVal;
//                                                                  NSString *databasePath =[self getDBPath];
//                                                                  sqlite3 *dataBase;
//                                                                     const char *stmt = [databasePath UTF8String];
//                                                                  sqlite3_stmt *statement;
//                                                                  retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                  if(retVal !=0){
//                                                                  }
//
//                                                                  NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISNULL(SUM(GRANDTOTAL),0)  as GRANDTOTAL  FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'    AND TEAMCODE = '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE];
//                                                                  stmt=[query UTF8String];
//                                                                  if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                  {
//                                                                      while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                          NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                          f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                          NSNumber *GRANDTOTAL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                          sqlite3_finalize(statement);
//                                                                          sqlite3_close(dataBase);
//
//                                                                          return GRANDTOTAL;
//                                                                      }
//                                                                  }
//
//                                                                  sqlite3_finalize(statement);
//                                                                  sqlite3_close(dataBase);
//                                                                  return 0;
//                                                              }
//
//                                                              -(NSNumber * ) GetTotalBowlteamRunsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE :(NSString*) BOWLINGTEAMCODE{
//                                                                  int retVal;
//                                                                  NSString *databasePath =[self getDBPath];
//                                                                  sqlite3 *dataBase;
//                                                                     const char *stmt = [databasePath UTF8String];
//                                                                  sqlite3_stmt *statement;
//                                                                  retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                  if(retVal !=0){
//                                                                  }
//
//                                                                  NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISNULL(SUM(GRANDTOTAL),0)  as  GRANDTOTAL  FROM BALLEVENTS   WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'    AND TEAMCODE = '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE];
//                                                                  stmt=[query UTF8String];
//                                                                  if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                  {
//                                                                      while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                          NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                          f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                          NSNumber *GRANDTOTAL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                          sqlite3_finalize(statement);
//                                                                          sqlite3_close(dataBase);
//
//                                                                          return GRANDTOTAL;
//                                                                      }
//                                                                  }
//
//                                                                  sqlite3_finalize(statement);
//                                                                  sqlite3_close(dataBase);
//                                                                  return 0;
//                                                              }
//
//                                                              -(NSNumber * ) GetTempBowlPenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BOWLINGTEAMCODE{
//                                                                  int retVal;
//                                                                  NSString *databasePath =[self getDBPath];
//                                                                  sqlite3 *dataBase;
//                                                                     const char *stmt = [databasePath UTF8String];
//                                                                  sqlite3_stmt *statement;
//                                                                  retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                  if(retVal !=0){
//                                                                  }
//
//                                                                  NSString *updateSQL = [NSString stringWithFormat:@" SELECT ISNULL(SUM(PENALTYRUNS),0) as PENALTYRUNS    FROM PENALTYDETAILS      WHERE COMPETITIONCODE = '%@'       AND MATCHCODE = '%@'      AND INNINGSNO <= '%@'      AND (AWARDEDTOTEAMCODE = '%@')      AND (BALLCODE IS NULL OR PENALTYTYPECODE = 'MSC135')",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLINGTEAMCODE];
//                                                                  stmt=[query UTF8String];
//                                                                  if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                  {
//                                                                      while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                          NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                          f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                          NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                          sqlite3_finalize(statement);
//                                                                          sqlite3_close(dataBase);
//
//                                                                          return PENALTYRUNS;
//                                                                      }
//                                                                  }
//
//                                                                  sqlite3_finalize(statement);
//                                                                  sqlite3_close(dataBase);
//                                                                  return 0;
//                                                              }
//                                                              -(NSNumber * ) GetTempBatTeamPenaltyForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE{
//                                                                  int retVal;
//                                                                  NSString *databasePath =[self getDBPath];
//                                                                  sqlite3 *dataBase;
//                                                                     const char *stmt = [databasePath UTF8String];
//                                                                  sqlite3_stmt *statement;
//                                                                  retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                  if(retVal !=0){
//                                                                  }
//
//                                                                  NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISNULL(SUM(PENALTYRUNS),0)  as  PENALTYRUNS   FROM PENALTYDETAILS   WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'     AND INNINGSNO < '%@' - 1      AND AWARDEDTOTEAMCODE = '%@'      AND ((INNINGSNO = '%@' AND BALLCODE IS NULL) OR ((INNINGSNO < '%@' - 1 AND BALLCODE IS NULL) OR PENALTYTYPECODE = 'MSC135')) ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE,INNINGSNO,INNINGSNO];
//                                                                  stmt=[query UTF8String];
//                                                                  if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                  {
//                                                                      while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                          NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                          f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                          NSNumber *PENALTYRUNS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                          sqlite3_finalize(statement);
//                                                                          sqlite3_close(dataBase);
//
//                                                                          return PENALTYRUNS;
//                                                                      }
//                                                                  }
//
//                                                                  sqlite3_finalize(statement);
//                                                                  sqlite3_close(dataBase);
//                                                                  return 0;
//                                                              }
//                                                              -(NSNumber * )GetgrandtotalForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*)TEMPBATPENALTY{
//                                                                  int retVal;
//                                                                  NSString *databasePath =[self getDBPath];
//                                                                  sqlite3 *dataBase;
//                                                                     const char *stmt = [databasePath UTF8String];
//                                                                  sqlite3_stmt *statement;
//                                                                  retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                  if(retVal !=0){
//                                                                  }
//
//                                                                  NSString *updateSQL = [NSString stringWithFormat:@"(SELECT ISNULL(SUM(GRANDTOTAL),0) as GRANDTOTAL   FROM BALLEVENTS    WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'    AND TEAMCODE = '%@'            AND INNINGSNO < '%@') + '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,TEMPBATPENALTY];
//                                                                  stmt=[query UTF8String];
//                                                                  if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                  {
//                                                                      while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                          NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                          f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                          NSNumber *GRANDTOTAL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                          sqlite3_finalize(statement);
//                                                                          sqlite3_close(dataBase);
//
//                                                                          return GRANDTOTAL;
//                                                                      }
//                                                                  }
//
//                                                                  sqlite3_finalize(statement);
//                                                                  sqlite3_close(dataBase);
//                                                                  return 0;
//                                                              }
//                                                              -(NSMutableArray*) GetLastBallATWOROTWForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) ISOVERCOMPLETE:(NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*)LASTBALLCODE
//                                                              {
//                                                                  NSMutableArray *GetlastBallDetails=[[NSMutableArray alloc]init];
//                                                                  NSString *databasePath = [self getDBPath];
//                                                                  sqlite3_stmt *statement;
//                                                                  sqlite3 *dataBase;
//                                                                  const char *dbPath = [databasePath UTF8String];
//                                                                  if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                  {
//                                                                      NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT TOP 1  ATWOROTW,    CASE WHEN '%@' = 0 THEN BOWLINGEND ELSE (CASE BOWLINGEND WHEN 'MSC150' THEN 'MSC151' WHEN 'MSC151' THEN 'MSC150' END) END  as  T_BOWLINGEND FROM BALLEVENTS    WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'   AND TEAMCODE = '%@'    AND INNINGSNO = '%@'    AND BALLCODE = '%@'",ISOVERCOMPLETE,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,LASTBALLCODE];
//
//                                                                                             const char *update_stmt = [updateSQL UTF8String];
//                                                                                             sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                             if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                             {
//                                                                                                 while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                     GetlastBallDetail *record=[[GetlastBallDetail alloc]init];
//                                                                                                     record.ATWOROTW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                     record.T_BOWLINGEND=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//
//
//                                                                                                     [GetlastBallDetails addObject:record];
//                                                                                                 }
//
//                                                                                             }
//                                                                                             }
//                                                                                             sqlite3_finalize(statement);
//                                                                                             sqlite3_close(dataBase);
//                                                                                             return GetlastBallDetails;
//                                                                                             }
//
//
//                                                                                             -(NSNumber * ) GetNoBallForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) BATTEAMOVERS  :(NSString*)BATTEAMOVRWITHEXTRASBALLS{
//                                                                                                 int retVal;
//                                                                                                 NSString *databasePath =[self getDBPath];
//                                                                                                 sqlite3 *dataBase;
//                                                                                                    const char *stmt = [databasePath UTF8String];
//                                                                                                 sqlite3_stmt *statement;
//                                                                                                 retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                 if(retVal !=0){
//                                                                                                 }
//
//                                                                                                 NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(NOBALL) as NOBALL FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@' AND MATCHCODE = '%@'   AND TEAMCODE = '%@' AND INNINGSNO = '%@'    AND OVERNO = '%@' AND BALLNO = '%@'  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRWITHEXTRASBALLS];
//                                                                                                 stmt=[query UTF8String];
//                                                                                                 if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                 {
//                                                                                                     while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                         NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                         f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                         NSNumber *NOBALL = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                         sqlite3_finalize(statement);
//                                                                                                         sqlite3_close(dataBase);
//
//                                                                                                         return NOBALL;
//                                                                                                     }
//                                                                                                 }
//
//                                                                                                 sqlite3_finalize(statement);
//                                                                                                 sqlite3_close(dataBase);
//                                                                                                 return 0;
//                                                                                             }
//
//                                                                                             -(NSMutableArray*) GetWicketPlayerAndTypeForInsertScoreEngine: (NSString*) LASTBALLCODE;
//                                                                                             {
//                                                                                                 NSMutableArray *GetWicketPlayerandTypeDetails=[[NSMutableArray alloc]init];
//                                                                                                 NSString *databasePath = [self getDBPath];
//                                                                                                 sqlite3_stmt *statement;
//                                                                                                 sqlite3 *dataBase;
//                                                                                                 const char *dbPath = [databasePath UTF8String];
//                                                                                                 if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                 {
//                                                                                                     NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT  WKT.WICKETPLAYER,  WKT.WICKETTYPE FROM BALLEVENTS BALL   INNER JOIN OVEREVENTS OVR ON OVR.COMPETITIONCODE = BALL.COMPETITIONCODE    AND OVR.MATCHCODE = BALL.MATCHCODE AND OVR.TEAMCODE = BALL.TEAMCODE    AND OVR.INNINGSNO = BALL.INNINGSNO AND OVR.OVERNO = BALL.OVERNO   LEFT OUTER JOIN WICKETEVENTS WKT ON WKT.BALLCODE = BALL.BALLCODE   WHERE BALL.BALLCODE = '%@'",LASTBALLCODE];
//                                                                                                                            const char *update_stmt = [updateSQL UTF8String];        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                            if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                            {
//                                                                                                                                while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                    GetWicketPlayerandTypeDetail *record=[[GetWicketPlayerandTypeDetail alloc]init];
//                                                                                                                                    record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                    record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//
//
//                                                                                                                                    [GetWicketPlayerandTypeDetails addObject:record];
//                                                                                                                                }
//
//                                                                                                                            }
//                                                                                                                            }
//                                                                                                                            sqlite3_finalize(statement);
//                                                                                                                            sqlite3_close(dataBase);
//                                                                                                                            return GetWicketPlayerandTypeDetails;
//                                                                                                                            }
//
//                                                                                                                            -(NSMutableArray*) GetStrickerNonStrickerForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO;
//                                                                                                                            {
//                                                                                                                                NSMutableArray *GetStrickerNonStrickerDetails=[[NSMutableArray alloc]init];
//                                                                                                                                NSString *databasePath = [self getDBPath];
//                                                                                                                                sqlite3_stmt *statement;
//                                                                                                                                sqlite3 *dataBase;
//                                                                                                                                const char *dbPath = [databasePath UTF8String];
//                                                                                                                                if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                {
//                                                                                                                                    NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT CURRENTSTRIKERCODE, CURRENTNONSTRIKERCODE    FROM INNINGSEVENTS    WHERE @COMPETITIONCODE = '%@' AND MATCHCODE = '%@' AND INNINGSNO = '%@'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
//                                                                                                                                                           const char *update_stmt = [updateSQL UTF8String];        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                           if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                           {
//                                                                                                                                                               while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                   GetStrickerNonStrickerDetail *record=[[GetStrickerNonStrickerDetail alloc]init];
//                                                                                                                                                                   record.WICKETPLAYER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                   record.WICKETTYPE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//
//
//                                                                                                                                                                   [GetStrickerNonStrickerDetails addObject:record];
//                                                                                                                                                               }
//
//                                                                                                                                                           }
//                                                                                                                                                           }
//                                                                                                                                                           sqlite3_finalize(statement);
//                                                                                                                                                           sqlite3_close(dataBase);
//                                                                                                                                                           return GetStrickerNonStrickerDetails;
//                                                                                                                                                           }
//
//                                                                                                                                                           -(NSString * ) GetWicketplayerForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;{
//                                                                                                                                                               NSString *databasePath = [self getDBPath];
//                                                                                                                                                               sqlite3_stmt *statement;
//                                                                                                                                                               sqlite3 *dataBase;
//                                                                                                                                                               const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                               if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                               {
//                                                                                                                                                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETPLAYER   FROM WICKETEVENTS   WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'   AND INNINGSNO = '%@'  AND WICKETTYPE != 'MSC102'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
//                                                                                                                                                                   const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                   sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                   if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                   {
//                                                                                                                                                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                           NSString *WICKETPLAYER =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                           sqlite3_finalize(statement);
//                                                                                                                                                                           sqlite3_close(dataBase);
//                                                                                                                                                                           return WICKETPLAYER;
//                                                                                                                                                                       }
//
//                                                                                                                                                                   }
//                                                                                                                                                                   else {
//                                                                                                                                                                       sqlite3_reset(statement);
//
//                                                                                                                                                                       return @"";
//                                                                                                                                                                   }
//                                                                                                                                                               }
//                                                                                                                                                               sqlite3_reset(statement);
//                                                                                                                                                               return @"";
//                                                                                                                                                           }
//                                                                                                                                                           -(NSString * ) GetWicketplayerInNonStrickerForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO;{
//                                                                                                                                                               NSString *databasePath = [self getDBPath];
//                                                                                                                                                               sqlite3_stmt *statement;
//                                                                                                                                                               sqlite3 *dataBase;
//                                                                                                                                                               const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                               if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                               {
//                                                                                                                                                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT WICKETPLAYER   FROM WICKETEVENTS   WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'   AND INNINGSNO = '%@'  AND WICKETTYPE != 'MSC102'",COMPETITIONCODE,MATCHCODE,INNINGSNO];
//                                                                                                                                                                   const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                   sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                   if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                   {
//                                                                                                                                                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                           NSString *WICKETPLAYER =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                           sqlite3_finalize(statement);
//                                                                                                                                                                           sqlite3_close(dataBase);
//                                                                                                                                                                           return WICKETPLAYER;
//                                                                                                                                                                       }
//
//                                                                                                                                                                   }
//                                                                                                                                                                   else {
//                                                                                                                                                                       sqlite3_reset(statement);
//
//                                                                                                                                                                       return @"";
//                                                                                                                                                                   }
//                                                                                                                                                               }
//                                                                                                                                                               sqlite3_reset(statement);
//                                                                                                                                                               return @"";
//                                                                                                                                                           }
//
//                                                                                                                                                           -(NSString * ) GetStrickerBallsForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) STRIKERCODE  {
//                                                                                                                                                               NSString *databasePath = [self getDBPath];
//                                                                                                                                                               sqlite3_stmt *statement;
//                                                                                                                                                               sqlite3 *dataBase;
//                                                                                                                                                               const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                               if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                               {
//                                                                                                                                                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALL.BALLCODE) as BALLCODE    FROM BALLEVENTS BALL     WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'   AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'         AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE];
//                                                                                                                                                                   const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                   sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                   if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                   {
//                                                                                                                                                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                           NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                           sqlite3_finalize(statement);
//                                                                                                                                                                           sqlite3_close(dataBase);
//                                                                                                                                                                           return BALLCODE;
//                                                                                                                                                                       }
//
//                                                                                                                                                                   }
//                                                                                                                                                                   else {
//                                                                                                                                                                       sqlite3_reset(statement);
//
//                                                                                                                                                                       return @"";
//                                                                                                                                                                   }
//                                                                                                                                                               }
//                                                                                                                                                               sqlite3_reset(statement);
//                                                                                                                                                               return @"";
//                                                                                                                                                           }
//                                                                                                                                                           -(NSString * ) GetStrickerCodeForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) STRIKERCODE {
//                                                                                                                                                               NSString *databasePath = [self getDBPath];
//                                                                                                                                                               sqlite3_stmt *statement;
//                                                                                                                                                               sqlite3 *dataBase;
//                                                                                                                                                               const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                               if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                               {
//                                                                                                                                                                   NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.STRIKERCODE  FROM BALLEVENTS BALL  WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'   AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@'     AND BALL.WIDE = 0       GROUP BY BALL.STRIKERCODE",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE];
//                                                                                                                                                                   const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                   sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                   if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                   {
//                                                                                                                                                                       while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                           NSString *STRIKERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                           sqlite3_finalize(statement);
//                                                                                                                                                                           sqlite3_close(dataBase);
//                                                                                                                                                                           return STRIKERCODE;
//                                                                                                                                                                       }
//
//                                                                                                                                                                   }
//                                                                                                                                                                   else {
//                                                                                                                                                                       sqlite3_reset(statement);
//
//                                                                                                                                                                       return @"";
//                                                                                                                                                                   }
//                                                                                                                                                               }
//                                                                                                                                                               sqlite3_reset(statement);
//                                                                                                                                                               return @"";
//                                                                                                                                                           }
//
//                                                                                                                                                           -(NSMutableArray*)  GetBallEventForInsertScoreEngine:(NSString*) STRIKERBALLS :  (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) STRIKERCODE  ;
//                                                                                                                                                           {
//                                                                                                                                                               NSMutableArray *GetBallEventDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                               NSString *databasePath = [self getDBPath];
//                                                                                                                                                               sqlite3_stmt *statement;
//                                                                                                                                                               sqlite3 *dataBase;
//                                                                                                                                                               const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                               if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                               {
//                                                                                                                                                                   NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@" SELECT BALL.STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME,ISNULL(SUM(BALL.TOTALRUNS),0) AS TOTALRUNS    , ISNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISFOUR = 1 THEN 1 ELSE 0 END),0) AS FOURS    , ISNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISSIX = 1 THEN 1 ELSE 0 END),0) AS SIXES    ,'%@' AS TOTALBALLS,CASE WHEN '%@' = 0 THEN 0 ELSE ((ISNULL(SUM(BALL.TOTALRUNS),0)/@)*100) END AS STRIKERATE, PM.BATTINGSTYLE    FROM BALLEVENTS BALL    INNER JOIN PLAYERMASTER PM ON BALL.STRIKERCODE = PM.PLAYERCODE    WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'    AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'     AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0    GROUP BY BALL.STRIKERCODE,PM.PLAYERNAME, PM.BATTINGSTYLE",STRIKERBALLS,STRIKERBALLS,STRIKERBALLS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE];
//                                                                                                                                                                                          const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                          sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                          if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                          {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                       GetBallEventDetail *record=[[GetBallEventDetail alloc]init];
//                                                                                                                                                                       record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                       record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                       record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                                                                                                                                                                       record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                                                                                                                                                                       record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                                                                                                                                                                       record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                                                                                                                                                                       record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//
//                                                                                                                                                                       [GetBallEventDetails addObject:record];
//                                                                                                                                                                   }
//
//                                                                                                                                                                                          }
//                                                                                                                                                                                          }
//                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                          return GetBallEventDetails;
//                                                                                                                                                                                          }
//
//                                                                                                                                                                                          //Duplicate Method                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          -(NSMutableArray*)  GetBallEventForInsertScoreEngine:(NSString*) STRIKERBALLS :  (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) STRIKERCODE  ;
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              NSMutableArray *GetBallEventDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              sqlite3_stmt *statement;
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              sqlite3 *dataBase;
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              {
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@" SELECT BALL.STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME,ISNULL(SUM(BALL.TOTALRUNS),0) AS TOTALRUNS    , ISNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISFOUR = 1 THEN 1 ELSE 0 END),0) AS FOURS    , ISNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISSIX = 1 THEN 1 ELSE 0 END),0) AS SIXES    ,'%@' AS TOTALBALLS,CASE WHEN '%@' = 0 THEN 0 ELSE ((ISNULL(SUM(BALL.TOTALRUNS),0)/@)*100) END AS STRIKERATE, PM.BATTINGSTYLE    FROM BALLEVENTS BALL    INNER JOIN PLAYERMASTER PM ON BALL.STRIKERCODE = PM.PLAYERCODE    WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'    AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'     AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0    GROUP BY BALL.STRIKERCODE,PM.PLAYERNAME, PM.BATTINGSTYLE",STRIKERBALLS,STRIKERBALLS,STRIKERBALLS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,STRIKERCODE];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      GetBallEventDetail *record=[[GetBallEventDetail alloc]init];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//                                                                                                                                                                                          //
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      [GetBallEventDetails addObject:record];
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  }
//                                                                                                                                                                                          //
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         }
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         }
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         sqlite3_finalize(statement);
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         sqlite3_close(dataBase);
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         return GetBallEventDetails;
//                                                                                                                                                                                          //                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         }
//                                                                                                                                                                                          -(NSMutableArray*) GetPlayermasterForInsertScoreEngine: (NSString*) STRIKERCODE ;
//                                                                                                                                                                                          {
//                                                                                                                                                                                              NSMutableArray *GetPlayermasterDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                              NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                              sqlite3_stmt *statement;
//                                                                                                                                                                                              sqlite3 *dataBase;
//                                                                                                                                                                                              const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                              if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                              {
//                                                                                                                                                                                                  NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@" SELECT PLAYERCODE,PLAYERNAME,0 AS TOTALRUNS, 0 AS FOURS, 0 AS SIXES,0 AS TOTALBALLS, 0 AS STRIKERATE, BATTINGSTYLE    FROM PLAYERMASTER WHERE PLAYERCODE = '%@'",STRIKERCODE];
//                                                                                                                                                                                                                         const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                         sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                         if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                         {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                      GetPlayermasterDetail *record=[[GetPlayermasterDetail alloc]init];
//                                                                                                                                                                                                      record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                      record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                      record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                                                                                                                                                                                                      record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                                                                                                                                                                                                      record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                                                                                                                                                                                                      record.TOTALBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                                                                                                                                                                                                      record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//                                                                                                                                                                                                      record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//
//                                                                                                                                                                                                      [GetPlayermasterDetails addObject:record];
//                                                                                                                                                                                                  }
//
//                                                                                                                                                                                                                         }
//                                                                                                                                                                                                                         }
//                                                                                                                                                                                                                         sqlite3_finalize(statement);
//                                                                                                                                                                                                                         sqlite3_close(dataBase);
//                                                                                                                                                                                                                         return GetPlayermasterDetails;
//                                                                                                                                                                                                                         }
//                                                                                                                                                                                                                         -(NSString * ) GetNonStrickerCodeForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) NONSTRIKERCODESTRIKERCODE  {
//                                                                                                                                                                                                                             NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                             sqlite3_stmt *statement;
//                                                                                                                                                                                                                             sqlite3 *dataBase;
//                                                                                                                                                                                                                             const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                             if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                             {
//                                                                                                                                                                                                                                 NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(BALL.BALLCODE) as BALLCODE  FROM BALLEVENTS BALL        WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'         AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'          AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE];
//                                                                                                                                                                                                                                 const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                 sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                 if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                 {
//                                                                                                                                                                                                                                     while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                         NSString *BALLCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                         sqlite3_finalize(statement);
//                                                                                                                                                                                                                                         sqlite3_close(dataBase);
//                                                                                                                                                                                                                                         return BALLCODE;
//                                                                                                                                                                                                                                     }
//
//                                                                                                                                                                                                                                 }
//                                                                                                                                                                                                                                 else {
//                                                                                                                                                                                                                                     sqlite3_reset(statement);
//
//                                                                                                                                                                                                                                     return @"";
//                                                                                                                                                                                                                                 }
//                                                                                                                                                                                                                             }
//                                                                                                                                                                                                                             sqlite3_reset(statement);
//                                                                                                                                                                                                                             return @"";
//                                                                                                                                                                                                                         }
//
//                                                                                                                                                                                                                         -(NSString * ) GetStrickerCodeforNonStrickerForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) NONSTRIKERCODESTRIKERCODE  {
//                                                                                                                                                                                                                             NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                             sqlite3_stmt *statement;
//                                                                                                                                                                                                                             sqlite3 *dataBase;
//                                                                                                                                                                                                                             const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                             if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                             {
//                                                                                                                                                                                                                                 NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.STRIKERCODE  FROM BALLEVENTS BALL  WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'   AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@'      AND BALL.WIDE = 0      GROUP BY BALL.STRIKERCODE  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE];
//
//                                                                                                                                                                                                                                 const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                 sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                 if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                 {
//                                                                                                                                                                                                                                     while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                         NSString *STRIKERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                         sqlite3_finalize(statement);
//                                                                                                                                                                                                                                         sqlite3_close(dataBase);
//                                                                                                                                                                                                                                         return STRIKERCODE;
//                                                                                                                                                                                                                                     }
//
//                                                                                                                                                                                                                                 }
//                                                                                                                                                                                                                                 else {
//                                                                                                                                                                                                                                     sqlite3_reset(statement);
//
//                                                                                                                                                                                                                                     return @"";
//                                                                                                                                                                                                                                 }
//                                                                                                                                                                                                                             }
//                                                                                                                                                                                                                             sqlite3_reset(statement);
//                                                                                                                                                                                                                             return @"";
//                                                                                                                                                                                                                         }
//
//
//                                                                                                                                                                                                                         -(NSMutableArray*) GetBallEventforNonstrickerForInsertScoreEngine: (NSString*) NONSTRIKERBALLS : (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) NONSTRIKERCODE  ;
//                                                                                                                                                                                                                         {
//                                                                                                                                                                                                                             NSMutableArray *GetBallEventDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                             NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                             sqlite3_stmt *statement;
//                                                                                                                                                                                                                             sqlite3 *dataBase;
//                                                                                                                                                                                                                             const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                             if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                             {
//                                                                                                                                                                                                                                 NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.STRIKERCODE AS PLAYERCODE,PM.PLAYERNAME,ISNULL(SUM(BALL.TOTALRUNS),0) AS TOTALRUNS    , ISNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISFOUR = 1 THEN 1 ELSE 0 END),0) AS FOURS    , ISNULL(SUM(CASE WHEN BALL.BYES = 0 AND BALL.LEGBYES = 0 AND BALL.ISSIX = 1 THEN 1 ELSE 0 END),0) AS SIXES    ,'%@' AS TOTALBALLS, CASE WHEN '%@' = 0 THEN 0 ELSE ((ISNULL(SUM(BALL.TOTALRUNS),0)/'%@')*100) END AS STRIKERATE, PM.BATTINGSTYLE    FROM BALLEVENTS BALL    INNER JOIN PLAYERMASTER PM ON BALL.STRIKERCODE = PM.PLAYERCODE    WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'    AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.STRIKERCODE = '%@' AND BALL.WIDE = 0    GROUP BY BALL.STRIKERCODE,PM.PLAYERNAME, PM.BATTINGSTYLE",NONSTRIKERBALLS,NONSTRIKERBALLS,NONSTRIKERBALLS,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,NONSTRIKERCODE];
//                                                                                                                                                                                                                                                        const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                        sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                        if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                        {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                     GetBallEventDetail *record=[[GetBallEventDetail alloc]init];
//                                                                                                                                                                                                                                     record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                     record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                                                     record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                                                                                                                                                                                                                                     record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                                                                                                                                                                                                                                     record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                                                                                                                                                                                                                                     record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                                                                                                                                                                                                                                     record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//
//                                                                                                                                                                                                                                     [GetBallEventDetails addObject:record];
//                                                                                                                                                                                                                                 }
//
//                                                                                                                                                                                                                                                        }
//                                                                                                                                                                                                                                                        }
//                                                                                                                                                                                                                                                        sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                        sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                        return GetBallEventDetails;
//                                                                                                                                                                                                                                                        }
//
//                                                                                                                                                                                                                                                        -(NSMutableArray*) GetPlayermasterInNonStrickerForInsertScoreEngine: (NSString*) NONSTRIKERCODE ;
//                                                                                                                                                                                                                                                        {
//                                                                                                                                                                                                                                                            NSMutableArray *GetPlayermasterDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                                                            NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                            sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                            sqlite3 *dataBase;
//                                                                                                                                                                                                                                                            const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                            if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                            {
//                                                                                                                                                                                                                                                                NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@" SELECT PLAYERCODE,PLAYERNAME,0 AS TOTALRUNS, 0 AS FOURS, 0 AS SIXES,0 AS TOTALBALLS, 0 AS STRIKERATE, BATTINGSTYLE    FROM PLAYERMASTER WHERE PLAYERCODE = '%@'",NONSTRIKERCODE];
//                                                                                                                                                                                                                                                                                       const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                       sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                       if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                       {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                                                    GetPlayermasterDetail *record=[[GetPlayermasterDetail alloc]init];
//                                                                                                                                                                                                                                                                    record.PLAYERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                    record.PLAYERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                                                                                    record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                                                                                                                                                                                                                                                                    record.FOURS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                                                                                                                                                                                                                                                                    record.SIXES=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                                                                                                                                                                                                                                                                    record.TOTALBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                                                                                                                                                                                                                                                                    record.STRIKERATE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//                                                                                                                                                                                                                                                                    record.BATTINGSTYLE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//
//                                                                                                                                                                                                                                                                    [GetPlayermasterDetails addObject:record];
//                                                                                                                                                                                                                                                                }
//
//                                                                                                                                                                                                                                                                                       }
//                                                                                                                                                                                                                                                                                       }
//                                                                                                                                                                                                                                                                                       sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                       sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                       return GetPlayermasterDetails;
//                                                                                                                                                                                                                                                                                       }
//
//                                                                                                                                                                                                                                                                                       -(NSMutableArray*) GetpartneShiprunsandBallsForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) STRIKERCODE   :(NSString*) NONSTRIKERCODE;
//                                                                                                                                                                                                                                                                                       {
//                                                                                                                                                                                                                                                                                           NSMutableArray *GetpartnerShipBallsandRunsDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                                                                                           NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                           sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                           sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                           const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                           if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                           {
//                                                                                                                                                                                                                                                                                               NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT SUM(GRANDTOTAL) PARTNERSHIPRUNS, SUM(CASE WHEN WIDE > 0 THEN 0 ELSE 1 END) PARTNERSHIPBALLS   FROM BALLEVENTS BALL   WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@' AND BALL.INNINGSNO = '%@'    AND (BALL.STRIKERCODE = '%@' OR BALL.NONSTRIKERCODE = '%@')    AND (BALL.STRIKERCODE = '%@' OR BALL.NONSTRIKERCODE = '%@')",COMPETITIONCODE,MATCHCODE,INNINGSNO,STRIKERCODE,STRIKERCODE,NONSTRIKERCODE,NONSTRIKERCODE];
//                                                                                                                                                                                                                                                                                                                      const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                      sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                      if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                      {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                                                                                   GetpartnerShipBallsandRunsDetail *record=[[GetpartnerShipBallsandRunsDetail alloc]init];
//                                                                                                                                                                                                                                                                                                   record.PARTNERSHIPRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                   record.PARTNERSHIPBALLS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//
//                                                                                                                                                                                                                                                                                                   [GetpartnerShipBallsandRunsDetails addObject:record];
//                                                                                                                                                                                                                                                                                               }
//
//                                                                                                                                                                                                                                                                                                                      }
//                                                                                                                                                                                                                                                                                                                      }
//                                                                                                                                                                                                                                                                                                                      sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                      sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                      return GetpartnerShipBallsandRunsDetails;
//                                                                                                                                                                                                                                                                                                                      }
//                                                                                                                                                                                                                                                                                                                      -(NSString * ) GetBowlerCodeforassignForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) BATTEAMOVERS: (NSString*) BATTEAMOVRWITHEXTRASBALLS: (NSString*) BATTEAMOVRWITHEXTRASBALLCOUNT  {
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                          const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.BOWLERCODE FROM BALLEVENTS BALL WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'     AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@' AND BALL.OVERNO = '%@' AND BALL.BALLNO = '%@'         AND BALL.BALLCOUNT = '%@'         GROUP BY BALL.BOWLERCODE ",COMPETITIONCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BATTEAMOVRWITHEXTRASBALLS,BATTEAMOVRWITHEXTRASBALLCOUNT];
//
//                                                                                                                                                                                                                                                                                                                              const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                              sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                              if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                              {
//                                                                                                                                                                                                                                                                                                                                  while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                      NSString *BOWLERCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                      sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                      sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                      return BOWLERCODE;
//                                                                                                                                                                                                                                                                                                                                  }
//
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                              else {
//                                                                                                                                                                                                                                                                                                                                  sqlite3_reset(statement);
//
//                                                                                                                                                                                                                                                                                                                                  return @"";
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//                                                                                                                                                                                                                                                                                                                          sqlite3_reset(statement);
//                                                                                                                                                                                                                                                                                                                          return @"";
//                                                                                                                                                                                                                                                                                                                      }
//
//                                                                                                                                                                                                                                                                                                                      -(NSString * ) GetWicketForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BATTINGTEAMCODE   :(NSString*) BOWLERCODE{
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                          const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              NSString *updateSQL = [NSString stringWithFormat:@"SELECT COUNT(WKT.WICKETNO) as WICKETNO      FROM BALLEVENTS BALL    INNER JOIN WICKETEVENTS WKT ON WKT.BALLCODE = BALL.BALLCODE       WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'       AND BALL.TEAMCODE = '%@' AND BALL.INNINGSNO = '%@'        AND BALL.BOWLERCODE = '%@' AND WKT.WICKETTYPE IN ('MSC105','MSC104','MSC099','MSC098','MSC096','MSC095')",COMPETITIONCODE,MATCHCODE	 ,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
//
//                                                                                                                                                                                                                                                                                                                              const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                              sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                              if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                              {
//                                                                                                                                                                                                                                                                                                                                  while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                      NSString *WICKETNO =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                      sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                      sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                      return WICKETNO;
//                                                                                                                                                                                                                                                                                                                                  }
//
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                              else {
//                                                                                                                                                                                                                                                                                                                                  sqlite3_reset(statement);
//
//                                                                                                                                                                                                                                                                                                                                  return @"";
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//                                                                                                                                                                                                                                                                                                                          sqlite3_reset(statement);
//                                                                                                                                                                                                                                                                                                                          return @"";
//                                                                                                                                                                                                                                                                                                                      }
//
//
//                                                                                                                                                                                                                                                                                                                      -(NSNumber * ) GetLastBowlerOverNoForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) BOWLERCODE  {
//                                                                                                                                                                                                                                                                                                                          int retVal;
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                             const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                          if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISNULL(MAX(OVERNO),0) as  OVERNO  FROM BALLEVENTS   WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'    AND TEAMCODE = '%@'    AND INNINGSNO = '%@'    AND BOWLERCODE = '%@'  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
//                                                                                                                                                                                                                                                                                                                          stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                          if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                  f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                  NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                  return OVERNO;
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                          return 0;
//                                                                                                                                                                                                                                                                                                                      }
//
//                                                                                                                                                                                                                                                                                                                      -(NSNumber * ) GetLastBowlerOverStatusForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO  ;{
//                                                                                                                                                                                                                                                                                                                          int retVal;
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                             const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                          if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:@" SELECT OVERSTATUS FROM OVEREVENTS  WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'    AND TEAMCODE = '%@'    AND INNINGSNO = '%@'    AND OVERNO='%@'  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,LASTBOWLEROVERNO];
//                                                                                                                                                                                                                                                                                                                          stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                          if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                  f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                  NSNumber *OVERSTATUS = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                  return OVERSTATUS;
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                          return 0;
//                                                                                                                                                                                                                                                                                                                      }
//
//                                                                                                                                                                                                                                                                                                                      -(NSNumber * ) GetLastBowlerOverBallNoStatusForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO : (NSString*) BOWLERCODE  {
//                                                                                                                                                                                                                                                                                                                          int retVal;
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                             const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                          if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:@" SELECT ISNULL(MAX(BALLNO),0) as  BALLNO    FROM BALLEVENTS     WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'     AND TEAMCODE = '%@'     AND INNINGSNO = '%@'     AND BOWLERCODE = '%@'     AND OVERNO = '%@'     AND ISLEGALBALL = 1  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,LASTBOWLEROVERNO];
//                                                                                                                                                                                                                                                                                                                          stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                          if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                  f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                  NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                  return BALLNO;
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                          return 0;
//                                                                                                                                                                                                                                                                                                                      }
//                                                                                                                                                                                                                                                                                                                      -(NSNumber * ) GetLASTBOWLEROVERBALLNOWITHEXTRASForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO : (NSString*) BOWLERCODE  {
//                                                                                                                                                                                                                                                                                                                          int retVal;
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                             const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                          if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:@" SELECT ISNULL(MAX(BALLNO),0) as BALLNO  FROM BALLEVENTS    WHERE COMPETITIONCODE ='%@'   AND MATCHCODE = '%@'     AND TEAMCODE = '%@'     AND INNINGSNO = '%@'     AND BOWLERCODE = '%@'     AND OVERNO = '%@'    )",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,LASTBOWLEROVERNO];
//
//                                                                                                                                                                                                                                                                                                                          stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                          if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                  f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                  NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                  return BALLNO;
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                          return 0;
//                                                                                                                                                                                                                                                                                                                      }
//
//                                                                                                                                                                                                                                                                                                                      -(NSNumber * ) GetLASTBOWLEROVERBALLCOUNTForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO : (NSString*) BOWLERCODE :(NSNumber*) LASTBOWLEROVERBALLNOWITHEXTRAS {
//                                                                                                                                                                                                                                                                                                                          int retVal;
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                             const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                          if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:@"SELECT ISNULL(MAX(BALLNO),0) as  BALLNO  FROM BALLEVENTS  WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'    AND TEAMCODE = '%@'     AND INNINGSNO = '%@'     AND BOWLERCODE = '%@'     AND OVERNO = '%@'     AND BALLNO = '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,LASTBOWLEROVERNO,LASTBOWLEROVERBALLNOWITHEXTRAS];
//
//                                                                                                                                                                                                                                                                                                                          stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                          if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                  f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                  NSNumber *BALLNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                  return BALLNO;
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                          return 0;
//                                                                                                                                                                                                                                                                                                                      }
//
//                                                                                                                                                                                                                                                                                                                      -(NSNumber * ) GetATWOROTWForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE   :(NSString*) LASTBOWLEROVERNO : (NSString*) BOWLERCODE :(NSNumber*) LASTBOWLEROVERBALLNOWITHEXTRAS : (NSNumber*) LASTBOWLEROVERBALLCOUNT {
//                                                                                                                                                                                                                                                                                                                          int retVal;
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                             const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                          if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:@"SELECT ATWOROTW FROM BALLEVENTS   WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'    AND TEAMCODE = '%@'    AND INNINGSNO = '%@'    AND BOWLERCODE = '%@'    AND OVERNO = @'%@'    AND BALLNO = '%@'    AND BALLCOUNT = '%@'  ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,LASTBOWLEROVERNO,LASTBOWLEROVERBALLNOWITHEXTRAS,LASTBOWLEROVERBALLCOUNT];
//
//                                                                                                                                                                                                                                                                                                                          stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                          if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                  f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                  NSNumber *ATWOROTW = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                  return ATWOROTW;
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                          return 0;
//                                                                                                                                                                                                                                                                                                                      }
//
//                                                                                                                                                                                                                                                                                                                      -(NSNumber * ) GetISPARTIALOVERForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSString*) BOWLERCODE:(NSString*) BATTEAMOVERS ;{
//                                                                                                                                                                                                                                                                                                                          int retVal;
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                             const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                          if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:@"SELECT CASE WHEN COUNT(BOWLERCODE) > 1 THEN 1 ELSE 0 END  as BOWLERCODE  FROM BOWLEROVERDETAILS    WHERE COMPETITIONCODE = '%@'    AND MATCHCODE = '%@'    AND TEAMCODE = '%@'    AND INNINGSNO = '%@'    AND OVERNO IN    (     SELECT OVERNO FROM BOWLEROVERDETAILS      WHERE COMPETITIONCODE = '%@'     AND MATCHCODE = '%@'     AND TEAMCODE = '%@'     AND INNINGSNO = '%@'     AND BOWLERCODE = '%@'     AND OVERNO < '%@'    )   ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE,BATTEAMOVERS];
//
//
//                                                                                                                                                                                                                                                                                                                          stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                          if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                  f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                  NSNumber *BOWLERCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                  return BOWLERCODE;
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                          return 0;
//                                                                                                                                                                                                                                                                                                                      }
//
//                                                                                                                                                                                                                                                                                                                      -(NSNumber * ) GetISPARTIALOVERInBowlForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSString*) BOWLERCODE:(NSString*) BATTEAMOVERS ;{
//                                                                                                                                                                                                                                                                                                                          int retVal;
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                             const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                          if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:@"SELECT  COUNT(1) as Count  FROM BOWLEROVERDETAILS   WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'   AND TEAMCODE ='%@'   AND INNINGSNO ='%@'   AND OVERNO ='%@'    AND BOWLERCODE <> '%@'",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BATTEAMOVERS,BOWLERCODE];
//
//
//                                                                                                                                                                                                                                                                                                                          stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                          if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                  NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                  f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                  NSNumber *Count = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                  return Count;
//                                                                                                                                                                                                                                                                                                                              }
//                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                          sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                          sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                          return 0;
//                                                                                                                                                                                                                                                                                                                      }
//                                                                                                                                                                                                                                                                                                                      -(NSMutableArray*) GetTotalBallsBowlForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) STRIKERCODE   :(NSString*) NONSTRIKERCODE;
//                                                                                                                                                                                                                                                                                                                      {
//                                                                                                                                                                                                                                                                                                                          NSMutableArray *GetTotalBallsBowlandmaidenandBowlRunDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                                                                                                                          NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                          sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                          sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                          const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                          if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                          {
//                                                                                                                                                                                                                                                                                                                              NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@" SELECT   IFNULL(SUM(CASE WHEN BALLCOUNT >= 6 AND OVERSTATUS = 1 THEN 6 ELSE BALLCOUNT END),0) as TOTALBALLSBOWL ,    IFNULL(SUM(CASE WHEN BALLCOUNT >= 6 AND OVERSTATUS = 1 AND TOTALRUNS = 0 THEN 1 ELSE 0 END),0) as MAIDENS,    IFNULL(SUM(OE.TOTALRUNS),0) as BOWLERRUNS   FROM   (    SELECT OE.OVERNO + 1 AS OVERNO, ISNULL(SUM(CASE WHEN BALL.ISLEGALBALL = 1 THEN 1 ELSE 0 END),0) AS BALLCOUNT, OE.OVERSTATUS,    ISNULL(SUM(BALL.TOTALRUNS + CASE WHEN BALL.NOBALL > 0 AND BALL.BYES > 0 THEN 1 WHEN BALL.NOBALL > 0 AND BALL.BYES = 0 THEN BALL.NOBALL ELSE 0 END + BALL.WIDE),0) AS TOTALRUNS    FROM BALLEVENTS BALL    INNER JOIN OVEREVENTS OE ON BALL.COMPETITIONCODE = OE.COMPETITIONCODE AND BALL.MATCHCODE = OE.MATCHCODE     AND BALL.INNINGSNO = OE.INNINGSNO AND BALL.TEAMCODE = OE.TEAMCODE AND BALL.OVERNO = OE.OVERNO    WHERE BALL.COMPETITIONCODE = '%@'    AND BALL.MATCHCODE = '%@'    AND BALL.TEAMCODE = '%@'    AND BALL.INNINGSNO = '%@'    AND BALL.BOWLERCODE = '%@'    GROUP BY BOWLERCODE,OE.OVERNO,OE.OVERSTATUS   )OE ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
//                                                                                                                                                                                                                                                                                                                                                     const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                                                     sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                                                     if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                                                     {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                                                                                                                  GetTotalBallsBowlandmaidenandBowlRunDetail *record=[[GetTotalBallsBowlandmaidenandBowlRunDetail alloc]init];
//                                                                                                                                                                                                                                                                                                                                  record.TOTALBALLSBOWL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                  record.MAIDENS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                                                                                                                                                  record.BOWLERRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//
//                                                                                                                                                                                                                                                                                                                                  [GetTotalBallsBowlandmaidenandBowlRunDetails addObject:record];
//                                                                                                                                                                                                                                                                                                                              }
//
//                                                                                                                                                                                                                                                                                                                                                     }
//                                                                                                                                                                                                                                                                                                                                                     }
//                                                                                                                                                                                                                                                                                                                                                     sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                     sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                     return GetTotalBallsBowlandmaidenandBowlRunDetails;
//                                                                                                                                                                                                                                                                                                                                                     }
//                                                                                                                                                                                                                                                                                                                                                     -(NSString*) GetBOWLERSPELLForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BOWLERCODE {
//                                                                                                                                                                                                                                                                                                                                                         NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                                                         sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                                                         sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                                                         const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                                                         if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                                                         {
//                                                                                                                                                                                                                                                                                                                                                             NSString *updateSQL = [NSString stringWithFormat:@"SELECT  SUM(SPELL)  as BOWLERSPELL  FROM  (  SELECT BALL.BOWLERCODE AS BOWLERCODE, BALL.OVERNO   , ISNULL((    SELECT CASE WHEN BALL.OVERNO - MAX(B.OVERNO) > 2 THEN @V_SPELLNO + 1 ELSE @V_SPELLNO END     FROM BALLEVENTS B     WHERE B.COMPETITIONCODE = BALL.COMPETITIONCODE AND B.MATCHCODE = BALL.MATCHCODE      AND B.INNINGSNO = BALL.INNINGSNO AND B.BOWLERCODE = BALL.BOWLERCODE     AND B.OVERNO < BALL.OVERNO     GROUP BY B.COMPETITIONCODE, B.MATCHCODE, B.INNINGSNO, B.BOWLERCODE    ), 1) SPELL    FROM BALLEVENTS BALL    WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'    AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@'    GROUP BY BALL.COMPETITIONCODE, BALL.MATCHCODE, BALL.INNINGSNO, BALL.BOWLERCODE, BALL.OVERNO   ) BOWLERSPELL",COMPETITIONCODE,MATCHCODE,INNINGSNO,BOWLERCODE];
//
//                                                                                                                                                                                                                                                                                                                                                             const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                                                             sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                                                             if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                                                             {
//                                                                                                                                                                                                                                                                                                                                                                 while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                                                     NSString *BOWLERSPELL =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                     sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                     sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                                     return BOWLERSPELL;
//                                                                                                                                                                                                                                                                                                                                                                 }
//
//                                                                                                                                                                                                                                                                                                                                                             }
//                                                                                                                                                                                                                                                                                                                                                             else {
//                                                                                                                                                                                                                                                                                                                                                                 sqlite3_reset(statement);
//
//                                                                                                                                                                                                                                                                                                                                                                 return @"";
//                                                                                                                                                                                                                                                                                                                                                             }
//                                                                                                                                                                                                                                                                                                                                                         }
//                                                                                                                                                                                                                                                                                                                                                         sqlite3_reset(statement);
//                                                                                                                                                                                                                                                                                                                                                         return @"";
//                                                                                                                                                                                                                                                                                                                                                     }
//                                                                                                                                                                                                                                                                                                                                                     -(NSMutableArray*) GetBowlerDetailsForInsertScoreEngine:(NSNumber*) ISPARTIALOVER :(NSNumber*)   LASTBOWLEROVERBALLNO : (NSNumber*)  BOWLERSPELL :(NSNumber*)  BOWLERRUNS :(NSNumber*)  S_ATWOROTW :(NSNumber*)  MAIDENS :(NSNumber*)  WICKETS :(NSNumber*) TOTALBALLSBOWL : (NSNumber*) LASTBOWLEROVERBALLNO:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) INNINGSNO  :(NSString*) BOWLERCODE;
//                                                                                                                                                                                                                                                                                                                                                     {
//                                                                                                                                                                                                                                                                                                                                                         NSMutableArray *GetBolwerDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                                                                                                                                                         NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                                                         sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                                                         sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                                                         const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                                                         if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                                                         {
//                                                                                                                                                                                                                                                                                                                                                             NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT BOWLERCODE, BOWLERNAME, '%@' BOWLERSPELL, '%@' AS TOTALRUNS, '%@' AS ATWOROTW,   CASE WHEN '%@' > 0 THEN   (CASE WHEN '%@' = 0 THEN '0' ELSE CONVERT(NVARCHAR,FLOOR('%@' / 6))+ '.' + CONVERT(NVARCHAR,'%@' % 6) END)   ELSE   CONVERT(NVARCHAR,OVERS) +'.'+ CONVERT(NVARCHAR,'%@')   END AS OVERS,   '%@' AS MAIDENOVERS, '%@' AS WICKETS, (CASE WHEN '%@' = 0 THEN 0 ELSE ('%@' / '%@') * 6 END) AS ECONOMY   FROM   (    SELECT BOWLERCODE,BOWLERNAME,SUM(CASE WHEN OVERSTATUS = 1 THEN 1 ELSE 0 END) OVERS    FROM    (     SELECT BALL.BOWLERCODE AS BOWLERCODE,PM.PLAYERNAME BOWLERNAME,OE.OVERSTATUS     FROM BALLEVENTS BALL     INNER JOIN OVEREVENTS OE ON BALL.COMPETITIONCODE = OE.COMPETITIONCODE AND BALL.MATCHCODE = OE.MATCHCODE      AND BALL.INNINGSNO = OE.INNINGSNO AND BALL.TEAMCODE = OE.TEAMCODE AND BALL.OVERNO = OE.OVERNO     INNER JOIN PLAYERMASTER PM ON BALL.BOWLERCODE = PM.PLAYERCODE     WHERE BALL.COMPETITIONCODE = '%@' AND BALL.MATCHCODE = '%@'     AND BALL.INNINGSNO = '%@' AND BALL.BOWLERCODE = '%@'     GROUP BY BALL.BOWLERCODE,PM.PLAYERNAME,OE.OVERNO,OE.OVERSTATUS    ) OE    GROUP BY BOWLERCODE,BOWLERNAME   ) BOWLDTLS",BOWLERSPELL ,BOWLERRUNS,S_ATWOROTW,ISPARTIALOVER,TOTALBALLSBOWL,TOTALBALLSBOWL,TOTALBALLSBOWL,LASTBOWLEROVERBALLNO,MAIDENS,WICKETS,BOWLERRUNS,TOTALBALLSBOWL,TOTALBALLSBOWL,COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BOWLERCODE];
//                                                                                                                                                                                                                                                                                                                                                                                    const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                                                                                    if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                                                                                    {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                                                                                                                                                 GetBolwerDetail *record=[[GetBolwerDetail alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                 record.BOWLERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                 record.BOWLERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                                                                                                                                                                                 record.BOWLERSPELL=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//                                                                                                                                                                                                                                                                                                                                                                 record.TOTALRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//                                                                                                                                                                                                                                                                                                                                                                 record.ATWOROTW=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//                                                                                                                                                                                                                                                                                                                                                                 record.OVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//                                                                                                                                                                                                                                                                                                                                                                 record.MAIDENOVERS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//                                                                                                                                                                                                                                                                                                                                                                 record.WICKETS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//                                                                                                                                                                                                                                                                                                                                                                 record.ECONOMY=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
//
//                                                                                                                                                                                                                                                                                                                                                                 [GetBolwerDetails addObject:record];
//                                                                                                                                                                                                                                                                                                                                                             }
//
//                                                                                                                                                                                                                                                                                                                                                                                    }
//                                                                                                                                                                                                                                                                                                                                                                                    }
//                                                                                                                                                                                                                                                                                                                                                                                    sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                    sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                    return GetBolwerDetails;
//                                                                                                                                                                                                                                                                                                                                                                                    }
//                                                                                                                                                                                                                                                                                                                                                                                    -(NSNumber * ) GetOverNoInBowlForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSString*) BALLCODENO{
//                                                                                                                                                                                                                                                                                                                                                                                        int retVal;
//                                                                                                                                                                                                                                                                                                                                                                                        NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                                                                                           const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                                                                                        retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                        if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                                                                                        }
//
//                                                                                                                                                                                                                                                                                                                                                                                        NSString *updateSQL = [NSString stringWithFormat:@"SELECT OVERNO FROM BALLEVENTS  WHERE COMPETITIONCODE='%@'   AND MATCHCODE='%@'    AND TEAMCODE='%@'    AND INNINGSNO='%@'   AND BALLCODE = '%@' ",COMPETITIONCODE,MATCHCODE,BATTINGTEAMCODE,INNINGSNO,BALLCODENO];
//
//
//                                                                                                                                                                                                                                                                                                                                                                                        stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                                                                                        {
//                                                                                                                                                                                                                                                                                                                                                                                            while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                                                                                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                                                                                f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                                                                                NSNumber *OVERNO = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                                                                                sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                                sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                                                                                return OVERNO;
//                                                                                                                                                                                                                                                                                                                                                                                            }
//                                                                                                                                                                                                                                                                                                                                                                                        }
//
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                        return 0;
//                                                                                                                                                                                                                                                                                                                                                                                    }
//
//                                                                                                                                                                                                                                                                                                                                                                                    -(NSNumber * ) GetISINNINGSLASTOVERForInsertScoreEngine: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSNumber*) OVERNO{
//                                                                                                                                                                                                                                                                                                                                                                                        int retVal;
//                                                                                                                                                                                                                                                                                                                                                                                        NSString *databasePath =[self getDBPath];
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                                                                                           const char *stmt = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                                                                                        retVal=sqlite3_open([databasePath UTF8String], &dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                        if(retVal !=0){
//                                                                                                                                                                                                                                                                                                                                                                                        }
//
//                                                                                                                                                                                                                                                                                                                                                                                        NSString *updateSQL = [NSString stringWithFormat:@"SELECT   COUNT(BALLCODE) as BALLCODE FROM BALLEVENTS    WHERE COMPETITIONCODE = '%@'   AND MATCHCODE = '%@'   AND INNINGSNO = '%@'      AND TEAMCODE = '%@'         AND OVERNO > '%@' ",COMPETITIONCODE,MATCHCODE,INNINGSNO,BATTINGTEAMCODE,OVERNO];
//
//
//                                                                                                                                                                                                                                                                                                                                                                                        stmt=[query UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                        if(sqlite3_prepare(dataBase, stmt, -1, &statement, NULL)==SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                                                                                        {
//                                                                                                                                                                                                                                                                                                                                                                                            while(sqlite3_step(statement)==SQLITE_ROW){
//
//                                                                                                                                                                                                                                                                                                                                                                                                NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//                                                                                                                                                                                                                                                                                                                                                                                                f.numberStyle = NSNumberFormatterDecimalStyle;
//                                                                                                                                                                                                                                                                                                                                                                                                NSNumber *BALLCODE = [f numberFromString:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//
//                                                                                                                                                                                                                                                                                                                                                                                                sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                                sqlite3_close(dataBase);
//
//                                                                                                                                                                                                                                                                                                                                                                                                return BALLCODE;
//                                                                                                                                                                                                                                                                                                                                                                                            }
//                                                                                                                                                                                                                                                                                                                                                                                        }
//
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                        return 0;
//                                                                                                                                                                                                                                                                                                                                                                                    }
//
//                                                                                                                                                                                                                                                                                                                                                                                    -(NSMutableArray*) GetTeamDetailsForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE;
//                                                                                                                                                                                                                                                                                                                                                                                    {
//                                                                                                                                                                                                                                                                                                                                                                                        NSMutableArray *GetteamDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                                        NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                                                                                        sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                                                                                        const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                        if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                                                                                        {
//                                                                                                                                                                                                                                                                                                                                                                                            NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT BE.TEAMCODE, TM.TEAMNAME  FROM BALLEVENTS BE  INNER JOIN TEAMMASTER TM  ON BE.TEAMCODE = TM.TEAMCODE  WHERE BE.COMPETITIONCODE='%@'   AND BE.MATCHCODE='%@'   GROUP BY BE.TEAMCODE,TM.TEAMNAME",COMPETITIONCODE,MATCHCODE];
//                                                                                                                                                                                                                                                                                                                                                                                                                   const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                                                   sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                                                                                                                   if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                                                                                                                   {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                                                                                                                                                                                GetteamDetail *record=[[GetteamDetail alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                                                record.TEAMCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                                                record.TEAMNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//
//
//                                                                                                                                                                                                                                                                                                                                                                                                [GetteamDetails addObject:record];
//                                                                                                                                                                                                                                                                                                                                                                                            }
//
//                                                                                                                                                                                                                                                                                                                                                                                                                   }
//                                                                                                                                                                                                                                                                                                                                                                                                                   }
//                                                                                                                                                                                                                                                                                                                                                                                                                   sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                                                   sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                                                   return GetteamDetails;
//                                                                                                                                                                                                                                                                                                                                                                                                                   }
//
//                                                                                                                                                                                                                                                                                                                                                                                                                   -(NSMutableArray*) GetUmpireDetailsForInsertScoreEngine;
//                                                                                                                                                                                                                                                                                                                                                                                                                   {
//                                                                                                                                                                                                                                                                                                                                                                                                                       NSMutableArray *GetUmpireDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                                                                       NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                                                                                                                       sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                                                                                                                       sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                                                                                                                       const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                                                       if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                                                                                                                       {
//                                                                                                                                                                                                                                                                                                                                                                                                                           NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT [OFFICIALSCODE] UMPIRECODE, [NAME] UMPIRENAME  FROM OFFICIALSMASTER   WHERE ROLE = 'MSC112'   AND RECORDSTATUS = 'MSC001'"];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                                                                                                                                                                                                               GetUmpireDetail *record=[[GetUmpireDetail alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                                                                               record.UMPIRECODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                                                                               record.UMPIRENAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//
//
//                                                                                                                                                                                                                                                                                                                                                                                                                               [GetUmpireDetails addObject:record];
//                                                                                                                                                                                                                                                                                                                                                                                                                           }
//
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  }
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  }
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  return GetUmpireDetails;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  }
//
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  -(NSMutableArray*) GetFieldingEventDetailsForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE: (NSNumber*) BOWLINGTEAMCODE ;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                  {
//                                                                                                                                                                                                                                                                                                                                                                                                                                                      NSMutableArray *GetfieldingEventDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                      NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                      sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                      sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                      const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                      if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                                                                                                                                                      {
//                                                                                                                                                                                                                                                                                                                                                                                                                                                          NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT FE.BALLCODE,BE.OVERNO,BE.BALLNO,(CONVERT(NVARCHAR,BE.OVERNO)+'.'+CONVERT(NVARCHAR,BE.BALLNO)) AS [OVER],    FE.FIELDERCODE, PM.PLAYERNAME AS FIELDERNAME,FE.FIELDINGFACTORCODE AS FIELDINGEVENTSCODE,    UPPER(FF.FIELDINGFACTOR) AS FIELDINGEVENTS,FE.NRS AS NETRUNS, 'F' AS FLAG    FROM FIELDINGEVENTS FE   INNER JOIN BALLEVENTS BE   ON FE.BALLCODE = BE.BALLCODE   INNER JOIN FIELDINGFACTOR FF   ON FE.FIELDINGFACTORCODE = FF.FIELDINGFACTORCODE   INNER JOIN PLAYERMASTER PM   ON FE.FIELDERCODE = PM.PLAYERCODE   WHERE BE.COMPETITIONCODE = '%@'   AND BE.MATCHCODE = '%@'   AND BE.TEAMCODE <> '%@'",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              GetfieldingEventDetail *record=[[GetfieldingEventDetail alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.BALLCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.OVERNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.BALLNO=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.OVER=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.FIELDERCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.FIELDERNAME=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.FIELDINGEVENTSCODE=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.FIELDINGEVENTS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.NETRUNS=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              record.FLAG=[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//
//
//                                                                                                                                                                                                                                                                                                                                                                                                                                                              [GetfieldingEventDetails addObject:record];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                          }
//
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 }
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 }
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 return GetfieldingEventDetails;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 }

-(BOOL)  UpdateBSForInsertScoreEngine:  (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSNumber*) INNINGSNO;{
    
   @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE BS  SET WICKETOVERNO=BE.OVERNO,    WICKETBALLNO=BE.BALLNO,    WICKETSCORE=(SELECT SUM(GRANDTOTAL) FROM BALLEVENTS BES              WHERE BES.COMPETITIONCODE'%@' AND BES.MATCHCODE='%@' AND BES.INNINGSNO='%@'                 AND (( CAST(CAST(BES.OVERNO AS NVARCHAR(MAX))+'.'+CAST(BES.BALLNO AS NVARCHAR(MAX)) AS FLOAT))                 BETWEEN 0.0 AND  CAST(CAST(BE.OVERNO AS NVARCHAR(MAX))+'.'+CAST(BE.BALLNO AS NVARCHAR(MAX)) AS FLOAT)))   FROM BATTINGSUMMARY BS   INNER JOIN WICKETEVENTS WE ON WE.COMPETITIONCODE=BS.COMPETITIONCODE              AND WE.MATCHCODE=BS.MATCHCODE              AND WE.INNINGSNO=BS.INNINGSNO              AND WE.WICKETPLAYER=BS.BATSMANCODE              AND BS.WICKETTYPE IS NOT NULL   INNER JOIN BALLEVENTS BE ON BE.BALLCODE =WE.BALLCODE   WHERE BS.COMPETITIONCODE='%@' AND BS.MATCHCODE='%@' AND BS.INNINGSNO='%@'",COMPETITIONCODE, MATCHCODE,INNINGSNO,COMPETITIONCODE, MATCHCODE,INNINGSNO];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare_v2(dataBase, selectStmt,-1, &statement, NULL)==SQLITE_OK)
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
                return NO;
            }
        }
        sqlite3_close(dataBase);
        
    }
    
    return NO;
   }
}
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                -(NSMutableArray*) GetBallDetailsForInsertScoreEngine:(NSString*) COMPETITIONCODE: (NSString*) MATCHCODE : (NSNumber*) INNINGSNO :(NSString*) BATTINGTEAMCODE :(NSNumber*) CURRENTOVER;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                {
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    NSMutableArray *GetBallDetails=[[NSMutableArray alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    NSString *databasePath = [self getDBPath];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    sqlite3_stmt *statement;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    sqlite3 *dataBase;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    const char *dbPath = [databasePath UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    {
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        NSString *updateSQL = [NSString stringWithFormat:NSString *updateSQL = [NSString stringWithFormat:@"SELECT BALL.BALLCODE, (CONVERT(VARCHAR,BALL.OVERNO)+'.'+ CONVERT(VARCHAR,BALL.BALLNO)) AS BALLNO,     BWLR.PLAYERNAME BOWLER, STRKR.PLAYERNAME STRIKER, NSTRKR.PLAYERNAME NONSTRIKER,     BT.BOWLTYPE BOWLTYPE, ST.SHOTNAME AS SHOTTYPE, BALL.TOTALRUNS, BALL.TOTALEXTRAS,    BALL.OVERNO,BALL.BALLNO,BALL.BALLCOUNT,BALL.ISLEGALBALL,BALL.ISFOUR,BALL.ISSIX,BALL.RUNS,BALL.OVERTHROW,    BALL.TOTALRUNS,BALL.WIDE,BALL.NOBALL,BALL.BYES,BALL.LEGBYES,BALL.TOTALEXTRAS,BALL.GRANDTOTAL,WE.WICKETNO,WE.WICKETTYPE,BALL.MARKEDFOREDIT,    PTY.PENALTYRUNS, PTY.PENALTYTYPECODE, '' AS ISINNINGSLASTOVER,    (MR.VIDEOLOCATION + '\' + BALL.VIDEOFILENAME) VIDEOFILEPATH    FROM BALLEVENTS BALL    INNER JOIN MATCHREGISTRATION MR    ON MR.COMPETITIONCODE = BALL.COMPETITIONCODE    AND MR.MATCHCODE = BALL.MATCHCODE    INNER JOIN TEAMMASTER TM    ON BALL.TEAMCODE = TM.TEAMCODE    INNER JOIN PLAYERMASTER BWLR    ON BALL.BOWLERCODE=BWLR.PLAYERCODE    INNER JOIN PLAYERMASTER STRKR    ON BALL.STRIKERCODE = STRKR.PLAYERCODE    INNER JOIN PLAYERMASTER NSTRKR    ON BALL.NONSTRIKERCODE = NSTRKR.PLAYERCODE    LEFT JOIN BOWLTYPE BT    ON BALL.BOWLTYPE = BT.BOWLTYPECODE    LEFT JOIN SHOTTYPE ST    ON BALL.SHOTTYPE = ST.SHOTCODE    LEFT JOIN WICKETEVENTS WE    ON BALL.BALLCODE = WE.BALLCODE    AND WE.ISWICKET = 1    LEFT JOIN PENALTYDETAILS PTY    ON BALL.BALLCODE = PTY.BALLCODE    WHERE  BALL.COMPETITIONCODE='%@'     AND BALL.MATCHCODE='%@'     AND BALL.TEAMCODE='%@'     AND BALL.INNINGSNO='%@'     AND BALL.OVERNO = '%@'    ORDER BY BALL.OVERNO, BALL.BALLNO, BALL.BALLCOUNT",COMPETITIONCODE,MATCHCODE,BOWLINGTEAMCODE,INNINGSNO,CURRENTOVER];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               const char *update_stmt = [updateSQL UTF8String];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               if (sqlite3_step(statement) == SQLITE_DONE)
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               {		while(sqlite3_step(statement)==SQLITE_ROW){
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            GetBallDetail *record=[[GetBallDetail alloc]init];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.BALLCODE             =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.BALLNO               =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,1  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.BOWLER               =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,2  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.STRIKER              =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,3  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.NONSTRIKER           =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,4  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.BOWLTYPE             =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,5  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.SHOTTYPE             =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.TOTALRUNS            =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,7  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.TOTALEXTRAS          =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,8  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.OVERNO               =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,9  )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.BALLNO               =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,10 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.BALLCOUNT            =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,11 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.ISLEGALBALL          =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,12 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.ISFOUR               =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,13 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.ISSIX                =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,14 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.RUNS                 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,15 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.OVERTHROW            =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,16 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.TOTALRUNS            =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,17 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.WIDE                 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,18 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.NOBALL               =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,19 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.BYES                 =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,20 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.LEGBYES              =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,21 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.TOTALEXTRAS          =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,22 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.GRANDTOTAL           =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,23 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.WE.WICKETNO          =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,24 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.WE.WICKETTYPE        =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,25 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.BALL.MARKEDFOREDIT   =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,26 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.PTY.PENALTYRUNS      =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,27 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.PTY.PENALTYTYPECODE  =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,28 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.ISINNINGSLASTOVER    =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,29 )];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            record.VIDEOFILEPATH        =[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,30 )];
//
//
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            [GetBallDetails addObject:record];
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        }
//
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               }
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               }
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               sqlite3_finalize(statement);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               sqlite3_close(dataBase);
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               return GetBallDetails;
//                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               }

-(BOOL)InsertAppealEvents: (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE :(NSString*) TEAMCODE : (NSInteger) INNINGSNO : (NSString*) BALLCODE : (NSString*) APPEALTYPECODE : (NSString*) APPEALSYSTEMCODE : (NSString*) APPEALCOMPONENTCODE : (NSString*) UMPIRECODE : (NSString*) BATSMANCODE : (NSString*) ISREFERRED : (NSString*) APPEALDECISION : (NSString*) APPEALCOMMENTS : (NSString*) FIELDERCODE
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *InsertSQL = [NSString stringWithFormat:@"INSERT INTO APPEALEVENTS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE,APPEALTYPECODE,APPEALSYSTEMCODE,APPEALCOMPONENTCODE,UMPIRECODE,BATSMANCODE,ISREFERRED,APPEALDECISION,APPEALCOMMENTS,FIELDERCODE)VALUES('%@','%@','%@',%ld,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",COMPETITIONCODE,MATCHCODE,TEAMCODE,(long)INNINGSNO,BALLCODE,(APPEALTYPECODE==nil || [APPEALTYPECODE isEqualToString:@"(null)"])?@"":APPEALTYPECODE,APPEALSYSTEMCODE,APPEALCOMPONENTCODE,
                               (UMPIRECODE==nil || [UMPIRECODE isEqualToString:@"(null)"])?@"":UMPIRECODE,(BATSMANCODE==nil || [BATSMANCODE isEqualToString:@"(null)"])?@"":BATSMANCODE,ISREFERRED,APPEALDECISION,APPEALCOMMENTS,FIELDERCODE];
        
        const char *selectStmt = [InsertSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry:MATCHCODE :@"APPEALEVENTS" :@"MSC250" :InsertSQL];
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

-(BOOL)  UpdateAppealEvents: (NSString*) APPEALTYPECODE : (NSString*) APPEALSYSTEMCODE : (NSString*) APPEALCOMPONENTCODE : (NSString*) UMPIRECODE : (NSString*) BATSMANCODE : (NSString*) ISREFERRED : (NSString*) APPEALDECISION : (NSString*) APPEALCOMMENTS : (NSString*) FIELDERCODE : (NSString*) BALLCODE
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE APPEALEVENTS SET APPEALTYPECODE = '%@',APPEALSYSTEMCODE = '%@',APPEALCOMPONENTCODE = '%@',UMPIRECODE = '%@',BATSMANCODE = '%@',ISREFERRED = '%@',APPEALDECISION = '%@',APPEALCOMMENTS = '%@',FIELDERCODE = '%@',WHERE BALLCODE = '%@'",APPEALTYPECODE,APPEALSYSTEMCODE,APPEALCOMPONENTCODE,UMPIRECODE,BATSMANCODE,ISREFERRED,APPEALDECISION,APPEALCOMMENTS,FIELDERCODE,BALLCODE];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
            [objPushSyncDBMANAGER InsertTransactionLogEntry: @"" :@"APPEALEVENTS" :@"MSC250" :updateSQL];
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

-(BOOL*) DeleteAppealEvents:(NSString*) BALLCODE
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *DeleteSQL = [NSString stringWithFormat:@"DELETE FROM APPEALEVENTS WHERE BALLCODE='%@'",BALLCODE];
        const char *selectStmt = [DeleteSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
            PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
            [objPushSyncDBMANAGER InsertTransactionLogEntry: @"" :@"APPEALEVENTS" :@"MSC252" :DeleteSQL];
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

-(BOOL)  InsertFieldingEvents : (NSString*) COMPETITIONCODE : (NSString*) MATCHCODE : (NSString*) TEAMCODE : (NSInteger) INNINGSNO : (NSString*) BALLCODE : (NSString*) FIELDERCODE : (NSString*) ISSUBSTITUTE : (NSString*) FIELDINGFACTOR : (NSInteger) NETRUNS
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *InsertSQL = [NSString stringWithFormat:@"INSERT INTO FIELDINGEVENTS(COMPETITIONCODE,MATCHCODE,TEAMCODE,INNINGSNO,BALLCODE,FIELDERCODE,ISSUBSTITUTE,FIELDINGFACTORCODE,NRS)VALUES('%@','%@','%@',%ld,'%@','%@','%@','%@','%@')",COMPETITIONCODE, MATCHCODE,TEAMCODE,(long)INNINGSNO,BALLCODE,(FIELDERCODE == nil ||[FIELDERCODE isEqualToString:@"(null)"] )?@"":FIELDERCODE,ISSUBSTITUTE,(FIELDINGFACTOR == nil ||[FIELDINGFACTOR isEqualToString:@"(null)"] )?@"":FIELDINGFACTOR,NETRUNS];
        
        const char *selectStmt = [InsertSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry: MATCHCODE :@"FIELDINGEVENTS" :@"MSC250" :InsertSQL];
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

-(BOOL)  UpdateFieldingEvents : (NSString*) FIELDERCODE : (NSString*) ISSUBSTITUTE : (NSString*) FIELDINGFACTOR : (NSInteger) NETRUNS: (NSString*) BALLCODE : (NSString*) FIELDINGFACTOR
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE FIELDINGEVENTS SET FIELDINGFACTORCODE = '%@' FIELDERCODE = '%@',ISSUBSTITUTE = '%@',FIELDINGFACTORCODE = '%@',NRS = '%@',WHERE BALLCODE = '%@'",FIELDINGFACTOR,FIELDERCODE,ISSUBSTITUTE,FIELDINGFACTOR,NETRUNS,BALLCODE];
        
        const char *selectStmt = [updateSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry: @"" :@"FIELDINGEVENTS" :@"MSC251" :updateSQL];
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

-(BOOL) DeleteFieldingEvents : (NSString*) BALLCODE
{
    @synchronized ([Utitliy syncId])  {
    NSString *databasePath = [self getDBPath];
    sqlite3_stmt *statement;
    sqlite3 *dataBase;
    const char *dbPath = [databasePath UTF8String];
    if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
    {
        NSString *DeleteSQL = [NSString stringWithFormat:@"DELETE FROM FIELDINGEVENTS WHERE BALLCODE='%@'",BALLCODE];
        const char *selectStmt = [DeleteSQL UTF8String];
        
        if(sqlite3_prepare(dataBase, selectStmt, -1, &statement, NULL)==SQLITE_OK)
        {
            if(sqlite3_step(statement)==SQLITE_DONE){
                sqlite3_reset(statement);
                sqlite3_finalize(statement);
                sqlite3_close(dataBase);
                PushSyncDBMANAGER *objPushSyncDBMANAGER = [[PushSyncDBMANAGER alloc] init];
                [objPushSyncDBMANAGER InsertTransactionLogEntry: @"" :@"FIELDINGEVENTS" :@"MSC252" :DeleteSQL];
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
@end
