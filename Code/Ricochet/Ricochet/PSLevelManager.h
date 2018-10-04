//
//  PSLevelManager.h
//  ricochet
//
//  Created by Philippe Sawaya on 2/3/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSLevel;

@interface PSLevelManager : NSObject

+(PSLevel *)levelForNumber:(NSUInteger)levelNumber;
+(NSUInteger)starsForNumberOfBounces:(NSUInteger)numBounces onLevel:(NSUInteger)levelNumber;

@end
