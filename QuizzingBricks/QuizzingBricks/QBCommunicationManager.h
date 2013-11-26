//
//  QBCommunicationManager.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-05.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QBLobby.h"
#import "QBGame.h"


@protocol QBRegisterComDelegate <NSObject>

- (void)registerSuccess;
- (void)registerFailed;

@end

@protocol QBLoginComDelegate <NSObject>

- (void)loginToken:(NSString *) token;
- (void)loginFailed;

@end

@protocol QBLobbyComDelegate <NSObject>

- (void)lobbies:(NSArray *)lobbyList;
- (void)getLobbiesFailed;
- (void)lobby:(QBLobby *)l;
- (void)getLobbyFailed;
- (void)createdLobby:(QBLobby *)l;
- (void)createLobbyFailed;

@end

@protocol QBGameComDelegate <NSObject>

- (void)games:(NSArray *)gameList;
- (void)getGamesFailed;
- (void)game:(QBGame *)g;
- (void)getGameFailed;

@end

@protocol QBFriendsComDelegate <NSObject>

- (void)returnFriends:(NSArray *)friends;
- (void)getFriendsFailed;
- (void)addFriendFailed;

@end

@protocol QBMeComDelegate <NSObject>

- (void)returnMeWithUserID:(NSString *)userID email:(NSString *) email;
- (void)getMeFailed;

@end

@interface QBCommunicationManager : NSObject

{
    id <QBLoginComDelegate> _registerDelegate;
    id <QBLoginComDelegate> _loginDelegate;
    id <QBLobbyComDelegate> _lobbyDelegate;
    id <QBGameComDelegate> _gameDelegate;
    id <QBFriendsComDelegate> _friendsDelegate;
    id <QBMeComDelegate> _meDelegate;
}
@property (nonatomic, strong) id registerDelegate;
@property (nonatomic, strong) id loginDelegate;
@property (nonatomic, strong) id lobbyDelegate;
@property (nonatomic, strong) id gameDelegate;
@property (nonatomic, strong) id friendsDelegate;
@property (nonatomic, strong) id meDelegate;

- (void)registerWithEmail:(NSString *)username password:(NSString *)password;
- (void)loginWithEmail:(NSString *)username password:(NSString *)password;
- (void)getLobbiesWithToken:(NSString *)token;
- (void)createLobbyWithToken:(NSString *)token size:(int)size;
- (void)getLobbyWithToken:(NSString *)token lobbyId:(NSString *)l_id;
- (void)getGamesWithToken:(NSString *)token;
- (void)getGameWithToken:(NSString *)token gameId:(NSString *)g_id;
- (void)getFriendsWithToken:(NSString *)token;
- (void)addFriendWithToken:(NSString *)token email:(NSString *)email;

@end
