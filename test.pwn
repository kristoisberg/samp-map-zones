#include "map-zones.inc"


main() {
    new MapZone:zone = GetMapZoneAtPoint(687.9, -860.6, -89.0);

    if (zone != INVALID_MAP_ZONE_ID) {
        new name[MAX_MAP_ZONE_NAME], soundid, count;
        GetMapZoneName(zone, name);
        GetMapZoneSoundID(zone, soundid);
        GetMapZoneAreaCount(zone, count);
        printf("%i %i %i %s", _:zone, soundid, count, name);

        new index = -1, Float:minX, Float:minY, Float:minZ, Float:maxX, Float:maxY, Float:maxZ;

        while ((index = GetMapZoneAreaPos(zone, minX, minY, minZ, maxX, maxY, maxZ, index + 1)) != -1) {
            printf("%f %f %f %f %f %f", minX, minY, minZ, maxX, maxY, maxZ);
        }
    } else {
        print("invalid zone");
    }
    
    return 1;
}