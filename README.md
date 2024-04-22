# mesibo_sample_app

## Problem
we are facing an issue using the `mesibo.getGroupProfile` where it is Throwing a `Null check operator used on a null value` exception when fetching the group profiles and giving a wrong groupname.

steps to repoduce
1. start the app and click login.
2. see the error message in console.
## NOTE:
1. for groupId `3032044` it occurs everytime.
2. for groupId `3040939` it only throws the exception when we first start the app and click on login. if we click on login button again (which will stop and start mesibo again), it does not throw an exception but still gives wrong groupname.