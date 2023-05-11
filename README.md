# Setup

Example:

~~~
require'comment-toggler'.setup{
    default_key = '#',
    filetypes = {
        c = {
            marker = '//',
        },
        lua = {},
        python = {},
        sh = {},
        tmux = {},
        vim = { key = '"' }
        yaml = {},
    },
}
~~~

# How it works

## Example 1

For example I have this `foo.sh`:

~~~
if cond; then
    A
    B
    C; if cond; then
        D
    fi; E
    F
fi; G
~~~

Say I want to comment out line `B`, `C`, `D` and `E`. I'll move cursor to under `B` and press `#` for 4 times (or `4#`) and it'll become this:

~~~
if cond; then
    A
   #B
   #C; if cond; then
   #    D
   #fi; E
    F
fi; G
~~~

and now the cursor is under `F`.

Then, I want to uncomment line `C`, `D`, `E` and comment out line `F`. I'll move cursor to under `C` and press `#` for 4 times (or `4#`) and it'll become this:

~~~
if cond; then
    A
   #B
    C; if cond; then
        D
    fi; E
   #F
fi; G
~~~

and now the cursor is under `G`.
