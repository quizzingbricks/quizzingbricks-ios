//
//  QBLobby.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-11.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBLobby : NSObject

@property (strong, nonatomic) NSString *lobbyID;
@property (nonatomic) NSInteger size;
@property (nonatomic) BOOL isOwner;
@property (strong, nonatomic) NSArray *players;

- (id)initWithSize:(NSInteger)size isOwner:(BOOL)isOwner players:(NSArray *)players;
- (id)initWithID: (NSString *)l_id size:(NSInteger)size isOwner:(BOOL)isOwner players:(NSArray *)players;

@end
