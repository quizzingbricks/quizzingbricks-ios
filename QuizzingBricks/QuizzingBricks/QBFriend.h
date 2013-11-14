//
//  QBFriend.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-14.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBFriend : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *email;

- (id)initWithUserID:(NSString *)userID email:(NSString *)email;

@end
