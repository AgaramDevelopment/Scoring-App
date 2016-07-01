//
//  InsertSEScoreEngineRecord.h
//  CAPScoringApp
//
//  Created by Stephen on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InsertSEScoreEngineRecord : NSObject

@end

@interface GetInsertTypeGreaterthanZeroDetail : NSObject
@property(strong,nonatomic)NSString *INNINGSNO	;
@property(strong,nonatomic)NSString *TEAMCODE	;
@property(strong,nonatomic)NSString *OVERNO	;
@property(strong,nonatomic)NSString *BALLNO	;
@property(strong,nonatomic)NSString *BALLCOUNT	;
@property(strong,nonatomic)NSString *ISLEGALBALL	;
@property(strong,nonatomic)NSString *STRIKERCODE	;
@property(strong,nonatomic)NSString *BOWLERCODE	;
@end

@interface GetBattingShortnameDetail : NSObject
@property(strong,nonatomic)NSString *SHORTTEAMNAME	;
@property(strong,nonatomic)NSString *TEAMNAME	;
@property(strong,nonatomic)NSString *TEAMLOGO	;
@end

@interface GetBowlingShortnameDetail : NSObject
@property(strong,nonatomic)NSString *SHORTTEAMNAME	;
@property(strong,nonatomic)NSString *TEAMNAME	;
@property(strong,nonatomic)NSString *TEAMLOGO	;
@end

@interface GetTarGetDetail : NSObject
@property(strong,nonatomic)NSString *TARGETRUNS	;
@property(strong,nonatomic)NSString *TARGETOVERS	;
@end

@interface GetMatchDetail : NSObject
@property(strong,nonatomic)NSString *TEAMAWICKETKEEPER	;
@property(strong,nonatomic)NSString *TEAMBWICKETKEEPER	;
@property(strong,nonatomic)NSString *TEAMACAPTAIN	;
@property(strong,nonatomic)NSString *TEAMBCAPTAIN	;
@property(strong,nonatomic)NSString *TEAMACODE	;
@property(strong,nonatomic)NSString *TEAMBCODE	;
@property(strong,nonatomic)NSString *ISDEFAULTORLASTINSTANCE	;
@end


@interface GetBowlDetail : NSObject
@property(strong,nonatomic)NSString *BOWLTYPECODE	;
@property(strong,nonatomic)NSString *BOWLTYPE	;
@property(strong,nonatomic)NSString *METASUBCODEDESCRIPTION	;
@property(strong,nonatomic)NSString *METASUBCODE	;
@end

@interface GetShotTypeDetail : NSObject
@property(strong,nonatomic)NSString *SHOTCODE	;
@property(strong,nonatomic)NSString *SHOTNAME	;
@property(strong,nonatomic)NSString *SHOTTYPE	;
@end

@interface GetRowNumberDetail : NSObject
@property(strong,nonatomic)NSString *rownum	;
@property(strong,nonatomic)NSString *WICKETPLAYER	;
@property(strong,nonatomic)NSString *WICKETTYPE	;
@property(strong,nonatomic)NSString *BALLCODE	;
@property(strong,nonatomic)NSString *COMPETITIONCODE	;
@property(strong,nonatomic)NSString *MATCHCODE	;
@property(strong,nonatomic)NSString *TEAMCODE	;
@property(strong,nonatomic)NSString *INNINGSNO	;
@end


@interface GetBowlPlayerDetail : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE	;
@property(strong,nonatomic)NSString *PLAYERNAME	;
@property(strong,nonatomic)NSString *BOWLINGTYPE	;
@property(strong,nonatomic)NSString *BOWLINGSTYLE	;
@property(strong,nonatomic)NSString *PENULTIMATEBOWLERCODE	;
@end


@interface GetlastBallDetail : NSObject
@property(strong,nonatomic)NSString *ATWOROTW	;
@property(strong,nonatomic)NSString *T_BOWLINGEND	;
@end

@interface GetWicketPlayerandTypeDetail : NSObject
@property(strong,nonatomic)NSString *WICKETPLAYER	;
@property(strong,nonatomic)NSString *WICKETTYPE	;
@end


@interface GetStrickerNonStrickerDetail : NSObject
@property(strong,nonatomic)NSString *CURRENTSTRIKERCODE	;
@property(strong,nonatomic)NSString *CURRENTNONSTRIKERCODE	;
@end

@interface GetBallEventDetail : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE	;
@property(strong,nonatomic)NSString *PLAYERNAME	;
@property(strong,nonatomic)NSString *TOTALRUNS	;
@property(strong,nonatomic)NSString *FOURS	;
@property(strong,nonatomic)NSString *SIXES	;
@property(strong,nonatomic)NSString *STRIKERATE	;
@property(strong,nonatomic)NSString *BATTINGSTYLE	;
@end
@interface GetPlayermasterDetail : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE	;
@property(strong,nonatomic)NSString *PLAYERNAME	;
@property(strong,nonatomic)NSString *TOTALRUNS	;
@property(strong,nonatomic)NSString *FOURS	;
@property(strong,nonatomic)NSString *SIXES	;
@property(strong,nonatomic)NSString *TOTALBALLS	;
@property(strong,nonatomic)NSString *STRIKERATE	;
@property(strong,nonatomic)NSString *BATTINGSTYLE	;
@end
@interface GetpartnerShipBallsandRunsDetail : NSObject
@property(strong,nonatomic)NSString *PARTNERSHIPRUNS	;
@property(strong,nonatomic)NSString *PARTNERSHIPBALLS	;
@end

@interface GetTotalBallsBowlandmaidenandBowlRunDetail : NSObject
@property(strong,nonatomic)NSString *TOTALBALLSBOWL	;
@property(strong,nonatomic)NSString *MAIDENS	;
@property(strong,nonatomic)NSString *BOWLERRUNS	;
@end


@interface GetBolwerDetail : NSObject
@property(strong,nonatomic)NSString *BOWLERCODE	;
@property(strong,nonatomic)NSString *BOWLERNAME	;
@property(strong,nonatomic)NSString *BOWLERSPELL	;
@property(strong,nonatomic)NSString *TOTALRUNS	;
@property(strong,nonatomic)NSString *ATWOROTW	;
@property(strong,nonatomic)NSString *OVERS	;
@property(strong,nonatomic)NSString *MAIDENOVERS	;
@property(strong,nonatomic)NSString *WICKETS	;
@property(strong,nonatomic)NSString *ECONOMY	;
@end
@interface GetteamDetail : NSObject
@property(strong,nonatomic)NSString *TEAMCODE	;
@property(strong,nonatomic)NSString *TEAMNAME	;
@end
@interface GetUmpireDetail : NSObject
@property(strong,nonatomic)NSString *UMPIRECODE	;
@property(strong,nonatomic)NSString *UMPIRENAME	;
@end
@interface GetfieldingEventDetail : NSObject
@property(strong,nonatomic)NSString *BALLCODE	;
@property(strong,nonatomic)NSString *OVERNO	;
@property(strong,nonatomic)NSString *BALLNO	;
@property(strong,nonatomic)NSString *OVER	;
@property(strong,nonatomic)NSString *FIELDERCODE	;
@property(strong,nonatomic)NSString *FIELDERNAME	;
@property(strong,nonatomic)NSString *FIELDINGEVENTSCODE	;
@property(strong,nonatomic)NSString *FIELDINGEVENTS	;
@property(strong,nonatomic)NSString *NETRUNS	;
@property(strong,nonatomic)NSString *FLAG	;
@end


@interface GetBallDetail : NSObject
@property (strong ,nonatomic )NSString *BALLCODE            ;
@property (strong ,nonatomic )NSString *BALLNO              ;
@property (strong ,nonatomic )NSString *BOWLER              ;
@property (strong ,nonatomic )NSString *STRIKER             ;
@property (strong ,nonatomic )NSString *NONSTRIKER          ;
@property (strong ,nonatomic )NSString *BOWLTYPE            ;
@property (strong ,nonatomic )NSString *SHOTTYPE            ;
@property (strong ,nonatomic )NSString *TOTALRUNS           ;
@property (strong ,nonatomic )NSString *TOTALEXTRAS         ;
@property (strong ,nonatomic )NSString *OVERNO              ;
//@property (strong ,nonatomic )NSString *BALLNO              ;
@property (strong ,nonatomic )NSString *BALLCOUNT           ;
@property (strong ,nonatomic )NSString *ISLEGALBALL         ;
@property (strong ,nonatomic )NSString *ISFOUR              ;
@property (strong ,nonatomic )NSString *ISSIX               ;
@property (strong ,nonatomic )NSString *RUNS                ;
@property (strong ,nonatomic )NSString *OVERTHROW           ;
//@property (strong ,nonatomic )NSString *TOTALRUNS           ;
@property (strong ,nonatomic )NSString *WIDE                ;
@property (strong ,nonatomic )NSString *NOBALL              ;
@property (strong ,nonatomic )NSString *BYES                ;
@property (strong ,nonatomic )NSString *LEGBYES             ;
//@property (strong ,nonatomic )NSString *TOTALEXTRAS         ;
@property (strong ,nonatomic )NSString *GRANDTOTAL          ;
@property (strong ,nonatomic )NSString *WICKETNO         ;
@property (strong ,nonatomic )NSString *WICKETTYPE       ;
@property (strong ,nonatomic )NSString *MARKEDFOREDIT  ;
@property (strong ,nonatomic )NSString *PENALTYRUNS     ;
@property (strong ,nonatomic )NSString *PENALTYTYPECODE ;
@property (strong ,nonatomic )NSString *ISINNINGSLASTOVER   ;
@property (strong ,nonatomic )NSString *VIDEOFILEPATH       ;
@end

@interface GetSummaryDetail : NSObject
@property (strong ,nonatomic )NSString *COMPETITIONCODE            ;
@property (strong ,nonatomic )NSString *MATCHCODE              ;
@property (strong ,nonatomic )NSString *MATCHDATE              ;
@property (strong ,nonatomic )NSString *INNINGSNO             ;
@property (strong ,nonatomic )NSString *TEAMCODE          ;
@property (strong ,nonatomic )NSString *SHORTTEAMNAME            ;
@property (strong ,nonatomic )NSString *INNINGSTOTAL            ;
@property (strong ,nonatomic )NSString *INNINGSTOTALWICKETS           ;
@property (strong ,nonatomic )NSString *MATCHOVERS         ;
@property (strong ,nonatomic )NSString *TOTALSCORE              ;
@end
