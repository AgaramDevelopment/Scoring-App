//
//  DbManager_OtherWicket.h
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbManager_OtherWicket : NSObject

+(NSMutableArray*) GetStrickerNonStrickerCodeForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

+(NSMutableArray*) GetPlayerDetailForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

+(NSMutableArray*) GetPlayerDetailOnRetiredHurtForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

+(NSMutableArray*) GetPlayerDetailOnAbsentHurtForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

+(NSMutableArray*) GetPlayerDetailOnTimeOutForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

+(NSMutableArray*) GetPlayerDetailOnRetiredHurt2ForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

+(NSMutableArray*) GetPlayerDetailOnRetiredHurtOnMSC108ForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;


+(NSMutableArray *)RetrieveOtherWicketType;

@end
