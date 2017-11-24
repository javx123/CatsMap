//
//  SearchViewController.m
//  Cats
//
//  Created by Javier Xing on 2017-11-21.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//
//- (IBAction)save:(id)sender {
//    [self.delegate searchViewController:self didSaveTag:nil];
//}
//
//- (IBAction)cancel:(id)sender {
//    [self.delegate searchTagCancel:self];
//}
//
- (IBAction)cancel:(id)sender {
    [self.delegate searchTagCancel:self];
}

- (IBAction)save:(id)sender {
    [self.delegate searchViewController:self didSaveTag:self.tagTextField.text];
}

- (IBAction)enableCurrentLocation:(id)sender {
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
