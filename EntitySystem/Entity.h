//
//  Entity.h
//  EntitySystem
//
//  Created by Zoee Silcock on 04/09/14.
//

#import <Foundation/Foundation.h>
#import "TagsComponent.h"

@class EntityManager;

@interface Entity : NSObject

@property (strong) EntityManager *entityManager;

- (id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager;
- (void)setEid:(uint32_t)eid;
- (uint32_t)eid;

- (TagsComponent *)tags;

@end