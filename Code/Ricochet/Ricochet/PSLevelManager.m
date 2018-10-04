//
//  PSLevelManager.m
//  ricochet
//
//  Created by Philippe Sawaya on 2/3/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSLevelManager.h"
#import "PSLevel.h"
#import "PSGameNode.h"

@implementation PSLevelManager

+(PSLevel *)levelForNumber:(NSUInteger)levelNumber {
    
    //Get raw text
    NSString *levels = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"levels" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [levels componentsSeparatedByString:@"\n"];

    //Identify line number of chosen level
    int idx = -1;
    for(int i = 0; i < lines.count; i++) {
        if([lines[i] integerValue] == levelNumber) {
            idx = i;
        }
    }
    
    //Get text of chosen level
    NSString *levelText = @"";
    BOOL levelIsComplete = NO;
    while (!levelIsComplete) {
        levelText = [levelText stringByAppendingFormat:@"%@", lines[idx]];
        if([lines[++idx] length] == 0) {
            levelIsComplete = YES;
            break;
        }
        else {
            levelText = [levelText stringByAppendingFormat:@"\n"];
        }
    }
    
    return [PSLevel levelFromText:levelText];
}

+(NSUInteger)starsForNumberOfBounces:(NSUInteger)numBounces onLevel:(NSUInteger)levelNumber {
    
#warning So Julian can run
    return arc4random_uniform(2)+1;

    //Get raw text
    NSString *rawText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stars" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [rawText componentsSeparatedByString:@"\n"];
    
    //Identify line number of chosen level
    int idx = -1;
    for(int i = 0; i < lines.count; i++) {
        if([lines[i] integerValue] == levelNumber) {
            idx = i;
            break;
        }
    }

    //Get text of chosen level
    NSArray *components = [lines[idx+1] componentsSeparatedByString:@","];
    if      (numBounces <= [components[0] integerValue]) return 3;
    else if (numBounces <= [components[1] integerValue]) return 2;
    else                                                 return 1;
}

@end
