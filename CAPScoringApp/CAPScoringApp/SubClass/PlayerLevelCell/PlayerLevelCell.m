//
//  PlayerLevelCell.m
//  CAPScoringApp
//
//  Created by RamaSubramanian on 02/06/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import "PlayerLevelCell.h"

@implementation PlayerLevelCell
@synthesize lbl_playerName,Lbl_playerordernumber,mainview,Img_drag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,100);
        
        self.mainview=[[UIView alloc]initWithFrame:CGRectMake(self.contentView.frame.origin.x,self.contentView.frame.origin.y,self.contentView.frame.size.width,self.contentView.frame.size.height-20)];
        self.mainview.backgroundColor=[UIColor colorWithRed:(8.0/255.0f) green:(9.0/255.0f) blue:(11.0/255.0f) alpha:1.0f];
        
        
        Lbl_playerordernumber = [[UILabel alloc]initWithFrame:CGRectMake(10, 18,100, 30)];
        
        //Lbl_playerordernumber.textAlignment = UITextAlignmentLeft;
        
        Lbl_playerordernumber.font = [UIFont systemFontOfSize:25];
        Lbl_playerordernumber.textColor=[UIColor whiteColor];
        
        lbl_playerName = [[UILabel alloc]initWithFrame:CGRectMake(120, 18,mainview.frame.size.width-120, 30)];
        
        //secondaryLabel.textAlignment = UITextAlignmentLeft;
         lbl_playerName.textColor=[UIColor whiteColor];
        
        lbl_playerName.font = [UIFont systemFontOfSize:25];
        
        Img_drag = [[UIImageView alloc]initWithFrame:CGRectMake(mainview.frame.size.width-100, 15,50, 50)];
        [Img_drag setImage:[UIImage imageNamed:@"Img_drag"]];
        [self.contentView addSubview:mainview];
        
        [self.contentView addSubview:Lbl_playerordernumber];
        
        [self.contentView addSubview:lbl_playerName];
        
        [self.contentView addSubview:Img_drag];
        
        
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
