//
//  FavoriteTeamEntity+CoreDataProperties.h
//  localsports
//
//  Created by Antonio Díaz Arroyo on 31/1/18.
//  Copyright © 2018 cice. All rights reserved.
//
//

#import "FavoriteTeamEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTeamEntity (CoreDataProperties)

+ (NSFetchRequest<FavoriteTeamEntity *> *)fetchRequest;

@property (nonatomic) double idCompetitionServer;
@property (nonatomic) BOOL isFavorite;
@property (nullable, nonatomic, copy) NSString *teamName;

@end

NS_ASSUME_NONNULL_END
