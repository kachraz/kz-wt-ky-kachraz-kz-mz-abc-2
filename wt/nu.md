# Installation of starship with nushell

Step 1

```rs
hx $nu.env-path
```

then add

```rs
mkdir ~/.cache/starship
starship init nu | save ~/.cache/starship/init.nu
```

After doing this we have to make sure that it gets sourced by nushell.

Step 2

```rs
hx $nu.config-path
```

Then

```rs
starship preset pure-preset > ~/.config/starship.toml
```

- Some times there can be problems with this method.
- So dont add it , and just source it every time

Step 3

```rs
source ~/.cache/starship/init.nu
```
