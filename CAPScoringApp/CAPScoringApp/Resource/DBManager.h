//
//  DBManager.h
//  CAP
//
//  Created by Lexicon on 20/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface DBManager : NSObject
+(NSMutableArray *)RetrieveEventData;

+(NSMutableArray *)checkUserLogin: (NSString *) userName password: (NSString *) password;
+(BOOL)checkExpiryDate: (NSString *) userId;
@end
