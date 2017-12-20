//
//  FavoriteTeamMatchTableViewCell.h
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 20/12/17.
//  Copyright © 2017 cice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteTeamMatchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelWeek;
@property (weak, nonatomic) IBOutlet UILabel *labelPlace;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTeamLocal;
@property (weak, nonatomic) IBOutlet UILabel *labelTeamVisitor;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreLocal;
@property (weak, nonatomic) IBOutlet UILabel *labelScoreVisitor;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@end
