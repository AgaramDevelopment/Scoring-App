//
//  InsertUpdateMatchResult.m
//  CAPScoringApp
//
//  Created by APPLE on 21/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "InsertUpdateMatchResult.h"
#import "DBManagerInsertUpdateMatchResult.h"

@implementation InsertUpdateMatchResult

//SP_INSERTMATCHRESULTS


-(void) InsertMatchResult:(NSString *)COMPETITIONCODE : (NSString*)MATCHCODE : (NSString*)MANOFTHESERIESCODE : (NSString*)BESTBATSMANCODE : (NSString*)BESTBOWLERCODE :(NSString*)BESTALLROUNDERCODE : (NSString*)MOSTVALUABLEPLAYERCODE : (NSString*)MATCHRESULTCODE : (NSString*)MATCHWONTEAMCODE :(NSNumber*)TEAMAPOINTS :(NSString*)TEAMBPOINTS : (NSString*)MANOFTHEMATCHCODE : (NSString*)COMMENTS :(NSString*)TEAMNAME : (NSString*)BUTTONNAME

{
    DBManagerInsertUpdateMatchResult *objDBManagerInsertUpdateMatchResult = [[DBManagerInsertUpdateMatchResult alloc] init];
    
    [objDBManagerInsertUpdateMatchResult UpdateCompetitionForInsertMatchResult : MANOFTHESERIESCODE : BESTBATSMANCODE : BESTBOWLERCODE : BESTALLROUNDERCODE : MOSTVALUABLEPLAYERCODE : COMPETITIONCODE];
    
    if(![[objDBManagerInsertUpdateMatchResult GetMatchresultCodeForInsertMatchResult :COMPETITIONCODE : MATCHCODE: BUTTONNAME ] isEqual:@""])
    {
        [objDBManagerInsertUpdateMatchResult DeleteMatchResultForInsertMatchResult :COMPETITIONCODE : MATCHCODE  ];
        
        [objDBManagerInsertUpdateMatchResult UpdateMatchRegistrationForInsertMatchResult :COMPETITIONCODE : MATCHCODE  ];
        
    }
    else if([[objDBManagerInsertUpdateMatchResult GetMatchresultCodeInElseIfForInsertMatchResult :COMPETITIONCODE : MATCHCODE : BUTTONNAME ] isEqual:@""])
    {
        [objDBManagerInsertUpdateMatchResult InsertMatchResultForInsertMatchResult : COMPETITIONCODE : MATCHCODE : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS : MANOFTHEMATCHCODE : COMMENTS];
        
        [objDBManagerInsertUpdateMatchResult UpdatematchRegistrationElseifForInsertMatchResult : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS : COMPETITIONCODE : MATCHCODE ];
    }
    else
    {
        [objDBManagerInsertUpdateMatchResult UpdatematchResultForInsertMatchResult : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS : MANOFTHEMATCHCODE: COMMENTS :  COMPETITIONCODE :MATCHCODE ];
        
        [objDBManagerInsertUpdateMatchResult UpdatematchRegistrationinElseForInsertMatchResult : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS : COMPETITIONCODE :MATCHCODE ];
    }
    
    
    
    
    
}

@end
