//
//  PSGameScene.h
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class PSLevel;

@interface PSGameScene : SKScene <SKPhysicsContactDelegate>

-(instancetype)initWithSize:(CGSize)size level:(PSLevel *)level;
-(void)resetForLevel:(PSLevel *)level;
-(void)pause;

@end
