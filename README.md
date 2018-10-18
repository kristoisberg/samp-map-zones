# SA-MP Map Zones

[![sampctl](https://shields.southcla.ws/badge/sampctl-samp--map--zones-2f2f2f.svg?style=for-the-badge)](https://github.com/kristoisberg/samp-map-zones)

This library does not bring anything gamechanging to the table, it's created to
stop a decade long era of bad practices regarding map zones. An array of ~350
zones dumped (or manually converted?) from the game has been around for such a
long time, but in that time I've never seen a satisfactory API for them. Let's
look at an implementation from Emmet\_'s South Central Roleplay.

```pawn
stock GetLocation(Float:fX, Float:fY, Float:fZ)
{
    enum e_ZoneData
    {
        e_ZoneName[32 char],
        Float:e_ZoneArea[6]
    };
    new const g_arrZoneData[][e_ZoneData] =
    {
        // ...
    };
    new
        name[32] = "San Andreas";

    for (new i = 0; i != sizeof(g_arrZoneData); i ++)
    {
        if (
            (fX >= g_arrZoneData[i][e_ZoneArea][0] && fX <= g_arrZoneData[i][e_ZoneArea][3]) &&
            (fY >= g_arrZoneData[i][e_ZoneArea][1] && fY <= g_arrZoneData[i][e_ZoneArea][4]) &&
            (fZ >= g_arrZoneData[i][e_ZoneArea][2] && fZ <= g_arrZoneData[i][e_ZoneArea][5]))
        {
            strunpack(name, g_arrZoneData[i][e_ZoneName]);

            break;
        }
    }
    return name;
}

stock GetPlayerLocation(playerid)
{
    new
        Float:fX,
        Float:fY,
        Float:fZ,
        string[32],
        id = -1;

    if ((id = House_Inside(playerid)) != -1)
    {
        fX = HouseData[id][housePos][0];
        fY = HouseData[id][housePos][1];
        fZ = HouseData[id][housePos][2];
    }
    // ...
    else GetPlayerPos(playerid, fX, fY, fZ);

    format(string, 32, GetLocation(fX, fY, fZ));
    return string;
}
```

![emmetemmet](https://i.imgur.com/cyUdlu4.png "Emmet Emmet")

If you didn't get the reference, you should probably check out
[this repository](https://github.com/sampctl/pawn-array-return-bug).
`GetPlayerLocation` most likely uses `format` to prevent this bug from
occurring, but the risk is still there and arrays should never be returned in
PAWN. Let's take a look at another implementation that even I used a long time
ago.

```pawn
stock GetPointZone(Float:x, Float:y, Float:z, zone[] = "San Andreas", len = sizeof(zone))
{
    for (new i, j = sizeof(Zones); i < j; i++)
    {
        if (x >= Zones[i][zArea][0] && x <= Zones[i][zArea][3] && y >= Zones[i][zArea][1] && y <= Zones[i][zArea][4] && z >= Zones[i][zArea][2] && z <= Zones[i][zArea][5])
        {
            strunpack(zone, Zones[i][zName], len);
            return 1;
        }
    }
    return 1;
}

stock GetPlayerZone(playerid, zone[], len = sizeof(zone))
{
    new Float:pos[3];
    GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

    for (new i, j = sizeof(Zones); i < j; i++)
    {
        if (x >= Zones[i][zArea][0] && x <= Zones[i][zArea][3] && y >= Zones[i][zArea][1] && y <= Zones[i][zArea][4] && z >= Zones[i][zArea][2] && z <= Zones[i][zArea][5])
        {
            strunpack(zone, Zones[i][zName], len);
            return 1;
        }
    }
    return 1;
}
```

First of all, what do we see? A lot of code repetition. That's easy to fix in
this case, but what if we also needed either the min/max position of the zone?
We'd have to loop through the zones again or take a different approach. Which
approach does this library take? Functions like `GetMapZoneAtPoint` and
`GetPlayerMapZone` do not return the name of the zone, they return an
identificator of it. The name or positions of the zone must be fetched using
another function. In addition to that, I rebuilt the array of zones myself since
the one used basically everywhere seems to be faulty according to
[this post](https://forum.sa-mp.com/showpost.php?p=4050745&postcount=7).

## Installation

Simply install to your project:

```bash
sampctl package install kristoisberg/samp-map-zones
```

Include in your code and begin using the library:

```pawn
#include <map-zones>
```

## Usage

### Constants

- `INVALID_MAP_ZONE_ID = MapZone:-1`
  - The return value of several functions when no map zone was matching the
    criteria.
- `MAX_MAP_ZONE_NAME = 27`
  - The length of the longest map zone name including the null character.
- `MAX_MAP_ZONE_AREAS = 13`
  - The most areas associated with a map zone.

### Functions

- `MapZone:GetMapZoneAtPoint(Float:x, Float:y, Float:z)`
  - Returns the ID of the map zone the point is in or `INVALID_MAP_ZONE_ID` if
    it isn't in any. Alias: `GetMapZoneAtPoint3D`.
- `MapZone:GetPlayerMapZone(playerid)`
  - Returns the ID of the map zone the player is in or `INVALID_MAP_ZONE_ID` if
    it isn't in any. Alias: `GetPlayerMapZone3D`.
- `MapZone:GetVehicleMapZone(vehicleid)`
  - Returns the ID of the map zone the vehicle is in or `INVALID_MAP_ZONE_ID` if
    it isn't in any. Alias: `GetVehicleMapZone3D`.
- `MapZone:GetMapZoneAtPoint2D(Float:x, Float:y)`
  - Returns the ID of the map zone the point is in or `INVALID_MAP_ZONE_ID` if
    it isn't in any. Does not check the Z-coordinate.
- `MapZone:GetPlayerMapZone2D(playerid)`
  - Returns the ID of the map zone the player is in or `INVALID_MAP_ZONE_ID` if
    it isn't in any. Does not check the Z-coordinate.
- `MapZone:GetVehicleMapZone2D(vehicleid)`
  - Returns the ID of the map zone the vehicle is in or `INVALID_MAP_ZONE_ID` if
    it isn't in any. Does not check the Z-coordinate.
- `bool:IsValidMapZone(MapZone:id)`
  - Returns `true` or `false` depending on if the map zone is valid or not.
- `bool:GetMapZoneName(MapZone:id, name[], size = sizeof(name))`
  - Retrieves the name of the map zone. Returns `true` or `false` depending on
    if the map zone is valid or not.
- `bool:GetMapZoneSoundID(MapZone:id, &soundid)`
  - Retrieves the sound ID of the map zone. Returns `true` or `false` depending 
    on if the map zone is valid or not.
- `bool:GetMapZoneAreaCount(MapZone:id, &count)`
  - Retrieves the count of areas associated with the map zone. Returns `true` or 
    `false` depending on if the map zone is valid or not.
- `GetMapZoneAreaPos(MapZone:id, &Float:minX = 0.0, &Float:minY = 0.0, &Float:minZ = 0.0, &Float:maxX = 0.0, &Float:maxY = 0.0, &Float:maxZ = 0.0, start = 0)`
  - Retrieves the coordinates of an area associated with the map zone. Returns 
    the array index for the area or `-1` if none were found. See the usage in 
    in the examples section.
- `GetMapZoneCount()`
  - Returns the count of map zones in the array. Could be used for iteration
    purposes.

## Examples

### Retrieving the location of a player

```pawn
CMD:whereami(playerid) {
    new MapZone:zone = GetPlayerMapZone(playerid);

    if (zone == INVALID_MAP_ZONE_ID) {
        return SendClientMessage(playerid, 0xFFFFFFFF, "probably in the ocean, mate");
    }

    new name[MAX_MAP_ZONE_NAME], soundid;
    GetMapZoneName(zone, name);
    GetMapZoneSoundID(zone, soundid);

    new string[128];
    format(string, sizeof(string), "you are in %s", name);

    SendClientMessage(playerid, 0xFFFFFFFF, string);
    PlayerPlaySound(playerid, soundid, 0.0, 0.0, 0.0);
    return 1;
}
```

### Iterating through areas associated with a map zone

```pawn
new zone = ZONE_RICHMAN, index = -1, Float:minX, Float:minY, Float:minZ, Float:maxX, Float:maxY, Float:maxZ;

while ((index = GetMapZoneAreaPos(zone, minX, minY, minZ, maxX, maxY, maxZ, index + 1) != -1) {
    printf("%f %f %f %f %f %f", minX, minY, minZ, maxX, maxY, maxZ);
}
```

### Extending

```pawn
stock MapZone:GetPlayerOutsideMapZone(playerid) {
    new House:houseid = GetPlayerHouseID(playerid), Float:x, Float:y, Float:z;

    if (houseid != INVALID_HOUSE_ID) { // if the player is inside a house, get the exterior location of the house
        GetHouseExteriorPos(houseid, x, y, z);
    } else if (!GetPlayerPos(playerid, x, y, z)) { // the player isn't connected, presuming that GetPlayerHouseID returns INVALID_HOUSE_ID in that case 
        return INVALID_MAP_ZONE_ID;
    }

    return GetMapZoneAtPoint(x, y, z);
}
```

## Testing

To test, simply run the package:

```bash
sampctl package run
```
