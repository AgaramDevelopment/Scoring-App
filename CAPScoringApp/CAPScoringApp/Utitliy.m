//
//  Utitliy.m
//  CAPScoringApp
//
//  Created by APPLE on 25/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "Utitliy.h"
#import "AppDelegate.h"


//Public IP host
@implementation Utitliy

+(NSString *)getIPPORT{
   return @"ioswebservice.upca.tv";
  //  return  @"192.168.1.116:8065";    //betaioswebservice.upca.tv betaioswebservice.upca.tv
    
    //return @"192.168.1.209:8101";    //http://192.168.1.209:8101  internal testing
    
    
    //return @"192.168.1.191:8100";     //t.nagar
    
    
   // return @"192.168.1.200:8131";  //local
    
    //return @"123.201.63.168:8131"; // - static
    
    //return @"capios.agaraminfotech.com";
}


+(NSString *)getSyncIPPORT{
    return @"ioswebservice.upca.tv";
  //  return  @"192.168.1.116:8065";   //192.168.1.49:8096 //@"192.168.1.116:8888";
    
    // return @"192.168.1.209:8101";
    
     //return @"192.168.1.191:8100";     //t.nagar
    
   // return @"192.168.1.200:8131";  //local
    
    //return @"123.201.63.168:8131"; // - static
    
   //return @"capios.agaraminfotech.com";
}

+(NSString *)SecureId{
    return  @"SecureId";
}

+ (NSString *)syncId
{
    return @"Sync";
}

//+(NSString *)getIPPORT{
//    return  @"betaioswebservice.upca.tv";
//}
//
//
//+(NSString *)getSyncIPPORT{
//    return  @"betaioswebservice.upca.tv";
//}
//
//+(NSString *)SecureId{
//    return  @"SecureId";
//}




//NSNumber *basePMWidth = [NSNumber numberWithInt:295];
//NSNumber *basePMHeight = [NSNumber numberWithInt:380];
//
//NSNumber *deviceProWidth = [NSNumber numberWithInt:623];
//NSNumber *deviceProHeight = [NSNumber numberWithInt:700];
//
//NSNumber *deviceOtherWidth = [NSNumber numberWithInt:367];
//NSNumber *deviceOtherHeight = [NSNumber numberWithInt:406];

//PitchMap
+(NSNumber *) getPitchMapXAxisForDevice:(NSNumber*) pmX {
    
    NSNumber *basePMWidth = [NSNumber numberWithInt:380];
    
    NSNumber *deviceProWidth = [NSNumber numberWithInt:623];
    
    NSNumber *deviceOtherWidth = [NSNumber numberWithInt:367];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmX.floatValue/basePMWidth.floatValue)*( [AppDelegate isIpadPro] ?deviceProWidth.floatValue: deviceOtherWidth.floatValue))];
        
        return result;
}

+(NSNumber *) getPitchMapYAxisForDevice:(NSNumber*) pmY {
    
    
    
    NSNumber *basePMHeight = [NSNumber numberWithInt:295];
    
    NSNumber *deviceProHeight = [NSNumber numberWithInt:(700-95)];
    
    NSNumber *deviceOtherHeight = [NSNumber numberWithInt:(406-40)];
    
    
    NSNumber *result = [NSNumber numberWithFloat:((pmY.floatValue/basePMHeight.floatValue)*( [AppDelegate isIpadPro] ?deviceProHeight.floatValue: deviceOtherHeight.floatValue))];
    NSNumber *newResult = [AppDelegate isIpadPro] ? [NSNumber numberWithFloat:result.floatValue+95.0] : [NSNumber numberWithFloat:result.floatValue+40.0];

    return newResult;
}

+(NSNumber *) getPitchMapXAxisForDB:(NSNumber*) pmX {
    
    NSNumber *basePMWidth = [NSNumber numberWithInt:380];
    
    NSNumber *deviceProWidth = [NSNumber numberWithInt:623];
    
    NSNumber *deviceOtherWidth = [NSNumber numberWithInt:367];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmX.floatValue/( [AppDelegate isIpadPro] ?deviceProWidth.floatValue: deviceOtherWidth.floatValue) )*basePMWidth.floatValue)];
    
    return result;
}

+(NSNumber *) getPitchMapYAxisForDB:(NSNumber*) pmY {
    
    NSNumber *basePMHeight = [NSNumber numberWithInt:295];
    
    NSNumber *deviceProHeight = [NSNumber numberWithInt:(700-95)];
    
    NSNumber *deviceOtherHeight = [NSNumber numberWithInt:(406-40)];

    NSNumber *newPmY = [AppDelegate isIpadPro] ? [NSNumber numberWithInt:pmY.intValue-95] : [NSNumber numberWithInt:pmY.intValue-40];

    NSNumber *result = [NSNumber numberWithFloat:((newPmY.floatValue/ ( [AppDelegate isIpadPro] ?deviceProHeight.floatValue: deviceOtherHeight.floatValue) )*basePMHeight.floatValue)];
    
    
    return result;
}



//WagonWheel

+(NSNumber *) getWagonWheelXAxisForDevice:(NSNumber*) pmX {
    
    NSNumber *baseWWWidth = [NSNumber numberWithInt:322];
    
    NSNumber *deviceProWidth = [NSNumber numberWithInt:350];
    
    NSNumber *deviceOtherWidth = [NSNumber numberWithInt:350];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmX.floatValue/baseWWWidth.floatValue)*( [AppDelegate isIpadPro] ?deviceProWidth.floatValue: deviceOtherWidth.floatValue))];
    
    return result;
}

+(NSNumber *) getWagonWheelYAxisForDevice:(NSNumber*) pmY {
    
    NSNumber *baseWWHeight = [NSNumber numberWithInt:295];
    
    NSNumber *deviceProHeight = [NSNumber numberWithInt:350];
    
    NSNumber *deviceOtherHeight = [NSNumber numberWithInt:350];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmY.floatValue/baseWWHeight.floatValue)*( [AppDelegate isIpadPro] ?deviceProHeight.floatValue: deviceOtherHeight.floatValue))];
    
    return result;
}

+(NSNumber *) getWagonWheelXAxisForDB:(NSNumber*) pmX {
    
    NSNumber *baseWWWidth = [NSNumber numberWithInt:322];
    
    NSNumber *deviceProWidth = [NSNumber numberWithInt:350];
    
    NSNumber *deviceOtherWidth = [NSNumber numberWithInt:350];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmX.floatValue/( [AppDelegate isIpadPro] ?deviceProWidth.floatValue: deviceOtherWidth.floatValue) )*baseWWWidth.floatValue)];
    
    return result;
}

+(NSNumber *) getWagonWheelYAxisForDB:(NSNumber*) pmY {
    
    NSNumber *baseWWHeight = [NSNumber numberWithInt:295];
    
    NSNumber *deviceProHeight = [NSNumber numberWithInt:350];
    
    NSNumber *deviceOtherHeight = [NSNumber numberWithInt:350];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmY.floatValue/ ( [AppDelegate isIpadPro] ?deviceProHeight.floatValue: deviceOtherHeight.floatValue) )*baseWWHeight.floatValue)];
    
    return result;
}





//For Report

+(NSNumber *) getWagonWheelXAxisForReportDevice:(NSNumber*) pmX {
    
    NSNumber *baseWWWidth = [NSNumber numberWithInt:322];
    
    NSNumber *deviceProWidth = [NSNumber numberWithInt:600];
    
    NSNumber *deviceOtherWidth = [NSNumber numberWithInt:600];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmX.floatValue/baseWWWidth.floatValue)*( [AppDelegate isIpadPro] ?deviceProWidth.floatValue: deviceOtherWidth.floatValue))];
    
    return result;
}

+(NSNumber *) getWagonWheelYAxisForReportDevice:(NSNumber*) pmY {
    
    NSNumber *baseWWHeight = [NSNumber numberWithInt:295];
    
    NSNumber *deviceProHeight = [NSNumber numberWithInt:600];
    
    NSNumber *deviceOtherHeight = [NSNumber numberWithInt:600];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmY.floatValue/baseWWHeight.floatValue)*( [AppDelegate isIpadPro] ?deviceProHeight.floatValue: deviceOtherHeight.floatValue))];
    
    return result;
}

+(NSNumber *) getWagonWheelXAxisForReportDB:(NSNumber*) pmX {
    
    NSNumber *baseWWWidth = [NSNumber numberWithInt:322];
    
    NSNumber *deviceProWidth = [NSNumber numberWithInt:600];
    
    NSNumber *deviceOtherWidth = [NSNumber numberWithInt:600];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmX.floatValue/( [AppDelegate isIpadPro] ?deviceProWidth.floatValue: deviceOtherWidth.floatValue) )*baseWWWidth.floatValue)];
    
    return result;
}

+(NSNumber *) getWagonWheelYAxisForReportDB:(NSNumber*) pmY {
    
    NSNumber *baseWWHeight = [NSNumber numberWithInt:295];
    
    NSNumber *deviceProHeight = [NSNumber numberWithInt:600];
    
    NSNumber *deviceOtherHeight = [NSNumber numberWithInt:600];
    
    NSNumber *result = [NSNumber numberWithFloat:((pmY.floatValue/ ( [AppDelegate isIpadPro] ?deviceProHeight.floatValue: deviceOtherHeight.floatValue) )*baseWWHeight.floatValue)];
    
    return result;
}





@end

//@implementation Utitliy
//
//+(NSString *)getIPPORT{
//    return  @"182.74.23.197:8102";
//}192.168.1.191:8100
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


//@"192.168.1.116:8888" - development
//@"192.168.1.151:8888" - testing
