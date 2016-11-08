//
//  DBManagerPlayersKPI.h
//  CAPScoringApp
//
//  Created by Raja sssss on 01/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManagerPlayersKPI : NSObject

-(NSMutableArray *)getBowlingKpi:(NSString*)MATCHTYPECODE:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)TEAMCODE:(NSString*)INNINGSNO:(NSString*)STRIKERCODE:(NSString*)BOWLERCODE;
@end
