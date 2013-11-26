//
//  QBLobby.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-11.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBLobby.h"

@implementation QBLobby

- (id)initWithSize:(NSInteger)size isOwner:(BOOL)isOwner players:(NSArray *)players
{
    self = [super init];
    if (self) {
        // Initialization code
        self.lobbyID = nil;
        self.size = size;
        self.isOwner = isOwner;
        self.players = players;
    }
    return self;
}

- (id)initWithID: (NSString *)l_id size:(NSInteger)size isOwner:(BOOL)isOwner players:(NSArray *)players
{
    self = [super init];
    if (self) {
        // Initialization code
        self.lobbyID = l_id;
        self.size = size;
        self.isOwner = isOwner;
        self.players = players;
    }
    return self;
}

@end
