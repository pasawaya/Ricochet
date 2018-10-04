//
//  PSUserData.h
//  ricochet
//
//  Created by Philippe Sawaya on 6/22/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSUserData : NSObject <NSCoding>

@property (nonatomic, strong) NSMutableDictionary *scores;
@property (nonatomic, assign) NSUInteger lastLevelUnlocked;

+(instancetype)sharedData;
-(void)reset;
-(void)save;

@end
