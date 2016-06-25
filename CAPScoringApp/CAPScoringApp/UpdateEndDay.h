//
//  UpdateEndDay.h
//  CAPScoringApp
//
//  Created by APPLE on 24/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateEndDay : NSObject
@property(strong,nonatomic)NSString *STARTTIME;
@property(strong,nonatomic)NSString *ENDTIME;
@property(strong,nonatomic)NSString *DURATION;
@property(strong,nonatomic)NSString *TEAMNAME;
@property(strong,nonatomic)NSString *DAYNO;
@property(strong,nonatomic)NSString *INNINGSNO;
@property(strong,nonatomic)NSString *TOTALRUNS;
@property(strong,nonatomic)NSString *TOTALOVERS;
@property(strong,nonatomic)NSString *TOTALWICKETS;
@property(strong,nonatomic)NSString *COMMENTS;
@property(strong,nonatomic)NSString *BATTINGTEAMCODE;

-(void) UpdateEndDay:(NSString*)COMPETITIONCODE:(NSString*)MATCHCODE:(NSString*)INNINGSNO:(NSString*)STARTTIME:(NSString*)ENDTIME:(NSString*)DAYNO:(NSString*)BATTINGTEAMCODE:(NSString*)COMMENTS:(NSString*)ENDTIMEFORMAT:(NSString*)STARTTIMEFORMAT
;
@end
