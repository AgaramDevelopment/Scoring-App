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

-(BOOL) CheckUserDetails:(NSString *)LOGINID:(NSString *)PASSWORD;
-(BOOL) INSERTUSERDETAILS:(NSString *)USERCODE:(NSString *)USERROLEID:(NSString *)LOGINID: (NSString *)PASSWORD:(NSString *)REMEMBERME:(NSString *)REMENTDATE:(NSString *)USERFULLNAME:(NSString *)MACHINEID:(NSString *)LICENSEUPTO:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS;

-(BOOL) UPDATEUSERDETAILS:(NSString *)LOGINID: (NSString *)PASSWORD:(NSString *)LICENSEUPTO;


//SecureIdDetails
-(BOOL) CheckSecureIdDetails:(NSString *)USERNAME;

-(BOOL) UPDATESECUREIDDETAILS:(NSString *)USERNAME:(NSString *)SECUREID:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS;

-(BOOL) INSERTSECUREIDDETAILS:(NSString *)USERNAME:(NSString *)SECUREID:(NSString *)STARTDATE:(NSString *)ENDDATE:(NSString *)CREATEDBY:(NSString *)CREATEDDATE:(NSString *)MODIFIEDBY:(NSString *)MODIFIEDDATE:(NSString *)RECORDSTATUS;

// Match Scorer Details

-(BOOL) CheckMatchScorerDetails:(NSString *)Competitioncode : (NSString *)Matchcode : (NSString *)Scorercode;
    
-(BOOL) InsertMatchScorerDetails:(NSString *)Competitioncode:(NSString *)Matchcode:(NSString *)Scorercode:(NSString *)Recordstatus:(NSString *)Createdby:(NSString *)Createddate:(NSString *)Modifiedby:(NSString *)Modifieddate;

-(BOOL) UpdateMatchScorerDetails:(NSString *)Competitioncode:(NSString *)Matchcode:(NSString *)Scorercode:(NSString *)Recordstatus:(NSString *)Createdby:(NSString *)Createddate:(NSString *)Modifiedby:(NSString *)Modifieddate;

//UserScorerDetails

-(BOOL) CheckUserScorerDetails: (NSString *)UserCode;

-(BOOL) InsertUserScorerDetails: (NSString *)UserCode : (NSString *)UserRoleID : (NSString *)LoginID : (NSString *)Password : (NSString *)Rememberme : (NSString *)RementDate : (NSString *)UserFullName : (NSString *)MachineID: (NSString *)LicenseUpTo : (NSString *)Recordstatus : (NSString *)Createdby : (NSString *)Createddate : (NSString *)Modifiedby : (NSString *)Modifieddate;

-(BOOL) UpdateUserScorerDetails: (NSString *)UserCode : (NSString *)UserRoleID : (NSString *)LoginID : (NSString *)Password : (NSString *)Rememberme : (NSString *)RementDate : (NSString *)UserFullName : (NSString *)MachineID: (NSString *)LicenseUpTo : (NSString *)Recordstatus : (NSString *)Createdby : (NSString *)Createddate : (NSString *)Modifiedby : (NSString *)Modifieddate;


@end
