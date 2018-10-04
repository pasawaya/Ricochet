//
//  PSGameNode.m
//  ricochet
//
//  Created by Philippe Sawaya on 3/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSGameNode.h"
#import "Constants.h"

@interface PSGameNode ()

@property (nonatomic, assign) NodeType type;

@end

@implementation PSGameNode

+(instancetype)nodeWithType:(NodeType)t position:(CGPoint)p size:(CGSize)size action:(SKAction *)action {
    CGRect frame = CGRectMake(0,
                              0,
                              size.width-kStrokeWidth, size.height-kStrokeWidth);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:8];
    PSGameNode *node = [super shapeNodeWithPath:path.CGPath centered:YES];
    node.action = action;
    node.position = CGPointMake(p.x, p.y);
    
    //Appearance
    node.fillColor = [SKColor blackColor];
    node.lineWidth = kStrokeWidth;
    node.strokeColor = (t == NodeTypeBumper) ? [Constants bumperColor] : [Constants obstacleColor];
    
    //Physics Body
    frame.size = size;
    CGRect physicsFrame = CGRectMake(-size.width/2, -size.height/2, size.width, size.height);
    node.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:physicsFrame];
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.friction = 0;
    node.physicsBody.dynamic = NO;
    node.physicsBody.restitution = 1.0;
    node.physicsBody.linearDamping = 0.0;
    node.physicsBody.angularDamping = 0.0;
    
    if(t == NodeTypeBumper) {
        node.physicsBody.categoryBitMask = ColliderTypeBumper;
        node.physicsBody.collisionBitMask = ColliderTypePuck;
        node.physicsBody.contactTestBitMask = ColliderTypePuck;
    }
    else if(t == NodeTypeObstacle) {
        node.physicsBody.categoryBitMask = ColliderTypeObstacle;
        node.physicsBody.contactTestBitMask = ColliderTypePuck;
    }
    
    return node;
}

-(void)beginAction {
    [self runAction:self.action];
}

@end
