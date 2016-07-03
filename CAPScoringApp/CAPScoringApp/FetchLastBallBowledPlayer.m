//
//  FetchLastBallBowledPlayer.m
//  CAPScoringApp
//
//  Created by APPLE on 14/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "FetchLastBallBowledPlayer.h"
#import "DBManager.h"

@implementation FetchLastBallBowledPlayer

//Last Bowler
@synthesize lastBowlerPlayerCode ;
@synthesize lastBowlerPlayerName;
@synthesize lastBowlerOver;
@synthesize lastBowlerMaidan;
@synthesize lastBowlerRuns;
@synthesize lastBowlerWicket;
@synthesize lastBowlerEcoRate;



-(void) getLastBallBowlerPlayer : (NSString*) COMPETITIONCODE MATCHCODE:(NSString*) MATCHCODE INNINGSNO: (NSString*) INNINGSNO OVERNO: (NSString*) OVERNO BATTINGTEAMCODE: (NSString*) BATTINGTEAMCODE{
    
    NSString *ballNo = [DBManager getBallNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:OVERNO];
    NSString *ballCount = [DBManager getBallCount:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:OVERNO BALLNO: ballNo];
    
    NSString *BOWLERCODE = [DBManager getLastBowlerCode:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO OVERNO:OVERNO BALLNO: ballNo BALLCOUNT: ballCount];
    
    
   
    NSNumber *WICKETS = 0;
    
    WICKETS = [DBManager getWicket:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    NSNumber *LASTBOWLEROVERNO;
    NSNumber *LASTBOWLEROVERBALLNO;
    NSNumber *LASTBOWLEROVERBALLNOWITHEXTRAS;
    NSNumber *LASTBOWLEROVERBALLCOUNT;
    
    
    LASTBOWLEROVERNO = [DBManager getLASTBOWLEROVERNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    NSNumber *LASTBOWLEROVERSTATUS = [DBManager getLASTBOWLEROVERSTATUS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO];
    
    if(LASTBOWLEROVERNO != nil){
        
        LASTBOWLEROVERBALLNO = [DBManager getLASTBOWLEROVERBALLNO:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE];
        
        LASTBOWLEROVERBALLNOWITHEXTRAS = [DBManager getLASTBOWLEROVERBALLNOWITHEXTRAS:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE];
        
        LASTBOWLEROVERBALLCOUNT = [DBManager getLASTBOWLEROVERBALLCOUNT:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:LASTBOWLEROVERBALLNOWITHEXTRAS];
        
    }else{
        LASTBOWLEROVERBALLNO = 0;
        LASTBOWLEROVERBALLNOWITHEXTRAS = 0;
        LASTBOWLEROVERBALLCOUNT = 0;
    }
    
    
    NSString *S_ATWOROTW = [DBManager getS_ATWOROTW:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE LASTBOWLEROVERBALLNOWITHEXTRAS:LASTBOWLEROVERBALLNOWITHEXTRAS LASTBOWLEROVERBALLCOUNT:LASTBOWLEROVERBALLCOUNT];
    
    //NSString *BATTEAMOVERSDATA = [NSString stringWithFormat: @"%d", (long)BATTEAMOVERS];
    

    
    
    NSNumber *TOTALBALLSBOWL;
    NSNumber *MAIDENS;
    NSNumber *BOWLERRUNS;
    NSNumber *ISPARTIALOVER = [DBManager getISPARTIALOVER:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE LASTBOWLEROVERNO:LASTBOWLEROVERNO BOWLERCODE:BOWLERCODE BATTEAMOVERS:OVERNO];
    
    if(ISPARTIALOVER.intValue == 0){
        ISPARTIALOVER = [DBManager getISPARTIALOVERWHEN0:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE BATTEAMOVERS:OVERNO];
    }
    NSMutableArray *getBowlerBasedDetails = [DBManager getTOTALBALLSBOWL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE];
    
    if([getBowlerBasedDetails count]>0){
        TOTALBALLSBOWL = [getBowlerBasedDetails objectAtIndex:0];
        MAIDENS = [getBowlerBasedDetails objectAtIndex:1];
        BOWLERRUNS = [getBowlerBasedDetails objectAtIndex:2];
        
    }
    
    
    LASTBOWLEROVERBALLNO = LASTBOWLEROVERSTATUS.intValue == 1 ? [NSNumber numberWithInt:0] : LASTBOWLEROVERBALLNO;
    
    
    NSNumber *BOWLERSPELL  = 0;
    NSNumber *V_SPELLNO = 0;
    
    BOWLERSPELL = [DBManager getBOWLERSPELL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE BATTEAMOVERS:OVERNO V_SPELLNO:V_SPELLNO];
    
    int BOWLERSPELLDATA = (int)[OVERNO intValue] - (int)LASTBOWLEROVERNO > 2 && (int)LASTBOWLEROVERSTATUS == 1 ? (int)BOWLERSPELL + 1 : (int)BOWLERSPELL;
    
    BOWLERSPELL = [NSNumber numberWithInt:BOWLERSPELLDATA];
    
    
    
    
    
    //BOWLER DETAILS
    NSMutableArray *lastBowlerDetaailsArray;
    
    if([DBManager GETBOLWERDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BATTINGTEAMCODE:BATTINGTEAMCODE BOWLERCODE:BOWLERCODE]){
        
        lastBowlerDetaailsArray =[DBManager GETBOLWLINGDETAIL:COMPETITIONCODE MATCHCODE:MATCHCODE INNINGSNO:INNINGSNO BOWLERCODE:BOWLERCODE BOWLERSPELL:BOWLERSPELL BOWLERRUNS:BOWLERRUNS S_ATWOROTW:S_ATWOROTW TOTALBALLSBOWL:TOTALBALLSBOWL WICKETS:WICKETS MAIDENS:MAIDENS ISPARTIALOVER:ISPARTIALOVER LASTBOWLEROVERBALLNO:LASTBOWLEROVERBALLNO];
      
    }else{
        
        lastBowlerDetaailsArray =[DBManager GETPLAYERDETAIL:BOWLERCODE];
    }
    

    if(lastBowlerDetaailsArray.count>0){
        
        lastBowlerPlayerCode = [lastBowlerDetaailsArray objectAtIndex:0];
        lastBowlerPlayerName = [lastBowlerDetaailsArray objectAtIndex:1];
        lastBowlerRuns = [lastBowlerDetaailsArray objectAtIndex:2];
        lastBowlerOver = [lastBowlerDetaailsArray objectAtIndex:3];
        lastBowlerMaidan = [lastBowlerDetaailsArray objectAtIndex:4];
        lastBowlerWicket = [lastBowlerDetaailsArray objectAtIndex:5];
        lastBowlerEcoRate = [lastBowlerDetaailsArray objectAtIndex:6];
        
    }
}
@end
