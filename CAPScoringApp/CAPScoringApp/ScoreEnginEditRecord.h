//
//  ScoreEnginEditRecord.h
//  CAPScoringApp
//
//  Created by RamaSubramanian on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreEnginEditRecord : NSObject

@end


@interface GetSEDetailsForMatchRegistration : NSObject
@property(strong,nonatomic)NSString *TEAMACODE	;
@property(strong,nonatomic)NSString *TEAMBCODE	;
@property(strong,nonatomic)NSString *MATCHOVERS	;
@end


@interface GetSEDetailsForCompetition : NSObject
@property(strong,nonatomic)NSString *MATCHTYPE	;
@property(strong,nonatomic)NSString *ISOTHERSMATCHTYPE	;
@end

@interface GetSEDetailsForBallEvents : NSObject

@property(strong,nonatomic)NSString *	INNINGSNO;
@property(strong,nonatomic)NSString *	BATTINGTEAMCODE;
@property(strong,nonatomic)NSString *	BOWLINGTEAMCODE;
@end


@interface GetSEDetailsForBattingTeamNames : NSObject
@property(strong,nonatomic)NSString *SHORTTEAMNAME	;
@property(strong,nonatomic)NSString *TEAMNAME	;
@property(strong,nonatomic)NSString *TEAMLOGO	;
@end


@interface GetSEDetailsForBowlingTeamNames : NSObject
@property(strong,nonatomic)NSString *SHORTTEAMNAME	;
@property(strong,nonatomic)NSString *TEAMNAME	;
@property(strong,nonatomic)NSString *TEAMLOGO	;
@end


@interface GetSEDetailsForMtachRevisedTarget : NSObject
@property(strong,nonatomic)NSString *TARGETRUNS	;
@property(strong,nonatomic)NSString *TARGETOVERS	;

@end

@interface GetSEDetailsForMatchDetails : NSObject
@property(strong,nonatomic)NSString *COMPETITIONCODE	;
@property(strong,nonatomic)NSString *MATCHCODE	;
@property(strong,nonatomic)NSString *BATTINGTEAMCODE	;
@property(strong,nonatomic)NSString *BOWLINGTEAMCODE	;
@property(strong,nonatomic)NSString *INNINGSNO	;
@property(strong,nonatomic)NSString *SESSIONNO	;
@property(strong,nonatomic)NSString *DAYNO	;
@property(strong,nonatomic)NSString *MATCHOVERS	;
@property(strong,nonatomic)NSString *MATCHTYPE	;
@property(strong,nonatomic)NSString *ISOTHERSMATCHTYPE	;
@property(strong,nonatomic)NSString *TEAMAWICKETKEEPER	;
@property(strong,nonatomic)NSString *TEAMBWICKETKEEPER	;
@property(strong,nonatomic)NSString *TEAMACAPTAIN	;
@property(strong,nonatomic)NSString *TEAMBCAPTAIN	;
@property(strong,nonatomic)NSString *TEAMACODE	;
@property(strong,nonatomic)NSString *TEAMBCODE	;
@property(strong,nonatomic)NSString *INNINGSSTATUS	;
@end

@interface GetSEDetailsForBowlType : NSObject
@property(strong,nonatomic)NSString *BOWLTYPECODE;
@property(strong,nonatomic)NSString *BOWLTYPE;
@property(strong,nonatomic)NSString *METASUBCODEDESCRIPTION;
@property(strong,nonatomic)NSString *METASUBCODE;
@end


@interface GetSEDetailsForShotType : NSObject
@property(strong,nonatomic)NSString *SHOTCODE;
@property(strong,nonatomic)NSString *SHOTNAME;
@property(strong,nonatomic)NSString *SHOTTYPE;
@end

@interface GetSEDetailsForBallEventsDetails : NSObject
@property(strong,nonatomic)NSString *OVERNO;
@property(strong,nonatomic)NSString *BALLNO;
@property(strong,nonatomic)NSString *BALLCOUNT;
@property(strong,nonatomic)NSString *BOWLERCODE;
@property(strong,nonatomic)NSString *ATWOROTW;
@property(strong,nonatomic)NSString *BOWLINGEND;
@property(strong,nonatomic)NSString *STRIKERCODE;
@property(strong,nonatomic)NSString *NONSTRIKERCODE;
@end


@interface GetSEDetailsForRetiredHurtDetails : NSObject
@property(strong,nonatomic)NSString *rownum;
@property(strong,nonatomic)NSString *WICKETPLAYER;
@property(strong,nonatomic)NSString *WICKETTYPE;
@property(strong,nonatomic)NSString *BALLCODE;
@property(strong,nonatomic)NSString *COMPETITIONCODE;
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *TEAMCODE;
@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *OVERNO;
@property(strong,nonatomic)NSString *BALLNO;
@property(strong,nonatomic)NSString *BALLCOUNT;
@end


@interface GetSEDetailsForBattingTeamPlayers : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE;
@property(strong,nonatomic)NSString *PLAYERNAME;
@property(strong,nonatomic)NSString *BATTINGSTYLE;
@end

@interface GetSEDetailsForBowlingTeamPlayers : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE;
@property(strong,nonatomic)NSString *PLAYERNAME;
@property(strong,nonatomic)NSString *BOWLINGTYPE;
@property(strong,nonatomic)NSString *BOWLINGSTYLE;
@property(strong,nonatomic)NSString *PENULTIMATEBOWLERCODE;
@end


@interface GetSEStrikerDetailsForBallEvents : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE;
@property(strong,nonatomic)NSString *PLAYERNAME;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *FOURS;
@property(strong,nonatomic)NSString *SIXES;
@property(strong,nonatomic)NSString *STRIKERATE;
@property(strong,nonatomic)NSString *BATTINGSTYLE;
@end


@interface GetSEStrikerDetailsForPlayerMaster : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE;
@property(strong,nonatomic)NSString *PLAYERNAME;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *FOURS;
@property(strong,nonatomic)NSString *SIXES;
@property(strong,nonatomic)NSString *STRIKERATE;
@property(strong,nonatomic)NSString *BATTINGSTYLE;
@end


@interface GetSENonStrikerDetailsForBallEvents : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE;
@property(strong,nonatomic)NSString *PLAYERNAME;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *FOURS;
@property(strong,nonatomic)NSString *SIXES;
@property(strong,nonatomic)NSString *STRIKERATE;
@property(strong,nonatomic)NSString *BATTINGSTYLE;
@end


@interface GetSENonStrikerDetailsForPlayerMaster : NSObject
@property(strong,nonatomic)NSString *PLAYERCODE;
@property(strong,nonatomic)NSString *PLAYERNAME;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *FOURS;
@property(strong,nonatomic)NSString *SIXES;
@property(strong,nonatomic)NSString *STRIKERATE;
@property(strong,nonatomic)NSString *BATTINGSTYLE;
@end


@interface GetSEPartnershipDetailsForBallEvents : NSObject
@property(strong,nonatomic)NSString *PARTNERSHIPRUNS;
@property(strong,nonatomic)NSString *PARTNERSHIPBALLS;
@end

@interface GetSEBallCountForBallEvents : NSObject
@property(strong,nonatomic)NSString *TOTALBALLSBOWL;
@property(strong,nonatomic)NSString *MAIDENS;
@property(strong,nonatomic)NSString *BOWLERRUNS;
@end

@interface GetSEBowlerDetailsForBallEvents : NSObject
@property(strong,nonatomic)NSString *BOWLERCODE;
@property(strong,nonatomic)NSString *BOWLERNAME;
@property(strong,nonatomic)NSString *BOWLERSPELL;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *ATWOROTW;
@property(strong,nonatomic)NSString *OVERS;
@property(strong,nonatomic)NSString *ECONOMY;
@end

@interface GetSEUmpireDetailsForBallEvents : NSObject
@property(strong,nonatomic)NSString *UMPIRE1CODE;
@property(strong,nonatomic)NSString *UMPIRE2CODE;
@property(strong,nonatomic)NSString *UMPIRE1NAME;
@property(strong,nonatomic)NSString *UMPIRE2NAME;
@end

@interface GetSEBallCodeDetailsForBallEvents : NSObject
@property(strong,nonatomic)NSString *BALLCODE;
@property(strong,nonatomic)NSString *BALLNO;
@property(strong,nonatomic)NSString *BOWLER;
@property(strong,nonatomic)NSString *STRIKER;
@property(strong,nonatomic)NSString *NONSTRIKER;
@property(strong,nonatomic)NSString *BOWLTYPE;
@property(strong,nonatomic)NSString *SHOTTYPE;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *TOTALEXTRAS;
@property(strong,nonatomic)NSString *OVERNO;
//@property(strong,nonatomic)NSString *BALLNO;
@property(strong,nonatomic)NSString *BALLCOUNT;
@property(strong,nonatomic)NSString *ISLEGALBALL;
@property(strong,nonatomic)NSString *ISFOUR;
@property(strong,nonatomic)NSString *ISSIX;
@property(strong,nonatomic)NSString *RUNS;
@property(strong,nonatomic)NSString *OVERTHROW;
//@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *WIDE;
@property(strong,nonatomic)NSString *NOBALL;
@property(strong,nonatomic)NSString *BYES;
@property(strong,nonatomic)NSString *LEGBYES;
//@property(strong,nonatomic)NSString *TOTALEXTRAS;
@property(strong,nonatomic)NSString *GRANDTOTAL;
@property(strong,nonatomic)NSString *WICKETNO;
@property(strong,nonatomic)NSString *WICKETTYPE;
@property(strong,nonatomic)NSString *WICKETEVENT;
@property(strong,nonatomic)NSString *MARKEDFOREDIT;
@property(strong,nonatomic)NSString *PENALTYRUNS;
@property(strong,nonatomic)NSString *PENALTYTYPECODE;
@property(strong,nonatomic)NSString *ISINNINGSLASTOVER;
@property(strong,nonatomic)NSString *VIDEOFILEPATH;
@end


@interface GetTeamDetailsForBallEventsBE : NSObject
@property(strong,nonatomic)NSString *TEAMCODE;
@property(strong,nonatomic)NSString *TEAMNAME;
@end

@interface GetBallDetailsForBallEventsBE : NSObject
@property (strong ,nonatomic ) NSString *BALLCODE;
@property (strong ,nonatomic ) NSString *COMPETITIONCODE;
@property (strong ,nonatomic ) NSString *MATCHCODE               ;
@property (strong ,nonatomic ) NSString *TEAMCODE                ;
@property (strong ,nonatomic ) NSString *INNINGSNO               ;
@property (strong ,nonatomic ) NSString *OVERNO                  ;
@property (strong ,nonatomic ) NSString *BALLNO                  ;
@property (strong ,nonatomic ) NSString *BALLCOUNT               ;
@property (strong ,nonatomic ) NSString *SESSIONNO               ;
@property (strong ,nonatomic ) NSString *STRIKERCODE            ;
@property (strong ,nonatomic ) NSString *NONSTRIKERCODE          ;
@property (strong ,nonatomic ) NSString *BOWLERCODE              ;
@property (strong ,nonatomic ) NSString *WICKETKEEPERCODE        ;
@property (strong ,nonatomic ) NSString *UMPIRE1CODE             ;
@property (strong ,nonatomic ) NSString *UMPIRE2CODE             ;
@property (strong ,nonatomic ) NSString *ATWOROTW                ;
@property (strong ,nonatomic ) NSString *BOWLINGEND              ;
@property (strong ,nonatomic ) NSString *BOWLTYPECODE;
//BOWLTYPE AS
@property (strong ,nonatomic ) NSString *BOWLTYPE             ;
@property (strong ,nonatomic ) NSString *BOWLERTYPE           ;
@property (strong ,nonatomic ) NSString * SHOTCODE    ;
//SHOTTYPE AS
@property (strong ,nonatomic ) NSString *SHOTNAME             ;
@property (strong ,nonatomic ) NSString *SHOTTYPE             ;
@property (strong ,nonatomic ) NSString *SHOTTYPECATEGORY        ;
@property (strong ,nonatomic ) NSString *ISLEGALBALL             ;
@property (strong ,nonatomic ) NSString *ISFOUR                  ;
@property (strong ,nonatomic ) NSString *ISSIX                   ;
@property (strong ,nonatomic ) NSString *RUNS                 ;
@property (strong ,nonatomic ) NSString *OVERTHROW               ;
@property (strong ,nonatomic ) NSString *TOTALRUNS               ;
@property (strong ,nonatomic ) NSString *WIDE                    ;
@property (strong ,nonatomic ) NSString *NOBALL                  ;
@property (strong ,nonatomic ) NSString *BYES                    ;
@property (strong ,nonatomic ) NSString *LEGBYES                 ;
@property (strong ,nonatomic ) NSString *PENALTY                 ;
@property (strong ,nonatomic ) NSString *TOTALEXTRAS             ;
@property (strong ,nonatomic ) NSString *GRANDTOTAL              ;
@property (strong ,nonatomic ) NSString *RBW                     ;
@property (strong ,nonatomic ) NSString *PMLINECODE            ;
@property (strong ,nonatomic ) NSString *PMLENGTHCODE            ;
@property (strong ,nonatomic ) NSString *PMSTRIKEPOINT           ;
@property (strong ,nonatomic ) NSString *PMSTRIKEPOINTLINECODE   ;
@property (strong ,nonatomic ) NSString *PMX1                    ;
@property (strong ,nonatomic ) NSString *PMY1                    ;
@property (strong ,nonatomic ) NSString *PMX2                    ;
@property (strong ,nonatomic ) NSString *PMY2                    ;
@property (strong ,nonatomic ) NSString *PMX3                    ;
@property (strong ,nonatomic ) NSString *PMY3                    ;
@property (strong ,nonatomic ) NSString *WWREGION                ;
@property (strong ,nonatomic ) NSString *REGIONNAME              ;
@property (strong ,nonatomic ) NSString *WWX1                    ;
@property (strong ,nonatomic ) NSString *WWY1                    ;
@property (strong ,nonatomic ) NSString *WWX2                    ;
@property (strong ,nonatomic ) NSString *WWY2                    ;
@property (strong ,nonatomic ) NSString *BALLDURATION            ;
@property (strong ,nonatomic ) NSString *ISAPPEAL                ;
@property (strong ,nonatomic ) NSString *ISBEATEN                ;
@property (strong ,nonatomic ) NSString *ISUNCOMFORT             ;
@property (strong ,nonatomic ) NSString *UNCOMFORTCLASSIFCATION  ;
@property (strong ,nonatomic ) NSString *ISWTB                   ;
@property (strong ,nonatomic ) NSString *ISRELEASESHOT           ;
@property (strong ,nonatomic ) NSString *MARKEDFOREDIT           ;
@property (strong ,nonatomic ) NSString *REMARKS                 ;
@property (strong ,nonatomic ) NSString *BALLSPEED               ;
@property (strong ,nonatomic ) NSString *BALLSPEEDTYPE;
@property (strong ,nonatomic ) NSString *BALLSPEEDCODE;
@property (strong ,nonatomic ) NSString *UNCOMFORTCLASSIFICATION ;
@property (strong ,nonatomic ) NSString *UNCOMFORTCLASSIFICATIONCODE   ;
@property (strong ,nonatomic ) NSString *UNCOMFORTCLASSIFICATIONSUBCODE;
@end


@interface GetSEWicketDetailsForWicketEvents : NSObject
@property(strong,nonatomic)NSString *BALLCODE;
@property(strong,nonatomic)NSString *ISWICKET;
@property(strong,nonatomic)NSString *WICKETNO;
@property(strong,nonatomic)NSString *WICKETTYPE;
@property(strong,nonatomic)NSString *WICKETPLAYER;
@property(strong,nonatomic)NSString *FIELDINGPLAYER;
@property(strong,nonatomic)NSString *VIDEOLOCATION;
@property(strong,nonatomic)NSString *WICKETEVENT;
@end


@interface GetSEAppealDetailsForAppealEvents : NSObject
@property(strong,nonatomic)NSString *BALLCODE;
@property(strong,nonatomic)NSString *OVERS;
@property(strong,nonatomic)NSString *APPEALTYPECODE;
@property(strong,nonatomic)NSString *APPEALTYPEDES;
@property(strong,nonatomic)NSString *APPEALSYSTEMCODE;
@property(strong,nonatomic)NSString *APPEALSYSTEMDES;
@property(strong,nonatomic)NSString *APPEALCOMPONENTCODE;
@property(strong,nonatomic)NSString *APPEALCOMPONENTDES;
@property(strong,nonatomic)NSString *UMPIRECODE;
@property(strong,nonatomic)NSString *UMPIRENAME;
@property(strong,nonatomic)NSString *BATSMANCODE;
@property(strong,nonatomic)NSString *BATSMANNAME;
@property(strong,nonatomic)NSString *ISREFERREDDESC;
@property(strong,nonatomic)NSString *ISREFERRED;
@property(strong,nonatomic)NSString *BOWLERNAME;
@property(strong,nonatomic)NSString *APPEALDECISIONDESC;
@property(strong,nonatomic)NSString *APPEALDECISION;
@property(strong,nonatomic)NSString *APPEALCOMMENTS;
@property(strong,nonatomic)NSString *FLAG;
@end


@interface GetSEPenaltyDetailsForPenaltyEvents : NSObject
@property(strong,nonatomic)NSString *COMPETITIONCODE;
@property(strong,nonatomic)NSString *MATCHCODE;
@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *BALLCODE;
@property(strong,nonatomic)NSString *PENALTYCODE;
@property(strong,nonatomic)NSString *AWARDEDTOTEAMCODE;
@property(strong,nonatomic)NSString *PENALTYRUNS;
@property(strong,nonatomic)NSString *PENALTYTYPECODE;
@property(strong,nonatomic)NSString *PENALTYTYPEDESCRIPTION;
@property(strong,nonatomic)NSString *PENALTYREASONCODE;
@property(strong,nonatomic)NSString *PENALTYREASONDESCRIPTION;
@end


@interface GetSESpinBallSpeedDetails: NSObject
@property(strong,nonatomic)NSString *METASUBCODE;
@property(strong,nonatomic)NSString *METADATATYPECODE;
@property(strong,nonatomic)NSString *METADATATYPEDESCRIPTION;
@property(strong,nonatomic)NSString *METASUBCODEDESCRIPTION;
@end

@interface GetSEFastBallSpeedDetails : NSObject
@property(strong,nonatomic)NSString *METASUBCODE;
@property(strong,nonatomic)NSString *METADATATYPECODE;
@property(strong,nonatomic)NSString *METADATATYPEDESCRIPTION;
@property(strong,nonatomic)NSString *METASUBCODEDESCRIPTION;
@end

