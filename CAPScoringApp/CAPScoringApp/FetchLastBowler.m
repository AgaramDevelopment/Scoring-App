//
//  FetchLastBowler.m
//  CAPScoringApp
//
//  Created by APPLE on 19/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FetchLastBowler.h"
#import "DBManagerLastBowler.h"

@implementation FetchLastBowler
@synthesize GetLastBolwerDetails;

-(void)LastBowlerDetails:(NSString *)COMPETITIONCODE:(NSString*)MATCHCODE :(NSString*) INNINGSNO: (NSNumber*) OVERNO : (NSNumber*) BALLNO : (NSNumber*) BALLCOUNT

{
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
    NSString* PREVIOUSBOWLEROVER =[[NSString alloc ] init];
    
    
    CURRENTBOWLERCODE =[DBManagerLastBowler GetBowlerCodeForBowlerDetails: COMPETITIONCODE : MATCHCODE : INNINGSNO : OVERNO : BALLNO : BALLCOUNT];
    
    
    
    PREVIOUSBOWLERCODE=[DBManagerLastBowler GetTopBowlerCodeForBowlerDetails: COMPETITIONCODE : MATCHCODE : INNINGSNO : OVERNO : BALLNO : BALLCOUNT : CURRENTBOWLERCODE];
    
    WICKETS=[DBManagerLastBowler GetWicketNoForBowlerDetails: COMPETITIONCODE: MATCHCODE: INNINGSNO:  OVERNO:  BALLNO:  BALLCOUNT:  PREVIOUSBOWLERCODE];
    
    LASTBOWLEROVERNO=[DBManagerLastBowler GetLastBowlerOverNoForBallEvents:  COMPETITIONCODE:  MATCHCODE:  INNINGSNO:  PREVIOUSBOWLERCODE:  OVERNO];
    
    BATTEAMOVERS=[DBManagerLastBowler GetBatTeamOversForOverEvents: COMPETITIONCODE: MATCHCODE: INNINGSNO: OVERNO];
    
    ISPARTIALOVER=[DBManagerLastBowler  GetBowlerCodeForIsPartialOver : COMPETITIONCODE:  MATCHCODE:  INNINGSNO:  PREVIOUSBOWLERCODE:  BATTEAMOVERS];
    
    
    BOWLERSPELL=[DBManagerLastBowler GetBowlerSpellForBallEvents:  V_SPELLNO :  COMPETITIONCODE :  MATCHCODE :  INNINGSNO :  PREVIOUSBOWLERCODE :  OVERNO];
    
    
    
    NSMutableArray *GetTotalballbowlMaidensBowlerrunsforlastbowldetails=[ DBManagerLastBowler GETTOTALBALLSBOWLMAIDENSBOWLERRUNSForLastBowlDetails :COMPETITIONCODE : MATCHCODE : INNINGSNO : PREVIOUSBOWLERCODE : OVERNO];
	   
    
    if(GetTotalballbowlMaidensBowlerrunsforlastbowldetails.count>0)
    {
        TOTALBALLSBOWL=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:0];
        MAIDENS=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:1];
        BOWLERRUNS=[GetTotalballbowlMaidensBowlerrunsforlastbowldetails objectAtIndex:2];
        
        
    }
    
    if(LASTBOWLEROVERNO != nil)
    {
        
        LASTBOWLEROVERBALLNO=[DBManagerLastBowler GetlastBowlerOverballNoForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  PREVIOUSBOWLERCODE :  LASTBOWLEROVERNO ];
        
        LASTBOWLEROVERBALLNOWITHEXTRAS=[DBManagerLastBowler GetlastBowlerOverballNoWithExtraForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  PREVIOUSBOWLERCODE :  LASTBOWLEROVERNO ];
        
        
        LASTBOWLEROVERBALLCOUNT=[DBManagerLastBowler GetlastballCountForlastBowlDetails : COMPETITIONCODE: MATCHCODE: INNINGSNO :  PREVIOUSBOWLERCODE :  LASTBOWLEROVERNO :  LASTBOWLEROVERBALLNOWITHEXTRAS];
        
       
    }else{
        LASTBOWLEROVERBALLNO = 0;
        LASTBOWLEROVERBALLNOWITHEXTRAS = 0;
        LASTBOWLEROVERBALLCOUNT = 0;
    }
    
    
    GetLastBolwerDetails=[ DBManagerLastBowler GetBallEventForLastBowlerDetails :  BOWLERSPELL :  BOWLERRUNS :  ISPARTIALOVER :  TOTALBALLSBOWL :  MAIDENS :  WICKETS: COMPETITIONCODE:  MATCHCODE: INNINGSNO : PREVIOUSBOWLERCODE: OVERNO:LASTBOWLEROVERBALLNO];
    
    }
    
    
    
    @end
