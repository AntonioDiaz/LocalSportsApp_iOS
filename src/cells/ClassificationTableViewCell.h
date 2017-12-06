//
//  ClassificationTableViewCell.h
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 6/12/17.
//  Copyright © 2017 cice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTeam;
@property (weak, nonatomic) IBOutlet UILabel *labelPosition;
@property (weak, nonatomic) IBOutlet UILabel *labelMatchesPlayed;
@property (weak, nonatomic) IBOutlet UILabel *labelMatchesWon;
@property (weak, nonatomic) IBOutlet UILabel *labelMatchesDrawn;
@property (weak, nonatomic) IBOutlet UILabel *labelMatchesLost;
@property (weak, nonatomic) IBOutlet UILabel *labelPoints;
@property (weak, nonatomic) IBOutlet UIView *viewSeparatorLine;

@end
