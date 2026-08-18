# Empower Humanity AI — Data Model Inventory

**Product:** Empower Humanity AI
**Document Type:** Data Model Inventory
**Target File:** `data-model.inventory.md`
**Status:** Initial Canonical Inventory
**Primary Application Scope:** Web, iOS, Android, macOS, Windows, Backend Services
**Architecture:** Persistent Human–AI Co-Intelligence Experience
**Primary Infrastructure Dependencies:** AI Native Substrate, AI Native Runtime, Construct Context, Ensolam, Generative Reality Systems / GRL, Intelligence Cloud, Complete Systems AI

---

# 1. Inventory Purpose

This Data Model Inventory defines the canonical application-domain data model for Empower Humanity AI.

It translates the Product Definition, Reality Model, System Guide, Feature Inventory, and Web Pages & Navigation Inventory into implementation-oriented entities, value objects, relationships, ownership boundaries, and persistence guidance.

The inventory should guide:

* Angular models and interfaces,
* NestJS entities and DTOs,
* FastAPI contracts where applicable,
* mobile application models,
* desktop application models,
* database schema design,
* API contracts,
* event contracts,
* service boundaries,
* GRD CRUD Waves,
* Inventory Waves,
* Feature Packets,
* and synchronization with ecosystem services.

Empower Humanity AI should persist the data necessary to provide one continuous human-facing co-intelligence experience while avoiding duplication of data canonically owned by AI Native Substrate, AI Native Runtime, Construct Context, Ensolam, Generative Reality Systems, or other ecosystem products.

---

# 2. Core Data Modeling Principle

The central Empower Humanity data relationship is:

```text
Human
   ↓
Empower Humanity Account
   ↓
Primary Co-Intelligence
   ↓
Persistent Relationship
   ↓
Goals / Plans / Tasks / Decisions / Projects
   ↓
Context + Reality References
   ↓
AI Interactions
   ↓
Authorized Actions
   ↓
Execution References
   ↓
Outcomes / Artifacts
   ↓
Updated Human Reality
```

Empower Humanity owns the human-facing representation of this loop.

The underlying infrastructure systems remain authoritative for their respective domains.

---

# 3. Data Ownership Boundary

Every model should belong to one of four categories.

## 3.1 Empower Humanity Authoritative Entities

Empower Humanity is the source of truth for entities such as:

* User Profile,
* Co-Intelligence Relationship,
* Interaction Preferences,
* Goals,
* Plans,
* Tasks,
* Decisions,
* Projects,
* Daily Intelligence,
* Recommendations,
* User-facing Notifications,
* User Autonomy Preferences,
* UI Preferences,
* Empower Humanity-specific Activity,
* product-specific Integration Configuration.

---

## 3.2 Referenced Ecosystem Entities

Empower Humanity should store references or projections for entities owned elsewhere.

Examples:

### Ensolam

* AI Being,
* Being Identity,
* Being characteristics.

### Construct Context

* Context Package,
* Context Source,
* Context Snapshot.

### Generative Reality Systems

* Reality Object,
* GRL Representation,
* Reality Graph.

### AI Native Substrate

* AI Interaction,
* Model Route,
* Intelligence Invocation,
* Intelligence Session,
* Execution Placement.

### AI Native Runtime

* Runtime Node,
* Execution,
* Execution Job,
* Capability,
* Permission Grant,
* Approval Request,
* Artifact,
* Runtime Event.

### Intelligence Cloud

* Specialized Intelligence,
* Intelligence Result.

---

## 3.3 Local Projections

Empower Humanity may maintain optimized projections of ecosystem data for:

* dashboards,
* activity views,
* search,
* notification counts,
* status summaries.

Projection data must not silently become the authoritative source.

---

## 3.4 Derived Models

Some models should be computed rather than stored as independent source-of-truth entities.

Examples:

* Today's Priorities,
* Goal Health,
* Needs Attention,
* Next Best Action,
* Co-Intelligence Work Summary,
* Device Health Summary.

---

# 4. Data Model Domain Inventory

The major data domains are:

```text
01. Identity & Account
02. Co-Intelligence
03. Human–AI Relationship
04. Conversation
05. Personal Profile & Preferences
06. Reality References
07. Context & Memory References
08. Goals
09. Plans
10. Tasks & Commitments
11. Projects
12. Decisions
13. Daily Intelligence
14. Recommendations & Opportunities
15. Knowledge
16. Files & Artifacts
17. Activity
18. Notifications
19. Calendar & Time
20. Communications
21. Devices
22. Runtime Integration
23. Execution
24. Permissions & Approvals
25. Autonomy
26. Dedicated Compute
27. Agents & Delegation
28. Specialized Intelligence
29. Life Domains
30. Integrations
31. Search
32. Privacy & Security
33. Sessions & Devices
34. Application Configuration
35. Events & Synchronization
36. Audit & Observability
```

---

# 5. Common Entity Fields

Most Empower Humanity-owned entities should follow a standard baseline.

```text
id
user_id
created_at
updated_at
created_by
updated_by
status
metadata
```

Where appropriate:

```text
archived_at
deleted_at
version
source
external_reference
```

Use soft deletion only where product requirements justify restoration, retention, or audit needs.

---

# 6. Identifier Strategy

Recommended identifiers:

```text
UUID / UUIDv7
```

or equivalent globally unique identifiers.

Public identifiers should not depend on sequential database IDs.

Cross-system references should preserve:

```text
system
entity_type
external_id
```

Example:

```json
{
  "system": "ai-native-runtime",
  "entity_type": "runtime_node",
  "external_id": "node_01H..."
}
```

---

# 7. Identity & Account Domain

## EH-DM-ID-001 — UserAccount

Represents the user's Empower Humanity account.

### Core Fields

```text
id
auth_subject_id
email
email_verified
account_status
access_tier
onboarding_status
preferred_locale
timezone
created_at
updated_at
last_active_at
```

### Relationships

```text
UserAccount
├── has one → UserProfile
├── has one → PrimaryCoIntelligence
├── has many → UserSessions
├── has many → ConnectedDevices
├── has many → Integrations
├── has many → Goals
├── has many → Projects
└── has many → Conversations
```

Authentication credentials should remain owned by the configured authentication provider rather than stored directly by Empower Humanity.

---

## EH-DM-ID-002 — UserProfile

Represents human-facing profile information.

### Fields

```text
id
user_id
display_name
given_name
family_name
avatar_url
headline
bio
location_display
preferred_name
pronouns_optional
locale
timezone
profile_completion
```

Avoid turning the profile into the entire Human Reality Model.

---

## EH-DM-ID-003 — AccessEntitlement

Represents product access.

### Fields

```text
id
user_id
entitlement_type
status
source
starts_at
expires_at
metadata
```

Examples:

```text
beta
founder
subscription
internal
design_partner
```

---

# 8. Co-Intelligence Domain

## EH-DM-COI-001 — PrimaryCoIntelligence

Represents the Empower Humanity application-level identity/reference to the user's primary co-intelligence.

### Fields

```text
id
user_id
ensolam_being_id
display_name
avatar_url
relationship_status
activation_status
created_at
updated_at
```

### Important Boundary

Empower Humanity should not duplicate the entire Ensolam Being model.

`ensolam_being_id` should reference the canonical AI Being identity.

---

## EH-DM-COI-002 — CoIntelligenceProfile

Empower Humanity-specific presentation and user preference model.

### Fields

```text
id
co_intelligence_id
display_name_override
avatar_override
voice_id
communication_style
response_depth
challenge_level
proactivity_level
notification_style
metadata
```

---

## EH-DM-COI-003 — CoIntelligenceCapabilitySummary

A user-facing projection of available capabilities.

### Fields

```text
id
co_intelligence_id
capability_category
display_name
description
availability_status
source_system
source_reference
```

This is a projection, not the Runtime Capability Registry.

---

## EH-DM-COI-004 — CoIntelligenceResponsibility

Represents persistent responsibilities the human has delegated to the co-intelligence.

Examples:

```text
Track important deadlines
Monitor job opportunities
Help manage project X
Prepare weekly planning review
```

### Fields

```text
id
user_id
co_intelligence_id
title
description
responsibility_type
scope
status
autonomy_policy_id
start_at
end_at
```

---

# 9. Human–AI Relationship Domain

## EH-DM-REL-001 — CoIntelligenceRelationship

Represents the persistent product-level human–AI relationship.

### Fields

```text
id
user_id
co_intelligence_id
started_at
relationship_status
interaction_count
last_interaction_at
relationship_summary
relationship_context_reference
```

Do not attempt to reduce relationship quality to a single simplistic score.

---

## EH-DM-REL-002 — RelationshipPreference

### Fields

```text
id
relationship_id
preference_key
preference_value
source
confidence_optional
effective_from
```

Examples:

```text
prefers_concise_updates
challenge_assumptions
avoid_unnecessary_interruptions
```

---

## EH-DM-REL-003 — SharedHistoryReference

References significant moments in the relationship.

### Fields

```text
id
relationship_id
history_type
occurred_at
summary
conversation_id
context_reference
reality_reference
```

---

# 10. Conversation Domain

## EH-DM-CONV-001 — Conversation

### Fields

```text
id
user_id
co_intelligence_id
title
conversation_type
status
started_at
last_message_at
archived_at
context_reference
project_id
goal_id
metadata
```

### Conversation Types

```text
general
project
goal
decision
planning
reflection
support
```

---

## EH-DM-CONV-002 — ConversationMessage

### Fields

```text
id
conversation_id
sender_type
sender_reference
message_type
content
created_at
sequence_number
parent_message_id
ai_interaction_reference
metadata
```

### Sender Types

```text
human
co_intelligence
agent
system
```

---

## EH-DM-CONV-003 — MessageAttachment

### Fields

```text
id
message_id
attachment_type
name
mime_type
size
storage_reference
artifact_reference
external_source_reference
created_at
```

---

## EH-DM-CONV-004 — ConversationAction

Represents a structured action proposed from conversation.

### Fields

```text
id
conversation_id
message_id
action_type
label
payload
status
created_at
completed_at
```

Examples:

```text
create_goal
create_task
approve_execution
open_artifact
start_plan
```

---

# 11. Personal Profile & Preferences Domain

## EH-DM-PREF-001 — UserPreference

Generic persistent preference.

### Fields

```text
id
user_id
category
preference_key
preference_value
source
updated_at
```

---

## EH-DM-PREF-002 — InteractionPreference

### Fields

```text
id
user_id
communication_style
response_depth
proactivity_level
challenge_level
explanation_preference
voice_preference
```

---

## EH-DM-PREF-003 — UIPreference

### Fields

```text
id
user_id
theme
density
sidebar_state
default_home_view
accessibility_preferences
```

---

# 12. Reality Reference Domain

Empower Humanity should not duplicate the canonical Generative Reality Systems ontology.

Instead, application data should reference Reality entities when useful.

---

## EH-DM-REAL-001 — RealityReference

### Fields

```text
id
user_id
reality_system
reality_entity_type
reality_entity_id
display_name
summary
relationship_type
last_synced_at
```

Possible types:

```text
person
organization
place
event
resource
commitment
responsibility
project
```

---

## EH-DM-REAL-002 — RealityChangeReference

### Fields

```text
id
user_id
reality_reference_id
change_type
occurred_at
summary
source_reference
```

---

## EH-DM-REAL-003 — PersonProjection

Optional optimized application projection.

### Fields

```text
id
user_id
reality_reference_id
display_name
relationship_label
avatar_url
summary
last_interaction_at
```

This should remain a projection if the Person is canonically represented elsewhere.

---

# 13. Context & Memory Domain

## EH-DM-CTX-001 — ContextReference

References Construct Context entities.

### Fields

```text
id
user_id
construct_context_id
context_type
purpose
status
created_at
expires_at
```

---

## EH-DM-CTX-002 — ContextSourceProjection

User-facing representation of a contextual source.

### Fields

```text
id
user_id
source_type
source_name
integration_id
enabled
last_synced_at
privacy_scope
```

---

## EH-DM-CTX-003 — MemoryItemProjection

User-visible memory record where product UX requires explicit review.

### Fields

```text
id
user_id
memory_reference
display_text
memory_type
source
status
created_at
last_used_at
```

### States

```text
active
corrected
hidden
forgotten
```

Canonical memory/context storage may belong to Construct Context or another memory subsystem.

---

# 14. Goals Domain

## EH-DM-GOAL-001 — Goal

### Fields

```text
id
user_id
parent_goal_id
title
description
goal_type
life_domain_id
status
priority
desired_outcome
motivation
start_date
target_date
completed_at
progress_percentage
goal_health
created_at
updated_at
```

### Status

```text
draft
active
paused
blocked
completed
abandoned
archived
```

---

## EH-DM-GOAL-002 — GoalMilestone

### Fields

```text
id
goal_id
title
description
status
target_date
completed_at
sort_order
```

---

## EH-DM-GOAL-003 — GoalProgressEntry

### Fields

```text
id
goal_id
progress_value
summary
source
evidence_reference
recorded_at
```

---

## EH-DM-GOAL-004 — GoalHealthAssessment

AI-derived model.

### Fields

```text
id
goal_id
health_state
confidence
summary
risk_factors
recommended_actions
assessed_at
intelligence_reference
```

### Health States

```text
on_track
attention
at_risk
blocked
inactive
```

---

# 15. Plans Domain

## EH-DM-PLAN-001 — Plan

### Fields

```text
id
user_id
goal_id
project_id
title
description
plan_type
status
start_date
target_date
created_by_type
created_by_reference
created_at
updated_at
```

---

## EH-DM-PLAN-002 — PlanStep

### Fields

```text
id
plan_id
parent_step_id
title
description
status
sort_order
owner_type
owner_reference
target_date
task_id
execution_eligible
```

---

## EH-DM-PLAN-003 — PlanDependency

### Fields

```text
id
plan_id
predecessor_step_id
successor_step_id
dependency_type
```

---

## EH-DM-PLAN-004 — PlanMilestone

### Fields

```text
id
plan_id
title
description
status
target_date
completed_at
```

---

# 16. Tasks & Commitments Domain

## EH-DM-TASK-001 — Task

### Fields

```text
id
user_id
parent_task_id
goal_id
project_id
plan_id
plan_step_id
title
description
task_type
owner_type
owner_reference
status
priority
scheduled_start
due_at
completed_at
execution_mode
created_at
updated_at
```

### Owner Types

```text
human
co_intelligence
agent
shared
```

### Status

```text
draft
planned
ready
active
waiting
blocked
completed
cancelled
```

---

## EH-DM-TASK-002 — TaskDependency

### Fields

```text
id
task_id
depends_on_task_id
dependency_type
```

---

## EH-DM-TASK-003 — TaskResult

### Fields

```text
id
task_id
result_type
summary
status
execution_reference
artifact_reference
completed_at
```

---

## EH-DM-TASK-004 — Commitment

Represents a meaningful obligation beyond a simple task.

### Fields

```text
id
user_id
title
description
commitment_type
counterparty_reference
due_at
status
source_reference
created_at
```

---

# 17. Projects Domain

## EH-DM-PROJ-001 — Project

### Fields

```text
id
user_id
title
description
status
priority
start_date
target_date
completed_at
primary_goal_id
context_reference
created_at
updated_at
```

---

## EH-DM-PROJ-002 — ProjectParticipant

Supports relevant humans, AI Beings, or agents.

### Fields

```text
id
project_id
participant_type
participant_reference
role
status
```

---

## EH-DM-PROJ-003 — ProjectArtifactLink

### Fields

```text
id
project_id
artifact_reference
relationship_type
created_at
```

---

## EH-DM-PROJ-004 — ProjectKnowledgeLink

### Fields

```text
id
project_id
knowledge_item_id
relationship_type
```

---

# 18. Decisions Domain

## EH-DM-DEC-001 — Decision

### Fields

```text
id
user_id
goal_id
project_id
title
question
description
status
importance
decision_deadline
selected_option_id
decision_summary
rationale
decided_at
review_at
created_at
updated_at
```

### Status

```text
identified
analyzing
ready
decided
deferred
cancelled
reviewing
```

---

## EH-DM-DEC-002 — DecisionOption

### Fields

```text
id
decision_id
title
description
sort_order
estimated_outcome
metadata
```

---

## EH-DM-DEC-003 — DecisionCriterion

### Fields

```text
id
decision_id
name
description
weight
sort_order
```

---

## EH-DM-DEC-004 — DecisionEvaluation

### Fields

```text
id
decision_id
option_id
criterion_id
score
assessment
source
```

---

## EH-DM-DEC-005 — DecisionRecommendation

### Fields

```text
id
decision_id
recommended_option_id
summary
reasoning_summary
risk_summary
confidence
intelligence_reference
created_at
```

---

## EH-DM-DEC-006 — DecisionOutcomeReview

### Fields

```text
id
decision_id
reviewed_at
actual_outcome
assessment
lessons
follow_up_actions
```

---

# 19. Daily Intelligence Domain

## EH-DM-DAILY-001 — DailyIntelligenceSnapshot

Represents the generated daily experience for a user.

### Fields

```text
id
user_id
date
greeting
summary
generated_at
context_reference
generation_reference
```

---

## EH-DM-DAILY-002 — DailyPriority

### Fields

```text
id
daily_snapshot_id
reference_type
reference_id
title
reason
priority_rank
status
```

Reference may point to:

* Task,
* Goal,
* Decision,
* Event,
* Recommendation.

---

## EH-DM-DAILY-003 — AttentionItem

### Fields

```text
id
daily_snapshot_id
attention_type
reference_type
reference_id
title
summary
severity
suggested_action
```

---

## EH-DM-DAILY-004 — DailyPlanItem

### Fields

```text
id
daily_snapshot_id
task_id
title
planned_start
planned_duration
sort_order
owner_type
```

---

# 20. Recommendations & Opportunities Domain

## EH-DM-REC-001 — Recommendation

### Fields

```text
id
user_id
recommendation_type
title
summary
rationale
priority
status
goal_id
project_id
source_intelligence_reference
created_at
expires_at
```

### Status

```text
new
viewed
accepted
dismissed
completed
expired
```

---

## EH-DM-REC-002 — Opportunity

### Fields

```text
id
user_id
opportunity_type
title
description
relevance_summary
potential_value
urgency
source
source_reference
status
discovered_at
expires_at
```

---

## EH-DM-REC-003 — RiskSignal

### Fields

```text
id
user_id
risk_type
title
description
severity
likelihood
impact
goal_id
project_id
source_reference
status
detected_at
```

---

## EH-DM-REC-004 — RecommendationFeedback

### Fields

```text
id
recommendation_id
user_id
feedback_type
feedback_text
created_at
```

---

# 21. Knowledge Domain

## EH-DM-KNOW-001 — KnowledgeItem

Represents an Empower Humanity-managed knowledge artifact or reference.

### Fields

```text
id
user_id
title
knowledge_type
content_reference
summary
source_type
source_reference
status
created_at
updated_at
```

### Types

```text
note
document
research
summary
reference
generated
external
```

---

## EH-DM-KNOW-002 — KnowledgeCollection

### Fields

```text
id
user_id
title
description
collection_type
created_at
updated_at
```

---

## EH-DM-KNOW-003 — KnowledgeCollectionItem

### Fields

```text
id
collection_id
knowledge_item_id
sort_order
added_at
```

---

## EH-DM-KNOW-004 — KnowledgeRelationship

### Fields

```text
id
knowledge_item_id
related_type
related_id
relationship_type
```

---

# 22. Files & Artifacts Domain

## EH-DM-ART-001 — ArtifactReference

Empower Humanity's reference to an artifact that may be owned by Runtime, Document Studio, object storage, or another ecosystem service.

### Fields

```text
id
user_id
source_system
source_artifact_id
artifact_type
name
mime_type
size
storage_reference
preview_reference
created_at
```

---

## EH-DM-ART-002 — ArtifactLineage

### Fields

```text
id
artifact_reference_id
origin_type
origin_reference
task_id
conversation_id
execution_reference
project_id
created_at
```

---

## EH-DM-ART-003 — FileReference

Represents a file known to Empower Humanity without taking ownership of the canonical file resource.

### Fields

```text
id
user_id
source_system
source_file_id
display_name
path_display
mime_type
runtime_node_reference
integration_id
last_known_modified_at
```

Do not treat a stored path as durable authority to access the file.

---

# 23. Activity Domain

## EH-DM-ACT-001 — ActivityItem

A human-readable activity projection.

### Fields

```text
id
user_id
activity_type
actor_type
actor_reference
title
summary
status
reference_type
reference_id
occurred_at
importance
metadata
```

Examples:

```text
goal_created
task_completed
ai_work_started
execution_completed
decision_made
artifact_created
recommendation_found
```

---

## EH-DM-ACT-002 — ActivityGroup

Optional grouping for multi-step work.

### Fields

```text
id
user_id
group_type
title
started_at
completed_at
status
```

---

# 24. Notifications Domain

## EH-DM-NOT-001 — Notification

### Fields

```text
id
user_id
notification_type
title
body
priority
status
channel
reference_type
reference_id
created_at
read_at
dismissed_at
expires_at
```

### Types

```text
proactive
task
goal
approval
execution
risk
opportunity
system
```

---

## EH-DM-NOT-002 — NotificationPreference

### Fields

```text
id
user_id
notification_type
in_app_enabled
push_enabled
email_enabled
desktop_enabled
minimum_priority
quiet_hours_policy_id
```

---

## EH-DM-NOT-003 — NotificationDelivery

### Fields

```text
id
notification_id
channel
delivery_status
attempted_at
delivered_at
failure_reason
```

---

# 25. Calendar & Time Domain

## EH-DM-TIME-001 — CalendarConnectionProjection

Reference to an Integration.

### Fields

```text
id
user_id
integration_id
provider
calendar_external_id
display_name
enabled
```

---

## EH-DM-TIME-002 — CalendarEventProjection

### Fields

```text
id
user_id
integration_id
external_event_id
title
start_at
end_at
timezone
location
status
last_synced_at
```

Canonical event authority remains the external calendar provider.

---

## EH-DM-TIME-003 — TimeBlock

Empower Humanity-owned planning construct.

### Fields

```text
id
user_id
title
task_id
goal_id
start_at
end_at
status
source
```

---

## EH-DM-TIME-004 — RecurringCommitment

### Fields

```text
id
user_id
title
recurrence_rule
start_at
end_at
status
related_task_template_id
```

---

# 26. Communications Domain

## EH-DM-COMM-001 — CommunicationReference

### Fields

```text
id
user_id
integration_id
communication_type
external_id
thread_external_id
sender_reference
recipient_summary
subject
occurred_at
status
```

The actual message remains owned by the communication provider unless explicitly imported.

---

## EH-DM-COMM-002 — DraftCommunication

Empower Humanity-owned draft.

### Fields

```text
id
user_id
communication_type
integration_id
recipient_data
subject
body
status
conversation_id
task_id
created_at
updated_at
```

---

## EH-DM-COMM-003 — FollowUpItem

### Fields

```text
id
user_id
communication_reference_id
title
reason
due_at
status
task_id
```

---

# 27. Devices Domain

## EH-DM-DEV-001 — ConnectedDevice

Human-facing device representation.

### Fields

```text
id
user_id
runtime_node_reference
device_reference
display_name
device_type
platform
connection_status
health_status
is_dedicated_compute
last_seen_at
created_at
```

AI Native Runtime remains authoritative for actual Runtime Node state.

---

## EH-DM-DEV-002 — DevicePreference

### Fields

```text
id
device_id
user_id
preferred_for_execution
display_name_override
notification_enabled
user_notes
```

---

## EH-DM-DEV-003 — DeviceStatusProjection

Transient/cached projection.

### Fields

```text
device_id
runtime_status
connection_status
health
active_execution_count
pending_approval_count
last_updated_at
```

---

# 28. Runtime Integration Domain

These entities are references/projections, not duplicated Runtime authority.

---

## EH-DM-RUN-001 — RuntimeNodeReference

### Fields

```text
id
user_id
runtime_node_id
runtime_installation_id
display_name
platform
runtime_version
connection_status
health_status
execution_availability
last_synced_at
```

---

## EH-DM-RUN-002 — RuntimeCapabilityProjection

### Fields

```text
id
runtime_node_reference_id
runtime_capability_id
display_name
category
availability
risk_level
last_synced_at
```

---

## EH-DM-RUN-003 — RuntimeJobReference

### Fields

```text
id
user_id
runtime_job_id
task_id
runtime_node_reference_id
status
started_at
completed_at
last_synced_at
```

---

# 29. Execution Domain

## EH-DM-EXEC-001 — AIWorkItem

Empower Humanity-owned user-facing representation of delegated AI work.

### Fields

```text
id
user_id
co_intelligence_id
task_id
goal_id
project_id
title
objective
work_type
status
priority
created_at
started_at
completed_at
```

This differs from a Runtime Execution.

One AI Work Item may involve multiple Runtime Executions.

---

## EH-DM-EXEC-002 — ExecutionReference

### Fields

```text
id
ai_work_item_id
runtime_execution_id
runtime_job_id
runtime_node_reference_id
capability_reference
status
started_at
completed_at
result_summary
```

---

## EH-DM-EXEC-003 — ExecutionResultProjection

### Fields

```text
id
execution_reference_id
status
summary
artifact_count
resource_change_count
error_code
completed_at
```

---

## EH-DM-EXEC-004 — ResourceChangeProjection

### Fields

```text
id
execution_reference_id
change_type
resource_type
display_name
resource_reference
occurred_at
```

Examples:

```text
created
modified
moved
deleted
launched
```

---

# 30. Permissions & Approvals Domain

Runtime remains authoritative for actual execution permissions.

Empower Humanity owns the human-facing governance experience and may store user policy preferences.

---

## EH-DM-GOV-001 — PermissionProjection

### Fields

```text
id
user_id
runtime_permission_id
subject_type
subject_reference
capability_reference
resource_scope_summary
effect
duration_type
runtime_node_reference
created_at
last_synced_at
```

---

## EH-DM-GOV-002 — ApprovalProjection

### Fields

```text
id
user_id
runtime_approval_request_id
ai_work_item_id
execution_reference_id
title
reason
risk_level
requested_scope_summary
status
requested_at
expires_at
last_synced_at
```

---

## EH-DM-GOV-003 — ApprovalDecisionReference

### Fields

```text
id
approval_projection_id
runtime_decision_id
decision
scope_summary
decided_at
```

---

## EH-DM-GOV-004 — GovernancePreference

Empower Humanity-owned preferences affecting user experience or upstream policy requests.

### Fields

```text
id
user_id
category
default_behavior
preferred_scope
notification_behavior
```

---

# 31. Autonomy Domain

## EH-DM-AUTO-001 — AutonomyPolicy

Empower Humanity-level human intent describing how independently the co-intelligence may operate.

### Fields

```text
id
user_id
co_intelligence_id
name
description
status
default_level
created_at
updated_at
```

### Suggested Levels

```text
manual
assistive
proactive
delegated
high_autonomy
```

These are product-level UX abstractions, not direct Runtime permission values.

---

## EH-DM-AUTO-002 — AutonomyRule

### Fields

```text
id
autonomy_policy_id
domain
capability_category
resource_scope_reference
device_reference
behavior
approval_threshold
background_allowed
notification_level
```

---

## EH-DM-AUTO-003 — AutonomyPause

### Fields

```text
id
user_id
scope_type
scope_reference
started_at
ends_at
reason
created_by
```

---

# 32. Dedicated Compute Domain

## EH-DM-COMP-001 — DedicatedComputeConfiguration

Empower Humanity's product-level configuration/reference.

### Fields

```text
id
user_id
runtime_node_reference_id
status
display_name
purpose
background_work_enabled
max_concurrent_ai_work
preferred_work_types
autonomy_policy_id
created_at
updated_at
```

Runtime remains authoritative for node execution state.

---

## EH-DM-COMP-002 — DedicatedComputeSummary

Derived projection.

### Fields

```text
runtime_node_reference_id
health
active_jobs
queued_jobs
local_models_available
storage_summary
last_seen_at
```

---

# 33. Agents & Delegation Domain

## EH-DM-AGENT-001 — AgentReference

References an agent identity that may be created by Ensolam, AI Native Substrate, Company Orchestrator, or another system.

### Fields

```text
id
user_id
external_agent_id
source_system
display_name
agent_type
status
created_at
```

---

## EH-DM-AGENT-002 — Delegation

Empower Humanity-level record of work delegated from the primary co-intelligence.

### Fields

```text
id
user_id
co_intelligence_id
agent_reference_id
task_id
objective
delegation_scope
status
delegated_at
completed_at
```

---

## EH-DM-AGENT-003 — DelegationScope

### Fields

```text
id
delegation_id
allowed_capability_categories
resource_scope_reference
device_scope
expires_at
```

Runtime/Substrate remain responsible for final effective authority.

---

# 34. Specialized Intelligence Domain

## EH-DM-INTEL-001 — IntelligenceReference

### Fields

```text
id
intelligence_cloud_id
intelligence_type
display_name
description
status
```

---

## EH-DM-INTEL-002 — IntelligenceInvocationReference

References Substrate/Intelligence Cloud execution.

### Fields

```text
id
user_id
intelligence_reference_id
purpose
source_type
source_reference
external_invocation_id
status
created_at
completed_at
```

---

## EH-DM-INTEL-003 — IntelligenceInsight

User-facing persisted insight where appropriate.

### Fields

```text
id
user_id
intelligence_invocation_reference_id
insight_type
title
summary
importance
related_goal_id
related_project_id
created_at
```

---

# 35. Life Domains

## EH-DM-LIFE-001 — LifeDomain

### Fields

```text
id
user_id
domain_type
display_name
description
status
priority
```

Default examples:

```text
work
education
relationships
health
finances
personal_growth
creativity
home
community
recreation
```

Users should not necessarily be forced into a fixed taxonomy.

---

## EH-DM-LIFE-002 — LifeDomainRelationship

Links objects to a life domain.

### Fields

```text
id
life_domain_id
entity_type
entity_id
relationship_type
```

---

# 36. Integrations Domain

## EH-DM-INTG-001 — Integration

### Fields

```text
id
user_id
provider
integration_type
display_name
status
external_account_reference
connected_at
last_synced_at
configuration
```

Do not store raw access credentials in normal application tables.

---

## EH-DM-INTG-002 — IntegrationPermission

### Fields

```text
id
integration_id
permission_key
status
scope
```

---

## EH-DM-INTG-003 — IntegrationSyncState

### Fields

```text
id
integration_id
resource_type
sync_status
last_success_at
last_attempt_at
cursor_reference
error_summary
```

---

# 37. Search Domain

Search should primarily use indexes/projections rather than become a separate business-domain authority.

---

## EH-DM-SEARCH-001 — SearchDocument

Derived index model.

### Fields

```text
id
user_id
entity_type
entity_id
title
text_content
semantic_reference
updated_at
visibility_scope
```

---

## EH-DM-SEARCH-002 — SavedSearch

### Fields

```text
id
user_id
name
query
filters
created_at
```

---

# 38. Privacy & Security Domain

## EH-DM-PRIV-001 — PrivacyPreference

### Fields

```text
id
user_id
category
setting
value
updated_at
```

---

## EH-DM-PRIV-002 — DataLocalityPreference

### Fields

```text
id
user_id
data_category
locality_policy
preferred_runtime_node
created_at
updated_at
```

Possible policies:

```text
cloud_allowed
local_preferred
local_only
ask
```

These preferences must eventually map into actual Substrate/Runtime policies.

---

## EH-DM-PRIV-003 — DataSourceConsent

### Fields

```text
id
user_id
source_type
source_reference
consent_status
allowed_uses
granted_at
revoked_at
```

---

# 39. Sessions & Application Devices Domain

## EH-DM-SESSION-001 — UserSession

### Fields

```text
id
user_id
client_type
client_identifier
started_at
last_active_at
expires_at
revoked_at
```

### Client Types

```text
web
ios
android
macos
windows
```

---

## EH-DM-SESSION-002 — AppDevice

Represents an Empower Humanity application installation/device independently of a Runtime Node.

### Fields

```text
id
user_id
platform
device_name
app_version
push_token_reference
last_active_at
trusted_status
```

Important:

```text
AppDevice ≠ RuntimeNode
```

A phone can be an Empower Humanity client without being a Runtime execution node.

---

# 40. Application Configuration Domain

## EH-DM-CONFIG-001 — UserAppConfiguration

### Fields

```text
id
user_id
configuration_key
configuration_value
updated_at
```

---

## EH-DM-CONFIG-002 — FeatureEntitlement

### Fields

```text
id
user_id
feature_key
enabled
source
expires_at
```

---

## EH-DM-CONFIG-003 — FeatureFlagProjection

Platform/admin controlled.

### Fields

```text
key
enabled
rollout_group
configuration
```

---

# 41. Events & Synchronization Domain

## EH-DM-EVENT-001 — DomainEvent

### Fields

```text
id
event_type
aggregate_type
aggregate_id
user_id
occurred_at
payload
correlation_id
causation_id
```

Examples:

```text
goal.created
goal.completed
task.delegated
decision.made
ai_work.started
notification.created
device.connected
```

---

## EH-DM-EVENT-002 — ExternalEventReference

References events received from infrastructure systems.

### Fields

```text
id
source_system
external_event_id
event_type
user_id
received_at
processed_at
processing_status
correlation_id
```

---

## EH-DM-EVENT-003 — SyncCheckpoint

### Fields

```text
id
user_id
source_system
resource_type
cursor
last_synced_at
status
```

---

# 42. Audit & Observability Domain

Empower Humanity should not replicate Runtime's authoritative execution audit log.

It may maintain application audit records for product actions.

---

## EH-DM-AUDIT-001 — ApplicationAuditRecord

### Fields

```text
id
user_id
actor_type
actor_reference
action
entity_type
entity_id
occurred_at
result
correlation_id
metadata
```

Examples:

```text
user.changed_autonomy
user.revoked_integration
user.renamed_co_intelligence
```

---

## EH-DM-AUDIT-002 — RuntimeAuditReference

### Fields

```text
id
user_id
runtime_audit_id
execution_reference_id
runtime_node_reference_id
occurred_at
```

---

# 43. Primary Relationship Map

```text
UserAccount
│
├── UserProfile
├── PrimaryCoIntelligence
│   ├── CoIntelligenceProfile
│   ├── CoIntelligenceRelationship
│   ├── Responsibilities
│   └── AutonomyPolicy
│
├── Conversations
│   └── Messages
│
├── Goals
│   ├── Milestones
│   ├── Plans
│   └── Tasks
│
├── Projects
│   ├── Tasks
│   ├── Plans
│   ├── Decisions
│   └── Knowledge
│
├── Decisions
│   ├── Options
│   ├── Criteria
│   └── Recommendation
│
├── KnowledgeItems
├── Recommendations
├── Notifications
├── Integrations
├── ConnectedDevices
│   └── RuntimeNodeReference
│
└── AIWorkItems
    ├── ExecutionReferences
    ├── ArtifactReferences
    └── Delegations
```

---

# 44. Co-Intelligence Execution Relationship

The application data model should preserve this separation:

```text
Task
   ↓
AIWorkItem
   ↓
ExecutionReference
   ↓
AI Native Runtime Execution
```

A Task answers:

> What needs to be accomplished?

An `AIWorkItem` answers:

> What work has been delegated to the co-intelligence?

A Runtime Execution answers:

> What governed capability invocation actually occurred?

Do not collapse these into one table/entity.

---

# 45. AI Interaction Relationship

Similarly:

```text
ConversationMessage
      ↓
AIInteractionReference
      ↓
AI Native Substrate
      ↓
Model / Intelligence Invocations
```

Empower Humanity owns the conversational product record.

AI Native Substrate owns the detailed underlying model interaction infrastructure.

---

# 46. Reality and Context Relationship

```text
Goal / Project / Conversation / Decision
           │
           ├── RealityReference
           │
           └── ContextReference
```

Application entities should link to reality/context rather than embedding large duplicated reality graphs or context packages.

---

# 47. Runtime Node Relationship

```text
User
 ↓
ConnectedDevice
 ↓
RuntimeNodeReference
 ↓
AI Native Runtime RuntimeNode
```

A `ConnectedDevice` is the Empower Humanity UX representation.

The Runtime Node remains owned by AI Native Runtime.

---

# 48. Dedicated Compute Relationship

```text
ConnectedDevice
      ↓
RuntimeNodeReference
      ↓
DedicatedComputeConfiguration
```

Dedicated Compute is a role/configuration applied to a Runtime Node, not a separate physical device entity type.

---

# 49. Approval Relationship

```text
AIWorkItem
   ↓
ExecutionReference
   ↓
ApprovalProjection
   ↓ references
AI Native Runtime ApprovalRequest
```

Empower Humanity may display and respond to approvals while Runtime remains authoritative for whether execution may continue.

---

# 50. Artifact Relationship

```text
Conversation
Task
Project
AIWorkItem
ExecutionReference
     ↓
ArtifactReference
     ↓
External Artifact Authority
```

Possible authorities:

* AI Native Runtime,
* Document Studio,
* object storage,
* external service.

---

# 51. Recommended Core Database Tables

For an initial NestJS/PostgreSQL application, the core schema should likely begin with:

```text
users
user_profiles
access_entitlements

primary_co_intelligences
co_intelligence_profiles
co_intelligence_relationships
co_intelligence_responsibilities

conversations
conversation_messages
message_attachments
conversation_actions

user_preferences
interaction_preferences
ui_preferences

goals
goal_milestones
goal_progress_entries
goal_health_assessments

plans
plan_steps
plan_dependencies
plan_milestones

tasks
task_dependencies
task_results
commitments

projects
project_participants
project_artifact_links
project_knowledge_links

decisions
decision_options
decision_criteria
decision_evaluations
decision_recommendations
decision_outcome_reviews

daily_intelligence_snapshots
daily_priorities
attention_items
daily_plan_items

recommendations
opportunities
risk_signals
recommendation_feedback

knowledge_items
knowledge_collections
knowledge_collection_items
knowledge_relationships

artifact_references
artifact_lineage
file_references

activity_items

notifications
notification_preferences
notification_deliveries

integrations
integration_permissions
integration_sync_states

connected_devices
device_preferences
runtime_node_references
runtime_capability_projections

ai_work_items
execution_references
execution_result_projections
resource_change_projections

permission_projections
approval_projections
approval_decision_references

autonomy_policies
autonomy_rules
autonomy_pauses

dedicated_compute_configurations

agent_references
delegations
delegation_scopes

life_domains
life_domain_relationships

privacy_preferences
data_locality_preferences
data_source_consents

user_sessions
app_devices

domain_events
external_event_references
sync_checkpoints
application_audit_records
```

This is an inventory, not a requirement to build every table in the first CRUD wave.

---

# 52. v0.1 CRUD Priority

## Tier 1 — Account & Relationship

```text
UserAccount
UserProfile
PrimaryCoIntelligence
CoIntelligenceProfile
CoIntelligenceRelationship
UserPreference
InteractionPreference
```

---

## Tier 2 — Core Collaboration

```text
Conversation
ConversationMessage
MessageAttachment
Goal
GoalMilestone
Plan
PlanStep
Task
Project
Decision
```

---

## Tier 3 — Daily Experience

```text
DailyIntelligenceSnapshot
DailyPriority
AttentionItem
Recommendation
Notification
ActivityItem
```

---

## Tier 4 — Execution Integration

```text
ConnectedDevice
RuntimeNodeReference
AIWorkItem
ExecutionReference
ApprovalProjection
PermissionProjection
ArtifactReference
```

---

## Tier 5 — Governance & Persistence

```text
AutonomyPolicy
AutonomyRule
DedicatedComputeConfiguration
AgentReference
Delegation
PrivacyPreference
DataLocalityPreference
```

---

# 53. Models That Should NOT Be Recreated Locally

The Empower Humanity database should not create competing authoritative implementations of:

```text
AI Native Runtime RuntimeNode
Runtime Installation
Runtime Capability
Runtime Permission Grant
Runtime Execution
Runtime Job
Runtime Approval Request
Runtime Audit Record

AI Native Substrate Model
Model Provider
Model Route
AI Interaction Engine
Intelligence Routing Graph

Construct Context Context Package internals

Ensolam Being internals

Generative Reality Systems Reality Graph / GRL internals
```

Where application UX requires them, use:

* references,
* snapshots,
* read models,
* projections,
* cached summaries.

---

# 54. Event-Driven Integration Guidance

External infrastructure changes should generally enter Empower Humanity through integration events.

Example:

```text
runtime.execution.started
        ↓
Empower Humanity integration service
        ↓
ExecutionReference updated
        ↓
ActivityItem created
        ↓
UI receives update
```

Example:

```text
runtime.approval_required
        ↓
ApprovalProjection
        ↓
Notification
        ↓
Web / Mobile approval UX
```

Example:

```text
runtime.execution.completed
        ↓
ExecutionResultProjection
        ↓
ArtifactReference
        ↓
TaskResult
        ↓
ActivityItem
        ↓
Context / Reality update workflow
```

---

# 55. Correlation IDs

Cross-system workflows should preserve correlation.

Important correlation fields include:

```text
user_id
conversation_id
goal_id
task_id
ai_work_item_id
substrate_interaction_id
runtime_job_id
runtime_execution_id
correlation_id
```

Example:

```text
Human asks request
      ↓
Conversation Message
      ↓
Substrate Interaction
      ↓
Task
      ↓
AI Work Item
      ↓
Runtime Execution
      ↓
Artifact
```

A common correlation identifier should allow the system to reconstruct this chain.

---

# 56. Synchronization Rules

## Rule 1

Empower Humanity-owned objects use Empower Humanity persistence as source of truth.

## Rule 2

External infrastructure objects retain their external source of truth.

## Rule 3

Projection records should contain a `last_synced_at`.

## Rule 4

External IDs must not be silently rewritten.

## Rule 5

Temporary infrastructure unavailability should not destroy local product records.

## Rule 6

Event processing should be idempotent.

---

# 57. Deletion & Retention

Deletion semantics should vary by domain.

### User-owned application data

May support:

* archive,
* soft delete,
* permanent delete.

### Audit data

Retention should follow governance requirements.

### Runtime audit data

Runtime remains authoritative.

### External projections

Can be removed and reconstructed when possible.

### User memory/context

Deletion/forget requests must propagate to the actual authoritative context/memory system where required.

---

# 58. Privacy Modeling Principle

Data access and data awareness must remain separate.

For example:

```text
FileReference exists
```

does not imply:

```text
Co-Intelligence currently has permission to read file
```

Likewise:

```text
Person exists in user's Reality
```

does not imply permission to access all communications involving that person.

This distinction should remain explicit in schemas and services.

---

# 59. Temporal Modeling

Many Empower Humanity entities have meaningful time dimensions.

Prefer explicit fields such as:

```text
created_at
updated_at
started_at
completed_at
due_at
target_date
expires_at
last_seen_at
last_synced_at
```

Avoid trying to infer all lifecycle state from `updated_at`.

---

# 60. Status Modeling

Do not reuse one generic status enumeration across unrelated entities.

Examples:

### Goal

```text
draft
active
paused
blocked
completed
abandoned
```

### Execution

Owned by Runtime.

### AI Work Item

```text
queued
active
waiting_approval
waiting_dependency
completed
failed
cancelled
```

### Integration

```text
connected
degraded
disconnected
revoked
error
```

Domain-specific states should remain explicit.

---

# 61. Structured Metadata

Avoid using a generic JSON `metadata` column as a substitute for proper domain modeling.

Use metadata only for:

* forward-compatible supplemental fields,
* provider-specific values,
* non-query-critical data.

Anything frequently queried or behaviorally important should become a typed field or related model.

---

# 62. Search Modeling

Search indexing should cover at minimum:

```text
Conversations
Goals
Plans
Tasks
Projects
Decisions
Knowledge
Artifacts
People projections
Activity
```

Semantic search should reference embedding/vector infrastructure rather than embedding vector columns arbitrarily into every business table.

---

# 63. Mobile Synchronization Considerations

Mobile clients should receive compact API projections rather than full database entities.

Useful mobile read models include:

```text
TodayViewModel
ChatThreadSummary
GoalSummary
TaskSummary
AIWorkSummary
ApprovalSummary
NotificationSummary
DeviceSummary
```

Offline/mobile caches should not become independent sources of truth.

---

# 64. Web Read Models

The Web Application will benefit from composite read models.

Examples:

## TodayView

```text
greeting
priorities
upcoming_commitments
attention_items
recommendations
active_ai_work
recent_outcomes
goal_health
```

## WorkOverview

```text
my_tasks
ai_tasks
active_projects
active_plans
open_decisions
blockers
```

## DeviceOverview

```text
connected_devices
runtime_health
active_execution_count
pending_approval_count
dedicated_compute_summary
```

These should be API projections rather than frontend aggregation of dozens of individual calls.

---

# 65. Recommended Backend Aggregate Boundaries

Potential NestJS domain modules:

```text
IdentityModule
CoIntelligenceModule
ConversationModule
GoalsModule
PlanningModule
TasksModule
ProjectsModule
DecisionsModule
DailyIntelligenceModule
RecommendationsModule
KnowledgeModule
ActivityModule
NotificationsModule
IntegrationsModule
DevicesModule
AIWorkModule
GovernanceModule
AutonomyModule
PrivacyModule
SearchModule
EventsModule
```

Integration modules:

```text
EnsolamIntegrationModule
ConstructContextIntegrationModule
RealityIntegrationModule
AINativeSubstrateIntegrationModule
AINativeRuntimeIntegrationModule
IntelligenceCloudIntegrationModule
```

This prevents infrastructure SDK code from leaking throughout domain modules.

---

# 66. Canonical Aggregate Candidates

Strong aggregate roots include:

```text
UserAccount

PrimaryCoIntelligence

Conversation

Goal

Plan

Task

Project

Decision

KnowledgeItem

AIWorkItem

Integration

AutonomyPolicy
```

Entities such as `DecisionOption`, `PlanStep`, and `GoalMilestone` should generally be managed within their parent aggregate boundary.

---

# 67. Initial Data Model Implementation Sequence

Recommended implementation sequence:

```text
1. User / Profile

2. Co-Intelligence / Relationship

3. Preferences

4. Conversations / Messages

5. Goals

6. Tasks

7. Plans

8. Projects

9. Decisions

10. Daily Intelligence projections

11. Recommendations

12. Notifications / Activity

13. Integrations

14. Devices / Runtime references

15. AI Work / Execution references

16. Approvals / Permissions projections

17. Autonomy

18. Knowledge / Artifacts

19. Privacy

20. Event synchronization
```

This sequence allows the human-facing product to become usable before the complete execution fabric is integrated.

---

# 68. Initial Beta Data Model

A minimum credible beta should persist:

```text
UserAccount
UserProfile

PrimaryCoIntelligence
CoIntelligenceProfile
CoIntelligenceRelationship

Conversation
ConversationMessage
MessageAttachment

Goal
GoalMilestone

Task

Plan
PlanStep

Project

DailyIntelligenceSnapshot
DailyPriority
AttentionItem

Recommendation

Notification
ActivityItem

Integration

ConnectedDevice
RuntimeNodeReference

AIWorkItem
ExecutionReference
ApprovalProjection
ArtifactReference

UserPreference
AutonomyPolicy
```

This is sufficient to support the primary beta loop:

```text
Human
 ↓
Persistent Co-Intelligence
 ↓
Conversation
 ↓
Goal / Task / Plan
 ↓
AI Work
 ↓
Runtime Execution
 ↓
Result
 ↓
Activity / Notification
 ↓
Persistent Context
```

---

# 69. Data Model Invariants

## Invariant 1

Each Empower Humanity user has at most one active primary co-intelligence in the default Gen-5 experience.

---

## Invariant 2

The primary co-intelligence's canonical Being identity is externally referencable and should not be redefined independently by every application.

---

## Invariant 3

A Runtime Execution is not the same thing as an Empower Humanity Task or AI Work Item.

---

## Invariant 4

A Runtime Node is not the same thing as an Empower Humanity application device.

---

## Invariant 5

A Context Reference does not grant authority to the underlying resource.

---

## Invariant 6

A File Reference does not grant filesystem access.

---

## Invariant 7

An Agent identity does not itself imply execution authority.

---

## Invariant 8

Empower Humanity should never become the source of truth for Runtime permission decisions merely because it presents their UX.

---

## Invariant 9

External projections should preserve their source-system IDs.

---

## Invariant 10

Meaningful AI work should be correlated back to the user intent, task, conversation, or responsibility that caused it.

---

## Invariant 11

Generated artifacts should preserve lineage.

---

## Invariant 12

Human governance preferences must remain distinct from low-level effective Runtime authority.

---

# 70. Canonical Data Model Statement

> **The Empower Humanity AI data model represents the persistent human-facing reality of a person collaborating with one primary co-intelligence: their relationship, conversations, goals, plans, tasks, projects, decisions, knowledge, recommendations, delegated AI work, outcomes, preferences, and governance choices. Infrastructure realities such as model interactions, context packages, AI Being identity, Runtime Nodes, permissions, and executions remain canonically owned by their respective ecosystem systems and are integrated into Empower Humanity through stable references, projections, events, and user-facing read models.**

This separation allows Empower Humanity AI to maintain a coherent persistent experience without duplicating the foundational intelligence, context, identity, reality, or execution systems beneath it.
