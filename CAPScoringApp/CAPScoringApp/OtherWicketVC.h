//
//  OtherWicketVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/18/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherWicketTVC.h"

@interface OtherWicketVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tbl_otherwicket;
@property(nonatomic,strong) NSString *matchcode;
@property(nonatomic,strong) NSString *competitioncode;
@property (strong, nonatomic) IBOutlet OtherWicketTVC *otherwicet_cell;


@end
