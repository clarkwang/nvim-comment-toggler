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

See the [demo video][demo].

[demo]: https://github.com/clarkwang/nvim-comment-toggler/issues/1
