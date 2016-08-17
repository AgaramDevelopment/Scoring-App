//
//  Utitliy.m
//  CAPScoringApp
//
//  Created by APPLE on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "Utitliy.h"
//Public IP host
//@implementation Utitliy
//
//+(NSString *)getIPPORT{
//    return  @"182.74.23.197:8102";
//}
//
//
//+(NSString *)getSyncIPPORT{
//    return  @"182.74.23.197:8102";
//}
//
//+(NSString *)SecureId{
//    return  @"SecureId";
//}
//@end

@implementation Utitliy

//return  @"182.74.23.197:8102"; Live
//return  @"192.168.1.49:8096"; Testing
+(NSString *)getIPPORT{
    return  @"192.168.1.49:8096";
}


+(NSString *)getSyncIPPORT{
    return  @"192.168.1.49:8096";
}

+(NSString *)SecureId{
    return  @"SecureId";
}
@end