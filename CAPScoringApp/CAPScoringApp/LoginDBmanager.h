//
//  LoginDBmanager.h
//  CAPScoringApp
//
//  Created by Lexicon on 01/07/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginDBmanager : NSObject
//UserDetails

+(BOOL) CheckUserDetails:(NSString *)LOGINID:(NSString *)PASSWORD;
+(BOOL) INSERTUSERDETAILS:(NSString *)USERCODE:(NSString *)USERROLEID:(NSString *)LOGINID: (NSString *)PASSWORD:(NSString *)REMEMBERME:(NSString *)REMENTDATE:(NSString *)USERFULLNAME:(NSString *)MACHINEID:(NSString *)LICENSEUPTO:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS;

+(BOOL) UPDATEUSERDETAILS:(NSString *)LOGINID: (NSString *)PASSWORD:(NSString *)LICENSEUPTO;


//SecureIdDetails
+(BOOL) CheckSecureIdDetails:(NSString *)USERNAME;

+(BOOL) UPDATESECUREIDDETAILS:(NSString *)USERNAME:(NSString *)SECUREID:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS;

+(BOOL) INSERTSECUREIDDETAILS:(NSString *)USERNAME:(NSString *)SECUREID:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS;
@end
