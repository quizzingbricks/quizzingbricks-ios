//
//  QBQuestion.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-12-03.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBQuestion.h"

@implementation QBQuestion

- (id)initWithQID:(NSString *)qID question:(NSString *)question answer1:(NSString *)a1 answer2:(NSString *)a2 answer3:(NSString *)a3 answer4:(NSString *)a4
{
    self = [super init];
    if (self) {
        self.qID = qID;
        self.question = question;
        self.answer1 = a1;
        self.answer2 = a2;
        self.answer3 = a3;
        self.answer4 = a4;
    }
    return self;
}

@end
