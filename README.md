# shorrt.app

[Download](https://github.com/piranha/shorrt/releases/1.0/2048/shorrt.zip).

This is the simplest app to run some application by using hotkey. Create a
config file `~/.shorrt` and fill it with configuration:

```
ctrl-cmd-i = app: iTunes
ctrl-cmd-' = app: Skype
```

As you can see, config is really simple: you have your hotkey with modifiers
(four of them: `ctrl`, `cmd`, `alt`, `shift`) and then action. Action has a type
and a payload, separated by `:`. Single action is available right now: `app`.

## OS X 10.9 Mavericks

To make shorrt work in Mavericks, go to `System Preferences` -> `Security & Privacy`
-> `Privacy` -> `Accessibility` and put a checkbox there for shorrt. You may
have to run it to show up there.

## TODO

 - key sequences (chords) - no idea how to do that :( HELP WANTED!
 - other types of action - request them!
