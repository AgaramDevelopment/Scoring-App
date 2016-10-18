//
//  DBManagerReports.h
//  CAPScoringApp
//
//  Created by Raja sssss on 18/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerReports : NSObject
-(NSMutableArray *)FixturesData:(NSString*)competitionCode :(NSString*)userCode;
@end
