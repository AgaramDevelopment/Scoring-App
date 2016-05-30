//
//  FixturesVC.h
//  CAPScoringApp
//
//  Created by Ramas Mac Book on 5/24/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TorunamentVC.h"
@interface FixturesVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *FixtureTVC;
@property(strong,nonatomic) IBOutlet UIView * popView;
@property(strong,nonatomic) IBOutlet NSLayoutConstraint * popviewYposition;
@property (strong, nonatomic) IBOutlet UIButton *btnSaveOutlet;

- (IBAction)btnCancel:(id)sender;
- (IBAction)btnsave:(id)sender;
@property (strong, nonatomic) IBOutlet UITextView *txt_info;


@property(nonatomic,strong)NSString *CompitionCode;

@end

