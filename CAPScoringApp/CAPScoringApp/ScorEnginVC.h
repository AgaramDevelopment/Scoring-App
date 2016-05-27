//
//  ScorEnginVC.h
//  CAPScoringApp
//
//  Created by Lexicon on 24/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScorEnginVC : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic,strong) IBOutlet UIView *CommonView;
@property (nonatomic,strong) IBOutlet UIView *TopView;
@property (nonatomic,strong) IBOutlet UIView *TopScorView;
@property (nonatomic,strong) IBOutlet UIView *TopFirstInsView;
@property (nonatomic,strong) IBOutlet UIView *TopSecondInsView;

// BATSMENVIEW
@property(nonatomic,strong) IBOutlet UIView * BatsmenView;
@property(nonatomic,strong) IBOutlet UIView * BatsmenTopView;
@property(nonatomic,strong) IBOutlet UILabel* selectBatsmenName;
//CurrentBatsmenScoredisplaylable
@property(nonatomic,strong) IBOutlet UIView * Batsmen1ScoreView;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen1Name;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen1Run;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen1Balls;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen14s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen16s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen1SR;


@property(nonatomic,strong) IBOutlet UIView * Batsmen2ScoreView;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen2Name;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen2Run;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen2Balls;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen24s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen26s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Batsmen2SR;






//BOWLERVIEW
@property(nonatomic,strong) IBOutlet UIView * BowlerView;
@property(nonatomic,strong) IBOutlet UIView * BowlerTopView;
@property(nonatomic,strong) IBOutlet UILabel* selectBowlerName;

//CurrentBowlerScoredisplaylable
@property(nonatomic,strong) IBOutlet UIView * Bowler1ScoreView;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler1Name;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler1Run;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler1Balls;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler14s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler16s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler1SR;



@property(nonatomic,strong) IBOutlet UIView * Bowler2ScoreView;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler2Name;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler2Run;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler2Balls;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler24s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler26s;
@property(nonatomic,strong) IBOutlet UILabel* lbl_Bowler2SR;


@property(nonatomic,strong) IBOutlet UIView * leftsideview;
@property(nonatomic,strong) IBOutlet UIView * Rightsideview;
@property(nonatomic,strong) IBOutlet UIView * Allvaluedisplayview;


@end
