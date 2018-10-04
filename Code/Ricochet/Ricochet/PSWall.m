//
//  PSWall.m
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSWall.h"
#import "Constants.h"

@implementation PSWall

+(instancetype)wallWithPosition:(CGPoint)pos size:(CGSize)size {
    PSWall *wall = [super spriteNodeWithColor:[Constants blue] size:size];
    wall.position = pos;
    
    //Physics
    CGRect frame = CGRectMake(pos.x-size.width/2,
                              pos.y-size.height/2,
                              size.width, size.height);
    
    wall.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
    wall.physicsBody.affectedByGravity = NO;
    wall.physicsBody.friction = 0;
    wall.physicsBody.dynamic = NO;
    wall.physicsBody.restitution = 1;
    wall.physicsBody.linearDamping = 0;
    wall.physicsBody.angularDamping = 0;
    wall.physicsBody.categoryBitMask = ColliderTypeWall;
    wall.physicsBody.collisionBitMask = ColliderTypePuck;
    wall.physicsBody.contactTestBitMask = ColliderTypePuck;
    
    return wall;
}

@end
