//
//  PSGameView.h
//  ricochet
//
//  Created by Philippe Sawaya on 2/16/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class PSLevel;

@interface PSGameView : SKView

-(instancetype)initWithFrame:(CGRect)frame level:(PSLevel *)level;
-(void)showLevel:(PSLevel *)level;
-(void)showNextLevel;
-(void)reshowCurrentLevel;

@end
