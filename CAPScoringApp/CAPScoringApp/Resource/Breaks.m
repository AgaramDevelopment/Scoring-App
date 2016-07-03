//
//  Breaks.m
//  CAPScoringApp
//
//  Created by Stephen on 11/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "Breaks.h"


@implementation BreakDetails
@synthesize BREAKNO;
@synthesize BREAKSTARTTIME;
@synthesize BREAKENDTIME;
@synthesize ISINCLUDEINPLAYERDURATION;
@synthesize BREAKCOMMENTS;


//+(void) InsertBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)BREAKSTARTTIME:(NSString*)BREAKENDTIME:
//(NSString*)COMMENTS:(NSString*)ISINCLUDEDURATION:(NSString*)BREAKNO
//{
//    
//    if([DBManager GetMatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE])
//    {
//        if([DBManager GetCompetitionCodeForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : COMMENTS : ISINCLUDEDURATION : BREAKNO])
//        {
//            if([DBManager MatchCodeForInsertBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE : INNINGSNO])
//            {
//                bool insertstatus=[DBManager InsertInningsBreakEvents : COMPETITIONCODE : INNINGSNO : MATCHCODE : BREAKSTARTTIME : BREAKENDTIME : COMMENTS : BREAKNO : ISINCLUDEDURATION];
//            }
//        }
//    }
//    
//    NSMutableArray*BreaksArray=[DBManager GetBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
//    NSString* MAXBREAKNO =[DBManager GetMaxBreakNoForInsertBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];
//}
//
////SP_UPDATEBREAKS
//+(void) UpdateBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)BREAKSTARTTIME:(NSString*)BREAKENDTIME:
//(NSString*)COMMENTS:(NSString*)ISINCLUDEDURATION:(NSString*)BREAKNO;
//{
//    
//    if([DBManager GetMatchCodeForUpdateBreaks : BREAKSTARTTIME : BREAKENDTIME : COMPETITIONCODE : MATCHCODE].length !=0)
//    {
//        if([DBManager GetCompetitionCodeForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : COMMENTS : ISINCLUDEDURATION : BREAKNO])
//        {
//            if([DBManager GetBreakNoForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKSTARTTIME : BREAKENDTIME : BREAKNO ])
//            {
//                bool updatestatus=[DBManager UpdateInningsBreakEvents : BREAKSTARTTIME : BREAKENDTIME : COMMENTS : ISINCLUDEDURATION : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO];
//            }
//        }
//    }
//    
//    NSMutableArray*UpdateBreaksArray=[DBManager GetBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
//    BREAKNO =[DBManager GetMaxBreakNoForUpdateBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];
//}
//
////SP_DELETEBREAKS
//+(void) DeleteBreaks:(NSString *)COMPETITIONCODE:(NSString*)INNINGSNO:(NSString*)MATCHCODE:(NSString*)COMMENTS:(NSString*)BREAKNO
//
//{
//    
//    if([DBManager GetCompetitionCodeForDeleteBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO].length !=0)
//    {
//        
//        bool deletestatus=[DBManager DeleteInningsBreakEvents : COMPETITIONCODE : MATCHCODE : INNINGSNO : BREAKNO];
//    }
//    
//    NSMutableArray*DeleteBreaksArray=[DBManager GetBreakDetails : COMPETITIONCODE : MATCHCODE : INNINGSNO];
//    BREAKNO =[DBManager GetMaxBreakNoForDeleteBreaks : COMPETITIONCODE : MATCHCODE : INNINGSNO];
//}

@end
