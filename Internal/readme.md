# Codes that are only intended for internal usages

Please put all utils that are only intended for internal usages under this sub-directory.\
When shipping utils with your opensource project,
please check if your `fmri/utils.git` repo in on the branch `opensource`,
before packing the functions here into your opensource repo.\

`git checkout opensource` will automatically move all files under this directory into .git,
so they will not be included when packing for shipping.

As for usage scenarios, for example, utils that utilizes GE's private API's are unlikely to-be opensourceable.
You may also want to put in here the functions that has hardcoded lab computer directories into it.

