//
//  SelectPlayersVC.h
//  CAPScoringApp
//
//  Created by APPLE on 25/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMatchSetUpVC.h"


@interface SelectPlayersVC : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
- (IBAction)btn_cancel:(id)sender;
- (IBAction)btn_select:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_select_count;
@property (weak, nonatomic) IBOutlet UITextField *txt_search;

- (IBAction)btn_search:(id)sender;

@property (strong,nonatomic) NSString *teamCode;
@property (strong,nonatomic) NSString *matchCode;



@end
