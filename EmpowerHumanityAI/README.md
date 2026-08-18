# Empower Humanity AI — iOS App

A native iOS SwiftUI Xcode project for **Empower Humanity AI**: a persistent human–AI co-intelligence application.

> **Important:** This project was generated in Replit without access to Xcode or a macOS build environment. The source and project structure have been statically reviewed for consistency. **The project has not been compiled in Xcode.** You will need to open it locally and address any Xcode-specific project metadata or compiler issues before running.

---

## Local Validation Steps

1. Clone or download the repository.
2. Open `EmpowerHumanityAI/EmpowerHumanityAI.xcodeproj` in **Xcode 15.3 or later**.
3. Review any "Update recommended project settings" prompt before accepting.
4. Select a **development team** if you intend to run on a physical device.
5. Select an **iPhone 15 Pro** simulator (or any iOS 17+ simulator).
6. Press **Cmd+B** to build first, fix any Xcode-specific diagnostics, then **Cmd+R** to run.
7. Test iPad layout separately using an iPad simulator.

> **Requirements:** Xcode 15.3+, macOS Sonoma 14+, iOS 17+ deployment target.

---

## Key Behaviours

### Debug builds
- App starts **unauthenticated** at the Landing screen (same as Release).
- A clearly marked **"Explore Demo"** button on Landing signs in as the Ben/Alex demo session.
- An **"Continue with Ben & Alex Demo"** button also appears on the Access Status screen for convenience.
- `DemoWorkflowCoordinator` is compiled only in `#if DEBUG` builds.
- No credentials are hard-coded; the demo session is loaded from `MockData.swift`.

### Release builds
- App starts unauthenticated at Landing.
- No demo login CTA is shown.
- No automatic session, no hard-coded credentials.

---

## Routing

Access routing is centralised in `AppRouter.swift` and `AppState.swift`. No access checks are scattered through feature Views.

| Auth State | Access Tier | Destination |
|---|---|---|
| Unauthenticated | — | Landing (PublicNavigationRoot) |
| Authenticated | Public | Access Status (RestrictedNavigationRoot) |
| Authenticated | Waitlist | Access Status (RestrictedNavigationRoot) |
| Authenticated | Approved Beta | Today (AuthenticatedRootView) |
| Authenticated | Founder Access | Today (AuthenticatedRootView) |
| Authenticated | Design Partner | Today (AuthenticatedRootView) |
| Authenticated | Subscriber | Today (AuthenticatedRootView) |

After **signup**, new accounts default to `AccessTier.waitlist` → Access Status screen.
After **sign-in** with a full-access tier → Today screen.

---

## Architecture

```
EmpowerHumanityAI/
├── EmpowerHumanityAI.xcodeproj/
│   └── project.pbxproj
├── EmpowerHumanityAI/
│   ├── App/                          # Entry point, AppState (@Observable), AppRouter
│   ├── Core/
│   │   ├── Models/                   # All domain model types (54+ structs/enums)
│   │   ├── Networking/               # URLSession APIClient, Endpoint protocol
│   │   ├── Auth/                     # KeychainService (CRUD, token helpers)
│   │   ├── Access/                   # AccessService — tier checks & entitlements
│   │   ├── Notifications/            # PushNotificationService, NotificationRouter
│   │   ├── Services/                 # HapticService, VoiceService, BiometricApprovalService
│   │   └── Utilities/                # View extensions, Date helpers, Color(hex:)
│   ├── Data/
│   │   ├── Repositories/             # Protocol-first repository interfaces
│   │   ├── Mock/                     # MockData (Ben/Alex demo dataset) + all mock repos
│   │   └── Services/                 # DemoWorkflowCoordinator (#if DEBUG)
│   ├── DesignSystem/
│   │   ├── Theme/                    # EHColors, EHTypography, EHSpacing, EHRadius, EHShadow, EHGradients
│   │   └── Components/               # CoIntelligenceOrb (8 states), EHComponents
│   └── Features/
│       ├── Public/                   # Landing, Login, Signup, AccessStatus
│       ├── Authenticated/Navigation/ # AuthenticatedRootView (drawer + split), SideMenuView
│       ├── Today/                    # TodayView + ViewModel
│       ├── Chat/                     # ChatView + ViewModel + ResponseCards (7 card types)
│       ├── Work/                     # WorkView (tasks, projects, decisions, plans)
│       ├── Goals/                    # GoalsView + GoalDetailView
│       ├── Knowledge/                # KnowledgeView (search + filter)
│       ├── Activity/                 # ActivityView (timeline)
│       ├── AIWork/                   # AIWorkView + ViewModel + AIWorkDetailView
│       ├── Approvals/                # ApprovalsView + ViewModel + ApprovalDetailView
│       ├── Devices/                  # DevicesView + DeviceDetailView
│       ├── Notifications/            # NotificationsView
│       ├── Integrations/             # IntegrationsView
│       └── Settings/                 # SettingsView + AutonomySettingsView
└── README.md
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

## Navigation

### iPhone (compact width)
Leading menu button → overlay drawer with dimmed backdrop → animated leading panel. **Not a tab bar.**

### iPad (regular width)
`NavigationSplitView` with persistent sidebar.

### Deep-link / Notification routing
Typed `DeepLink` enum in `NotificationRouter.swift` converts push payloads into navigation destinations.
`DetailDestination` enum in `NavigationDestination.swift` supports `NavigationPath`-based pushes:

```
notification → approval detail
notification → AI Work detail
activity     → relevant artifact/work item
```

---

## Demo Data

The app ships with a coherent demo dataset (`MockData.swift`). All data is mock — no network calls are made.

| Entity | Value |
|---|---|
| User | **Ben Carter** (Founder Access tier) |
| Co-Intelligence | **Alex** (OrbState: available) |
| Goals | "Ship Empower Humanity AI v1.0" (65%), "Grow team to 5" (33%) |
| AI Work | Reviewing deployment logs (waitingForApproval), Research (working), Weekly report (completed) |
| Approvals | Hotfix to Feature 0.2 (low risk, pending) |
| Devices | iPhone (online), MacBook Pro (online), Home Mac Mini (working), Windows Workstation (offline) |

---

## Architecture Decisions

- **`@Observable`** (Swift 5.9) — AppState, all ViewModels
- **Repository pattern** — protocol interfaces (`Repositories.swift`) with mock implementations; swap for real `API*Repository` when backend is live
- **No third-party Swift Package dependencies** — 100% Apple frameworks (SwiftUI, Foundation, Observation, LocalAuthentication, UserNotifications, AVFoundation, Speech, Security)
- **`#if DEBUG` gates** — demo session loader, `DemoWorkflowCoordinator`
- **Keychain** — `KeychainService` for session token storage (architecture in place)
- **LocalAuthentication** — `BiometricApprovalService` for sensitive approval confirmation; real prompting requires a signed development team and device enrollment
- **UserNotifications** — `PushNotificationService` architecture in place; APNs requires signed entitlements and device token registration

---

## Connecting to the Real Backend

The communication architecture is:

```
iOS App
  ↓ URLSession (APIClient.swift)
Empower Humanity NestJS Core API
  ↓
Empower Humanity AI Services
  ↓
AI Native Substrate / Runtime
```

**Do not add direct OpenAI / Anthropic / Gemini SDK integrations** into the iOS app. All AI interaction goes through the NestJS Core API.

Steps to wire up the real backend:

1. Set `API_BASE_URL` in a `Config.xcconfig` file (or via environment/build settings).
2. Update `APIClient.swift` base URL to read from build settings.
3. Replace `Mock*Repository` instances in each ViewModel `init` with real `API*Repository` implementations using the same protocol interface.
4. Register APNs device token in `PushNotificationService.didRegisterForRemoteNotifications`.
5. Configure signing and capabilities in Xcode for Push Notifications, Face ID, and Keychain Sharing as each integration is wired.

### Security note

**Do not embed server secrets in the iOS application bundle or in xcconfig files committed to the repository.** The iOS app should only contain:
- Public configuration values (e.g. `API_BASE_URL`)
- Per-user access tokens and refresh tokens stored in Keychain after authentication

The following must never be embedded in the client:
- Server-side session secrets
- Private signing secrets
- Database credentials
- AI provider API keys

---

## Bundle Identity

| Property | Value |
|---|---|
| Product name | Empower Humanity AI |
| Target | EmpowerHumanityAI |
| Bundle ID | `ai.empowerhumanity.EmpowerHumanityAI` |
| Deployment target | iOS 17+ |
| Device families | iPhone + iPad |
| Swift | Swift 5.9 (`@Observable`) |

---

## Things to Verify Locally in Xcode

The following cannot be validated without a macOS/Xcode environment and should be checked after opening:

1. **Font files** — `Fonts/PlusJakartaSans-*.ttf` and `Fonts/Inter-*.ttf` must be present in the Xcode target and listed in `Info.plist` under `UIAppFonts`. Add the actual font files from their respective open-source repositories if not already present.
2. **Signing** — Set a development team for device deployment and Push Notification entitlements.
3. **APNs** — Real push notifications require the Push Notifications capability and a device token.
4. **Face ID prompts** — Biometric authentication requires a real device with Face ID/Touch ID enrolled.
5. **Dynamic Type** — Verify text scales correctly at all accessibility sizes.

---

*Native SwiftUI source generated. Xcode project statically validated. Xcode compilation has not been performed because Replit does not provide Xcode/macOS tooling.*
