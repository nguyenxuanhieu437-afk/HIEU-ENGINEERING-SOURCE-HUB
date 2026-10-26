# Inventor iLogic — K-Factor Reference Diagnostic

**Status:** experimental · **Date:** 2026-10-26 · **Inventor runtime test:** NOT PERFORMED.

## Purpose
Read-only audit of an Inventor assembly's referenced-document descriptors. Counts resolved, suppressed and genuinely missing links, avoiding the mistake of treating every suppressed occurrence as a missing file. It does **not** modify any Inventor model.

## Usage
Open an assembly (.iam) in Autodesk Inventor, add `KFactor_REFERENCE_DIAGNOSTIC.iLogicVb` as an iLogic rule and run it. It writes a local `KFactor_Reference_Audit_YYYYMMDD_HHMMSS.txt` beside the assembly, or in the system temporary folder if necessary. Inspect the report locally; **do not upload it** without removing confidential absolute paths and project identifiers.

## Provenance and scope
Commissioned by the repository owner and generated as a separate diagnostic rule on 2026-10-26. This file contains no bundled Autodesk or third-party source. Static inspection found no embedded credentials or hard-coded private paths. The Inventor API compile/runtime behavior and reference completeness have **not** been verified on a test assembly; do not describe it as production-ready.

The separate K-factor setter variants (original, FIXED and V2) are **not published** here: their upstream authorship and redistribution rights require clearance. No license is granted for third-party source by this repository.

See `SOURCE_MANIFEST.json` for SHA-256 and audit status.
