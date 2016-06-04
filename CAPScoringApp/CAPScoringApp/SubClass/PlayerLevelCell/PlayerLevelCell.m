//
//  PlayerLevelCell.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 02/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerLevelCell.h"

@implementation PlayerLevelCell
@synthesize lbl_playerName,Lbl_playerordernumber,mainview,Img_drag,IMg_captain,Img_wktkeeper,Btn_Captain,Btn_WktKeeper;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,100);
        
        self.mainview=[[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x,self.contentView.frame.origin.y,self.contentView.frame.size.width,self.contentView.frame.size.height-20)];
        self.mainview.backgroundColor=[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f];
        
        
        Lbl_playerordernumber = [[UILabel alloc]initWithFrame:CGRectMake(10, 20,100, 30)];
        
        //Lbl_playerordernumber.textAlignment = UITextAlignmentLeft;
        
        Lbl_playerordernumber.font = [UIFont systemFontOfSize:25];
        Lbl_playerordernumber.textColor=[UIColor whiteColor];
        
        lbl_playerName = [[UILabel alloc]initWithFrame:CGRectMake(120, 20,mainview.frame.size.width-120, 30)];
        
        //secondaryLabel.textAlignment = UITextAlignmentLeft;
         lbl_playerName.textColor=[UIColor whiteColor];
        
        lbl_playerName.font = [UIFont systemFontOfSize:25];
        
        Img_drag = [[UIImageView alloc]initWithFrame:CGRectMake(mainview.frame.size.width-100, 15,50, 50)];
        [Img_drag setImage:[UIImage imageNamed:@"Img_drag"]];
        
        Img_wktkeeper = [[UIImageView alloc]initWithFrame:CGRectMake(mainview.frame.size.width-170, 15,50, 50)];
        //[Img_wktkeeper setImage:[UIImage imageNamed:@""]];
        
        IMg_captain = [[UIImageView alloc]initWithFrame:CGRectMake(mainview.frame.size.width-230, 15,50, 50)];
        //[IMg_captain setImage:[UIImage imageNamed:@""]];
        
        Btn_Captain = [[UIButton alloc]initWithFrame:CGRectMake(mainview.frame.size.width-230, 15,50, 50)];
        [Btn_Captain setBackgroundColor:[UIColor clearColor]];
        
        Btn_WktKeeper = [[UIButton alloc]initWithFrame:CGRectMake(mainview.frame.size.width-170, 15,50, 50)];
        [Btn_WktKeeper setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:mainview];
        
        [self.contentView addSubview:Lbl_playerordernumber];
        
        [self.contentView addSubview:lbl_playerName];
        
        [self.contentView addSubview:Img_drag];
        
        [self. contentView addSubview:Img_wktkeeper];
        
        [self.contentView addSubview:IMg_captain];
        
        [self.contentView addSubview:Btn_WktKeeper];
        
        [self.contentView addSubview: Btn_Captain];
        
        
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
