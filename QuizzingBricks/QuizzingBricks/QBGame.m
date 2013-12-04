//
//  QBGame.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-19.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBGame.h"

@implementation QBGame

- (id)initWithGameID:(NSString *)gameID size:(NSInteger)size state:(NSInteger)state
{
    self = [super init];
    if (self) {
        self.gameID = gameID;
        self.size = size;
        self.state = state;
    }
    return self;
}

- (id)initWithGameID:(NSString *)gameID board:(NSArray *)board players:(NSArray *)players
{
    self = [super init];
    if (self) {
        self.yellowColor = nil;
        self.redColor = nil;
        self.greenColor = nil;
        self.blueColor = nil;
        self.gameID = gameID;
        self.board = board;
        self.players = players;
    }
    return self;
}

- (id)initWithSize:(NSInteger)size status:(NSString *)status players:(NSArray *)players
{
    self = [super init];
    if (self) {
        // Initialization code
        self.gameID = nil;
        self.size = size;
        self.status = status;
        self.players = players;
        /*
         for (int i = 0; i<8; i++) {
         [self.board replaceObjectAtIndex:i withObject:[[NSMutableArray alloc] initWithCapacity:8]];
         }*/
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
