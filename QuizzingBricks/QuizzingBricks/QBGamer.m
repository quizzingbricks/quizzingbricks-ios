//
//  QBGamer.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-12-03.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBGamer.h"

@implementation QBGamer

- (id)initWithUserID:(NSString *)userID email:(NSString *)email score:(NSInteger)score state:(NSInteger)state x:(NSInteger)x y:(NSInteger)y correct:(BOOL)correct
{
    self = [super init];
    if (self) {
        // Initialization code
        self.userID = userID;
        self.email = email;
        self.score = score;
        self.state = state;
        self.x = x;
        self.y = y;
        self.answeredCorrectly = correct;
    }
    return self;
}

@end
