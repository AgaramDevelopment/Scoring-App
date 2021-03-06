//
//  BALLEVENTSPushRecords.m
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 7/3/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "BALLEVENTSPushRecords.h"

@implementation BALLEVENTSPushRecords



@synthesize BALLCODE;
@synthesize COMPETITIONCODE;
@synthesize MATCHCODE;
@synthesize TEAMCODE;
@synthesize DAYNO;
@synthesize INNINGSNO;
@synthesize OVERNO;
@synthesize BALLNO;
@synthesize BALLCOUNT;
@synthesize OVERBALLCOUNT;
@synthesize SESSIONNO;
@synthesize STRIKERCODE;
@synthesize NONSTRIKERCODE;
@synthesize BOWLERCODE;
@synthesize WICKETKEEPERCODE;
@synthesize UMPIRE1CODE;
@synthesize UMPIRE2CODE;
@synthesize ATWOROTW;
@synthesize BOWLINGEND;
@synthesize BOWLTYPE;
@synthesize SHOTTYPE;
@synthesize ISLEGALBALL;
@synthesize ISFOUR;
@synthesize ISSIX;
@synthesize RUNS;
@synthesize OVERTHROW;
@synthesize TOTALRUNS;
@synthesize WIDE;
@synthesize NOBALL;
@synthesize BYES;
@synthesize LEGBYES;
@synthesize PENALTY;
@synthesize TOTALEXTRAS;
@synthesize GRANDTOTAL;
@synthesize RBW;
@synthesize PMLINECODE;
@synthesize PMLENGTHCODE;
@synthesize PMX1;
@synthesize PMY1;
@synthesize PMX2;
@synthesize PMY2;
@synthesize PMX3;
@synthesize PMY3;
@synthesize WWREGION;
@synthesize WWX1;
@synthesize WWY1;
@synthesize WWX2;
@synthesize WWY2;
@synthesize BALLDURATION;
@synthesize ISAPPEAL;
@synthesize ISBEATEN;
@synthesize ISUNCOMFORT;
@synthesize ISWTB;
@synthesize ISRELEASESHOT;
@synthesize MARKEDFOREDIT;
@synthesize REMARKS;
@synthesize VIDEOFILENAME;
@synthesize SHOTTYPECATEGORY;
@synthesize PMSTRIKEPOINT;
@synthesize PMSTRIKEPOINTLINECODE;
@synthesize BALLSPEED;
@synthesize UNCOMFORTCLASSIFCATION;
@synthesize ISSYNC;




-(NSMutableDictionary *)BALLEVENTSPushRecordsDictionary {
    
    
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:BALLCODE,@"BALLCODE",COMPETITIONCODE,@"COMPETITIONCODE", MATCHCODE,@"MATCHCODE",TEAMCODE,@"TEAMCODE", DAYNO,@"DAYNO", INNINGSNO,@"INNINGSNO",OVERNO,@"OVERNO",BALLNO,@"BALLNO", BALLCOUNT,@"BALLCOUNT",OVERBALLCOUNT,@"OVERBALLCOUNT", SESSIONNO,@"SESSIONNO", STRIKERCODE,@"STRIKERCODE",NONSTRIKERCODE,@"NONSTRIKERCODE", BOWLERCODE,@"BOWLERCODE", WICKETKEEPERCODE,@"WICKETKEEPERCODE", UMPIRE1CODE,@"UMPIRE1CODE", UMPIRE2CODE,@"UMPIRE2CODE",ATWOROTW,@"ATWOROTW", BOWLINGEND,@"BOWLINGEND", BOWLTYPE,@"BOWLTYPE", SHOTTYPE,@"SHOTTYPE",ISLEGALBALL,@"ISLEGALBALL", ISFOUR,@"ISFOUR", ISSIX,@"ISSIX", RUNS,@"RUNS", OVERTHROW, @"OVERTHROW", TOTALRUNS ,@"TOTALRUNS", WIDE, @"WIDE", NOBALL ,@"NOBALL",BYES, @"BYES",LEGBYES, @"LEGBYES",PENALTY ,@"PENALTY", TOTALEXTRAS, @"TOTALEXTRAS", GRANDTOTAL, @"GRANDTOTAL", RBW ,@"RBW", PMLINECODE ,@"PMLINECODE", PMLENGTHCODE ,@"PMLENGTHCODE", PMX1 ,@"PMX1", PMY1 ,@"PMY1", PMX2, @"PMX2",PMY2, @"PMY2", PMX3 ,@"PMX3", PMY3, @"PMY3", WWREGION ,@"WWREGION", WWX1, @"WWX1", WWY1 ,@"WWY1", WWX2, @"WWX2",WWY2 ,@"WWY2", BALLDURATION ,@"BALLDURATION", ISAPPEAL, @"ISAPPEAL", ISBEATEN ,@"ISBEATEN", ISUNCOMFORT ,@"ISUNCOMFORT", ISWTB ,@"ISWTB", ISRELEASESHOT, @"ISRELEASESHOT", MARKEDFOREDIT, @"MARKEDFOREDIT", REMARKS, @"REMARKS", VIDEOFILENAME ,@"VIDEOFILENAME", SHOTTYPECATEGORY, @"SHOTTYPECATEGORY",PMSTRIKEPOINT ,@"PMSTRIKEPOINT", PMSTRIKEPOINTLINECODE, @"PMSTRIKEPOINTLINECODE", BALLSPEED ,@"BALLSPEED", UNCOMFORTCLASSIFCATION ,@"UNCOMFORTCLASSIFCATION", ISSYNC, @"ISSYNC", nil];
}


@end
