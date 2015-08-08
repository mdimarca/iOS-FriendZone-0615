//
//  ViewController.m
//  Icebreaker
//
//  Created by Omar El-Fanek on 7/28/15.
//  Copyright (c) 2015 ChickenBiscut. All rights reserved.
//

#import "ChatViewController.h"
#import "DataStore.h"
#define kFirechat @"https://icebreakerchat.firebaseio.com"


@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) BOOL newMessagesOnTop;

@end

@implementation ChatViewController 

#pragma mark  - Setup
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize array that will store chat messages
    self.chat = [[NSMutableArray alloc] init];
    
    // Initialize root
    self.firebase = [[Firebase alloc] initWithUrl:kFirechat];
    
    // Generate number for username
    
    DataStore *dataStore = [DataStore sharedDataStore];
    
    
    self.name = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", dataStore.user.firstName]];
    
    
    [self.nameField setTitle:self.name forState:UIControlStateNormal];
    
    // Sets new message location
    self.newMessagesOnTop = YES;
    
    // This allows us to check if there were messages stored on the server when we booted up (YES) or if they are new messages since we've started the app.
    // This is so we can batch together the initial messages' reloadData for a pref gain.
    __block BOOL initialAdds = YES;
    
    [self.firebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        if (self.newMessagesOnTop){
            [self.chat insertObject:snapshot.value atIndex:0];
        } else {
            [self.chat addObject:snapshot.value];
        }
        
        // Reload the tableview
        if (!initialAdds) {
            [self.tableView reloadData];
        }
    }];
    
    [self.firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.tableView reloadData];
        initialAdds = NO;
    }];



//    // Creates a reference to a Firebase database URL
//    Firebase *myRootReference = [[Firebase alloc] initWithUrl:@"https://icebreakerchat.firebaseio.com"];
//    
//    // Writes data to Firebase
//    [myRootReference setValue:@"Second hard coding data send test"];
//    
//    // Reads data and reacts to changes
//    [myRootReference observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        NSLog (@"%@ -> %@", snapshot.key, snapshot.value);
//    }];
//    
//    [myRootReference createUser:@"email@email.com" password:@"password" withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
//        if (error) {
//            NSLog (@"Error: %@", error);
//        } else {
//            NSString *uid = [result objectForKey:@"uid"];
//            NSLog(@"Success creating user account with uid: %@", uid);
//        }
//    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  - Text Field
// This method is called when the user enters text in the text field.
// The chat message is added to our Firebase

-(BOOL)textFieldShouldReturn:(UITextField *)aTextField {
    [aTextField resignFirstResponder];
    [[self.firebase childByAutoId] setValue:@{ @"name" : self.name, @"text" : aTextField.text }];
    
    [aTextField setText:@""];
    return NO;
}


#pragma mark  - Table View
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    // Number of chat messages
    NSLog(@"Chat count: %lu", self.chat.count);
    return [self.chat count];
}

// This method dynamically changes the message size
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *chatMessage = [self.chat objectAtIndex:indexPath.row];
    
    NSString *text = chatMessage [@"text"];
    
    // Standard textLabel.frame = {{10, 30}, {260, 22}}
    const CGFloat TEXT_LABEL_WIDTH = 260;
    CGSize constraint = CGSizeMake(TEXT_LABEL_WIDTH, 2000);

    // Standard textLabel.font = font-family "Helvetica"; font-weight: bold; font-style: normal; font-size: 18px
    
//    CGSize size = [text sizeWithAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:18.0f]}];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];

    const CGFloat CELL_CONTENT_MARGIN = 22;
    CGFloat height = MAX(CELL_CONTENT_MARGIN + size.height, 44);
    
    return height;
}


-(UITableViewCell *) tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)index{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSLog (@"Cell for row at index path is being called!");

    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:18];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSDictionary *chatMessage = [self.chat objectAtIndex: index.row];
    
    cell.textLabel.text = chatMessage [@"text"];
    cell.detailTextLabel.text = chatMessage[@"name"];
    
    return cell;
}

#pragma - Keyboard

// Subscribe to keyboard show and hide notifications
-(void) viewWillAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillShowNotification object:nil];

}

-(void) viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

// Unsubscribe to keyboard show and hide notifications
-(void) keyboardWillShow:(NSNotification *)notification {
    [self moveView: [notification userInfo] up:YES];
}

-(void) keyboardWillHide:(NSNotification *)notification {
    [self moveView: [notification userInfo] up:NO];
}

-(void) moveView:(NSDictionary *)userInfo up:(BOOL)up{
    
    CGRect keyboardEndFrame;
    [[userInfo objectForKey : UIKeyboardFrameEndUserInfoKey]
     getValue : &keyboardEndFrame];
    
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey : UIKeyboardAnimationDurationUserInfoKey]
     getValue : &animationCurve];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey : UIKeyboardAnimationDurationUserInfoKey]
     getValue : &animationDuration];
    
    // Get correct keyboard size and animate accordingly
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    int y = keyboardFrame.size.height * (up ? -1 : 1);
    self.view.frame = CGRectOffset(self.view.frame, 0, y);

    [UIView commitAnimations];
}
 
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if ([self.field isFirstResponder]) {
        [self.field resignFirstResponder];
    }
}


@end

