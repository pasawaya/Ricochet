//
//  PSPuck.m
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSPuck.h"
#import "Constants.h"

@implementation PSPuck

+(instancetype)puckWithPosition:(CGPoint)pos size:(CGSize)size {
    PSPuck *puck = [super shapeNodeWithCircleOfRadius:size.width/2];
    puck.position = pos;
    
    //Appearance
    puck.fillColor = [SKColor blackColor];
    puck.strokeColor = [SKColor whiteColor];
    puck.lineWidth = kStrokeWidth;
    
    //Physics Body
    puck.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(size.width+kStrokeWidth)/2];
    puck.physicsBody.friction = 0;
    puck.physicsBody.affectedByGravity = NO;
    puck.physicsBody.dynamic = YES;
    puck.physicsBody.restitution = 1;
    puck.physicsBody.linearDamping = 0;
    puck.physicsBody.angularDamping = 0;
    puck.physicsBody.categoryBitMask = ColliderTypePuck;
    puck.physicsBody.collisionBitMask = ColliderTypeBumper | ColliderTypeWall;
    puck.physicsBody.contactTestBitMask = ColliderTypeObstacle | ColliderTypeBumper | ColliderTypeWall;
    
    return puck;
}

@end
