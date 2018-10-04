//
//  PSLevel.h
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LevelStatus) {
    LevelStatusCompleted = 0,
    LevelStatusNew = 1,
    LevelStatusLocked = 2
};

@interface PSLevel : NSObject

@property (nonatomic, strong) NSMutableArray *components; //Bumpers, Obstacles, etc.
@property (nonatomic, assign) NSUInteger levelNumber;
@property (nonatomic, assign) LevelStatus status;
@property (nonatomic, assign) NSUInteger starsEarned;

+(instancetype)levelFromText:(NSString *)text;
-(void)reset;

@end
