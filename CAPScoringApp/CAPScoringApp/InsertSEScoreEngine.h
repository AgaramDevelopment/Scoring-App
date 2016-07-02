//
//  InsertSEScoreEngine.h
//  CAPScoringApp
//
//  Created by Stephen on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManagerInsertScoreEngine.h"
@interface InsertSEScoreEngine : NSObject
-(void) InsertScoreEngine:
(NSString *)COMPETITIONCODE:
(NSString*)MATCHCODE :
(NSString*) TEAMCODE :
(NSNumber*) INNINGSNO:
(NSString*) BALLCODE :
(NSNumber*) OVERNO :
(NSNumber*) BALLNO:
(NSNumber*) BALLCOUNT:
(NSNumber*) DAYNO :
(NSNumber*) SESSIONNO :
(NSString *)STRIKERCODE:
(NSString *)NONSTRIKERCODE:
(NSString *)BOWLERCODE:
(NSString *)WICKETKEEPERCODE:
(NSString *)UMPIRE1CODE:
(NSString *)UMPIRE2CODE:
(NSString *)ATWOROTW:
(NSString *)BOWLINGEND:
(NSString *)BOWLTYPE :
(NSString *)SHOTTYPE:
(NSString *)SHOTTYPECATEGORY:
(NSNumber *)ISLEGALBALL:
(NSNumber *)ISFOUR:
(NSNumber *)ISSIX:
(NSNumber *)RUNS:
(NSNumber *)OVERTHROW:
(NSNumber *)TOTALRUNS:
(NSNumber *)WIDE:
(NSNumber *)NOBALL:
(NSNumber *)BYES:
(NSNumber *)LEGBYES:
(NSNumber *)PENALTY:
(NSNumber *)TOTALEXTRAS:
(NSNumber *)GRANDTOTAL:
(NSNumber *)RBW:
(NSString *)PMLINECODE:
(NSString *)PMLENGTHCODE:
(NSNumber *)PMSTRIKEPOINT:
(NSNumber *)PMX1:
(NSNumber *)PMY1:
(NSNumber *)PMX2:
(NSNumber *)PMY2:
(NSNumber *)PMX3:
(NSNumber *)PMY3:
(NSString *)WWREGION:
(NSNumber *)WWX1:
(NSNumber *)WWY1:
(NSNumber *)WWX2:
(NSNumber *)WWY2:
(NSNumber *)BALLDURATION:
(NSNumber *)ISAPPEAL:
(NSNumber *)ISBEATEN:
(NSNumber *)ISUNCOMFORT:
(NSNumber *)ISWTB:
(NSNumber *)ISRELEASESHOT:
(NSString *)MARKEDFOREDIT:
(NSString *)REMARKS:
(NSString *)VIDEOFILENAME:
(NSString *)ISWICKET:
(NSString *)WICKETTYPE:
(NSString *)WICKETPLAYER:
(NSString *)FIELDINGPLAYER:
(NSString *)INSERTTYPE:
(NSString *)AWARDEDTOTEAMCODE:
(NSNumber *)PENALTYRUNS:
(NSString *)PENALTYTYPECODE:
(NSString *)PENALTYREASONCODE:
(NSString *)BALLSPEED:
(NSString *)UNCOMFORTCLASSIFCATION:
(NSString *)WICKETEVENT;
@end
