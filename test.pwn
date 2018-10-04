#include "map-zones.inc"


main() {
    new MapZone:zone = GetMapZoneAtPoint(2162.4, 2012.2, -89.0);

    if (zone != INVALID_MAP_ZONE_ID) {
        new name[32], soundid, count;
        GetMapZoneName(zone, name);
        GetMapZoneSoundID(zone, soundid);
        GetMapZoneAreaCount(zone, count);
        printf("%i %i %i %s", _:zone, soundid, count, name);


        // The following method is preferred to using a for loop with the result of GetMapZoneAreaCount:

        new area, Float:minX, Float:minY, Float:minZ, Float:maxX, Float:maxY, Float:maxZ;

        while (GetMapZoneAreaPos(zone, area, minX, minY, minZ, maxX, maxY, maxZ)) {
            printf("%f %f %f %f %f %f", minX, minY, minZ, maxX, maxY, maxZ);
            area++;
        }
    } else {
        print("invalid zone");
    }

    return 1;
}
