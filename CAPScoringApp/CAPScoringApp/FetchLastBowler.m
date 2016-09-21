//
//  FetchLastBowler.m
//  CAPScoringApp
//
//  Created by APPLE on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FetchLastBowler.h"
#import "DBManagerLastBowler.h"
#import "DBManager.h"

@implementation FetchLastBowler
@synthesize GetLastBolwerDetails;

-(void)LastBowlerDetails:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*) INNINGSNO: (NSNumber*) OVERNO : (NSNumber*) BALLNO : (NSNumber*) BALLCOUNT

{
    DBManagerLastBowler *dbLastBowler = [[DBManagerLastBowler alloc]init];
    NSNumber* BOWLERSPELL =[[NSNumber alloc ] init];
    BOWLERSPELL = [NSNumber numberWithInteger:0];
    
    NSNumber* V_SPELLNO =[[NSNumber alloc ] init];
    V_SPELLNO = [NSNumber numberWithInteger:0];
    
    NSNumber* BOWLERRUNS =[[NSNumber alloc ] init];
    NSNumber* TOTALBALLSBOWL =[[NSNumber alloc ] init];
    NSNumber* MAIDENS =[[NSNumber alloc ] init];
    NSNumber* BATTEAMOVERS =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERNO =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERBALLNO =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERBALLNOWITHEXTRAS =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERBALLCOUNT =[[NSNumber alloc ] init];
    NSString* PREVIOUSBOWLERCODE =[[NSString alloc ] init];
    NSString* CURRENTBOWLERCODE =[[NSString alloc ] init];
    NSNumber* WICKETS =[[NSNumber alloc ] init];
    NSNumber* ISPARTIALOVER =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERSTATUS =[[NSNumber alloc ] init];
    NSNumber *  PREVIOUSOVERNO;
    NSNumber *  PREVIOUSBALLNO;
    NSNumber *  PREVIOUSBALLCOUNT;
    
    
    NSString * overno =[dbLastBowler GETLastBowlOverNo:COMPETITIONCODE :MATCHCODE :INNINGSNO];
    PREVIOUSOVERNO =[NSNumber numberWithInt:overno.intValue];
    
   NSString * ballno =[dbLastBowler GETLastBowlBallNo:COMPETITIONCODE :MATCHCODE :INNINGSNO :PREVIOUSOVERNO];
    
    PREVIOUSBALLNO =[NSNumber numberWithInt:ballno.intValue];
    
    NSString * ballcount =[dbLastBowler GETLastBowlBallCount:COMPETITIONCODE :MATCHCODE :INNINGSNO :PREVIOUSOVERNO :PREVIOUSBALLNO];
    
     PREVIOUSBALLCOUNT =[NSNumber numberWithInt:ballcount.intValue];
    
    CURRENTBOWLERCODE =[dbLastBowler GetBowlerCodeForBowlerDetails: COMPETITIONCODE : MATCHCODE : INNINGSNO : OVERNO : BALLNO : BALLCOUNT];
    
    
    
    PREVIOUSBOWLERCODE=[dbLastBowler GetTopBowlerCodeForBowlerDetails: COMPETITIONCODE : MATCHCODE : INNINGSNO : PREVIOUSOVERNO : PREVIOUSBALLNO : PREVIOUSBALLCOUNT : CURRENTBOWLERCODE];
    
    WICKETS=[dbLastBowler GetWicketNoForBowlerDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO:  OVERNO:  BALLNO:  BALLCOUNT:  PREVIOUSBOWLERCODE];
    
    LASTBOWLEROVERNO=[dbLastBowler GetLastBowlerOverNoForBallEvents :  COMPETITIONCODE:  MATCHCODE:  INNINGSNO:  PREVIOUSBOWLERCODE:  OVERNO];
    
    LASTBOWLEROVERSTATUS = [dbLastBowler GetlastOverStatusForlastBowlerDetails:COMPETITIONCODE :MATCHCODE :INNINGSNO :LASTBOWLEROVERNO];
    
    BATTEAMOVERS=[dbLastBowler GetBatTeamOversForOverEvents: COMPETITIONCODE: MATCHCODE: INNINGSNO: OVERNO];
    
    ISPARTIALOVER=[dbLastBowler  GetBowlerCodeForIsPartialOver : COMPETITIONCODE:  MATCHCODE:  INNINGSNO:  PREVIOUSBOWLERCODE:  LASTBOWLEROVERNO];
    
    
    BOWLERSPELL=[dbLastBowler GetBowlerSpellForBallEvents:  V_SPELLNO :  COMPETITIONCODE :  MATCHCODE :  INNINGSNO :  PREVIOUSBOWLERCODE :  OVERNO];
    
    
    
    NSMutableArray *GetTotalballbowlMaidensBowlerrunsforlastbowldetails=[ dbLastBowler GETTOTALBALLSBOWLMAIDENSBOWLERRUNSForLastBowlDetails :COMPETITIONCODE : MATCHCODE : INNINGSNO : PREVIOUSBOWLERCODE : OVERNO];
	   
    
    if(GetTotalballbowlMaidensBowlerrunsforlastbowldetails.count>0)
    {
        TOTALBALLSBOWL=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:0];
        MAIDENS=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:1];
        BOWLERRUNS=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:2];
        
        
    }
    
    if(LASTBOWLEROVERNO != nil)
    {
        
        LASTBOWLEROVERBALLNO=[dbLastBowler GetlastBowlerOverballNoForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  PREVIOUSBOWLERCODE :  LASTBOWLEROVERNO ];
        
        LASTBOWLEROVERBALLNOWITHEXTRAS=[dbLastBowler GetlastBowlerOverballNoWithExtraForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  PREVIOUSBOWLERCODE :  LASTBOWLEROVERNO ];
        
        
        LASTBOWLEROVERBALLCOUNT=[dbLastBowler GetlastballCountForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  PREVIOUSBOWLERCODE :  LASTBOWLEROVERNO :  LASTBOWLEROVERBALLNOWITHEXTRAS];
        
        
    }else{
        LASTBOWLEROVERBALLNO = 0;
        LASTBOWLEROVERBALLNOWITHEXTRAS = 0;
        LASTBOWLEROVERBALLCOUNT = 0;
    }
    
    LASTBOWLEROVERBALLNO = (LASTBOWLEROVERSTATUS.intValue == 1) ? [NSNumber numberWithInt:0] : LASTBOWLEROVERBALLNO;
    
    GetLastBolwerDetails=[ dbLastBowler GetBallEventForLastBowlerDetails :  BOWLERSPELL :  BOWLERRUNS :  ISPARTIALOVER :  TOTALBALLSBOWL :  MAIDENS :  WICKETS: COMPETITIONCODE:  MATCHCODE: INNINGSNO : PREVIOUSBOWLERCODE: OVERNO:LASTBOWLEROVERBALLNO];
    
}



@end

@implementation FetchCurrentBowler
@synthesize GetCurrentBolwerDetails;

-(void)CurrentBowlerDetails : (NSString *)COMPETITIONCODE : (NSString*)MATCHCODE :(NSString*) INNINGSNO : (NSNumber*) OVERNO : (NSNumber*) BALLNO : (NSNumber*) BALLCOUNT : (NSString*) BOWLERCODE
{
    DBManagerLastBowler *dbLastBowler = [[DBManagerLastBowler alloc]init];
    NSString* CURRENTBOWLERCODE = BOWLERCODE;
    NSNumber* BOWLERSPELL =[[NSNumber alloc ] init];
    BOWLERSPELL = [NSNumber numberWithInteger:0];
    
    NSNumber* V_SPELLNO =[[NSNumber alloc ] init];
    V_SPELLNO = [NSNumber numberWithInteger:0];
    
    NSNumber* BOWLERRUNS =[[NSNumber alloc ] init];
    NSNumber* TOTALBALLSBOWL =[[NSNumber alloc ] init];
    NSNumber* MAIDENS =[[NSNumber alloc ] init];
    NSNumber* BATTEAMOVERS =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERNO =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERBALLNO =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERBALLNOWITHEXTRAS =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERBALLCOUNT =[[NSNumber alloc ] init];
    NSNumber* WICKETS =[[NSNumber alloc ] init];
    NSNumber* ISPARTIALOVER =[[NSNumber alloc ] init];
    NSNumber* LASTBOWLEROVERSTATUS =[[NSNumber alloc ] init];
    
    WICKETS=[dbLastBowler GetWicketNoForBowlerDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO:  OVERNO:  BALLNO:  BALLCOUNT:  CURRENTBOWLERCODE];
    
    LASTBOWLEROVERNO=[dbLastBowler GetLastBowlerOverNoForBallEvents :  COMPETITIONCODE:  MATCHCODE:  INNINGSNO:  CURRENTBOWLERCODE:  OVERNO];
    
    LASTBOWLEROVERSTATUS = [dbLastBowler GetlastOverStatusForlastBowlerDetails:COMPETITIONCODE :MATCHCODE :INNINGSNO :LASTBOWLEROVERNO];
    
    BATTEAMOVERS=[dbLastBowler GetBatTeamOversForOverEvents : COMPETITIONCODE: MATCHCODE: INNINGSNO: OVERNO];
    
    ISPARTIALOVER=[dbLastBowler  GetBowlerCodeForIsPartialOver : COMPETITIONCODE:  MATCHCODE:  INNINGSNO:  CURRENTBOWLERCODE:  BATTEAMOVERS];
    
    
    BOWLERSPELL=[dbLastBowler GetBowlerSpellForBallEvents:  V_SPELLNO :  COMPETITIONCODE :  MATCHCODE :  INNINGSNO :  CURRENTBOWLERCODE :  OVERNO];
    
    
    
    NSMutableArray *GetTotalballbowlMaidensBowlerrunsforlastbowldetails=[ dbLastBowler GETTOTALBALLSBOWLMAIDENSBOWLERRUNSForLastBowlDetails :COMPETITIONCODE : MATCHCODE : INNINGSNO : CURRENTBOWLERCODE : OVERNO];
	   
    
    if(GetTotalballbowlMaidensBowlerrunsforlastbowldetails.count>0)
    {
        TOTALBALLSBOWL=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:0];
        MAIDENS=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:1];
        BOWLERRUNS=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:2];
        
        
    }
    
    if(LASTBOWLEROVERNO != nil)
    {
        
        LASTBOWLEROVERBALLNO=[dbLastBowler GetlastBowlerOverballNoForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  CURRENTBOWLERCODE :  LASTBOWLEROVERNO ];
        
        LASTBOWLEROVERBALLNOWITHEXTRAS=[dbLastBowler GetlastBowlerOverballNoWithExtraForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  CURRENTBOWLERCODE :  LASTBOWLEROVERNO ];
        
        
        LASTBOWLEROVERBALLCOUNT=[dbLastBowler GetlastballCountForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  CURRENTBOWLERCODE :  LASTBOWLEROVERNO :  LASTBOWLEROVERBALLNOWITHEXTRAS];
    }else{
        LASTBOWLEROVERBALLNO = 0;
        LASTBOWLEROVERBALLNOWITHEXTRAS = 0;
        LASTBOWLEROVERBALLCOUNT = 0;
    }
    LASTBOWLEROVERBALLNO = (LASTBOWLEROVERSTATUS.intValue == 1) ? [NSNumber numberWithInt:0] : LASTBOWLEROVERBALLNO;
    
    GetCurrentBolwerDetails = [ dbLastBowler GetBallEventForLastBowlerDetails :  BOWLERSPELL :  BOWLERRUNS :  ISPARTIALOVER :  TOTALBALLSBOWL :  MAIDENS :  WICKETS: COMPETITIONCODE:  MATCHCODE: INNINGSNO : CURRENTBOWLERCODE : OVERNO:LASTBOWLEROVERBALLNO];
    
}

@end

@implementation FetchCurrentBatsman
@synthesize PlayerCode;
@synthesize PlayerName;
@synthesize TotalRuns;
@synthesize Fours;
@synthesize Sixes;
@synthesize TotalBalls;
@synthesize StrickRate;
@synthesize BattingStyle;

-(void)CurrentBatsmanDetails : (NSString *)COMPETITIONCODE : (NSString*)MATCHCODE :(NSString*) INNINGSNO : (NSString*) BATTINGTEAMCODE : (NSString*) BATSMANCODE
{
    NSNumber *STRIKERBALLS = [NSNumber numberWithInt:0];
    DBManager *objDBManager = [[DBManager alloc]init];
    STRIKERBALLS = [objDBManager getSTRIKERBALLS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:BATSMANCODE];
    
    //Striker details
    NSMutableArray *strickerDetailsArray;
    if([objDBManager hasSTRIKERBALLS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:BATSMANCODE]){
        strickerDetailsArray = [objDBManager getStrickerCode:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO: INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE STRIKERCODE:BATSMANCODE STRIKERBALLS:STRIKERBALLS];
    }else{
        strickerDetailsArray =  [objDBManager getStrickerDetails:BATSMANCODE];
    }
    if(strickerDetailsArray.count>0){
        PlayerCode = [strickerDetailsArray objectAtIndex:0];
        PlayerName = [strickerDetailsArray objectAtIndex:1];
        TotalRuns = [strickerDetailsArray objectAtIndex:2];
        Fours = [strickerDetailsArray objectAtIndex:3];
        Sixes = [strickerDetailsArray objectAtIndex:4];
        TotalBalls = [strickerDetailsArray objectAtIndex:5];
        StrickRate = [strickerDetailsArray objectAtIndex:6];
        BattingStyle = [strickerDetailsArray objectAtIndex:7];
    }
}

@end