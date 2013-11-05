//
//  QBDataManager.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-30.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBDataManager.h"

@implementation QBDataManager

static QBDataManager *dataManager;

+ (QBDataManager *)sharedManager
{
    if (!dataManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            dataManager = [[QBDataManager alloc] init];
        });
        
    }
    
    return dataManager;
}

@end
