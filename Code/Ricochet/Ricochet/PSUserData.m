//
//  PSUserData.m
//  ricochet
//
//  Created by Philippe Sawaya on 6/22/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSUserData.h"
#import "Constants.h"
#import "PSLevelManager.h"

@implementation PSUserData

+(instancetype)sharedData {
    static PSUserData *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [PSUserData loadInstance];
    });
    
    return sharedInstance;
}

+(instancetype)loadInstance {
    PSUserData *gameData;
    
    NSData* decodedData = [NSData dataWithContentsOfFile:[PSUserData dataFilePath]];
    if(decodedData) {
        gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
    }
    else {
        gameData = [[PSUserData alloc] init];
        [gameData reset];
    }
    
    return gameData;
}

-(instancetype)initWithCoder:(NSCoder *)decoder {
    if(self = [self init]) {
        _scores = [decoder decodeObjectForKey:kUserDataScoresKey];
        _lastLevelUnlocked = [decoder decodeIntegerForKey:kUserDataLastLevelUnlockedKey];
    }
    
    return self;
}

-(void)reset {
    if(self.scores) {
        [self.scores removeAllObjects];
    }
    else {
        self.scores = [NSMutableDictionary dictionary];
    }
    
    for(int i = 1; i <= kLevelsNumLevels; i++) {
        [self.scores setObject:@(-1) forKey:@(i)];
    }
    
    self.lastLevelUnlocked = 1;
}

-(void)save {
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    [encodedData writeToFile:[PSUserData dataFilePath] atomically:YES];
}

#pragma mark - Utilities
+(NSString *)dataFilePath {
    static NSString *filepath = nil;
    if(!filepath) {
        filepath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"game_data"];
    }
    
    return filepath;
}

#pragma mark - NSCoding Protocol
-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.scores forKey:kUserDataScoresKey];
    [encoder encodeInteger:self.lastLevelUnlocked forKey:kUserDataLastLevelUnlockedKey];
}

@end
