//
//  DBManagerSpellReport.h
//  CAPScoringApp
//
//  Created by APPLE on 19/11/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManagerSpellReport : NSObject

-(NSMutableArray *)getSpellReportDetail:(NSString *)COMPETITIONCODE:(NSString *)MATCHCODE:(NSString *)TEAMCODE:(NSString *)INNINGSNO;

@end
