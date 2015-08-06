//
//  Chat.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/5/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#define firebaseConstant @"https://icebreakerchat.firebaseio.com"


#import "Chat.h"
#import <Firebase/Firebase.h>
#import <Parse/Parse.h>

#import "DataStore.h"


@interface Chat() <JSQMessagesCollectionViewDataSource, JSQMessagesCollectionViewDelegateFlowLayout>

//@property (nonatomic, strong) NSString *groupId;
//
//@property (nonatomic) BOOL initialized;
//@property (nonatomic) NSUInteger typingCounter;
//
//@property (nonatomic, strong) Firebase *firebase1;
//@property (nonatomic, strong) Firebase *firebase2;
//
//@property (nonatomic, strong) NSMutableArray *items;
//
//@property (nonatomic, strong) NSDictionary *started;
//@property (nonatomic, strong) NSDictionary *avatars;
//
//@property (nonatomic, strong) JSQMessagesAvatarImage *avatarImageBlank;



@property (nonatomic, strong) JSQMessagesBubbleImage *bubbleImageOutgoing;
@property (nonatomic, strong) JSQMessagesBubbleImage *bubbleImageIncoming;
@property (nonatomic, strong) NSMutableArray *messages;


@end

@implementation Chat





//-(instancetype) initWith:(NSString *)groupId{
//    self = [super init];
//    _groupId = groupId;
//    return self;
//}
//
//
//-(void) viewDidLoad {
//    
//    [super viewDidLoad];
//    self.title = @"Chat";
//    
//    self.items = [[NSMutableArray alloc] init];
//    self.messages = [[NSMutableArray alloc] init];
//    self.started = [[NSMutableDictionary alloc] init];
//    self.avatars = [[NSMutableDictionary alloc] init];
//    
//    PFUser *user = [PFUser currentUser];
//    self.senderId = user.objectId;
//    self.senderDisplayName = user[@"first_name"];
//    
//    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
//    self.bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor blueColor]];
//    self.bubbleImageIncoming = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor lightGrayColor]];
//
//    
//    DataStore *dataStore = [DataStore sharedDataStore];
//    self.avatarImageBlank = [JSQMessagesAvatarImageFactory avatarImageWithImage:dataStore.user.profilePhoto diameter:30.0];
//    
//    
//    self.firebase1 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Message/%@", firebaseConstant, self.groupId]];
//    self.firebase2 = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Typing/%@", firebaseConstant, self.groupId]];
//
////    [self loadMessages];
//}
//
//- (void) viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//    self.collectionView.collectionViewLayout.springinessEnabled = NO;
//}
//
//- (void) viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:YES];
//    
//    if (self.isMovingFromParentViewController) {
//        NSLog (@"isMovingFromParentViewController is being called!");
//    }
//}





// RECENT //


































@end
