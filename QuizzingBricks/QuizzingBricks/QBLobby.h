//
//  QBLobby.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-11.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBLobby : NSObject

@property (nonatomic) NSInteger size;
@property (nonatomic) BOOL isOwner;
@property (strong, nonatomic) NSArray *players;

- (id)initWithSize:(NSInteger)size isOwner:(BOOL)isOwner players:(NSArray *)players;

@end
