//
//  QBDataManager.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-30.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBDataManager : NSObject
+ (QBDataManager *)sharedManager;

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *u_id;

@end
