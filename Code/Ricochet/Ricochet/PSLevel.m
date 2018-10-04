//
//  PSLevel.m
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSLevel.h"
#import "PSLevelManager.h"
#import "Constants.h"

#import "PSGameNode.h"

@implementation PSLevel

+(instancetype)levelFromText:(NSString *)text {
    int w = [Constants width],  //For brevity
        h = [Constants height];
    
    PSLevel *level = [[PSLevel alloc] init];
    level.components = [NSMutableArray array];
    
    NSArray *lines = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for(int i = 1; i < lines.count; i++) {
        NSArray *componentFields = [lines[i] componentsSeparatedByString:@";"];
        
        //Get Type
        NSString *typeString = componentFields[0];
        NodeType type = ([typeString isEqualToString:kBumperKey]) ? NodeTypeBumper : NodeTypeObstacle;
        
        //Get Position
        NSUInteger positionIndex = 1;
        if([typeString isEqualToString:kMultipleMovingBumperKey] ||
           [typeString isEqualToString:kMultipleMovingObstacleKey] ||
           [typeString isEqualToString:kExternallyRotatingBumperKey] ||
           [typeString isEqualToString:kExternallyRotatingObstacleKey]) {
            positionIndex = 2;
        }
        else if([typeString isEqualToString:kMovingDiagonalBumperKey] ||
                [typeString isEqualToString:kMovingDiagonalObstacleKey] ||
                [typeString isEqualToString:kRotatingMovingBumperKey] ||
                [typeString isEqualToString:kRotatingMovingObstacleKey]) {
            positionIndex = 3;
        }
        
        NSArray *positionComponents = [componentFields[positionIndex] componentsSeparatedByString:@","];
        CGPoint position = CGPointMake([positionComponents[0] floatValue] * w,
                                       h - [positionComponents[1] floatValue] * h);
        
        //Get Size
        NSUInteger sizeIndex = 2;
        if([typeString isEqualToString:kMovingBumperKey] ||
           [typeString isEqualToString:kMovingObstacleKey]) {
            sizeIndex = 3;
        }
        if([typeString isEqualToString:kMultipleMovingBumperKey] ||
           [typeString isEqualToString:kMultipleMovingObstacleKey] ||
           [typeString isEqualToString:kExternallyRotatingBumperKey] ||
           [typeString isEqualToString:kExternallyRotatingObstacleKey] ||
           [typeString isEqualToString:kMovingDiagonalObstacleKey] ||
           [typeString isEqualToString:kMovingDiagonalBumperKey] ||
           [typeString isEqualToString:kRotatingMovingBumperKey] ||
           [typeString isEqualToString:kRotatingMovingObstacleKey]) {
            sizeIndex = 1;
        }
        NSArray *sizeComponents = [componentFields[sizeIndex] componentsSeparatedByString:@","];
        CGSize size = CGSizeMake([sizeComponents[0] floatValue] * w, [sizeComponents[1] floatValue] * h);
        
        //Get Actions
        SKAction *action = nil;
        if([typeString isEqualToString:kMovingBumperKey] ||
           [typeString isEqualToString:kMovingObstacleKey]) {
            type = ([typeString isEqualToString:kMovingBumperKey]) ? NodeTypeBumper : NodeTypeObstacle;
            
            //Get p1, p2, and delta between them
            NSArray *destination = [componentFields[2] componentsSeparatedByString:@","];
            CGPoint p2 = CGPointMake(w * [destination[0] floatValue], h - h * [destination[1] floatValue]);
            
            CGFloat dx = p2.x-position.x,
                    dy = p2.y-position.y;
            
            //Create indefinite translation between p1 and p2
            NSTimeInterval duration = [componentFields[4] floatValue];
            SKAction *toAction = [SKAction moveBy:CGVectorMake(dx, dy) duration:duration],
                     *fromAction = [SKAction moveBy:CGVectorMake(-dx, -dy) duration:duration];
            action = [SKAction repeatActionForever:[SKAction sequence:@[toAction, fromAction]]];
        }
        
        if([typeString isEqualToString:kMultipleMovingBumperKey] ||
           [typeString isEqualToString:kMultipleMovingObstacleKey]) {
            type = ([typeString isEqualToString:kMultipleMovingBumperKey]) ? NodeTypeBumper : NodeTypeObstacle;
            
            int pointsStartIndex = 2;
            int pointsEndIndex = (int)componentFields.count - 3;
            
            NSTimeInterval duration = [componentFields[componentFields.count-2] doubleValue];
            NSMutableArray *forwardActions = [NSMutableArray array];
            
            //Get forward actions
            for(int i = pointsStartIndex+1; i <= pointsEndIndex; i++) {
                NSArray *p2Fields = [componentFields[i] componentsSeparatedByString:@","],
                        *p1Fields = [componentFields[i-1] componentsSeparatedByString:@","];
                
                CGPoint p2 = CGPointMake(w * [p2Fields[0] floatValue], h - h * [p2Fields[1] floatValue]);
                CGPoint p1 = CGPointMake(w * [p1Fields[0] floatValue], h - h * [p1Fields[1] floatValue]);
                
                CGFloat dx = p2.x-p1.x,
                        dy = p2.y-p1.y;
                
                [forwardActions addObject:[SKAction moveBy:CGVectorMake(dx, dy) duration:duration]];
            }
            
            SKAction *forwardSequence = [SKAction sequence:forwardActions];
            
            BOOL reverses = [componentFields[componentFields.count-1] isEqualToString:@"YES"];
            if(reverses) {
                SKAction *reverseSequence = [forwardSequence reversedAction];
                action = [SKAction repeatActionForever:[SKAction sequence:@[forwardSequence, reverseSequence]]];
            }
            else {
                NSArray *p1Field = [componentFields[pointsStartIndex] componentsSeparatedByString:@","],
                        *pNField = [componentFields[pointsEndIndex] componentsSeparatedByString:@","];
                
                CGPoint pN = CGPointMake(w * [pNField[0] floatValue], h - h * [pNField[1] floatValue]);
                CGPoint p1 = CGPointMake(w * [p1Field[0] floatValue], h - h * [p1Field[1] floatValue]);
                
                CGFloat dx = p1.x-pN.x,
                        dy = p1.y-pN.y;
                
                SKAction *returnToStart = [SKAction moveBy:CGVectorMake(dx, dy) duration:duration];
                action = [SKAction repeatActionForever:[SKAction sequence:@[forwardSequence, returnToStart]]];
            }
        }
        
        if([typeString isEqualToString:kRotatingBumperKey] ||
           [typeString isEqualToString:kRotatingObstacleKey]) {
            type = ([typeString isEqualToString:kRotatingBumperKey]) ? NodeTypeBumper : NodeTypeObstacle;
            
            NSInteger directionMultiplier = -1;
            if(componentFields.count == 5 && [componentFields[4] isEqualToString:@"cc"]) {
                directionMultiplier = 1;
            }
            
            NSTimeInterval duration = [componentFields[3] floatValue];
            action = [SKAction repeatActionForever:[SKAction rotateByAngle:2*M_PI*directionMultiplier duration:duration]];
        }
        
        if([typeString isEqualToString:kDiagonalBumperKey] ||
           [typeString isEqualToString:kDiagonalObstacleKey]) {
            type = ([typeString isEqualToString:kDiagonalBumperKey]) ? NodeTypeBumper : NodeTypeObstacle;
            
            CGFloat angle = [componentFields[3] floatValue] * (M_PI/180.);
            action = [SKAction rotateToAngle:angle duration:0];
        }
        
        if([typeString isEqualToString:kRotatingMovingBumperKey] ||
           [typeString isEqualToString:kRotatingMovingObstacleKey]) {
            type = ([typeString isEqualToString:kRotatingMovingBumperKey]) ? NodeTypeBumper : NodeTypeObstacle;
            
            //Rotation
            NSInteger directionMultiplier = -1;
            if(componentFields.count == 7 && [componentFields[6] isEqualToString:@"cc"]) {
                directionMultiplier = 1;
            }
            
            NSTimeInterval rotationDuration = [componentFields[2] floatValue];
            SKAction *rotationAction = [SKAction repeatActionForever:[SKAction rotateByAngle:2*M_PI*directionMultiplier
                                                                                    duration:rotationDuration]];
            //Movement
            NSArray *destination = [componentFields[4] componentsSeparatedByString:@","];
            CGPoint p2 = CGPointMake(w * [destination[0] floatValue], h - h * [destination[1] floatValue]);
            
            CGFloat dx = p2.x-position.x,
                    dy = p2.y-position.y;
            
            NSTimeInterval duration = [componentFields[5] floatValue];
            SKAction *toAction = [SKAction moveBy:CGVectorMake(dx, dy) duration:duration],
                     *fromAction = [SKAction moveBy:CGVectorMake(-dx, -dy) duration:duration];
            SKAction *movementAction = [SKAction repeatActionForever:[SKAction sequence:@[toAction, fromAction]]];
            
            //Combined
            action = [SKAction group:@[rotationAction, movementAction]];
        }
        
        if([typeString isEqualToString:kMovingDiagonalBumperKey] ||
           [typeString isEqualToString:kMovingDiagonalObstacleKey]) {
            type = ([typeString isEqualToString:kMovingDiagonalBumperKey]) ? NodeTypeBumper : NodeTypeObstacle;
            
            CGFloat angle = [componentFields[2] floatValue] * (M_PI/180.);
            SKAction *rotation = [SKAction rotateToAngle:angle duration:0];
            
            //Get p1, p2, and delta between them
            NSArray *destination = [componentFields[4] componentsSeparatedByString:@","];
            CGPoint p2 = CGPointMake(w * [destination[0] floatValue], h - h * [destination[1] floatValue]);
            
            CGFloat dx = p2.x-position.x,
                    dy = p2.y-position.y;
            
            //Create indefinite translation between p1 and p2
            NSTimeInterval duration = [componentFields[5] floatValue];
            SKAction *toAction = [SKAction moveBy:CGVectorMake(dx, dy) duration:duration],
                     *fromAction = [SKAction moveBy:CGVectorMake(-dx, -dy) duration:duration];
            SKAction *foreverAction = [SKAction repeatActionForever:[SKAction sequence:@[toAction,fromAction]]];
            
            action = [SKAction sequence:@[rotation, foreverAction]];
        }
        
        if([typeString isEqualToString:kExternallyRotatingBumperKey] ||
           [typeString isEqualToString:kExternallyRotatingObstacleKey]) {
            type = ([typeString isEqualToString:kExternallyRotatingBumperKey]) ? NodeTypeBumper : NodeTypeObstacle;
            
            NSTimeInterval duration = [componentFields[4] floatValue];
            CGFloat radius = [componentFields[3] floatValue]*w;
            
            NSInteger directionMultiplier = -1;
            if(componentFields.count == 6 && [componentFields[5] isEqualToString:@"cc"]) {
                directionMultiplier = 1;
            }
            
            SKNode *centerNode = [[SKNode alloc] init];
            centerNode.position = position;
            [centerNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:2*M_PI*directionMultiplier
                                                                               duration:duration]]];
            
            CGPoint gameNodePosition = CGPointMake(radius, 0);
            PSGameNode *node = [PSGameNode nodeWithType:type position:gameNodePosition size:size action:nil];
            [centerNode addChild:node];
            [level.components addObject:centerNode];
        }
        else {
            PSGameNode *node = [PSGameNode nodeWithType:type position:position size:size action:action];
            [level.components addObject:node];
        }
    }
    
    level.levelNumber = [lines[0] integerValue];
    
    return level;
}

-(void)reset {
    PSLevel *originalLevel = [PSLevelManager levelForNumber:self.levelNumber];
    self.components = originalLevel.components;
}

@end
