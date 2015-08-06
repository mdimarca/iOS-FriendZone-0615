//
//  ChatWithPeopleVC.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 8/5/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ChatWithPeopleVC.h"
#import <JSQMessages.h>
#import <JSQMessagesBubbleImage.h>


@interface ChatWithPeopleVC ()

@property (strong, nonatomic) JSQMessagesBubbleImage *bubbleImageOutgoing;
@property (strong, nonatomic) JSQMessagesBubbleImage *bubbleImageIncoming;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *messages;

@end

@implementation ChatWithPeopleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.senderId = @"test";
    self.senderDisplayName = @"test2";
    
    self.title = @"test3";
    
    
        JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
        self.bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor blueColor]];
        self.bubbleImageIncoming = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor lightGrayColor]];

    
    
    NSLog(@"Doing what we want?");
    // Do any additional setup after loading the view.'
    

}


//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    return _messages[indexPath.item];
//}
//
////-------------------------------------------------------------------------------------------------------------------------------------------------
//- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
//             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    
//
//}
//
////-------------------------------------------------------------------------------------------------------------------------------------------------
//- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
//                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    JSQMessage *message = messages[indexPath.item];
//    if (avatars[message.senderId] == nil)
//    {
//        [self loadAvatar:message.senderId];
//        return avatarImageBlank;
//    }
//    else return avatars[message.senderId];
//}
//
////-------------------------------------------------------------------------------------------------------------------------------------------------
//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    if (indexPath.item % 3 == 0)
//    {
//        JSQMessage *message = messages[indexPath.item];
//        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
//    }
//    else return nil;
//}
//
////-------------------------------------------------------------------------------------------------------------------------------------------------
//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    JSQMessage *message = messages[indexPath.item];
//    if ([self incoming:message])
//    {
//        if (indexPath.item > 0)
//        {
//            JSQMessage *previous = messages[indexPath.item-1];
//            if ([previous.senderId isEqualToString:message.senderId])
//            {
//                return nil;
//            }
//        }
//        return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
//    }
//    else return nil;
//}
//
////-------------------------------------------------------------------------------------------------------------------------------------------------
//- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
////-------------------------------------------------------------------------------------------------------------------------------------------------
//{
//    if ([self outgoing:messages[indexPath.item]])
//    {
//        NSDictionary *item = items[indexPath.item];
//        return [[NSAttributedString alloc] initWithString:item[@"status"]];
//    }
//    else return nil;
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
