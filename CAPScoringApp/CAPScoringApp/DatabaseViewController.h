//
//  DatabaseViewController.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 22/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface DatabaseViewController : NSObject{
    sqlite3 *database;
    sqlite3_stmt *statement;
    NSString *dbName;
}
@property(nonatomic ,assign) sqlite3 *database;
@property(nonatomic ,assign) sqlite3_stmt *statement;
@property(nonatomic ,retain) NSString *dbName;
+(DatabaseViewController *)sharedInstance;
//-(id)initWithDB:(NSString *)db_Name;
-(NSString *)getDBFilePath;
-(BOOL)checkNCreateDB;
-(BOOL)getConnection:(const char*)dbPath;
-(BOOL)createStatement:(NSString *)querySQL;
-(BOOL)closeConnection;
-(BOOL)createTable:(NSString *)sqlQuery;
-(BOOL)updateQuery:(NSString *)sqlQuery;
-(NSMutableArray *)executeQuery:(NSString *)query;
-(void)ProcessData;

@end
