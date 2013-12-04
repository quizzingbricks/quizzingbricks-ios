//
//  QBCommunicationManager.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-05.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QBLobby;
@class QBGame;
@class QBQuestion;


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
- (void)inviteFriendSucceded;
- (void)inviteFriendFailed;
- (void)acceptInviteSucceeded;
- (void)acceptInviteFailed;
- (void)startGameSucceeded;
- (void)startGameFailed;

@end

@protocol QBGameComDelegate <NSObject>

- (void)games:(NSArray *)gameList;
- (void)getGamesFailed;
- (void)game:(QBGame *)g;
- (void)getGameFailed;

@end

@protocol QBPlayDelegate <NSObject>

- (void)playMoveSucceded;
- (void)playMoveFailed;

@end

@protocol QBQuestionDelegate <NSObject>

- (void)receivedQuestion:(QBQuestion *)question;
- (void)questionFailed;
- (void)answerSucceded;
- (void)answerFailed;

@end

@protocol QBFriendsComDelegate <NSObject>

- (void)returnFriends:(NSArray *)friends;
- (void)getFriendsFailed;
- (void)addFriendSucceded;
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
    id <QBPlayDelegate> _playDelegate;
    id <QBQuestionDelegate> _questionDelegate;
    id <QBFriendsComDelegate> _friendsDelegate;
    id <QBMeComDelegate> _meDelegate;
}
@property (nonatomic, strong) id registerDelegate;
@property (nonatomic, strong) id loginDelegate;
@property (nonatomic, strong) id lobbyDelegate;
@property (nonatomic, strong) id gameDelegate;
@property (nonatomic, strong) id playDelegate;
@property (nonatomic, strong) id questionDelegate;
@property (nonatomic, strong) id friendsDelegate;
@property (nonatomic, strong) id meDelegate;

- (void)registerWithEmail:(NSString *)username password:(NSString *)password;
- (void)loginWithEmail:(NSString *)username password:(NSString *)password;
- (void)getLobbiesWithToken:(NSString *)token;
- (void)createLobbyWithToken:(NSString *)token size:(int)size;
- (void)getLobbyWithToken:(NSString *)token lobbyId:(NSString *)l_id;
- (void)inviteFriendWithToken:(NSString *)token lobbyID:(NSString *)l_id friendIDs:(NSArray *)f_ids;
- (void)acceptInviteWithToken:(NSString *)token lobbyID:(NSString *)l_id;
- (void)startGameWithToken:(NSString *)token lobbyID:(NSString *)l_id;
- (void)getGamesWithToken:(NSString *)token;
- (void)getGameWithToken:(NSString *)token gameId:(NSString *)g_id;
- (void)playMoveWithToken:(NSString *)token gameID:(NSString *)g_id xCoord:(NSInteger)x yCoord:(NSInteger)y;
- (void)getQuestionWithToken:(NSString *)token gameId:(NSString *)g_id;
- (void)sendAnswerWithToken:(NSString *)token gameId:(NSString *)g_id answer:(NSInteger)answer;
- (void)getFriendsWithToken:(NSString *)token;
- (void)addFriendWithToken:(NSString *)token email:(NSString *)email;
- (void)getMeWithToken:(NSString *)token;

@end
