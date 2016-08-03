//
//  DbManager_OtherWicket.h
//  CAPScoringApp
//
//  Created by Lexicon on 29/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbManager_OtherWicket : NSObject

-(NSMutableArray*) GetStrickerNonStrickerCodeForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSMutableArray*) GetPlayerDetailForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSMutableArray*) GetPlayerDetailOnRetiredHurtForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSMutableArray*) GetPlayerDetailOnAbsentHurtForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSMutableArray*) GetPlayerDetailOnTimeOutForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSMutableArray*) GetPlayerDetailOnRetiredHurt2ForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSMutableArray*) GetPlayerDetailOnRetiredHurtOnMSC108ForFetchOtherwicketPlayerDetails: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;


-(NSMutableArray *)RetrieveOtherWicketType;


//------------------------
// insert other wickets
//------------------------
-(NSString*) GetBallCodeForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER  ;

-(NSString*) GetMaxOverForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;

-(NSString*) GetMaxBallForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) MAXOVER;

-(NSString*) GetMaxBallCountForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) MAXOVER: (NSString*) MAXBALL ;

-(NSString*) GetBallCodeOnExistsForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) MAXOVER: (NSString*) MAXBALL : (NSString*) BALLCOUNT ;

-(NSString*) GetBallCodeForAssignForInsertOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) MAXOVER: (NSString*) MAXBALL : (NSString*) BALLCOUNT ;

-(NSString*) GetMaxIdForInsertOtherwicket:  (NSString*) MATCHCODE ;

-(BOOL) InsertWicketEventForInsertOtherwicket:(NSString*) BALLCODE :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETNO: (NSString*) WICKETTYPE: (NSString*) WICKETPLAYER: (NSString*) VIDEOLOCATION;

-(NSMutableArray*) GetWicketDetailForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER;

-(NSString*) GetBatsManCodeForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER;

-(BOOL)  UpdateBattingSummaryForInsertOtherwicket:(NSString*) N_WICKETNO :(NSString*) N_WICKETTYPE:(NSString*) N_FIELDERCODE:(NSString*) TOTALRUNS :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER;

-(NSString*) GetBattingPositionNoForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;


-(BOOL)   InsertBattingSummaryForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) BATTINGPOSITIONNO: (NSString*) WICKETPLAYER :(NSString*) N_WICKETNO:(NSString*) N_WICKETTYPE:(NSString*) TOTALRUNS ;


-(NSString*) GetInningsNoForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;

-(BOOL)   UpdateInningsSummaryForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO : (NSNumber*) WICKETNO;

-(BOOL)   InsertInningsSummaryForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO : (NSNumber*) WICKETNO;

-(NSMutableArray*) GetPlayerDetailForInsertOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE ;

-(NSMutableArray*) GetWicketEventDetailsForInsertOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSNumber*) GetWicketNoForInsertOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;





//------------------------
//UPDATE OTHER WICKETS
//------------------------

-(NSString*) GetBallCodeForUpdateOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER :(NSNumber*) WICKETNO: (NSString*) WICKETTYPE  ;

-(BOOL)   UpdateWicKetEventUpdateOtherwicket:(NSString*) WICKETTYPE:(NSString*) WICKETPLAYER:(NSString*) VIDEOLOCATION :(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO:(NSNumber*) WICKETNO;

-(NSMutableArray*) GetWicketOnAssignForUpdateOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER;

-(BOOL)   UpdateBattingSummaryForUpdateOtherwicket:(NSString*) N_WICKETNO:(NSString*) N_WICKETTYPE:(NSString*) N_FIELDERCODE :(NSString*) TOTALRUNS: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER;;

-(NSMutableArray*) GetPlayerDetailForUpdateOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE ;

-(NSMutableArray*) GetWicketEventDetailsForUpdateOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSString*) GetWicketNoForUpdateOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;
-(NSMutableArray*)  GetwicketForUpdateOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO: (NSString*) WICKETPLAYER;



//------------------------
//DELETE OTHER WICKETS
//------------------------

-(NSMutableArray*) GetWicketPlayerandTypeForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO ;

-(BOOL)   UpdateBattingSummaryForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER;

-(BOOL)   DeleteBattingSummaryForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSString*) WICKETPLAYER;

-(BOOL)   UpdateBattingSummaryDetailForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO;

-(BOOL)   UpdateInningsSummaryDetailForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(BOOL)  DeleteWicketEventsForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO;

-(BOOL)  UpdateWicketEventsForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO : (NSNumber*) WICKETNO;

-(NSMutableArray*) GetPlayerDetailForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE ;

-(NSMutableArray*) GetWicketEventDetailsForDeleteOtherwicket: (NSString*) COMPETITIONCODE: (NSString*) MATCHCODE:(NSString*) TEAMCODE: (NSNumber*) INNINGSNO ;

-(NSString*) GetWicketNoForDeleteOtherwicket:(NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO;

-(NSString*)  GetBallCodeForDeleteOtherwicket: (NSString*) COMPETITIONCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE :(NSNumber*) INNINGSNO :(NSNumber*) WICKETNO;

@end


