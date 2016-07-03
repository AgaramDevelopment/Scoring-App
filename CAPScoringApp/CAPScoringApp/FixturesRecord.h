//
//  FixturesRecord.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 5/24/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FixturesRecord : NSObject
@property(strong,nonatomic)NSString *competitioncode;
@property(strong,nonatomic)NSString *matchcode;
@property(strong,nonatomic)NSString *matchname;
@property(strong,nonatomic)NSString *matchdate;
@property(strong,nonatomic)NSString *matchovercomments;
@property(strong,nonatomic)NSString *groundcode;
@property(strong,nonatomic)NSString *groundname;
@property(strong,nonatomic)NSString *teamAcode;
@property(strong,nonatomic)NSString *teamAname;
@property(strong,nonatomic)NSString *teamBcode;
@property(strong,nonatomic)NSString *teamBname;
@property(strong,nonatomic)NSString *city;
@property(strong,nonatomic)NSString *overs;
@property(strong,nonatomic)NSString *matchTypeName;
@property(strong,nonatomic)NSString *matchTypeCode;
@property(strong,nonatomic)NSString *count;
@property(strong,nonatomic)NSString *MatchStatus;
@end