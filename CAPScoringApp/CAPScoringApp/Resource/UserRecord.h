//
//  UserRecord.h
//  CAPScoringApp
//
//  Created by APPLE on 25/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRecord : NSObject

@property(strong,nonatomic)NSString *userCode;
@property(strong,nonatomic)NSString *userName;
@property(strong,nonatomic)NSString *password;
@property(strong,nonatomic)NSString *expiryDate;



@end
