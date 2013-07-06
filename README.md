# shorrt.app

This is a simplest app to run some application by using hotkey. Create a config
file `~/.shorrt` and fill it with configuration:

```
ctrl-cmd-i = app: iTunes
ctrl-cmd-' = app: Skype
```

As you can see, config is really simple: you have your hotkey with modifiers
(four of them: `ctrl`, `cmd`, `alt`, `shift`) and then action. Action has a type
and a payload, separated by `:`. Single action is available right now: `app`.

TODO:

 - key sequences (chords) - no idea how to do that :( HELP WANTED!
 - other types of action - request them!
