//
//  Entity.m
//  EntitySystem
//
//  Created by Zoee Silcock on 04/09/14.
//

#import "Entity.h"
#import "EntityManager.h"

@implementation Entity {
    uint32_t _eid;
}

- (id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager {
    if ((self = [super init])) {
        _eid = eid;
        _entityManager = entityManager;
    }
    return self;
}

- (void)setEid:(uint32_t)eid {
    _eid = eid;
}

- (uint32_t)eid {
    return _eid;
}

- (TagsComponent *)tags {
    return (TagsComponent *) [_entityManager getComponentOfClass:[TagsComponent class]  forEntity:self];
}

@end
