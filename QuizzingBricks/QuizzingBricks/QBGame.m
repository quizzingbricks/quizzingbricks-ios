//
//  QBGame.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-19.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBGame.h"

@implementation QBGame

- (id)initWithSize:(NSInteger)size status:(NSString *)status players:(NSArray *)players
{
    self = [super init];
    if (self) {
        // Initialization code
        self.gameID = nil;
        self.size = size;
        self.status = status;
        self.players = players;
    }
    return self;
}

- (id)initWithSize:(NSInteger)size gameID:(NSString *)gameID status:(NSString *)status
{
    self = [super init];
    if (self) {
        // Initialization code
        self.gameID = gameID;
        self.size = size;
        self.status = status;
        self.players = [[NSArray alloc] init];
    }
    return self;
}

@end
