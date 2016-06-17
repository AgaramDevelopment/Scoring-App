//
//  RevicedOverVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 6/13/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RevicedOverVC : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *txt_overs;
@property (strong, nonatomic) IBOutlet UITextField *txt_comments;
@property(strong,nonatomic) IBOutlet UIButton * btn_submit;
- (IBAction)btn_submit:(id)sender;
@property(nonatomic,strong) NSString *matchCode;
@property(nonatomic,strong) NSString *competitionCode;


@end
