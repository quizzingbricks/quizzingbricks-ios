//
//  QBPlayer.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-12.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBPlayer.h"

@implementation QBPlayer

- (id)initWithUserID:(NSString *)userID email:(NSString *)email status:(NSString *)status
{
    self = [super init];
    if (self) {
        // Initialization code
        self.userID = userID;
        self.email = email;
        self.status = status;
    }
    return self;
}

@end
