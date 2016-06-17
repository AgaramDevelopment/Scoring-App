////
////  BreakDB.m
////  CAPScoringApp
////
////  Created by Lexicon on 15/06/16.
////  Copyright © 2016 agaram. All rights reserved.
////
//
//#import "BreakDB.h"
//#import "AddBreakVC.h"
//@implementation BreakDB
//
//
//
//
//
//+(NSString *) GetMatchCodeForInsertBreaks:(NSString*) BREAKSTARTTIME:(NSString*) BREAKENDTIME:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE;
//NSString *databasePath = [self getDBPath];
//sqlite3_stmt *statement;
//sqlite3 *dataBase;
//const char *dbPath = [databasePath UTF8String];
//if (sqlite3_open(dbPath, &dataBase) == SQLITE_OK)
//{
//    NSString *updateSQL = [NSString stringWithFormat:@"SELECT MATCHCODE FROM MATCHREGISTRATION WHERE (((CONVERT(DATETIME,'%@'))>= MATCHDATE )) AND ((CONVERT(DATETIME,'%@'))>= MATCHDATE )  AND COMPETITIONCODE ='%@'  AND MATCHCODE='%@' ",BREAKSTARTTIME,BREAKENDTIME,COMPETITIONCODE,MATCHCODE];
//    const char *update_stmt = [updateSQL UTF8String];
//    sqlite3_prepare_v2(dataBase, update_stmt,-1, &statement, NULL);
//    if (sqlite3_step(statement) == SQLITE_DONE)
//    {
//        while(sqlite3_step(statement)==SQLITE_ROW){
//            sqlite3_finalize(statement);
//            sqlite3_close(dataBase);
//            NSString *MATCHCODE =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            
//            return MATCHCODE;
//        }
//        
//    }
//    else {
//        sqlite3_reset(statement);
//        
//        return @"";
//    }
//}
//sqlite3_reset(statement);
//return @"";
//}
//
//@end
