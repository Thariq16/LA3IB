# Design Guidelines

This document serves as the **source of truth** for all UI/UX decisions in the LA3IB application. Every new screen and component must adhere to these principles.

## Core Principles

1.  **Minimalistic**: Less is more. Avoid clutter. Use whitespace effectively to guide the user's eye.
2.  **Modern**: Use current design trends (e.g., subtle shadows, rounded corners, clean typography) but ensure longevity.
3.  **Mobile-First**: Design for the smallest screen first. Ensure touch targets are accessible (min 44x44px).
4.  **UX-Focused**: Frictionless interactions are the priority. If a feature is hard to use, it is broken.

## Color System (Trust & Soothing)

The color palette is designed to build trust and provide a calm, welcoming environment.

### Light Mode
*   **Primary**: `#00A651` (KSA Green - Growth, Energy, Trust)
*   **Secondary**: `#2D3436` (Charcoal - Strong, Modern Text)
*   **Background**: `#F8F9FA` (Off-White - Soothing, clean)
*   **Surface**: `#FFFFFF` (White - Cards, Modals)
*   **Error**: `#E74C3C` (Soft Red)

### Dark Mode
*   **Primary**: `#2ECC71` (Lighter Green for contrast)
*   **Secondary**: `#DFE6E9` (Light Grey - Text)
*   **Background**: `#121212` (True Dark - Battery friendly)
*   **Surface**: `#1E1E1E` (Dark Grey - Cards)
*   **Error**: `#CF6679` (Desaturated Red)

## Typography

Use **Google Fonts: Inter**. It is clean, legible, and supports multiple weights.

*   **Headings**: Bold / Semi-Bold.
*   **Body**: Regular / Medium.
*   **Captions**: Regular (Greyed out).

## UI Components

*   **Uniformity**: All buttons, inputs, and cards must look consistent across the app.
*   **Buttons**: Rounded corners (e.g., `BorderRadius.circular(12)`). High contrast text.
*   **Inputs**: Clear borders, helpful placeholders, validation error states.
*   **Cards**: Subtle elevation (shadows) in Light Mode, lighter border/surface in Dark Mode.

## Accessibility

*   **Contrast**: Ensure text has sufficient contrast against backgrounds.
*   **Sizing**: No tap target smaller than 44px.
*   **Feedback**: Interactive elements must provide visual feedback on press/hover.
