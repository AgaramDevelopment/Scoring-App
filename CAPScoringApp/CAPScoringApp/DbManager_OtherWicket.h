//
//  DbManager_OtherWicket.h
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbManager_OtherWicket : NSObject

+(NSMutableArray*) GetPlayerDetailForFetchOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE;

+(NSMutableArray*) GetWicketEventDetailsForFetchOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

+(NSString*) GetWicketNoForFetchOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;

+(NSMutableArray*) GetNotOutAndOutBatsManForFetchOtherwicket:(NSString*) MATCHCODE:(NSString*) TEAMCODE;

+(NSMutableArray *)RetrieveOtherWicketType;

@end
