//
//  TownsTableViewCell.h
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 4/12/17.
//  Copyright © 2017 cice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TownsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTownName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewTown;

@end
