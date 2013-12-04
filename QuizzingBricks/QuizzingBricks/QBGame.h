//
//  QBGame.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-19.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBGamer;

@interface QBGame : NSObject

@property (strong, nonatomic) NSString *gameID;
@property (nonatomic) NSInteger size;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSArray *board;

@property (strong, nonatomic) QBGamer *redColor;
@property (strong, nonatomic) QBGamer *yellowColor;
@property (strong, nonatomic) QBGamer *greenColor;
@property (strong, nonatomic) QBGamer *blueColor;

- (id)initWithGameID:(NSString *)gameID board:(NSArray *)board players:(NSArray *)players;
- (id)initWithSize:(NSInteger)size status:(NSString *)status players:(NSArray *)players;
- (id)initWithSize:(NSInteger)size gameID:(NSString *)gameID status:(NSString *)status;

@end
