//
//  SearchViewController.h
//  Cats
//
//  Created by Javier Xing on 2017-11-21.
//  Copyright © 2017 Javier Xing. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchViewController;

@protocol SearchTagProtocol <NSObject>
-(void)searchTagCancel:(SearchViewController*)controller;
-(void)searchViewController:(SearchViewController *)controller didSaveTag:(NSString *)tag;
@end

@interface SearchViewController : UIViewController

@property (nonatomic, weak) id <SearchTagProtocol> delegate;

@end
