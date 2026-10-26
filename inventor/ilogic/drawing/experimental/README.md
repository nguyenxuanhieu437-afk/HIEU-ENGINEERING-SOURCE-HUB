# HIEU Sync Sheet Name to Part Number — experimental

**Platform:** Autodesk Inventor 2025+; drawing `.idw` or Inventor `.dwg`.  
**Status:** Experimental, static source review only; not compiled or runtime-tested in Inventor.  
**Provenance:** Original iLogic rule created for the project owner's request on 2026-10-26. No third-party code included. Autodesk API documentation and CAD Forum are reference links only.  
**License:** No standalone open-source license granted; rights retained by owner.

## Behavior

For every drawing sheet, the rule finds the first Drawing View whose model reference resolves. It reads the referenced model's **Design Tracking Properties → Part Number** and attempts to rename that sheet accordingly. Sheets without views, unresolved models or blank Part Numbers are skipped. The code replaces some characters that are unsuitable in sheet names; therefore the result can differ from the literal Part Number. It does not edit model Part Number, title blocks or geometry.

The rule logs changed/unchanged/skipped/error counts. It is **not read-only**: it modifies drawing sheet names. If a name collides, Inventor's sheet-name constraints may cause an error, which the rule reports; collision behavior has not been tested. Where a sheet contains views from different models, the first resolvable view is used.

## Manual setup (recommended first)

1. Back up the drawing. Open it in Inventor.
2. Manage → iLogic → Add Rule, name it `HIEU_SYNC_SHEET_PARTNUMBER`.
3. Paste the complete [source](HIEU_SYNC_SHEET_PARTNUMBER.iLogicVb) into the rule, save and run.
4. Review the report and sheet names before saving the drawing.

## Optional Before Save trigger

Change `Const SHOW_REPORT As Boolean = True` to `False` to avoid popups. In **iLogic → Event Triggers → This Document**, attach the rule to **Before Save Document**. Test on a copy first. Event triggers can rename sheets whenever the drawing is saved.

## Verification and limitations

- Source integrity: SHA-256 in [SOURCE_MANIFEST.json](SOURCE_MANIFEST.json).
- Source was also distributed as a ZIP in Library; the ZIP's embedded `.iLogicVb` is byte-identical. The duplicate ZIP is **not** published.
- Static checks: no embedded tokens, private keys, absolute user paths, network calls or shell execution patterns found.
- Inventor API compilation, duplicate-name behavior, drawing Model States/iParts and Before Save behavior **not tested**.
- The script has no version declaration; do not treat this archive as a released product.

## API references (documentation only)

- https://help.autodesk.com/cloudhelp/2023/ENU/Inventor-API/files/Sheet_Name.htm
- https://help.autodesk.com/cloudhelp/2026/ENU/Inventor-iLogic/files/GUID-B14A47F4-81D2-4627-A973-2BC7F790DF89.htm
