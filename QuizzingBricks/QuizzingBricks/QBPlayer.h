//
//  QBPlayer.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-12.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBPlayer : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *status;

- (id)initWithUserID:(NSString *)userID email:(NSString *)email status:(NSString *)status;

@end
