let s:plugin_root_dir = expand('<sfile>:p:h:h')
let s:kusto_cli_exe = 'kusto.cli.exe'

function! KustoCli#FindOrInstallLocalKustoCliExe(...) abort
    let l:kusto_cli_path = s:plugin_root_dir . '\bin\KustoTools\tools\' . s:kusto_cli_exe
    if !executable(l:kusto_cli_path)
        call KustoCli#Install()
    endif
    return l:kusto_cli_path
endfunction

function! KustoCli#Install(...) abort
    echo 'Installing Kusto.Cli, please wait...'

    let l:logfile = s:plugin_root_dir . '\installer\install.log'
    let l:script = shellescape(
                \ s:plugin_root_dir . '\installer\kustotools-installer.ps1')
    let l:command = printf(
                \ 'powershell -ExecutionPolicy Bypass -File %s',
                \ l:script)

    let l:error_msgs = systemlist(l:command)

    if v:shell_error
        call writefile(['> ' . l:command, repeat('=', 80)], l:logfile)
        call writefile(l:error_msgs, l:logfile, 'a')

        echohl ErrorMsg
        echomsg 'Failed to install Microsoft.Azure.Kusto.Tools'

        echohl WarningMsg
        echomsg 'The full error logs can be found in the file: ' l:logfile
        echohl None
    else
        echohl Title
        echomsg printf('Microsoft.Azure.Kusto.Tools installed')
        echohl None
    endif
endfunction
