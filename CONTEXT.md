# Flutter Clean Architecture Starter

This context defines the project language for a Flutter portfolio repository whose purpose is to demonstrate senior-level architectural judgment.

## Language

**Reference Starter**:
A reusable Flutter project foundation that demonstrates production-shaped architecture through concrete app flows. It is meant to be studied, reused, and extended without treating the codebase as a one-off demo.
_Avoid_: Template-only project, architecture museum, screen demo

**Feature**:
A user-facing capability owned as a vertical area of the app. A **Feature** contains the concepts, workflows, and layer-specific code needed for that capability without depending on unrelated features.
_Avoid_: Screen, module, folder

**Project Management**:
The example product domain used by the **Reference Starter**. It covers organizing work into **Projects** and tracking the **Tasks** that move that work forward.
_Avoid_: Todo app, productivity demo

**Authentication**:
The capability that establishes who is using the app before they access **Projects** and **Tasks**. In this starter, **Authentication** is treated as a swappable boundary so the app can demonstrate session flow without being defined by a specific identity provider.
_Avoid_: Login screen, auth package, identity platform

**Session**:
The current authenticated access state for the person using the app. A **Session** determines whether the user can reach **Projects** and **Tasks**.
_Avoid_: Token, login flag, auth state

**Project**:
A container for related work with its own identity and task list. A **Project** can have many **Tasks**.
_Avoid_: Workspace, board, folder

**Task**:
A unit of work that can be tracked through completion. Every **Task** belongs to exactly one **Project** in the starter.
_Avoid_: Todo, item, card

**Architecture Boundary**:
A rule that keeps responsibilities separated so UI, business policy, data access, and external services do not collapse into each other. Boundaries are part of the project’s teaching value, not decorative structure.
_Avoid_: Folder convention, code style preference

**Data Flow**:
The path a user intent follows through the app and back to user-visible state. In this project, **Data Flow** must be clear enough for a new team member to trace without guessing where business decisions, API access, loading, and errors are handled.
_Avoid_: Callback chain, API call

**Senior Mindset**:
Architectural judgment that optimizes for maintainability, testability, onboarding, and safe feature growth. It is demonstrated by explicit trade-offs and disciplined boundaries rather than by adding patterns for their own sake.
_Avoid_: Advanced code, clever implementation

## Example Dialogue

Developer: “Should this starter be a generic template?”

Reviewer: “No. It should be a **Reference Starter**: reusable, but backed by real **Data Flow** and visible **Architecture Boundaries**.”

Developer: “So each new screen gets its own folder?”

Reviewer: “Not exactly. A **Feature** is a user-facing capability, not merely a screen. The folder structure should help the team add capabilities without damaging existing ones.”

Developer: “Is this just a todo app?”

Reviewer: “No. The domain is **Project Management**. A **Project** owns related work, and each **Task** represents one trackable unit of that work.”

Developer: “Can a **Task** exist without a **Project**?”

Reviewer: “No. In this starter, every **Task** belongs to exactly one **Project** so the domain stays sharper than a generic todo list.”

Developer: “Why include **Authentication** in a starter?”

Reviewer: “Because it gives the app a real boundary around who can access **Projects** and **Tasks**, without turning the project into an identity-system showcase.”

Developer: “Does **Authentication** mean Firebase, Supabase, or OAuth?”

Reviewer: “No. **Authentication** is a swappable boundary here. The starter needs clear **Session** behavior first, while providers can be exchanged behind that boundary.”
