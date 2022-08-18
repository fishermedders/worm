# worm

Ever been in computercraft and thought to yourself

> "I would really like an archaic but tried and true way to boot facelifted scripts that most folks call operating systems!"

Well, if you are one of 2 people on planet earth that has wanted to do that, you're in luck

![Screenshot of the shite bootloader](https://i.imgur.com/vSUJFtV.png)

## actually using it (why)
If you actually want to use it as a bootloader, make it your startup file
I'm not judging you for wanting to use it, it's a working bootloader, and furthermore, cash money!!!

## configuration
One first run it will generate a config file under `/.worm/config`.

Under the boot section, just edit the first part of each table to be the text shown on screen, and the second to the command (with or without arguments) that you'd like to run.

Example:
```lua
["boot"]={
    {"Art Class (man I hated art class)","paint fridge_picture"},
    {"It's 4am get off minecraft", "shutdown"}
}
```

If you absolutely hate configs and want to have the suckless experience, edit line 5 from `useConfig = true` to `useConfig = false`. It will no longer generate a config and you're free to modify the program in any way you like to have the most optimal riced experience.
Or as the [license](https://github.com/fishermedders/worm/blob/main/LICENSE) says, "DO WHAT THE FUCK YOU WANT TO"

grub -> larve -> __**worm**__
(get it?)
