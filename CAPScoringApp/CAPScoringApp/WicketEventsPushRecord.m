//
//  WicketEventsPushRecord.m
//  CAPScoringApp
//
//  Created by Lexicon on 04/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "WicketEventsPushRecord.h"

@implementation WicketEventsPushRecord
@synthesize BALLCODE;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize INNINGSNO;
@synthesize ISWICKET;
@synthesize WICKETNO;
@synthesize WICKETTYPE;
@synthesize WICKETPLAYER;
@synthesize FIELDINGPLAYER;
@synthesize WICKETEVENT;
@synthesize ISSYNC;

-(NSDictionary *)WicketEventsPushRecordDictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:BALLCODE,@"BALLCODE",COMPETITIONCODE,@"COMPETITIONCODE", MATCHCODE,@"MATCHCODE",TEAMCODE,@"TEAMCODE", INNINGSNO,@"INNINGSNO", ISWICKET,@"ISWICKET",WICKETNO,@"WICKETNO",WICKETTYPE,@"WICKETTYPE", WICKETPLAYER,@"WICKETPLAYER",FIELDINGPLAYER,@"FIELDINGPLAYER", WICKETEVENT,@"WICKETEVENT", ISSYNC,@"ISSYNC", nil];
}


@end
