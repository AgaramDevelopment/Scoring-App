//
//  Utitliy.h
//  CAPScoringApp
//
//  Created by APPLE on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utitliy : NSObject
+(NSString *) getIPPORT;
+(NSString *)getSyncIPPORT;
+(NSString *) SecureId;
//+(NSString *) getPitchMapAxis :(NSNumber*) pmX ;
+ (NSString *)syncId;

+(NSNumber *) getPitchMapXAxisForDevice:(NSNumber*) pmX ;
+(NSNumber *) getPitchMapYAxisForDevice:(NSNumber*) pmY;

+(NSNumber *) getPitchMapXAxisForDB:(NSNumber*) pmX;

+(NSNumber *) getPitchMapYAxisForDB:(NSNumber*) pmY;

+(NSNumber *) getWagonWheelXAxisForDevice:(NSNumber*) pmX ;
+(NSNumber *) getWagonWheelYAxisForDevice:(NSNumber*) pmY ;

+(NSNumber *) getWagonWheelXAxisForDB:(NSNumber*) pmX ;

+(NSNumber *) getWagonWheelYAxisForDB:(NSNumber*) pmY;


//For Report
+(NSNumber *) getWagonWheelXAxisForReportDevice:(NSNumber*) pmX;
+(NSNumber *) getWagonWheelYAxisForReportDevice:(NSNumber*) pmY;
+(NSNumber *) getWagonWheelXAxisForReportDB:(NSNumber*) pmX;
+(NSNumber *) getWagonWheelYAxisForReportDB:(NSNumber*) pmY;
@end
