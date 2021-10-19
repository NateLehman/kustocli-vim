# kustocli-vim
a kusto vim plugin

![screenshot-of-kustocli-vim](https://github.com/NateLehman/kustocli-vim/blob/25fc1101732304cf8a5e069890bcbfc05408c228/media/kustocli-vim.example.png)

## Background
The goal of this plugin is to provide a kusto query authoring experience native to VIM. This plugin does 2 distinct things so far

1. Provides syntax highlighting for the kusto query/command language. These files are recognized with the extensions `.kql`, `.csl`, and `.kusto`
2. Provides commands and shortcuts to send and recieve the results of queries being written.

## Requirements
This project is built on and tested with VIM version 8.2 but that might not be a hard requirement.

## Installation
Install the Vim plugin using your preferred plugin manager:

| Plugin Manager                                       | Command                                                                              |
|------------------------------------------------------|--------------------------------------------------------------------------------------|
| [Vim-plug](https://github.com/junegunn/vim-plug)     | `Plug 'NateLehman/kustocli-vim'`                                                     |
| [Vundle](https://github.com/gmarik/vundle)           | `Bundle 'NateLehman/kustocli-vim'`                                                   |
| [NeoBundle](https://github.com/Shougo/neobundle.vim) | `NeoBundle 'NateLehman/kustocli-vim'`                                                |

... or git:

| ['runtimepath'](http://vimhelp.appspot.com/options.txt.html#%27runtimepath%27) handler | Command                                            |
|------------------------------------------------------|--------------------------------------------------------------------------------------|
| [Vim 8.0+ Native packages](http://vimhelp.appspot.com/repeat.txt.html#packages) | `$ git clone git://github.com/NateLehman/kustocli-vim ~/.vim/pack/plugins/start/kustocli-vim` |
| [Pathogen](https://github.com/tpope/vim-pathogen)    | `$ git clone git://github.com/NateLehman/kustocli-vim ~/.vim/bundle/kustocli-vim`     |

If not using a plugin manager such as Vim-plug (which does this automatically), make sure your .vimrc contains these lines:

```vim
filetype indent plugin on
syntax enable
```

## Usage
The plugin is designed to work very similarly to [Kusto.Explorer](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/tools/kusto-explorer). Kusto query commands and syntax highlighting will activate when a `kusto` file type is opened, or when the filetype is set to `kusto` within VIM (by using `:set filetype=kusto`).

### How to Run a Query
1. Be in normal mode.
2. Hover the cursor over the paragraph you wish to send as a query.
3. Press `shift`+`enter`. You may need to wait while the query completes. A new scratch window should open up with the output of the query.

If you'd like to be more flexible with where the window opens for your query results. You can use the underlying command `:KustoQuery` which also works with [`<mods>`](https://vimhelp.org/map.txt.html#%3Cmods%3E). For example, `shift`+`enter` maps to:

```vim
:bel KustoQuery
```
## Setup
### Connection String
The [connection string](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/api/connection-strings/kusto) used for the kusto cluster can be set with
```vim
" add this to your .vimrc to point queries at your preferred kusto cluster
:let g:KustoCli_cluster_conn_string = "<my-cluster-connection-string>"
```
It is very important that you add this to your vimrc to access your desired cluster. By default, the connection string is set to the [_Samples_ database referenced by the kusto documentation](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/samples?pivots=azuredataexplorer), so you can test out the plugin by copy-pasting queries from the documentation.

### `Kusto.Cli.exe` Install location
You may define a path to the [Kusto.Cli.exe](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/tools/kusto-cli) you have installed with:
```vim
:let g:KustoCli_executable_path="C:\<path-to>\Kusto.Cli.exe"
```
Otherwise, upon first loading a `.kusto` file or setting the filetype to `kusto`, the plugin will automatically download and cache the most recent version of the Kusto CLI from its [official source](https://www.nuget.org/packages/Microsoft.Azure.Kusto.Tools/).
