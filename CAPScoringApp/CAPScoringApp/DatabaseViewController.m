//
//  DatabaseViewController.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 22/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "DatabaseViewController.h"
static DatabaseViewController *_instance;
@implementation DatabaseViewController

@synthesize database;
@synthesize statement;
@synthesize dbName;
+(DatabaseViewController *)sharedInstance{
    if (_instance == nil) {
        _instance = [[self alloc]init];
    }
    return _instance;
}
-(BOOL)createTable:(NSString *)sqlQuery{
    const char *sql_Query = [sqlQuery UTF8String];
    BOOL returnFlag;
    NSString *dbFilePath = [self getDBFilePath];
    BOOL connectionFlag = [self  getConnection:[dbFilePath UTF8String]];
    if (connectionFlag) {
        if (sqlite3_exec(database,sql_Query,NULL,NULL,NULL) == SQLITE_OK) {
            NSLog(@"table is created successfully");
            returnFlag =YES;
        }else{
            NSLog(@"table is not created ");
            returnFlag =NO;
        }
        [self closeConnection];
    }else{
        NSLog(@"Connection is not opened");
        returnFlag = NO;
    }
    return  returnFlag;
}
// this method is used to insert/ update record in database
-(BOOL)updateQuery:(NSString *)sqlQuery{
    BOOL returnFlag= NO;
    NSString *dbFilePath = [self getDBFilePath];
    BOOL connectionFlag = [self getConnection:[dbFilePath UTF8String]];
    if (connectionFlag) {
        BOOL statementFlag = [self createStatement:sqlQuery];
        if (statementFlag==YES && sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"row is insertedne");
            sqlite3_finalize(statement);
            returnFlag = YES;
        }else{
            NSLog(@"Row can not be inserteded");
            returnFlag = NO;
        }
        [self closeConnection];
    }else{
        returnFlag = NO;
    }
    return returnFlag;
}
// calling this method to close the opened db connection
-(BOOL)closeConnection{
    if (sqlite3_close(database) == SQLITE_OK) {
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)getConnection:(const char*)dbPath{
    if (sqlite3_open(dbPath,&database)== SQLITE_OK) {
        NSLog(@"Connection is openend successfully");
        //NSLog(@"databadfsad %@",database);
        return YES;
    }else{
        NSLog(@"Connection is not openend");
        return NO;
    }
}
-(BOOL)createStatement:(NSString *)querySQL{
    const char *dbquery = [querySQL UTF8String];
    NSLog(@"going texecutere quernt%@",querySQL);
    if (sqlite3_prepare_v2(database,dbquery,-1,&statement,NULL)== SQLITE_OK) {
        NSLog(@"query is executed successfully");
        return YES;
    }else{
        NSLog(@"query is not executed successfully");
        return NO;
    }
}
// below mehod   is used to check and create database in App document directory
-(BOOL)checkNCreateDB{
    //Getting App Path Array
    NSArray *DocsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //Getting App Document Directory path
    NSString *docsPath = [DocsArray objectAtIndex:0];
    //Now we are adding DB File Name in Document Directory path
    NSString *dbPath = [docsPath stringByAppendingPathComponent:self.dbName];
    //Now we are getting File Manager Object to determine Sqlite file existing in Document Directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dbPath]) {
        //Control comes inside if DBFile is not existing and we are are copying that file in Document Directory
        NSString *dbPathInApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.dbName];
        [fileManager copyItemAtPath:dbPathInApp toPath:dbPath error:nil];
        return YES;
    }else{
        //Control comes inside if  DB File is already existing
        NSLog(@"Database is already existing");
        return NO;
    }
}

//Below method is used to select record from Database
-(NSMutableArray *)executeQuery:(NSString *)query{
    [self checkNCreateDB];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    //getting DBPath
    NSString *dbFilePath = [self getDBFilePath];
    //getting Connection
    BOOL connectionCreationFlag = [self getConnection:[dbFilePath UTF8String]];
    if (connectionCreationFlag) {
        NSLog(@"connection is established");
        BOOL statementCreationFlag = [self createStatement:query];
        if (statementCreationFlag) {
            NSLog(@"statement is created in executequery");
            while (sqlite3_step(statement)== SQLITE_ROW) {
                int noOfColumns = sqlite3_data_count(statement);
                NSLog(@"no of rows in database is %d",sqlite3_data_count(statement));
                NSMutableDictionary *dictRow = [[NSMutableDictionary alloc]init];
                for (int i = 0; i< noOfColumns;i++) {
                    NSString *columnValue = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement,i)];
                    [dictRow setObject:columnValue forKey:[NSString stringWithFormat:@"COL%d",i]];
                }
                [dataArray addObject:dictRow];
            }
            sqlite3_finalize(statement);
        }else{
            NSLog(@"statement is not created");
        }
        NSLog(@"connection is closed");
        sqlite3_close(database);
    }else{
        NSLog(@"connection can not be established");
    }
    NSLog(@"dataarray is %@",dataArray);
    return  dataArray;
}

//below method return dbfilepath , which is residing in App Document Directory
-(NSString*) getDBFilePath{
    //getting Docs Array
    NSArray *docsDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //getting Documents Directory path
    NSString *docsPath = [docsDir objectAtIndex:0];
    //getting Database file path
    NSString *DBFilePath = [docsPath stringByAppendingPathComponent:self.dbName];
    NSLog(@"Dbpath is %@",DBFilePath);
    return DBFilePath;
}
//
//- (oneway void)release
//{
//}
//
//- (id)retain
//{
//    return _instance;
//}
//
//- (id)autorelease
//{
//    return _instance;
//}
//
////-(void)dealloc{
////    dbName;
////}
//
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
@end
