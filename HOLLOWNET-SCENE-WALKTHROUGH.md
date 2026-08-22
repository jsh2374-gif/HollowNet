# HollowNet Scene-by-Scene Control Walkthrough

This walkthrough is the working control-map review for House in the Hollow. It covers every scene and room in the August 2026 registry, preserves the difference between installed equipment and planned infrastructure, and identifies where another room controller would add real value.

## Control layers

```text
HNA-26-CTL-003 HollowNet Main Hub
└── Zone Controller
    ├── Room or Area Controller — only when coordination justifies it
    └── Local Asset / HollowNet Field Node
```

A room controller is recommended when a scene has multiple coordinated effects, shared timing or safety interlocks, an actor control point, or several field nodes. A single self-contained effect can report directly to its zone controller or remain Local Only.

## Operations

### Control Room

| Record | Current state | Walkthrough decision |
| --- | --- | --- |
| `HNA-26-CTL-003` HollowNet Main Hub | Planned | Select hub computer, UPS, wired network switch, MQTT service, operator interface and emergency-stop behavior. This remains the parent of every zone controller. |

## Exterior Grounds

Parent: `HNA-26-CTL-004` Exterior Grounds Zone Controller, planned and controlled by the Main Hub.

| Scene / room | Existing and planned assets | Current control | Recommended next step |
| --- | --- | --- | --- |
| Front Gate | `HNA-26-ANM-001` Front Gate — Built | Pneumatic motion and audio share the actor switch; switch remains local fallback | **Confirmed:** use `HNA-26-CTL-014` Front Gate Controller under `CTL-004`. Main Hub remote enable, test and emergency stop are required. Select the ESP32/industrial I/O, valve interface and sensing; validate de-energized valve vent/hold behavior before operation. |
| Bridge / Fountain | `HNA-26-LGT-001` Jack-O-Lanterns and `HNA-26-CTL-015` SimFlame Controller — Built | **Confirmed:** Garden Shed power automatically starts the SimFlame LV unit and its three 12 V AC flicker circuits | Keep local; Main Hub control is not required at this time. Record the Garden Shed source circuit or outlet label during electrical documentation. |
| Garden Shed | `HNA-26-ANM-002` Caretaker — Built | **Confirmed:** Garden Shed power starts its 12 V DC wiper motor and LED lantern; motion runs continuously | Keep local; no Main Hub control or dedicated HollowNet controller is required. The Garden Shed power feed also enables the Bridge/Fountain SimFlame controller. |
| Exterior Facade | `HNA-26-PRJ-001` Mia & Roy — Installed | **Confirmed:** Pi auto-starts the silent loop; projector currently starts manually; operation is local | Keep the planned direct link to `CTL-004`; no separate facade controller is required. Hub must show Pi-online and loop-running status and provide start, stop, restart-loop and reboot-Pi controls. Add automatic projector startup after identifying the projector's supported control method. |
| Queue | `HNA-26-SCN-006` Haunted Radio — Planned | Controlled by `HNA-26-CTL-002` | Complete player/amplifier, tuning input, controller, power and network choices. `CTL-002` reports through `CTL-004`. |
| Shared exterior mist | `HNA-26-FOG-001` Mist System — Installed | Local Only; spans bridge, facade, Furnace Room and Cemetery | Treat as a cross-zone utility. During walkthrough, decide whether to split it into separately addressable valve/pump branches or keep a single safety-controlled utility asset. |

## Front House

Parent: `HNA-26-CTL-005` Front House Zone Controller, planned and controlled by the Main Hub.

| Scene / room | Existing and planned assets | Current control | Recommended next step |
| --- | --- | --- | --- |
| Facade Windows | `HNA-26-PRJ-002` Facade Windows — Planned | Media Player, Local Only | Confirm whether this facade belongs operationally to Front House or Exterior Grounds. Once ownership is settled, connect the player directly to the owning zone controller. |
| Front Porch | `HNA-26-ANM-003` Rocking Chair — Built | Timer Relay, Local Only | Keep the timer as local fallback. Add remote enable/test and status only if useful; no room controller is required for one effect. |
| Reception Room | `HNA-26-ANM-004` Suit of Armor — Planned | ESP32 / Wi-Fi, Local Only | This is already a good HollowNet field-node candidate. Connect directly to `CTL-005` unless more synchronized Reception Room effects are planned. |

## Upper House

Parent: `HNA-26-CTL-006` Upper House Zone Controller, planned and controlled by the Main Hub.

| Scene / room | Existing and planned assets | Current control | Recommended next step |
| --- | --- | --- | --- |
| First Room | `HNA-26-SCN-001` Mrs. Grimm — Installed | Reports to Room Controller | Use `HNA-26-CTL-011` First Room Controller, which reports to `CTL-006`. Document the Pi's scene start, stop, ready and fault signals. |
| Reception Room | `HNA-26-SCN-002` Living Portrait — Installed | BooBox, Local Only | Keep BooBox local operation. Add an enable/test/status interface to `CTL-006` before considering another room controller. |
| Stair Hall | `HNA-26-ACT-001` Stair Hall Ghost and `HNA-26-ANM-005` Filing Cabinet — Installed | Separate local controllers | Strong room-controller candidate if the ghost, cabinet and Storm must sequence together. Review actor trigger ownership first. |
| Stair Hall through Grand Hall | `HNA-26-PRJ-003` Storm — Installed | Media Player, Local Only | Decide whether Storm belongs to a future Stair Hall controller, Grand Hall controller or directly to `CTL-006`; avoid assigning it to two rooms. |
| Sitting Room | `HNA-26-ANM-006` Spiders — Installed | Local Only | Keep local unless remote test/status is needed. A dedicated room controller is not justified by the current single effect. |
| Library | `HNA-26-SCN-003` Library Hanging Transformation — Installed | Pi, Local Only | Because this is already a scene controller, connect it directly to `CTL-006` unless new synchronized Library effects are planned. |
| Back Hall | `HNA-26-ANM-007` Back Hall Ghost — Installed | Local Only | Review trigger and mechanism. A direct field-node connection to `CTL-006` is sufficient for one effect. |
| Gallery | `HNA-26-SCN-004` Gallery Mirror and `HNA-26-OTH-001` George — Installed | Separate local operation | Strong room-controller candidate if George and the mirror are one timed scene. Confirm whether George remains a passive puppet or needs an actuator record. |
| Conservatory | `HNA-26-OTH-002` Possessed — Installed | Mic, Local Only | Clarify what the microphone controls and whether the effect produces audio, lighting or motion. Keep local until its signal path is documented. |
| Grand Hall | `HNA-26-VID-001` Grand Hall Eyes and `HNA-26-ANM-008` Grand Hall Chandeliers — Installed | Separate local operation | Strong room-controller candidate, especially if Storm joins the sequence. Document chandelier safety and decide the shared scene trigger. |

## Basement

Parent: `HNA-26-CTL-007` Basement Zone Controller, planned and controlled by the Main Hub.

| Scene / room | Existing and planned assets | Current control | Recommended next step |
| --- | --- | --- | --- |
| Pantry | `HNA-26-VID-002` Head in Basket and `HNA-26-VID-003` Head in Jar — Installed | Both report to Room Controller | Use `HNA-26-CTL-012` Pantry Room Controller under `CTL-007`; define common start, stop, ready and synchronized playback behavior. |
| Coal Cellar | `HNA-26-VID-004` Little Girl in Mirror — Installed | Raspberry Pi / Wi-Fi, Local Only | Connect the existing Pi directly to `CTL-007`; a separate room controller is unnecessary unless the Coal Cellar grows. |
| Furnace Room | `HNA-26-SCN-005` Furnace Room — Installed | Reports to Room Controller | Use `HNA-26-CTL-013` Furnace Room Controller under `CTL-007`. Document actor button, crackers, video, audio and mist-system interaction. |
| Dungeon | `HNA-26-PRJ-004` Dungeon Projection and `HNA-26-ANM-009` Trunk — Installed | Separate local operation | Strong room-controller candidate if the projection and trunk share a trigger or timing sequence. |
| Bone Room | `HNA-26-PRJ-005` Bone Room Creature — Installed | Media Player, Local Only | Connect directly to `CTL-007` when remote enable/test is needed; no room controller is required yet. |
| Last Room | `HNA-26-PRJ-006` Mrs. Grimm Ghost and `HNA-26-MTR-001` Moving Shade Light — Installed | Separate local operation | Strong room-controller candidate if projection and moving light are synchronized or actor-triggered together. |

## Cemetery

Parent: `HNA-26-CTL-008` Cemetery Zone Controller, planned and controlled by the Main Hub.

| Scene / room | Existing and planned assets | Current control | Recommended next step |
| --- | --- | --- | --- |
| Cemetery | `HNA-26-ANM-010` HDL Figures — Installed | Local Only | Document motor and lighting channels, then decide direct field-node control under `CTL-008`. Include the cemetery mist branch in the same scene review. |

## Bog

Parent: `HNA-26-CTL-001` Bog Zone Controller, planned and controlled by the Main Hub.

| Scene / room | Existing and planned assets | Current control | Recommended next step |
| --- | --- | --- | --- |
| Bog | `HNA-26-ANM-011` Mud Skeleton, `ANM-012` Crawler, `ANM-013` Coffin Skeleton and `ANM-014` Stake Skeleton — Planned | Four ESP32 field nodes planned under `CTL-001` | Confirm each mechanism, motor driver, power supply, limits/current protection and ambient/trigger behavior. The field nodes can report directly to the Bog controller; no extra room controller is currently needed. |

## Reserved future zones

| Zone | Controller | Current state | Walkthrough decision |
| --- | --- | --- | --- |
| Crypt | `HNA-26-CTL-009` Crypt Zone Controller | Planned placeholder; no assets assigned | Define the Crypt scenes and room names before creating child controllers or assets. |
| Out Back | `HNA-26-CTL-010` Out Back Zone Controller | Planned placeholder; no assets assigned | Define the Out Back scenes and room names before creating child controllers or assets. |

## Recommended walkthrough order

1. Exterior Grounds — Front Gate through Queue, including ownership of the shared mist system.
2. Front House — resolve the two facade definitions and Reception Room expansion.
3. Upper House — decide room controllers for Stair Hall, Gallery and Grand Hall.
4. Basement — finalize Pantry and Furnace Room, then decide Dungeon and Last Room.
5. Cemetery and Bog — define field-node hardware and outdoor networking.
6. Crypt and Out Back — create assets only after their room/scene lists are known.

For each scene, record five decisions before assigning hardware: trigger, outputs, safe/default state, local fallback, and parent controller.
