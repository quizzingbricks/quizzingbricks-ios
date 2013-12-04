//
//  QBGamer.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-12-03.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBGamer : NSObject

@property (strong, nonatomic) NSString *userID;
@property (nonatomic) BOOL answeredCorrectly;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger state;
@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

- (id)initWithUserID:(NSString *)userID score:(NSInteger)score state:(NSInteger)state x:(NSInteger)x y:(NSInteger)y correct:(BOOL)correct;

@end
