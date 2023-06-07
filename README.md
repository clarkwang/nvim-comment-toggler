[packer.nvim]: https://github.com/wbthomason/packer.nvim
[lazy.nvim]: https://github.com/folke/lazy.nvim

# How it works

See the [demo video][demo].

[demo]: https://github.com/clarkwang/nvim-comment-toggler/issues/1

# Install/setup

## Example with [packer.nvim]

~~~
use { 'clarkwang/nvim-comment-toggler',
    config = function()
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
                yaml = {},
            },
        }
    end,
}
~~~

## Example with [lazy.nvim]

~~~
plugins = {
    ...

    { 'clarkwang/nvim-comment-toggler',
        opts = {
            default_key = '#',
            filetypes = {
                c = {
                    marker = '//',
                },
                lua = {},
                python = {},
                sh = {},
                tmux = {},
                yaml = {},
            },
        },
    }
    
    ...
}

require'lazy'.setup(plugins, { lazy.nvim opts here })
~~~

## Manual

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
