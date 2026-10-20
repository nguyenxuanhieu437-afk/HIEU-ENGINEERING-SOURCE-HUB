# Source onboarding & release policy

Use a subfolder for each tool family, preserving the original file name. Each imported file must have a recorded source, SHA-256, date, owner and a status: `legacy`, `experimental`, `candidate`, or `released`.

For Inventor iLogic, document Inventor version, rule type, required references, test assembly/part and compile status. For LISP, document AutoCAD version, command names and `APPLOAD` instructions.

Before public commits: scan for tokens and private paths; review copyright; exclude confidential drawings and vendor models. Remove secrets from Git history if accidentally published and revoke compromised credentials immediately.

Use GitHub topics for lookup (inventor, ilogic, autocad, autolisp, tekla, engineering-automation, bom, dstv). Create version tags only after testing; tags are not periodic indexing markers.
