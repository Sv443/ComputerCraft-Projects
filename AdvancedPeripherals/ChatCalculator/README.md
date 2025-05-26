## ChatCalculator
This program listens to chat messages with a certain prefix, evaluates the mathematical expression, and replies with the result.  
It can be used to quickly calculate simple math problems without having to open a calculator or use a website.  
Parentheses and order of operations are not supported. All operations are strictly done left to right.

<br>

### Usage:
Send a chat message with the prefix `!calc`, followed by a mathematical expression, e.g. `!calc 2 + 2 * 2`  
The supported operators are: `+`, `-`, `*`, `/`, `%`, `^` or `**`, `root` or `r`  
  
- Specify the number of the root after the operator, e.g. `!calc 1 + 8 root 2` for the square root of 9, which is 3
- The expression is always evaluated left to right, so `!calc 2 + 2 * 2` will yield `8`, not `6`

<br>

### Installation:
1. Craft a computer and chat box and place them next to each other
2. Run these commands:
```
label set ChatCalculator
pastebin get nRvyMz30 startup.lua
reboot
```
