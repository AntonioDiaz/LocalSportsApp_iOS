//
//  FavoriteTeamEntity+CoreDataProperties.h
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 20/12/17.
//  Copyright © 2017 cice. All rights reserved.
//
//

#import "FavoriteTeamEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTeamEntity (CoreDataProperties)

+ (NSFetchRequest<FavoriteTeamEntity *> *)fetchRequest;

@property (nonatomic) BOOL isFavorite;
@property (nullable, nonatomic, copy) NSString *teamName;
@property (nonatomic) double idCompetitionServer;

@end

NS_ASSUME_NONNULL_END
