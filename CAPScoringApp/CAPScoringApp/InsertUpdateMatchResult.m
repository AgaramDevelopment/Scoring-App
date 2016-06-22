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

-(void) InsertMatchResult:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*)MANOFTHESERIESCODE:(NSString*)BESTBATSMANCODE:(NSString*)BESTBOWLERCODE:(NSString*)BESTALLROUNDERCODE
:(NSString*)MOSTVALUABLEPLAYERCODE:(NSString*)MATCHRESULTCODE:(NSString*)MATCHWONTEAMCODE:(NSNumber*)TEAMAPOINTS:(NSString*)TEAMBPOINTS:(NSString*)MANOFTHEMATCHCODE:(NSString*)COMMENTS:(NSString*)TEAMNAME
:(NSString*)BUTTONNAME

{
    
    
    [DBManagerInsertUpdateMatchResult UpdateCompetitionForInsertMatchResult : MANOFTHESERIESCODE : BESTBATSMANCODE : BESTBOWLERCODE : BESTALLROUNDERCODE : MOSTVALUABLEPLAYERCODE : COMPETITIONCODE];
    
    if([DBManagerInsertUpdateMatchResult GetMatchresultCodeForInsertMatchResult :COMPETITIONCODE : MATCHCODE: @"" ] !=0)
    {
        [DBManagerInsertUpdateMatchResult DeleteMatchResultForInsertMatchResult :COMPETITIONCODE : MATCHCODE  ];
        
        [DBManagerInsertUpdateMatchResult UpdateMatchRegistrationForInsertMatchResult :COMPETITIONCODE : MATCHCODE  ];
        
    }
    else if([DBManagerInsertUpdateMatchResult GetMatchresultCodeInElseIfForInsertMatchResult :COMPETITIONCODE : MATCHCODE : BUTTONNAME ])
    {
        [DBManagerInsertUpdateMatchResult InsertMatchResultForInsertMatchResult : COMPETITIONCODE : MATCHCODE : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS : MANOFTHEMATCHCODE : COMMENTS];
        
        [DBManagerInsertUpdateMatchResult UpdatematchRegistrationElseifForInsertMatchResult : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS : COMPETITIONCODE : MATCHCODE ];
    }
    else
    {
        [DBManagerInsertUpdateMatchResult UpdatematchResultForInsertMatchResult : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS : MANOFTHEMATCHCODE: COMMENTS :  COMPETITIONCODE :MATCHCODE ];
        
        [DBManagerInsertUpdateMatchResult UpdatematchRegistrationinElseForInsertMatchResult : MATCHRESULTCODE : MATCHWONTEAMCODE : TEAMAPOINTS : TEAMBPOINTS : COMPETITIONCODE :MATCHCODE ];
    }
    
    
    
    
    
}

@end
