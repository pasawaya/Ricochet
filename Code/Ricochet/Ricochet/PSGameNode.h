//
//  PSGameNode.h
//  ricochet
//
//  Created by Philippe Sawaya on 3/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, NodeType) {
    NodeTypeBumper,
    NodeTypeObstacle
};

@interface PSGameNode : SKShapeNode

@property (nonatomic, strong) SKAction *action;

+(instancetype)nodeWithType:(NodeType)t position:(CGPoint)p size:(CGSize)size action:(SKAction *)action;
-(void)beginAction;

@end
