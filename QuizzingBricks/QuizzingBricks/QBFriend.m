//
//  QBFriend.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-14.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBFriend.h"

@implementation QBFriend

- (id)initWithUserID:(NSString *)userID email:(NSString *)email
{
    self = [super init];
    if (self) {
        // Initialization code
        self.userID = userID;
        self.email = email;
    }
    return self;
}

@end
