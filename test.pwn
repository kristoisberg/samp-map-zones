#include "map-zones.inc"


main() {
    new MapZone:zone = GetMapZoneAtPoint(1334.76, -1715.39, 12.44);

    if (zone != INVALID_MAP_ZONE_ID) {
        new name[32];
        GetMapZoneName(zone, name);
        printf("%i %s", _:zone, name);
    }

    return 1;
}