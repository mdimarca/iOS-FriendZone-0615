//
//  MessagingViewController.m
//  Icebreaker
//
//  Created by Gan Chau on 8/6/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "MessagingViewController.h"
#import <JSQMessages.h>
#import <JSQMessagesBubbleImageFactory.h>
#import <Firebase/Firebase.h>
#import <Parse/Parse.h>
#import "DataStore.h"
#import "MatchedUserViewController.h"

NSString *const FIREBASE_CHAT_URL = @"https://ice-breaker-ios.firebaseIO.com";

@interface MessagingViewController ()

@property (strong, nonatomic) JSQMessagesBubbleImage *bubbleImageOutgoing;
@property (strong, nonatomic) JSQMessagesBubbleImage *bubbleImageIncoming;
@property (strong, nonatomic) JSQMessagesAvatarImage *avatar;
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) Firebase *firebase;

@end

@implementation MessagingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUp];
}

- (void)setUp
{
    self.firebase = [[Firebase alloc] initWithUrl:FIREBASE_CHAT_URL];
    
    DataStore *dataStore = [DataStore sharedDataStore];
    
    /**
     *  Override point for customization.
     *
     *  Customize your view.
     *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
     *
     *  Customize your layout.
     *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
     */
    
    self.title = dataStore.user.firstName;
    self.senderId = dataStore.user.facebookID;//[PFUser currentUser][@"facebookId"];
    self.senderDisplayName = dataStore.user.firstName;//[PFUser currentUser][@"first_name"];
    
    self.messages = [@[] mutableCopy];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.bubbleImageOutgoing = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.bubbleImageIncoming = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
//    JSQMessagesAvatarImage *myImage = [JSQMessagesAvatarImageFactory avatarImageWithImage:dataStore.user.profilePhoto
//                                                                                   diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    
//    self.avatars = @{ myAvatar : myImage,
//                      otherAvatar : otherImage };
    
    self.avatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:dataStore.user.profilePhoto
                                                             diameter:30];
    self.inputToolbar.contentView.leftBarButtonItem = nil; /* custom button or nil to remove */
    self.showLoadEarlierMessagesHeader = NO;
    
    /**
     *  Register custom menu actions for cells.
     */
//    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
//    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    
    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
    
    // Sets new message location
    BOOL newMessagesOnTop = NO;
    
    // This allows us to check if there were messages stored on the server when we booted up (YES) or if they are new messages since we've started the app.
    // This is so we can batch together the initial messages' reloadData for a pref gain.
    __block BOOL initialAdds = YES;
    
    [[self.firebase childByAppendingPath:@"123456"] observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        NSLog(@"snapshot: %@", snapshot.value);
        
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:snapshot.value[@"senderID"]
                                                 senderDisplayName:snapshot.value[@"name"]
                                                              date:[NSDate date]
                                                              text:snapshot.value[@"text"]];
        
        if (newMessagesOnTop){
            [self.messages insertObject:message atIndex:0];
        } else {
            [self.messages addObject:message];
        }
        
        // Reload the tableview
        if (!initialAdds) {
            [self.collectionView reloadData];
        }
        NSLog(@"%@", snapshot.value);
    }];
    
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.collectionView reloadData];
        initialAdds = NO;
    }];
}

//+ (void)createGameOnFirebaseWithRef:(Firebase *)ref
//                               user:(SBUser *)user
//                withCompletionBlock:(void (^)(BOOL success, NSString *digits))block
//                   withFailureBlock:(void (^)(NSError *error))failureBlock {
//    NSString *randomNumber = [SBConstants randomRoomNumber];
//    [ref runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
//        NSArray *newRoom = @[ @{ @"name": user.name,
//                                 @"monster": user.monster,
//                                 @"hp": user.hp,
//                                 @"vp": user.vp } ];
//        [[currentData childDataByAppendingPath:randomNumber] setValue:newRoom];
//        
//        return [FTransactionResult successWithValue:currentData];
//    } andCompletionBlock:^(NSError *error, BOOL committed, FDataSnapshot *snapshot) {
//        if (committed) {
//            block(YES, randomNumber);
//        } else {
//            failureBlock(error);
//        }
//    }];
//}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    //[JSQSystemSoundPlayer jsq_playMessageSentSound];
    
//    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
//                                             senderDisplayName:senderDisplayName
//                                                          date:date
//                                                          text:text];
    
    NSDictionary *newMessage = @{ @"name" : senderDisplayName,
                                  @"text" : text,
                                  @"senderID" : senderId };
    
    [[[self.firebase childByAppendingPath:@"123456"] childByAutoId] setValue:newMessage];
    //    [self.messages addObject:message];
    
    [self finishSendingMessageAnimated:YES];
}

//- (void)didPressAccessoryButton:(UIButton *)sender
//{
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
//                                                       delegate:self
//                                              cancelButtonTitle:@"Cancel"
//                                         destructiveButtonTitle:nil
//                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
//    
//    [sheet showFromToolbar:self.inputToolbar];
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == actionSheet.cancelButtonIndex) {
//        return;
//    }
//    
//    switch (buttonIndex) {
//        case 0:
//            //[self.demoData addPhotoMediaMessage];
//            break;
//            
//        case 1:
//        {
//            //__weak UICollectionView *weakView = self.collectionView;
//            
//            //[self.demoData addLocationMediaMessageCompletion:^{
//            //    [weakView reloadData];
//            //}];
//        }
//            break;
//            
//        case 2:
//            //[self.demoData addVideoMediaMessage];
//            break;
//    }
//    
//    [JSQSystemSoundPlayer jsq_playMessageSentSound];
//    
//    [self finishSendingMessageAnimated:YES];
//}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView
       messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        NSLog(@"returning bubble image outgoing");
        
        return self.bubbleImageOutgoing;
    }
    return self.bubbleImageIncoming;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
//    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
//    if ([message.senderId isEqualToString:self.senderId]) {
//        if (![NSUserDefaults outgoingAvatarSetting]) {
//            return nil;
//        }
//    }
//    else {
//        if (![NSUserDefaults incomingAvatarSetting]) {
//            return nil;
//        }
//    }
//    
//    
    return self.avatar;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView
  attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView
  attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView
  attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.messages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if (!message.isMediaMessage) {
        if ([message.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor whiteColor];
        } else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate
#pragma mark - Custom menu items

//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action
//    forItemAtIndexPath:(NSIndexPath *)indexPath
//            withSender:(id)sender
//{
//    if (action == @selector(customAction:)) {
//        return YES;
//    }
//    
//    return [super collectionView:collectionView
//                canPerformAction:action
//              forItemAtIndexPath:indexPath
//                      withSender:sender];
//}
//
//- (void)collectionView:(UICollectionView *)collectionView
//         performAction:(SEL)action
//    forItemAtIndexPath:(NSIndexPath *)indexPath
//            withSender:(id)sender
//{
//    if (action == @selector(customAction:)) {
//        [self customAction:sender];
//        return;
//    }
//    
//    [super collectionView:collectionView
//            performAction:action
//       forItemAtIndexPath:indexPath
//               withSender:sender];
//}
//
//- (void)customAction:(id)sender
//{
//    NSLog(@"Custom action received! Sender: %@", sender);
//    
//    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
//                                message:nil
//                               delegate:nil
//                      cancelButtonTitle:@"OK"
//                      otherButtonTitles:nil]
//     show];
//}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout
  heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
