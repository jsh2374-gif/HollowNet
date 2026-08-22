# HollowNet-Native Assets

Every effect, controller and field node should enter HollowNet with a permanent identity and an explicit place in the control hierarchy. The August 2026 asset pack applies this approach without replacing any existing planner records.

## Identity and relationships

- Attraction assets use `HNA-YY-TYPE-NNN`.
- Controller infrastructure uses the `CTL` type code, for example `HNA-26-CTL-001`.
- `Controlled By` contains the Asset ID of the immediate controller.
- `Affects` contains the Asset IDs controlled by a controller, one per line.
- `Reports To` records the hierarchy level: Main Hub, Zone Controller, Room Controller or Local Only.
- `Controller ID` is reserved for the field node or controller-box identity once hardware is assigned. It is deliberately left unassigned in planning records instead of inventing a hardware address.

Unknown hardware, power and network values remain `TBD` until they are selected and verified.

## Physical labels

The planner now prints two labels from the same asset record:

1. **Asset label** — name, permanent HNA ID, zone, room, type and service QR.
2. **Controller label** — parent HNA ID, node/controller ID, controller type, power, network and the same service QR.

The QR opens the asset's HollowNet service and documentation page. Assign the permanent HNA ID before fabrication; fill in the controller ID, power and network fields when hardware is installed.

## August 2026 native asset pack

The additive pack at `data/hollownet-native-assets.json` contains:

| Asset ID | Asset | Zone | Relationship |
| --- | --- | --- | --- |
| `HNA-26-SCN-006` | Haunted Radio | Exterior Grounds / Queue | Controlled by `HNA-26-CTL-002` |
| `HNA-26-CTL-001` | Bog Zone Controller | Bog | Reports to Main Hub; controls four Bog nodes |
| `HNA-26-CTL-002` | Queue Zone Controller | Exterior Grounds / Queue Control | Reports to Main Hub; controls Haunted Radio |
| `HNA-26-ANM-011` | Bog Mud Skeleton | Bog | Controlled by `HNA-26-CTL-001` |
| `HNA-26-ANM-012` | Bog Crawler | Bog | Controlled by `HNA-26-CTL-001` |
| `HNA-26-ANM-013` | Bog Coffin Skeleton | Bog | Controlled by `HNA-26-CTL-001` |
| `HNA-26-ANM-014` | Bog Stake Skeleton | Bog | Controlled by `HNA-26-CTL-001` |

Choose **Add Native Asset Pack** in the asset planner to register only missing records. The action never replaces an existing record or an existing matching Asset ID. With editing unlocked, additions are saved locally and queued for the existing cloud-sync path.

`data/hollownet-planner-backup-2026-08-22.json` is the uploaded 31-record planner backup plus these seven records. It contains 38 unique Asset IDs and is retained as the complete migration snapshot.

## Hierarchy

```text
HollowNet Main Hub
├── HNA-26-CTL-002 Queue Zone Controller
│   └── HNA-26-SCN-006 Haunted Radio
└── HNA-26-CTL-001 Bog Zone Controller
    ├── HNA-26-ANM-011 Bog Mud Skeleton
    ├── HNA-26-ANM-012 Bog Crawler
    ├── HNA-26-ANM-013 Bog Coffin Skeleton
    └── HNA-26-ANM-014 Bog Stake Skeleton
```
