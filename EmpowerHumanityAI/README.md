# Empower Humanity AI — iOS App

A native iOS SwiftUI Xcode project for **Empower Humanity AI**: a persistent human–AI co-intelligence application.

---

## Opening in Xcode

1. Clone or download the repository.
2. Open `EmpowerHumanityAI/EmpowerHumanityAI.xcodeproj` in Xcode 15.3 or later.
3. Select a simulator (iPhone 15 Pro recommended) or your connected device.
4. Press **Cmd+R** to build and run.

> **Requirements:** Xcode 15.3+, macOS Sonoma, iOS 17+ deployment target.

---

## Architecture

```
EmpowerHumanityAI/
├── App/                          # Entry point, AppState (@Observable), routing
├── Core/
│   ├── Models/                   # All domain model types (54+ structs/enums)
│   ├── Networking/               # URLSession APIClient, Endpoint protocol
│   ├── Auth/                     # KeychainService (CRUD, token helpers)
│   ├── Access/                   # AccessService — tier checks & entitlements
│   ├── Notifications/            # PushNotificationService, NotificationRouter
│   ├── Services/                 # HapticService, VoiceService, BiometricApprovalService
│   └── Utilities/                # View extensions, Date helpers, Color(hex:)
├── Data/
│   ├── Repositories/             # Protocol-first repository interfaces
│   ├── Mock/                     # MockData (Ben/Alex demo dataset) + all mock repos
│   └── Services/                 # DemoWorkflowCoordinator (#if DEBUG)
├── DesignSystem/
│   ├── Theme/                    # EHColors, EHTypography, EHSpacing, EHRadius, EHShadow, EHGradients
│   └── Components/               # CoIntelligenceOrb (8 states), EHComponents
└── Features/
    ├── Public/                   # Landing, Login, Signup, AccessStatus
    ├── Authenticated/Navigation/ # AuthenticatedRootView (drawer + split), SideMenuView
    ├── Today/                    # TodayView + ViewModel
    ├── Chat/                     # ChatView + ViewModel + ResponseCards (7 card types)
    ├── Work/                     # WorkView (tasks, projects, decisions, plans)
    ├── Goals/                    # GoalsView + GoalDetailView
    ├── Knowledge/                # KnowledgeView (search + filter)
    ├── Activity/                 # ActivityView (timeline)
    ├── AIWork/                   # AIWorkView + ViewModel + AIWorkDetailView
    ├── Approvals/                # ApprovalsView + ViewModel + ApprovalDetailView
    ├── Devices/                  # DevicesView + DeviceDetailView
    ├── Notifications/            # NotificationsView
    ├── Integrations/             # IntegrationsView
    └── Settings/                 # SettingsView + AutonomySettingsView
```

---

## Design System

| Token | Description |
|---|---|
| `EHColors` | Intelligence Spectrum palette — 6 primary + semantic surface hierarchy |
| `EHTypography` | Plus Jakarta Sans (display) / Inter (body) with SF Pro fallback |
| `EHSpacing` | 4-point scale from `xxs (4)` to `page (64)` |
| `EHRadius` | `sm (8)` → `pill (999)` |
| `EHShadow` | Card, panel, orb glow shadow presets |
| `EHGradients` | Signature 5-stop co-intelligence gradient + 5 semantic secondaries |

### CoIntelligenceOrb

8 animated states: `available`, `listening`, `thinking`, `acting`, `waiting`, `completed`, `attention`, `error`.

Never red — attention/error use a corner dot indicator while the gradient identity persists.

---

## Demo Data

The app ships with a coherent demo dataset (`MockData.swift`):

| Entity | Value |
|---|---|
| User | **Ben Carter** (Founder Access tier) |
| Co-Intelligence | **Alex** (OrbState: available) |
| Goals | "Ship Empower Humanity AI v1.0" (65%), "Grow team to 5" (33%) |
| AI Work | Reviewing deployment logs (waitingForApproval), Research (working), Weekly report (completed) |
| Approvals | Hotfix to Feature 0.2 (low risk, pending) |
| Devices | iPhone (online), MacBook Pro (online), Home Mac Mini (working), Windows Workstation (offline) |

In **Debug** builds, the app auto-signs in as Ben to skip the landing screen.

---

## Architecture Decisions

- **@Observable** (Swift 5.9) — AppState, all ViewModels
- **Repository pattern** — protocol interfaces with mock implementations; swap in real APIClient when backend is live
- **No third-party Swift Package dependencies** — 100% Apple frameworks
- **`#if DEBUG` gates** — auto-login, DemoWorkflowCoordinator
- **Keychain** — session token storage
- **LocalAuthentication** — BiometricApprovalService (architecture prepared, real auth requires signed entitlements)
- **UserNotifications** — PushNotificationService (APNs architecture prepared, local notifications work in simulator)

---

## Connecting to the Real Backend

1. Set `SESSION_SECRET` and API base URL in a `Config.xcconfig` file.
2. Update `APIClient.swift` with the NestJS Core API base URL.
3. Replace `Mock*Repository` instances in each ViewModel `init` with real `API*Repository` implementations.
4. Add `Plus Jakarta Sans` and `Inter` font files to the Xcode target and register them in `Info.plist`.
5. Register APNs device token in `PushNotificationService.didRegisterForRemoteNotifications`.

---

## Bundle ID

`ai.empowerhumanity.EmpowerHumanityAI`

---

*Built for iOS 17+, iPhone and iPad.*
