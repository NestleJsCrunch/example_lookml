# Readme

Descrip: This LookML project provides a set of basic examples for common use cases, in an interactive environment.
Author: ldap `jamesnestler@` | github `NestleJsCrunch` | slack `@jimmyjames`

## What can I do in this environment?

- Test code in dev mode
- Test explores in both prod and dev mode
- (Coming Soon), Test Looks and Dashboards in prod and dev mode

## How does this work?

- This project is configured with a read only deploy key, so no code can be committed or deployed. See FAQs for more information.
- The project is structured thusly:
  - The `models` folder contains all LookML models. Each model follows the naming convention `<view_folders>.md`
    - Each model maps to a specific use case of Looker
    - Each model will contain at least one explore
  - The `base_views` folder contains a set of view files that are re-used throughout the rest of the project
    - Views within `base_views` are frequently [extended](https://docs.looker.com/data-modeling/learning-lookml/extends) into other views
  - Other folders will each map to a specific use case and a specific model in the models folder.
    - Folder will contain a readme document. The name of the readme document will follow the convention `<folder_name>_readme`
    - The readme document will list and explain the function of other files within the folder
  - The `manifest.lkml` file contains project level settings as well as a list of constants
    - [LookML Constants](https://docs.looker.com/reference/manifest-params/constant) defined in the manifest are frequently used throughout the project, including table names.
    - For a description of what a manifest is, [see](https://docs.looker.com/reference/manifest-reference)


## Bugs and Feature Requests

Bugs = Code is broken, or does not work as intended.
Feature Request = A request for additional functionality.

To report a bug, please file an issue against the Github repo and include the following information:
- The instance you experienced the issue on (eg, lookerv216.looker.com, lookerv214.looker.com, etc)
- A link to or a description of the specific place where you experienced the issue
- A screenshot of the issue (if possible), and/or a detailed description of the issue itself
- Your LDAP and date you experienced the issue. Please also add the `Bug` tag

To make a Feature Request, please file an issue against the Github repo and include the following information:
- A description of what you would like implemented
- Detail about why implementing would be useful
- Your LDAP. Please add the tag `Feature Request`


## FAQs

- "I'm lost, where do I start?"

(See the index file for a list of folders and what each folder covers)

- "Help! I made changes and I don't want to keep them anymore. What do I do?"

(Revert Changes)

- "I tried committing and received an error, is this expected?"

(Read only deploy key)

- "Can I share this code with customers?"

(Yes, but this is not official so don't promise any guarantee or warantee)

- "How does <x piece of code> work?

(Readme, Resource Rainbow, Asking good questions)
