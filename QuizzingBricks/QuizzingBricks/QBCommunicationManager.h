//
//  QBCommunicationManager.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-05.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QBCommunicationDelegate <NSObject>

- (void)loginToken:(NSString *) token;
- (void)loginFailed;

@end

@interface QBCommunicationManager : NSObject

{
    id <QBCommunicationDelegate> _delegate;
}
@property (nonatomic, strong) id delegate;

- (void)loginWithEmail:(NSString *)username password:(NSString *)password;

@end
