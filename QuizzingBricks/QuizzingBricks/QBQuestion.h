//
//  QBQuestion.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-12-03.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QBQuestion : NSObject

@property (strong, nonatomic) NSString *qID;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *answer1;
@property (strong, nonatomic) NSString *answer2;
@property (strong, nonatomic) NSString *answer3;
@property (strong, nonatomic) NSString *answer4;

- (id)initWithQID:(NSString *)qID question:(NSString *)question answer1:(NSString *)a1 answer2:(NSString *)a2 answer3:(NSString *)a3 answer4:(NSString *)a4;

@end
