//
//  InsertSEScoreEngine.m
//  CAPScoringApp
//
//  Created by Stephen on 30/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "InsertSEScoreEngine.h"
#import "InningsBowlerDetailsRecord.h"
#import "OverBallCountRecord.h"

@implementation InsertSEScoreEngine

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
(NSString *)WICKETEVENT
{
    NSString* BATTINGTEAMCODE;
    NSString* BOWLINGTEAMCODE ;
    NSString* BATTEAMSHORTNAME ;
    NSString* BOWLTEAMSHORTNAME ;
    NSString* BATTEAMNAME ;
    NSString* BOWLTEAMNAME;
    NSString* MATCHOVERS ;
    NSString* BATTEAMLOGO;
    NSString* BOWLTEAMLOGO;
    NSString* MATCHTYPE;
    NSString* INNINGSSTATUS ;
    NSString* BALLCODENO ;
    NSString* MAXID ;
    NSString* SB_STRIKERCODE ;
    NSString* SB_BOWLERCODE ;
    NSNumber* N_OVERNO ;
    NSNumber* N_BALLNO ;
    NSNumber* N_BALLCOUNT ;
    NSNumber* OVERBALLCOUNT ;
    NSNumber* T_OVERNO ;
    NSNumber* T_BALLNO ;
    NSNumber* T_BALLCOUNT ;
    NSNumber* T_ISLEGALBALL ;
    NSString* MAXPENALTYID ;
    NSString* PENALTYCODE ;
    NSString* PREVIOUSBALLCODE ;
    NSString* PREVIOUSBOWLERCODE ;
    NSNumber* T_TOTALRUNS ;
    NSString* T_STRIKERCODE ;
    NSString* T_NONSTRIKERCODE ;
    
    objoverballCount=[[NSMutableArray alloc]init];
    
    SB_STRIKERCODE = STRIKERCODE;
    SB_BOWLERCODE = BOWLERCODE;
    
    if([DBManagerInsertScoreEngine GetBallCodeForInsertScoreEngine : COMPETITIONCODE :MATCHCODE].length != 0)
    {
        BOOL SqlStatus = [DBManagerInsertScoreEngine UpdateMatchStatusForInsertScoreEngine : COMPETITIONCODE :MATCHCODE ];
       
        
    }
    BALLCOUNT=[DBManagerInsertScoreEngine GetBallCountForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE: INNINGSNO:OVERNO: BALLNO ];
    
    
    if([DBManagerInsertScoreEngine GetBallCodesForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE: INNINGSNO:OVERNO: BALLNO : BALLCOUNT ].length <= 0)
    {
        if(BALLCODE.length == 0)
        {
            BALLCODENO=[DBManagerInsertScoreEngine GetMaxIdForInsertScoreEngine :MATCHCODE ];
        }
        
        if(INSERTTYPE.length >0)
        {
            NSMutableArray *_GetInsertTypeGreaterthanZeroDetails=[ DBManagerInsertScoreEngine GetInsertTypeGreaterthanZeroDetailsForInsertScoreEngine :  COMPETITIONCODE:  MATCHCODE: BALLCODE ];
            if(_GetInsertTypeGreaterthanZeroDetails.count>0)
            {
                GetInsertTypeGreaterthanZeroDetail *Recorddetails = [_GetInsertTypeGreaterthanZeroDetails objectAtIndex:0];
                INNINGSNO=[Recorddetails INNINGSNO];
                TEAMCODE=[Recorddetails TEAMCODE];
                T_OVERNO=[Recorddetails OVERNO];
                T_BALLNO=[Recorddetails BALLNO];
                T_BALLCOUNT=[Recorddetails BALLCOUNT];
                T_ISLEGALBALL=[Recorddetails ISLEGALBALL];
                SB_STRIKERCODE=[Recorddetails STRIKERCODE];
                SB_BOWLERCODE=[Recorddetails BOWLERCODE];
            }
            
            N_OVERNO = T_OVERNO;
            
            if (INSERTTYPE == @"BEFORE")
            {
                N_BALLNO = T_BALLNO;
                N_BALLCOUNT = T_BALLCOUNT;
                if(T_BALLCOUNT == [NSNumber numberWithInt:1])
                {
                    [DBManagerInsertScoreEngine UpdateBallEventtableForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :TEAMCODE: T_OVERNO : T_BALLNO];
                }
                else
                {
                    [DBManagerInsertScoreEngine UpdateBallEventtableForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :TEAMCODE: T_OVERNO : T_BALLNO];
                    [DBManagerInsertScoreEngine UpdateBallEventtablesForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :TEAMCODE: T_OVERNO : T_BALLNO : T_BALLCOUNT];//Method Overloading
                }
            }
            else if(INSERTTYPE == @"AFTER")
            {
                if(T_ISLEGALBALL == [NSNumber numberWithInt:1])
                {
                    N_BALLNO = [NSNumber numberWithInt: ([T_BALLNO intValue] + 1)];
                    N_BALLCOUNT = [NSNumber numberWithInt:1];
                    [DBManagerInsertScoreEngine UpdateBallEventtableForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :TEAMCODE: T_OVERNO : T_BALLNO];
                }
                else
                {
                    [DBManagerInsertScoreEngine UpdateBallEventtableForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :TEAMCODE: T_OVERNO : T_BALLNO];
                    if  (T_BALLCOUNT > 1)
                    {
                        N_BALLNO = [NSNumber numberWithInt: ([T_BALLNO intValue] + 1)];
                        N_BALLCOUNT = [NSNumber numberWithInt:1];
                        [DBManagerInsertScoreEngine UpdateBallEventtablesInAddBallNoForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :TEAMCODE: T_OVERNO : T_BALLNO : T_BALLCOUNT];
                    }
                    else
                    {
                        N_BALLNO = T_BALLNO;
                        N_BALLCOUNT = [NSNumber numberWithInt: ([T_BALLCOUNT intValue] + 1)] ;
                        
                        [DBManagerInsertScoreEngine UpdateBallEventtablesInAddBallNoForInsertScoreEngine : COMPETITIONCODE :MATCHCODE :TEAMCODE :INNINGSNO :TEAMCODE: T_OVERNO : T_BALLNO : T_BALLCOUNT];
                    }
                }
            }
            [DBManagerInsertScoreEngine InsertBallEventForInsertScoreEngine :BALLCODENO:N_BALLNO:N_BALLCOUNT:BALLSPEED:UNCOMFORTCLASSIFCATION:COMPETITIONCODE: MATCHCODE:INNINGSNO:TEAMCODE: BALLCODE];
           NSMutableArray * inningsDetail= [DBManagerInsertScoreEngine getOverBallCountDetails :COMPETITIONCODE : MATCHCODE: T_OVERNO : INNINGSNO];
//            if(INSERTTYPE ==@"AFTER")
//            {
//                for(int i=0; i<inningsDetail.count; i++)
//                {
//                    OverBallCountRecord *objRecord =(OverBallCountRecord *)[inningsDetail objectAtIndex:i];
//                    if(BALLCODE == objRecord.objBallCode)
//                    {
//                        
//                    }
//                }
//            }
//            else if (INSERTTYPE ==@"BEFORE")
//            {
//                
//            }
//           
            
            
            
            [DBManagerInsertScoreEngine UpdateOverBallCountInBallEventtForInsertScoreEngine :COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO: T_OVERNO];
           // [DBManagerInsertScoreEngine UpdateBEForInsertScoreEngine : MATCHCODE:INNINGSNO: T_OVERNO];
        }
        else
        {
            N_OVERNO = OVERNO;
            N_BALLNO = BALLNO;
            N_BALLCOUNT = BALLCOUNT;
            
            if ((AWARDEDTOTEAMCODE).length > 0 && (PENALTYREASONCODE).length > 0)
            {
                MAXPENALTYID= [DBManagerInsertScoreEngine GetmaxPenaltyIdForInsertScoreEngine];
                
                //PENALTYCODE = 'PNT' + RIGHT(REPLICATE('0',7)+CAST(MAXPENALTYID AS VARCHAR(7)),7)
                
                [DBManagerInsertScoreEngine InsertPenaltyDetailsForInsertScoreEngine :COMPETITIONCODE: MATCHCODE:INNINGSNO:BALLCODENO:PENALTYCODE:AWARDEDTOTEAMCODE:PENALTYRUNS:PENALTYTYPECODE:PENALTYREASONCODE];
                if (AWARDEDTOTEAMCODE != TEAMCODE)
                {
                    TOTALEXTRAS = [NSNumber numberWithInt: ([TOTALEXTRAS intValue] - [PENALTY intValue])];
                    GRANDTOTAL = [NSNumber numberWithInt: ([GRANDTOTAL intValue] - [PENALTY intValue])];
                    PENALTY = 0;
                }
            }
            PREVIOUSBALLCODE= [DBManagerInsertScoreEngine GetPrevoiusBallCodeForInsertScoreEngine :OVERNO:BALLCOUNT:BALLNO:MATCHCODE:INNINGSNO];
            
            if([DBManagerInsertScoreEngine GetBallcodeInBallEventForInsertScoreEngine :PREVIOUSBALLCODE:BOWLERCODE]>0)
            {
                PREVIOUSBOWLERCODE=[DBManagerInsertScoreEngine GetPrevoiusBowlerCodeForInsertScoreEngine : PREVIOUSBALLCODE];
                
                
                [DBManagerInsertScoreEngine UpdateBolwerOverDetailsForInsertScoreEngine :COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO:OVERNO:PREVIOUSBOWLERCODE];
                
                [DBManagerInsertScoreEngine UpdateBolwlingSummaryForInsertScoreEngine :COMPETITIONCODE: MATCHCODE:INNINGSNO:PREVIOUSBOWLERCODE];
                
                [DBManagerInsertScoreEngine InsertBowlerOverDetailsForInsertScoreEngine :COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO:OVERNO:BOWLERCODE];
            }
            else if([DBManagerInsertScoreEngine GetBallCodeForUpdateBowlerOverDetailsForInsertScoreEngine :COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO : OVERNO] <= 1)
            {
                [DBManagerInsertScoreEngine UpdateBowlerDetailsForInsertScoreEngine : BOWLERCODE :COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO: OVERNO];
                
            }
            OVERBALLCOUNT= [DBManagerInsertScoreEngine GetOverBallCountForInsertScoreEngine :COMPETITIONCODE: MATCHCODE:TEAMCODE:INNINGSNO: OVERNO];
            
            
            [DBManagerInsertScoreEngine InsertBallEventsForInsertScoreEngine :  BALLCODENO   :COMPETITIONCODE    : MATCHCODE       : TEAMCODE       : INNINGSNO       : DAYNO       : OVERNO       : BALLNO       : BALLCOUNT       : OVERBALLCOUNT       : SESSIONNO       : STRIKERCODE       : NONSTRIKERCODE       : BOWLERCODE       : WICKETKEEPERCODE       : UMPIRE1CODE       : UMPIRE2CODE       : ATWOROTW       : BOWLINGEND       : BOWLTYPE       : SHOTTYPE       : SHOTTYPECATEGORY       : ISLEGALBALL       : ISFOUR       : ISSIX       : RUNS       : OVERTHROW       : TOTALRUNS       : WIDE       : NOBALL       : BYES       : LEGBYES       : PENALTY       : TOTALEXTRAS       : GRANDTOTAL       : RBW       : PMLINECODE       : PMLENGTHCODE       : PMSTRIKEPOINT       : @""       : PMX1       : PMY1       : PMX2       : PMY2       : PMX3       : PMY3       : WWREGION       : WWX1       : WWY1       : WWX2       : WWY2       : BALLDURATION       : ISAPPEAL       : ISBEATEN       : ISUNCOMFORT       : ISWTB       : ISRELEASESHOT       : MARKEDFOREDIT       : REMARKS       : VIDEOFILENAME       : BALLSPEED       : UNCOMFORTCLASSIFCATION  ];
            
            T_TOTALRUNS=0;
            //T_TOTALRUNS=(TOTALRUNS + (CASE WHEN WIDE > 0 THEN WIDE-1 ELSE WIDE END) +                 (CASE WHEN NOBALL > 0 THEN NOBALL-1 ELSE NOBALL END) + LEGBYES + BYES + (CASE WHEN (BYES > 0 || LEGBYES > 0) THEN OVERTHROW ELSE 0 END));
            
            
            T_STRIKERCODE  = STRIKERCODE;
            T_NONSTRIKERCODE = NONSTRIKERCODE;
            
            
            if(([T_TOTALRUNS intValue] % 2) > 0)
            {
                T_STRIKERCODE = NONSTRIKERCODE;
                T_NONSTRIKERCODE = STRIKERCODE;
                
                
            }
            
            [DBManagerInsertScoreEngine UpdateInningsEventEventsForInsertScoreEngine :  T_STRIKERCODE : T_NONSTRIKERCODE :BOWLERCODE  : COMPETITIONCODE    : MATCHCODE       : TEAMCODE       : INNINGSNO];
        }
        if([ISWICKET intValue] == 1)
        {
            
            [DBManagerInsertScoreEngine InsertWicketEventsForInsertScoreEngine :  BALLCODENO:  COMPETITIONCODE:  MATCHCODE: TEAMCODE :  INNINGSNO:ISWICKET : WICKETTYPE : WICKETPLAYER : FIELDINGPLAYER : WICKETEVENT];
        }
        
        //     [INSERTSCOREBOARD  :	 COMPETITIONCODE: 	 MATCHCODE: 	 BATTINGTEAMCODE: 	 BOWLINGTEAMCODE: 	 INNINGSNO: 	 SB_STRIKERCODE: 	 ISFOUR: 	 ISSIX: 	 RUNS: 	 OVERTHROW: 	 ISWICKET: 	 WICKETTYPE: 	 WICKETPLAYER: 	 SB_BOWLERCODE: 	 N_OVERNO: 	 N_BALLNO: 	 BATTEAMRUNS: 	 WIDE: 	 NOBALL: 	 BYES: 	 LEGBYES: 	0:: 	1:	0:	0:	1];
        [DBManagerInsertScoreEngine UpdateBSForInsertScoreEngine : COMPETITIONCODE:  MATCHCODE : INNINGSNO];
        //        BATTINGTEAMCODE =TEAMCODE;
        //
        //        BOWLINGTEAMCODE=[DBManagerInsertScoreEngine    ];
        //
        //        MATCHTYPE=[DBManagerInsertScoreEngine GetmatchtypeForInsertScoreEngine : COMPETITIONCODE]
        //
        //        INNINGSSTATUS=[DBManagerInsertScoreEngine GetInningsStatusForInsertScoreEngine :  COMPETITIONCODE:  MATCHCODE: INNINGSNO ]
        //
        //        NSMutableArray *GetBattingShortnameDetails=[ DBManagerInsertScoreEngine GetBattingShortnameForInsertScoreEngine:  BATTINGTEAMCODE ]
        //					   if(GetBattingShortnameDetails.count>0)
        //                       {
        //
        //                           BATTEAMSHORTNAME=[GetBattingShortnameDetails objectAtIndex:0]
        //                           BATTEAMNAME	=[GetBattingShortnameDetails objectAtIndex:1]
        //                           BATTEAMLOGO=[GetBattingShortnameDetails objectAtIndex:2]
        //                       }
        //        NSMutableArray *GetBowlingShortnameDetails=[ DBManagerInsertScoreEngine GetBowlingShortnameForInsertScoreEngine:  BOWLINGTEAMCODE ]
        //					   if(GetBowlingShortnameDetails.count>0)
        //                       {
        //
        //                           BOWLTEAMSHORTNAME=[GetBowlingShortnameDetails objectAtIndex:0]
        //                           BOWLTEAMNAME	=[GetBowlingShortnameDetails objectAtIndex:1]
        //                           BOWLTEAMLOGO=[GetBowlingShortnameDetails objectAtIndex:2]
        //                       }
        //
        //        NSNumber* T_TARGETRUNS =[[NSNumber alloc ] init];
        //        NSNumber* T_TARGETOVERS =[[NSNumber alloc ] init];
        //
        //        NSMutableArray *GetTarGetDetails=[ DBManagerInsertScoreEngine GettargetDetailsForInsertScoreEngine:  COMPETITIONCODE: MATCHCODE ]
        //					   if(GetTarGetDetails.count>0)
        //                       {
        //
        //                           T_TARGETRUNS=[GetTarGetDetails objectAtIndex:0]
        //                           T_TARGETOVERS	=[GetTarGetDetails objectAtIndex:1]
        //
        //                       }
        //
        //        MATCHOVERS = CASE WHEN T_TARGETOVERS > 0 THEN T_TARGETOVERS ELSE MATCHOVERS END;
        //
        //        NSMutableArray *GetMatchDetails=[ DBManagerInsertScoreEngine GetmatchDetailsForInsertScoreEngine:  COMPETITIONCODE : MATCHCODE ]
        //
        //
        //        NSMutableArray *GetBowlDetails=[ DBManagerInsertScoreEngine GetBowltypeDetailsForInsertScoreEngine ]
        //
        //        NSMutableArray *GetShotTypeDetails=[ DBManagerInsertScoreEngine GetShotTypeDetailsForInsertScoreEngine ]
        //
        //
        //        WITH X AS
        //
        //        NSMutableArray *GetRowNumberDetails=[ DBManagerInsertScoreEngine GetRowNumberForInsertScoreEngine:  COMPETITIONCODE : MATCHCODE  :BATTINGTEAMCODE : INNINGSNO]
        //
        //
        //
        //        NSMutableArray *GetPlayerDetails=[ DBManagerInsertScoreEngine GetPlayerDetailsForInsertScoreEngine:  COMPETITIONCODE : MATCHCODE  :BATTINGTEAMCODE : INNINGSNO]
        //
        //        NSNumber* BATTEAMRUNS =[[NSNumber alloc ] init];
        //        NSNumber* BATTEAMWICKETS =[[NSNumber alloc ] init];
        //				    NSNumber* BATTEAMOVERS =[[NSNumber alloc ] init];
        //        NSNumber* BATTEAMOVRBALLS =[[NSNumber alloc ] init];
        //        NSNumber* BATTEAMOVRWITHEXTRASBALLS =[[NSNumber alloc ] init];
        //        NSNumber* BATTEAMOVRWITHEXTRASBALLCOUNT =[[NSNumber alloc ] init];
        //        NSNumber* PREVOVRBALLS =[[NSNumber alloc ] init];
        //        NSNumber* PREVOVRWITHEXTRASBALLS =[[NSNumber alloc ] init];
        //        NSNumber* BATTEAMOVRBALLSCNT =[[NSNumber alloc ] init];
        //        NSNumber* LASTBALLCODE =[[NSNumber alloc ] init];
        //        NSNumber* BATTEAMRUNRATE =[[NSNumber alloc ] init];
        //        NSNumber* ISOVERCOMPLETE =[[NSNumber alloc ] init];
        //        NSNumber* ISPREVIOUSLEGALBALL =[[NSNumber alloc ] init];
        //        NSNumber* BATTEAMPENALTY =[[NSNumber alloc ] init];
        //        NSNumber* BOWLTEAMPENALTY =[[NSNumber alloc ] init];
        //        NSNumber* TEMPBATTEAMPENALTY =[[NSNumber alloc ] init];
        //
        //
        //        if(INNINGSNO=3 && ([DBManagerInsertScoreEngine GetIsFollowOnForInsertScoreEngine : COMPETITIONCODE : MATCHCODE  : INNINGSNO ]=1) )
        //            TEMPBATTEAMPENALTY=0;
        //        else if(INNINGSNO=4 && ([DBManagerInsertScoreEngine GetIsFollowOnInElseIfForInsertScoreEngine : COMPETITIONCODE : MATCHCODE  : INNINGSNO ]=1) )
        //            TEMPBATTEAMPENALTY=[DBManagerInsertScoreEngine GetTeamTeampenaltyForInsertScoreEngine : COMPETITIONCODE : MATCHCODE  : BATTINGTEAMCODE ]
        //            else
        //                TEMPBATTEAMPENALTY=[DBManagerInsertScoreEngine GetTeamTeampenaltyInelseForInsertScoreEngine : COMPETITIONCODE : MATCHCODE  : BATTINGTEAMCODE : INNINGSNO ]
        //
        //                BATTEAMRUNS=[DBManagerInsertScoreEngine GetbatTeamRunsForInsertScoreEngine : COMPETITIONCODE : MATCHCODE  : BATTINGTEAMCODE : INNINGSNO ]
        //
        //                BATTEAMRUNS = IFNULL (BATTEAMRUNS, 0) + IFNULL (TEMPBATTEAMPENALTY, 0);
        //
        //
        
        //
        //        if ([INNINGSNO intValue] == 1)
        //        {
        //
        //            BATTEAMPENALTY=[DBManagerInsertScoreEngine GetbatTeampenaltyForInsertScoreEngine : COMPETITIONCODE : MATCHCODE  : BATTINGTEAMCODE  ];
        //
        //            BOWLTEAMPENALTY=0;
        //        }
        //        else if ([INNINGSNO intValue]==2)
        //        {
        //
        //            BATTEAMPENALTY=[DBManagerInsertScoreEngine GetbatTeampenaltyInElseForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO : BATTINGTEAMCODE  ];
        //
        //            if  MATCHTYPE IN ('MSC023','MSC114')
        //
        //            {
        //
        //                BOWLTEAMPENALTY=[DBManagerInsertScoreEngine GetBowlingTeampenaltyForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO : BOWLINGTEAMCODE  ]
        //
        //
        //            }
        //            else
        //            {
        //                BOWLTEAMPENALTY=[DBManagerInsertScoreEngine GetBowlingTeampenaltyInElseForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO : BOWLINGTEAMCODE  ]
        //            }
        //
        //            else if(INNINGSNO =3)
        //            {
        //                if([DBManagerInsertScoreEngine GetIsFollowOnDetailForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO ] = 1  )
        //                {
        //                    BATTEAMPENALTY=[DBManagerInsertScoreEngine GetBattingTeampenaltysForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO : BATTINGTEAMCODE ]
        //
        //                }
        //                else
        //                {
        //
        //                    BATTEAMPENALTY=[DBManagerInsertScoreEngine GetBattingTeampenaltyForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO : BATTINGTEAMCODE ]
        //
        //                    BOWLTEAMPENALTY=[DBManagerInsertScoreEngine GetBowlTeampenaltyForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO : BOWLINGTEAMCODE  ]
        //
        //
        //                }
        //
        //
        //            }
        //            else if (INNINGSNO=4 )
        //            {
        //                if([DBManagerInsertScoreEngine GetIsFollowOnInElseIfForInsertScoreEngine : COMPETITIONCODE : MATCHCODE  : INNINGSNO ]=1)
        //                {
        //                    BATTEAMPENALTY=[DBManagerInsertScoreEngine GetBattingTeampenaltyInn4ForInsertScoreEngine : COMPETITIONCODE : MATCHCODE :  BATTINGTEAMCODE ]
        //
        //                }
        //                else
        //                {
        //                    BATTEAMPENALTY=[DBManagerInsertScoreEngine GetbatTeampenaltyInn4InElseForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO: BATTINGTEAMCODE ]
        //
        //                    BOWLTEAMPENALTY=[DBManagerInsertScoreEngine GetBowlingTeampenaltyInn4ForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO : BOWLINGTEAMCODE  ]
        //
        //                }
        //                BATTEAMWICKETS=[DBManagerInsertScoreEngine GetBatTeamWicketForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : TEAMCODE :  INNINGSNO ]
        //
        //                BATTEAMOVERS=[DBManagerInsertScoreEngine GetBatTeamOverForInsertScoreEngine : BALLCODENO ]
        //
        //                BATTEAMOVRBALLS=[DBManagerInsertScoreEngine GetBatTeamOverBallForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : BATTEAMOVERS ]
        //
        //                BATTEAMOVRWITHEXTRASBALLS=[DBManagerInsertScoreEngine GetBatTeamOverWithExtraBallForInsertScoreEngine : BALLCODENO ]
        //
        //                BATTEAMOVRWITHEXTRASBALLCOUNT=[DBManagerInsertScoreEngine GetBatTeamOverWithExtraBallCountForInsertScoreEngine : BALLCODENO ]
        //
        //                LASTBALLCODE = BALLCODENO;
        //
        //                ISPREVIOUSLEGALBALL=[DBManagerInsertScoreEngine GetIslegalBallCountForInsertScoreEngine : LASTBALLCODE ]
        //
        //                if([DBManagerInsertScoreEngine GetOverNoForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE :  BATTINGTEAMCODE: INNINGSNO : BATTEAMOVERS ]!=0)
        //                {
        //                    if([DBManagerInsertScoreEngine GetOverNosForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE :  BATTINGTEAMCODE: INNINGSNO : BATTEAMOVERS ])
        //                    {
        //                        ISOVERCOMPLETE = 0;
        //                    }
        //                    else
        //                    {
        //                        ISOVERCOMPLETE = 1;
        //                        BATTEAMOVRBALLS = 0;
        //                    }
        //
        //
        //                }
        //                else
        //                {
        //
        //                    ISOVERCOMPLETE = -1;
        //
        //
        //                }
        //                NSNumber* TOTALBALLS =[[NSNumber alloc ] init];
        //
        //                TOTALBALLS = ((CASE WHEN ISOVERCOMPLETE = 1 THEN BATTEAMOVERS+1 ELSE BATTEAMOVERS END) * 6) + (CASE WHEN BATTEAMOVRBALLS > 6 THEN 6 ELSE BATTEAMOVRBALLS END);
        //                BATTEAMRUNRATE = CASE WHEN TOTALBALLS = 0 THEN 0 ELSE (BATTEAMRUNS / TOTALBALLS) * 6 END
        //
        //                NSString* PENULTIMATEBOWLERCODE =[[NSString alloc ] init];
        //
        //                PENULTIMATEBOWLERCODE=[DBManagerInsertScoreEngine GetBowlerCodeForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE :  BATTINGTEAMCODE: INNINGSNO :ISOVERCOMPLETE: BATTEAMOVERS ]
        //
        //
        //                NSMutableArray *GetBowlPlayerDetails=[ DBManagerInsertScoreEngine GetBowlingTeamPlayersForInsertScoreEngine: COMPETITIONCODE:MATCHCODE:BATTINGTEAMCODE: INNINGSNO:ISOVERCOMPLETE : BATTEAMOVERS]
        //
        //
        //                NSString* T_ATWOROTW =[[NSString alloc ] init];
        //                NSString* T_BOWLINGEND =[[NSString alloc ] init];
        //                NSNumber* TOTALBATTEAMRUNS =[[NSNumber alloc ] init];
        //                NSNumber* TOTALBOWLTEAMRUNS =[[NSNumber alloc ] init];
        //                NSNumber* REQRUNRATE =[[NSNumber alloc ] init];
        //                NSNumber* RUNSREQUIRED =[[NSNumber alloc ] init];
        //                NSNumber* REMBALLS =[[NSNumber alloc ] init];
        //                NSNumber* COMPLETEDINNINGS =[[NSNumber alloc ] init];
        //                NSNumber* TARGETRUNS =[[NSNumber alloc ] init];
        //
        //                COMPLETEDINNINGS =[GetCompletedInningsForInsertScoreEngine:COMPETITIONCODE:  MATCHCODE]
        //
        //                if COMPLETEDINNINGS > 0
        //                {
        //                    TOTALBATTEAMRUNS=[GetTotalBatteamRunsForInsertScoreEngine:COMPETITIONCODE:  MATCHCODE : BATTINGTEAMCODE]
        //
        //                    TOTALBOWLTEAMRUNS=[GetTotalBowlteamRunsForInsertScoreEngine:COMPETITIONCODE:  MATCHCODE : BOWLINGTEAMCODE]
        //
        //                    NSNumber* TEMPBOWLPENALTY =[[NSNumber alloc ] init];
        //                    NSNumber* TEMPBATPENALTY =[[NSNumber alloc ] init];
        //
        //
        //
        //                    if(INNINGSNO = 4 && MATCHTYPE IN ('MSC023','MSC114')) OR (INNINGSNO = 2 AND MATCHTYPE NOT IN ('MSC023','MSC114'))
        //                    {
        //
        //
        //                        TEMPBOWLPENALTY=[GetTempBowlPenaltyForInsertScoreEngine:COMPETITIONCODE:  MATCHCODE : INNINGSNO : BOWLINGTEAMCODE]
        //
        //                        TEMPBATPENALTY=[GetTempBatTeamPenaltyForInsertScoreEngine:COMPETITIONCODE:  MATCHCODE : INNINGSNO : BATTINGTEAMCODE]
        //                    }
        //
        //                    TARGETRUNS = ((TOTALBOWLTEAMRUNS + TEMPBOWLPENALTY) -  [DBManagerInsertScoreEngine  GetgrandtotalForInsertScoreEngine : COMPETITIONCODE:  MATCHCODE : INNINGSNO : BATTINGTEAMCODE: TEMPBATPENALTY ])
        //
        //                    if TARGETRUNS > 0 SET TARGETRUNS = TARGETRUNS + 1 ELSE SET TARGETRUNS = 1;
        //
        //
        //
        //                    TOTALBATTEAMRUNS = TOTALBATTEAMRUNS + BATTEAMPENALTY;
        //                    TOTALBOWLTEAMRUNS = TOTALBOWLTEAMRUNS + BOWLTEAMPENALTY;
        //
        //                    TOTALBOWLTEAMRUNS = ( CASE WHEN (MATCHTYPE IN ('MSC023','MSC114') && INNINGSNO = 4 && TOTALBOWLTEAMRUNS > 0) THEN TOTALBOWLTEAMRUNS + 1
        //                                         WHEN (MATCHTYPE NOT IN ('MSC023','MSC114') && INNINGSNO = 2 && TOTALBOWLTEAMRUNS > 0) THEN TOTALBOWLTEAMRUNS + 1
        //                                         ELSE TOTALBOWLTEAMRUNS END)
        //
        //
        //
        //                    TARGETRUNS = CASE WHEN T_TARGETRUNS > 0 THEN T_TARGETRUNS ELSE TARGETRUNS END;
        //
        //                    TOTALBOWLTEAMRUNS = CASE WHEN T_TARGETRUNS > 0 THEN T_TARGETRUNS ELSE TOTALBOWLTEAMRUNS END
        //
        //                    TOTALBOWLTEAMRUNS = CASE WHEN TOTALBOWLTEAMRUNS = 0 THEN 1 ELSE TOTALBOWLTEAMRUNS END;
        //
        //
        //                    RUNSREQUIRED = (TOTALBOWLTEAMRUNS - TOTALBATTEAMRUNS) ;
        //                    REMBALLS = (MATCHOVERS * 6) - ((CASE WHEN ISOVERCOMPLETE = 1 THEN BATTEAMOVERS + 1 ELSE BATTEAMOVERS END  * 6) + BATTEAMOVRBALLS);
        //                    REQRUNRATE = CASE WHEN @REMBALLS = 0 THEN 0 ELSE (RUNSREQUIRED / REMBALLS) * (CASE WHEN REMBALLS < 6 THEN 1 ELSE 6 END) END
        //
        //
        //                    NSMutableArray *GetlastBallDetails=[ DBManagerInsertScoreEngine GetLastBallATWOROTWForInsertScoreEngine :ISOVERCOMPLETE:COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO :LASTBALLCODE]
        //                    if(GetlastBallDetails.count>0)
        //                    {
        //
        //                        T_ATWOROTW=[GetlastBallDetails objectAtIndex:0]
        //                        T_BOWLINGEND=[GetlastBallDetails objectAtIndex:1]
        //                    }
        //
        //
        //
        //                    NSNumber* ISFREEHIT =[[NSNumber alloc ] init];
        //
        //
        //                    if (ISPREVIOUSLEGALBALL = 1   )
        //                        ISFREEHIT = 0
        //                        else
        //                        {
        //
        //                            if([ DBManagerInsertScoreEngine GetNoBallForInsertScoreEngine :COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO :LASTBALLCODE : BATTEAMOVERS : BATTEAMOVRWITHEXTRASBALLS] > 0)
        //                                ISFREEHIT = 1;
        //                        }
        
        
        //                            NSNumber* STRIKERBALLS =[[NSNumber alloc ] init];
        //                            NSNumber* NONSTRIKERBALLS =[[NSNumber alloc ] init];
        //                            NSNumber* T_OVERSTATUS =[[NSNumber alloc ] init];
        //                            NSString* T_WICKETPLAYER =[[NSString alloc ] init];
        //                            NSString* T_WICKETTYPE =[[NSString alloc ] init];
        //
        //                            NSMutableArray *GetWicketPlayerandTypeDetails=[ DBManagerInsertScoreEngine GetWicketPlayerAndTypeForInsertScoreEngine :LASTBALLCODE]
        //                            if(GetWicketPlayerandTypeDetails.count>0)
        //                            {
        //
        //                                T_WICKETPLAYER=[GetWicketPlayerandTypeDetails objectAtIndex:0]
        //                                T_WICKETTYPE=[GetWicketPlayerandTypeDetails objectAtIndex:1]
        //                            }
        //                            NSMutableArray *GetStrickerNonStrickerDetails=[ DBManagerInsertScoreEngine GetStrickerNonStrickerForInsertScoreEngine :COMPETITIONCODE : MATCHCODE :  INNINGSNO ]
        //                            if(GetStrickerNonStrickerDetails.count>0)
        //                            {
        //
        //                                STRIKERCODE=[GetStrickerNonStrickerDetails objectAtIndex:0]
        //                                NONSTRIKERCODE=[GetStrickerNonStrickerDetails objectAtIndex:1]
        //                            }
        //
        //                            if (T_WICKETTYPE = @"MSC102")
        //                            {
        //
        //                                STRIKERCODE = (CASE WHEN STRIKERCODE = T_WICKETPLAYER THEN '' ELSE STRIKERCODE END);
        //                                NONSTRIKERCODE = (CASE WHEN NONSTRIKERCODE = T_WICKETPLAYER THEN '' ELSE NONSTRIKERCODE END);
        //                            }
        //                            else
        //                            {
        //
        //                                STRIKERCODE = (CASE WHEN STRIKERCODE IN ( DBManagerInsertScoreEngine  GetWicketplayerForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : INNINGSNO)THEN @"" ELSE STRIKERCODE END
        //
        //                                               NONSTRIKERCODE = (CASE WHEN @NONSTRIKERCODE IN (DBManagerInsertScoreEngine GetWicketplayerInNonStrickerForInsertScoreEngine: COMPETITIONCODE : MATCHCODE : INNINGSNO ) THEN @"" ELSE NONSTRIKERCODE END
        //                                                                 }
        //
        //
        //
        //                                                                 STRIKERBALLS=[ DBManagerInsertScoreEngine GetStrickerBallsForInsertScoreEngine :COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : STRIKERCODE]
        //
        //
        //                                                                 if([ DBManagerInsertScoreEngine GetStrickerCodeForInsertScoreEngine :COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : STRIKERCODE] !=0)
        //                                                                 {
        //
        //                                                                     NSMutableArray *GetBallEventDetails=[ DBManagerInsertScoreEngine GetBallEventForInsertScoreEngine :COMPETITIONCODE : MATCHCODE :  INNINGSNO : BATTINGTEAMCODE : STRIKERBALLS : STRIKERCODE ]
        //
        //                                                                 }
        //                                                                 else
        //                                                                 {
        //                                                                     NSMutableArray *GetPlayermasterDetails=[ DBManagerInsertScoreEngine GetPlayermasterForInsertScoreEngine :STRIKERCODE]
        //
        //                                                                 }
        //                                                                 NONSTRIKERBALLS=[ DBManagerInsertScoreEngine GetNonStrickerCodeForInsertScoreEngine :COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : NONSTRIKERCODE]
        //
        //
        //                                                                 if([ DBManagerInsertScoreEngine GetStrickerCodeforNonStrickerForInsertScoreEngine :COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE : INNINGSNO : NONSTRIKERCODE]!=0)
        //                                                                 {
        //                                                                     NSMutableArray *GetBallEventDetails=[ DBManagerInsertScoreEngine GetBallEventforNonstrickerForInsertScoreEngine :COMPETITIONCODE : MATCHCODE :  INNINGSNO : BATTINGTEAMCODE : NONSTRIKERBALLS : NONSTRIKERCODE ]
        //
        //                                                                     NSMutableArray *GetPlayermasterDetails=[ DBManagerInsertScoreEngine GetPlayermasterInNonStrickerForInsertScoreEngine :STRIKERCODE]
        //
        //                                                                     NSMutableArray *GetpartnerShipBallsandRunsDetails=[ DBManagerInsertScoreEngine GetpartneShiprunsandBallsForInsertScoreEngine :COMPETITIONCODE : MATCHCODE :  INNINGSNO : BATTINGTEAMCODE : STRIKERCODE : NONSTRIKERCODE ]
        //
        //                                                                     NSNumber* WICKETS =[[NSNumber alloc ] init];
        //
        //                                                                     if([DBManagerInsertScoreEngine GetOverNoForInsertScoreEngine : COMPETITIONCODE : MATCHCODE : BATTINGTEAMCODE :  BATTINGTEAMCODE: INNINGSNO : BATTEAMOVERS ]!=0)
        //                                                                     {
        //                                                                         BOWLERCODE =[DBManagerInsertScoreEngine GetBowlerCodeforassignForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE   : BATTEAMOVERS: BATTEAMOVRWITHEXTRASBALLS:  BATTEAMOVRWITHEXTRASBALLCOUNT   ]
        //
        //                                                                         WICKETS =[DBManagerInsertScoreEngine GetWicketForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE   : BOWLERCODE ]
        //
        //                                                                         NSNumber* LASTBOWLEROVERNO =[[NSNumber alloc ] init];
        //                                                                         NSNumber* LASTBOWLEROVERBALLNO =[[NSNumber alloc ] init];
        //                                                                         NSNumber* LASTBOWLEROVERBALLNOWITHEXTRAS =[[NSNumber alloc ] init];
        //                                                                         NSNumber* LASTBOWLEROVERBALLCOUNT =[[NSNumber alloc ] init];
        //
        //                                                                         LASTBOWLEROVERNO = [DBManagerInsertScoreEngine GetLastBowlerOverNoForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE   : BOWLERCODE ]
        //
        //                                                                         LASTBOWLEROVERSTATUS =[DBManagerInsertScoreEngine GetLastBowlerOverStatusForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE   : LASTBOWLEROVERNO ]
        //
        //
        //                                                                         if(LASTBOWLEROVERNO !=nil )
        //                                                                         {
        //
        //                                                                             LASTBOWLEROVERBALLNO =  [DBManagerInsertScoreEngine GetLastBowlerOverBallNoStatusForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE : BOWLERCODE  : LASTBOWLEROVERNO ]
        //
        //                                                                             LASTBOWLEROVERBALLNOWITHEXTRAS = [DBManagerInsertScoreEngine GetLASTBOWLEROVERBALLNOWITHEXTRASForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE : BOWLERCODE  : LASTBOWLEROVERNO ]
        //
        //                                                                             LASTBOWLEROVERBALLCOUNT =  [DBManagerInsertScoreEngine GetLASTBOWLEROVERBALLCOUNTForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE : BOWLERCODE  : LASTBOWLEROVERNO : LASTBOWLEROVERBALLNOWITHEXTRAS ]
        //                                                                         }
        //                                                                         else
        //                                                                         {
        //                                                                             LASTBOWLEROVERBALLNO = 0;
        //                                                                             LASTBOWLEROVERBALLNOWITHEXTRAS = 0;
        //                                                                             LASTBOWLEROVERBALLCOUNT = 0;
        //
        //
        //                                                                         }
        //
        //                                                                         NSString* S_ATWOROTW =[[NSString alloc ] init];
        //
        //                                                                         S_ATWOROTW=[DBManagerInsertScoreEngine GetATWOROTWForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE : BOWLERCODE  : LASTBOWLEROVERNO : LASTBOWLEROVERBALLNOWITHEXTRAS: LASTBOWLEROVERBALLCOUNT ]
        //
        //                                                                         NSNumber* TOTALBALLSBOWL =[[NSNumber alloc ] init];
        //                                                                         NSNumber* MAIDENS =[[NSNumber alloc ] init];
        //                                                                         NSNumber* BOWLERRUNS =[[NSNumber alloc ] init];
        //                                                                         NSNumber* ISPARTIALOVER =[[NSNumber alloc ] init];
        //
        //
        //                                                                         ISPARTIALOVER=[DBManagerInsertScoreEngine GetISPARTIALOVERForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE : BOWLERCODE  : BATTEAMOVERS  ]
        //
        //
        //                                                                         if (SPARTIALOVER = 0 )
        //                                                                         {
        //                                                                             SPARTIALOVER=[DBManagerInsertScoreEngine GetISPARTIALOVERInBowlForInsertScoreEngine :COMPETITIONCODE:  MATCHCODE:  INNINGSNO  : BATTINGTEAMCODE : BOWLERCODE  : BATTEAMOVERS  ]
        //
        //
        //                                                                             NSMutableArray *GetTotalBallsBowlandmaidenandBowlRunDetails=[ DBManagerInsertScoreEngine GetTotalBallsBowlForInsertScoreEngine :COMPETITIONCODE : MATCHCODE :  INNINGSNO : BATTINGTEAMCODE : BOWLERCODE : BATTEAMOVERS ]
        //
        //                                                                             LASTBOWLEROVERBALLNO = CASE WHEN LASTBOWLEROVERSTATUS = 1 THEN 0 ELSE LASTBOWLEROVERBALLNO END;
        //
        //                                                                             NSNumber* BOWLERSPELL =[[NSNumber alloc ] init];
        //                                                                             (NSNumber*) V_SPELLNO =[[NSNumber alloc ] init];
        //
        //                                                                             BOWLERSPELL=[ DBManagerInsertScoreEngine GetBOWLERSPELLForInsertScoreEngine :COMPETITIONCODE : MATCHCODE :  INNINGSNO : BATTINGTEAMCODE : BOWLERCODE  ]
        //
        //
        //                                                                             BOWLERSPELL = CASE WHEN BATTEAMOVERS - LASTBOWLEROVERNO > 2 THEN BOWLERSPELL + 1 ELSE BOWLERSPELL END;
        //
        //
        //
        //                                                                             NSMutableArray *GetBolwerDetails=[ DBManagerInsertScoreEngine GetBowlerDetailsForInsertScoreEngine ISPARTIALOVER :  LASTBOWLEROVERBALLNO :  BOWLERSPELL : BOWLERRUNS : S_ATWOROTW :  MAIDENS :  WICKETS :(NSNumber*) TOTALBALLSBOWL : (NSNumber*) LASTBOWLEROVERBALLNO: COMPETITIONCODE:  MATCHCODE: INNINGSNO  : BOWLERCODE;]
        //
        //                                                                             (NSNumber*) CURRENTOVER =[[NSNumber alloc ] init];
        //
        //                                                                             CURRENTOVER =CASE WHEN LEN(BALLCODENO) > 0 THEN ([DBManagerInsertScoreEngine GetOverNoInBowlForInsertScoreEngine : COMPETITIONCODE: MATCHCODE : INNINGSNO : BATTINGTEAMCODE : BALLCODENO] else  ( CASE WHEN ISOVERCOMPLETE = 1 THEN BATTEAMOVERS+1 ELSE BATTEAMOVERS END  )   )
        //
        //
        //
        //                                                                         }
        //
        //
        //                                                                         (NSNumber*) ISINNINGSLASTOVER =[[NSNumber alloc ] init];
        //
        //                                                                         ISINNINGSLASTOVER=[DBManagerInsertScoreEngine GetISINNINGSLASTOVERForInsertScoreEngine : COMPETITIONCODE:  MATCHCODE : INNINGSNO : BATTINGTEAMCODE : OVERNO]
        //
        //                                                                         NSMutableArray *GetBallDetails=[ DBManagerInsertScoreEngine GetBallDetailsForInsertScoreEngine: COMPETITIONCODE: MATCHCODE : INNINGSNO : BATTINGTEAMCODE :CURRENTOVER]
        //
        //
        //                                                                         NSMutableArray *GetteamDetails=[ DBManagerInsertScoreEngine GetTeamDetailsForInsertScoreEngine :COMPETITIONCODE :  MATCHCODE]
        //
        //                                                                         NSMutableArray *GetUmpireDetails=[ DBManagerInsertScoreEngine GetUmpireDetailsForInsertScoreEngine]
        //
        //                                                                         NSMutableArray *GetfieldingEventDetails=[ DBManagerInsertScoreEngine GetFieldingEventDetailsForInsertScoreEngine :COMPETITIONCODE :  MATCHCODE : BOWLINGTEAMCODE]
        //
        //                                                                         [FETCHSEALLINNINGSSCOREDETAILS COMPETITIONCODE :  MATCHCODE ]
        //
        //
        
        //
        //
        //                                                                     }
        //                                                                     else
        //                                                                     {
        //
        //                                                                     }
        //
        //
        //
        //                                                                 }
        //
        //
        //
        //                                                                 }
        //
        //
        //                                                                 }
        
        
        //}
        
        
        
        
        
    }
}
@end
