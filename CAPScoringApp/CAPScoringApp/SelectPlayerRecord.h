//
//  SelectPlayerRecord.h
//  CAPScoringApp
//
//  Created by APPLE on 26/05/16.
//  Copyright © 2016 agaram. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectPlayerRecord : NSObject

@property(strong,nonatomic)NSString *playerName;
@property(strong,nonatomic)NSString *playerCode;
@property(strong,nonatomic)NSNumber *isSelected;
@property(nonatomic,strong)NSString *isSelectCapten;
@property(nonatomic,strong)NSString *isSelectWKTKeeper;
@property(nonatomic,strong)NSString *playerOrder;
@property(nonatomic,strong)NSString *battingStyle;
@end
