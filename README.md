
# Multiple-GIT-Handler
A Powershell script to run multiple GIT repositories at once to help keep them in-line.

Any operation you might perform using GIT on one repository can be run on many.

Example

    git status

Equivalent

    aqgit status

If an action is taken on a file or folder then the application will attempt to run that on all repositories.

    aqgit add \path\file.js

This will add any changes to:

- \path\file.js
- \path\file.css
- \path\file.ts
- ...


  
