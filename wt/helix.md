1. [Helix Editor Setup](#helix-editor-setup)
2. [Config](#config)

---

# Helix Editor Setup

1. This is going to be the setup script for the helix editor which you use all the time

# Config

```rs
hx ~/.config/helix/config.toml
```

- This to edit the correct file

```rs
theme = "doom_acario_dark"

[editor]
true-color = true
cursorline = true
gutters = ["diagnostics","line-numbers"]

[editor.indent-guides]
render = true
character = "╎"

[editor.whitespace]
render = "all"
```
