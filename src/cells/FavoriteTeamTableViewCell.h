//
//  FavoriteTeamTableViewCell.h
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 20/12/17.
//  Copyright © 2017 cice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteTeamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelCompetition;
@property (weak, nonatomic) IBOutlet UILabel *labelCategory;
@property (weak, nonatomic) IBOutlet UILabel *labelTeam;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end
