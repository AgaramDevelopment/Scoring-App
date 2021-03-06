//
//  DBMANAGERSYNC.h
//  CAPScoringApp
//
//  Created by Lexicon on 22/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBMANAGERSYNC : NSObject
//competition insert&Update
-(BOOL) CheckCompetitionCode:(NSString *)COMPETITIONCODE;

-(BOOL)InsertMASTEREvents:(NSString*) COMPETITIONCODE:(NSString*) COMPETITIONNAME:(NSString*) SEASON:(NSString*) TROPHY:(NSString*) STARTDATE:(NSString*) ENDDATE:(NSString*) MATCHTYPE:(NSString*) ISOTHERSMATCHTYPE :(NSString*) MANOFTHESERIESCODE:(NSString*) BESTBATSMANCODE :(NSString*) BESTBOWLERCODE:(NSString*) BESTALLROUNDERCODE:(NSString*) MOSTVALUABLEPLAYERCODE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;

-(BOOL ) UPDATECOMPETITION:(NSString*) COMPETITIONCODE:(NSString*) COMPETITIONNAME:(NSString*) SEASON:(NSString*) TROPHY:(NSString*) STARTDATE:(NSString*) ENDDATE:(NSString*) MATCHTYPE:(NSString*) ISOTHERSMATCHTYPE :(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;





///competitionteamdetails
-(BOOL) CheckCompetitionCodeTeamCode:(NSString *)COMPETITIONCODE:(NSString *)TEAMCODE;
-(BOOL) InsertCompetitionTeamDetails:(NSString*) COMPETITIONTEAMCODE:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE:(NSString*) RECORDSTATUS;
-(BOOL) DELETECompetitionCodeTeamCode:(NSString *)COMPETITIONCODE:(NSString *)TEAMCODE;



//Competitionteamplayer

-(BOOL) CheckCompetitionteamplayer:(NSString *)COMPETITIONCODE:(NSString *)TEAMCODE:(NSString *)PLAYERCODE;

-(BOOL) InsertCompetitionTeamPlayer:(NSString*) COMPETITIONCODE:(NSString*) TEAMCODE:(NSString*) PLAYERCODE:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;




//Matchregistration
-(BOOL) CheckAlreadySyncMatchregistration:(NSString *)MATCHCODE;
-(BOOL) Matchregistration:(NSString *)MATCHCODE;
-(BOOL) InsertMatchregistration:(NSString*) MATCHCODE:(NSString*) MATCHNAME:(NSString*) COMPETITIONCODE:(NSString*) MATCHOVERS:(NSString*) MATCHOVERCOMMENTS:(NSString*) MATCHDATE:(NSString*) ISDAYNIGHT:(NSString*) ISNEUTRALVENUE:(NSString*) GROUNDCODE:(NSString*) TEAMACODE:(NSString*) TEAMBCODE:(NSString*) TEAMACAPTAIN:(NSString*) TEAMAWICKETKEEPER:(NSString*) TEAMBCAPTAIN:(NSString*) TEAMBWICKETKEEPER:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) UMPIRE3CODE:(NSString*) MATCHREFEREECODE:(NSString*) MATCHRESULT:(NSString*) MATCHRESULTTEAMCODE:(NSString*) TEAMAPOINTS:(NSString*) TEAMBPOINTS:(NSString*) MATCHSTATUS:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) ISDEFAULTORLASTINSTANCE;

-(BOOL) UpdateMatchregistration:(NSString*) MATCHCODE:(NSString*) MATCHNAME:(NSString*) COMPETITIONCODE:(NSString*) MATCHOVERS:(NSString*) MATCHOVERCOMMENTS:(NSString*) MATCHDATE:(NSString*) ISDAYNIGHT:(NSString*) ISNEUTRALVENUE:(NSString*) GROUNDCODE:(NSString*) TEAMACODE:(NSString*) TEAMBCODE:(NSString*) TEAMACAPTAIN:(NSString*) TEAMAWICKETKEEPER:(NSString*) TEAMBCAPTAIN:(NSString*) TEAMBWICKETKEEPER:(NSString*) UMPIRE1CODE:(NSString*) UMPIRE2CODE:(NSString*) UMPIRE3CODE:(NSString*) MATCHREFEREECODE:(NSString*) MATCHRESULT:(NSString*) MATCHRESULTTEAMCODE:(NSString*) TEAMAPOINTS:(NSString*) TEAMBPOINTS:(NSString*) MATCHSTATUS:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) ISDEFAULTORLASTINSTANCE;


//Matchteamplayerdetails

-(BOOL) CheckMatchteamplayerdetails:(NSString *)MATCHCODE:(NSString *)TEAMCODE:(NSString *)PLAYERCODE;
-(BOOL) InsertMatchteamplayerdetails:(NSString*) MATCHTEAMPLAYERCODE:(NSString*) MATCHCODE:(NSString*) TEAMCODE:(NSString*) PLAYERCODE:(NSString*)PLAYINGORDER:(NSString*) RECORDSTATUS;



//TeamMaster
//CheckTeamMaster:TEAMCODE
-(BOOL) CheckTeamMaster:(NSString *)MATCHCODE;
-(BOOL)InsertTeamMaster:(NSString*) TEAMCODE:(NSString*) TEAMNAME:(NSString*) SHORTTEAMNAME:(NSString*) TEAMTYPE:(NSString*)TEAMLOGO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;
-(BOOL )UpdateTeamMaster:(NSString*) TEAMNAME:(NSString*) SHORTTEAMNAME:(NSString*) TEAMTYPE:(NSString*) TEAMLOGO:(NSString*) RECORDSTATUS:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) TEAMCODE;

//playerMaster

-(BOOL )CheckPlayermaster:(NSString*) PLAYERCODE;
-(BOOL ) InsertPlayermaster:(NSString*) PLAYERCODE:(NSString*) PLAYERNAME:(NSString*) PLAYERDOB:(NSString*) PLAYERPHOTO:(NSString*) BATTINGSTYLE:(NSString*) BATTINGORDER:(NSString*) BOWLINGSTYLE:(NSString*)BOWLINGTYPE:(NSString*) BOWLINGSPECIALIZATION:(NSString*) PLAYERROLE:(NSString*) PLAYERREMARKS:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) BALLTYPECODE:(NSString*) SHOTTYPE:(NSString*) SHOTCODE:(NSString*)PMLENGTHCODE:(NSString*)PMLINECODE:(NSString*) PMXVALUE:(NSString*) PMYVALUE:(NSString*) ATWOROTW;
-(BOOL) UpdatePlayermaster:(NSString*) PLAYERCODE:(NSString*) PLAYERNAME:(NSString*) PLAYERDOB:(NSString*) PLAYERPHOTO:(NSString*) BATTINGSTYLE:(NSString*) BATTINGORDER:(NSString*) BOWLINGSTYLE:(NSString*)BOWLINGTYPE:(NSString*) BOWLINGSPECIALIZATION:(NSString*) PLAYERROLE:(NSString*) PLAYERREMARKS:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE:(NSString*) BALLTYPECODE:(NSString*) SHOTTYPE:(NSString*) SHOTCODE:(NSString*)PMLENGTHCODE:(NSString*)PMLINECODE:(NSString*) PMXVALUE:(NSString*) PMYVALUE:(NSString*) ATWOROTW;



//PlayerTeamDeatils
-(BOOL )CheckPlayerTeamDetails:(NSString*) PLAYERCODE:(NSString*) TEAMCODE;
-(BOOL) InsertPlayerTeamDetails:(NSString*) PLAYERCODE:(NSString*) TEAMCODE:(NSString*) RECORDSTATUS;
-(BOOL) UpdatePlayerTeamDetails:(NSString*) PLAYERCODE:(NSString*) TEAMCODE:(NSString*) RECORDSTATUS;





//Officialsmaster

-(BOOL )CheckOfficialsmaster:(NSString*)OFFICIALSCODE;

-(BOOL) InsertOfficialsmaster:(NSString*) OFFICIALSCODE:(NSString*) NAME:(NSString*) ROLE:(NSString*) COUNTRY:(NSString*) STATE:(NSString*) CATEGORY:(NSString*) OFFICIALSPHOTO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;

-(BOOL) UpdateOfficialsmaster:(NSString*) OFFICIALSCODE:(NSString*) NAME:(NSString*) ROLE:(NSString*) COUNTRY:(NSString*) STATE:(NSString*) CATEGORY:(NSString*) OFFICIALSPHOTO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;




//Coachmaster

-(BOOL )CheckCoachmaster:(NSString*)COACHCODE;
-(BOOL) InsertCoachmaster:(NSString*) COACHCODE:(NSString*) COACHNAME:(NSString*) COACHTEAMCODE:(NSString*)COACHSPECIALIZATION:(NSString*) COACHPHOTO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;
-(BOOL) UpdateCoachmaster:(NSString*) COACHCODE:(NSString*) COACHNAME:(NSString*) COACHTEAMCODE:(NSString*)COACHSPECIALIZATION:(NSString*) COACHPHOTO:(NSString*) RECORDSTATUS:(NSString*) CREATEDBY:(NSString*) CREATEDDATE:(NSString*) MODIFIEDBY:(NSString*) MODIFIEDDATE;

//Groundmaster


-(BOOL )CheckGroundmaster:(NSString*)GROUNDCODE;

-(BOOL) InsertGroundmaster:(NSString*)GROUNDCODE:(NSString*)GROUNDNAME:(NSString*)COUNTRY:(NSString*)STATE:(NSString*)CITY:(NSString*)GROUNDPROFILE:(NSString*)GSTOPLEFT:(NSString*)GSTOPRIGHT:(NSString*)GSBOTTOMLEFT:(NSString*)GSBOTTOMRIGHT:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:MODIFIEDDATE;

-(BOOL) UpdateGroundmaster:(NSString*)GROUNDCODE:(NSString*)GROUNDNAME:(NSString*)COUNTRY:(NSString*)STATE:(NSString*)CITY:(NSString*)GROUNDPROFILE:(NSString*)GSTOPLEFT:(NSString*)GSTOPRIGHT:(NSString*)GSBOTTOMLEFT:(NSString*)GSBOTTOMRIGHT:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:MODIFIEDDATE;



//Shottype

-(BOOL )CheckShottype:(NSString*)SHOTCODE;

-(BOOL) UpdateShottype:(NSString*)SHOTCODE:(NSString*)SHOTNAME:(NSString*)SHOTTYPE:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE;

-(BOOL) InsertShottype:(NSString*)SHOTCODE:(NSString*)SHOTNAME:(NSString*)SHOTTYPE:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE;


//Bowltype
-(BOOL )CheckBowltype:(NSString*)BOWLTYPECODE;

-(BOOL) UpdateBowltype:(NSString*)BOWLTYPECODE:(NSString*)BOWLTYPE:(NSString*)BOWLERTYPE:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE;

-(BOOL) InsertBowltype:(NSString*)BOWLTYPECODE:(NSString*)BOWLTYPE:(NSString*)BOWLERTYPE:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE;



//Bowlerspecialization

-(BOOL)CheckBowlerspecialization:BOWLERSPECIALIZATIONCODE;

-(BOOL)UpdateBowlerspecialization:(NSString*)BOWLERSPECIALIZATIONCODE:(NSString*)BOWLERSPECIALIZATION:(NSString*)BOWLERSTYLE:(NSString*)BOWLERTYPE:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:MODIFIEDDATE;

-(BOOL) InsertBowlerspecialization:(NSString*)BOWLERSPECIALIZATIONCODE:(NSString*)BOWLERSPECIALIZATION:(NSString*)BOWLERSTYLE:(NSString*)BOWLERTYPE:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:MODIFIEDDATE;


//Fieldingfactor

-(BOOL) CheckFieldingfactor:(NSString*)BOWLERSPECIALIZATIONCODE;

-(BOOL)UpdateFieldingfactor:(NSString*)FIELDINGFACTORCODE:(NSString*)FIELDINGFACTOR:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE;
-(BOOL)InsertFieldingfactor:(NSString*)FIELDINGFACTORCODE:(NSString*)FIELDINGFACTOR:(NSString*)DISPLAYORDER:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE;


//Metadata

-(BOOL) CheckMetaData:METASUBCODE;
-(BOOL)InsertMetaData:(NSString*)METASUBCODE:(NSString*)METADATATYPECODE:(NSString*)METADATATYPEDESCRIPTION:(NSString*)METASUBCODEDESCRIPTION;


//PowerplayType
-(BOOL)  CheckPowerplayType:POWERPLAYTYPECODE;
-(BOOL)InsertPowerplayType:(NSString*)POWERPLAYTYPECODE:(NSString*)POWERPLAYTYPENAME:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE:(NSString*)ISSYSTEMREFERENCE;

-(BOOL)UpdatePowerplayType:(NSString*)POWERPLAYTYPECODE:(NSString*)POWERPLAYTYPENAME:(NSString*)RECORDSTATUS:(NSString*)CREATEDBY:(NSString*)CREATEDDATE:(NSString*)MODIFIEDBY:(NSString*)MODIFIEDDATE:(NSString*)ISSYSTEMREFERENCE;


//fetch the image
-(NSMutableArray *)getPlayerCode;
-(NSMutableArray *)getTeamCode;

-(NSMutableArray *)getofficailCode;
-(NSMutableArray *)getgroundcode;

@property(nonatomic,strong) NSString *getDBPath;

@end
