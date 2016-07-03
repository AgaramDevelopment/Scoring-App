//
//  PushSyncDBMANAGER.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushSyncDBMANAGER : NSObject

+(NSMutableArray *)RetrieveMATCHREGISTRATIONData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveMATCHTEAMPLAYERDETAILSData:(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveMATCHRESULTData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveMATCHEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveINNINGSSUMMARYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveINNINGSEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveIINNINGSBREAKEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveBALLEVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveBATTINGSUMMARYData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
+(NSMutableArray *)RetrieveOVEREVENTSData: (NSString *) COMPETITIONCODE :(NSString *) MATCHCODE;
@end
