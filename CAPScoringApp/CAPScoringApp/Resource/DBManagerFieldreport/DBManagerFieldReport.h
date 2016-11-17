//
//  DBManagerFieldReport.h
//  CAPScoringApp
//
//  Created by APPLE on 16/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagerFieldReport : NSObject

-(NSMutableArray *) getFieldingdetails:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE :(NSString *)TEAMCODE :(NSString *) INNINGSNO :(NSString *) FIELDERCODE :(NSString *) FIELDINGFACTORCODE ;

-(NSMutableArray *)GETFIELDINGFACTORCODE;

-(NSMutableArray *) GETFIELDERCODE:(NSString *) COMPETITIONCODE :(NSString *) MATCHCODE :(NSString *)TEAMCODE :(NSString *) INNINGSNO ;

@end
