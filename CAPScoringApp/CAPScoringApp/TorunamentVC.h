//
//  TorunamentVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TorunamentVC : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) IBOutlet UILabel * selectMatchName;


- (IBAction)Btn_touch:(id)sender;

@end
