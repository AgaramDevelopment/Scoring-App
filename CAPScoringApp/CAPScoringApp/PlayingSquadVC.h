//
//  PlayingSquadVC.h
//  CAPScoringApp
//
//  Created by Raja sssss on 19/10/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingSquadCell.h"

@interface PlayingSquadVC : UIViewController


@property(strong,nonatomic) NSString *matchCode;
@property(strong,nonatomic) NSString *teamAname;
@property(strong,nonatomic) NSString *teamBname;
@property(strong,nonatomic) NSString *venu;
@property(strong,nonatomic) NSString *city;
@property(strong,nonatomic) NSString *date;
@property(strong,nonatomic) NSString *month;
@property(strong,nonatomic) NSString *year;
@property(strong,nonatomic) NSString *teamACode;
@property(strong,nonatomic) NSString *teamBCode;
@property(strong,nonatomic) NSString *matchType;


@property (strong, nonatomic) IBOutlet UILabel *txt_teamA_heading;
@property (strong, nonatomic) IBOutlet UILabel *txt_teamB_heading;


//@property (strong, nonatomic) IBOutlet UILabel *txt_hme_ground;
//@property (strong, nonatomic) IBOutlet UIImageView *img_teamA;
//@property (strong, nonatomic) IBOutlet UILabel *txt_teamA;
//@property (strong, nonatomic) IBOutlet UILabel *txt_teamB;
//@property (strong, nonatomic) IBOutlet UIImageView *img_teamB;
//@property (strong, nonatomic) IBOutlet UILabel *txt_date_venu;
//@property (strong, nonatomic) IBOutlet UILabel *txt_teamA_heading;
//@property (strong, nonatomic) IBOutlet UILabel *txt_teamB_heading;

@property (strong, nonatomic) IBOutlet UITableView *tbl_players;

@property (strong, nonatomic) IBOutlet UILabel *txt_hme_name;
@property (strong, nonatomic) IBOutlet UIImageView *img_teamA;
@property (strong, nonatomic) IBOutlet UILabel *txt_teamA;
@property (strong, nonatomic) IBOutlet UILabel *txt_teamB;
@property (strong, nonatomic) IBOutlet UIImageView *img_teamB;
@property (strong, nonatomic) IBOutlet UILabel *txt_date_venu;

@property (strong, nonatomic) IBOutlet PlayingSquadCell *playingSquadCell;

@end
