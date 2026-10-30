# TST_DIM_PROJECTED_SAFE — Inventor iLogic (experimental)

**Status:** Experimental source archive; static audit only. No Inventor 2025/2027 compile or runtime acceptance test has been performed.

**Provenance:** Original model-generated, user-commissioned iLogic source archived from the owner's Library (2026-10-30). No third-party source included. Ownership of model drawings used with the rule is separate.

## Behavior

- Works on Inventor IDW/DWG drawing documents.
- Default scope is **active sheet only** (`ALL_SHEETS = False`); can optionally process all sheets.
- For nonstandard-isometric drawing views, changes `GeneralDimensionType` to **Projected** for subsequently created dimensions.
- Audits existing True, overridden and hidden-value general dimensions. **It does not replace, delete or convert existing dimensions.**
- Writes a local audit text file in the OS temporary folder; does not save the drawing automatically and does not show popups.

**Important:** Projected sheet-plane measurements can differ from true 3D geometry lengths. Changing a drawing view's dimension setting can affect future dimensions. Back up the drawing and review the intended manufacturing measurement against the 3D model before use.

## Use on a test drawing

1. Back up an IDW/DWG and open the copy in Inventor 2025 or 2027.
2. In Manage → iLogic, add an external rule and paste [the complete source](TST_DIM_PROJECTED_SAFE.iLogicVb).
3. Run manually. Inspect the view settings and the audit at `%TEMP%\TST_DIM_PROJECTED_SAFE_AUDIT.txt`.
4. Confirm every dimension and projection against the model before applying to production drawings. Do not attach to Event Triggers until acceptance-tested.

## Source integrity and QA

- SHA-256: `1cfe2f7d75a99bee4e131964cb119c616c8c0ab09b2c9178daad90d1edf33132` (7,598 bytes; UTF-8, LF).
- `TST_DIM_PROJECTED_SAFE(1).iLogicVb` is byte-identical to the canonical Library file; duplicate omitted.
- Static pattern scan found no hard-coded credentials, personal paths, network calls or shell execution. The rule writes a local report and modifies view defaults; this is **not a read-only rule**.
- **Not verified:** Inventor API compile, event triggers, drawing view edge cases, 3D geometry accuracy, manufacturing acceptance.
- No release tag. No standalone open-source license is granted; owner retains rights.

The more invasive `TST_DIM_AUTO_FIX_GLOBAL.iLogicVb`, which can recreate and delete existing dimensions, is **not included** pending Inventor testing and an explicit release review.
