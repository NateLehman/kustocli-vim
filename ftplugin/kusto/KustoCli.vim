if get(b:, 'KustoCli_ftplugin_loaded', 0) | finish | endif
let b:KustoCli_ftplugin_loaded = 1

let g:KustoCli_cluster_conn_string = get(g:, 'KustoCli_cluster_conn_string', 'https://help.kusto.windows.net/Samples;Fed=true')

if !exists('g:KustoCli_executable_path')
    let g:KustoCli_executable_path = KustoCli#FindOrInstallLocalKustoCliExe()
endif

function! s:kustoquery(mods) abort
    try
        let l:a_save = @a
        silent! normal! "ayip
        let l:query = split(@a, "\n")
        let l:input_filename = tempname()
        try
            call writefile(l:query, l:input_filename)
            let l:command = printf(
                        \ '%s %s -focus:true -banner:false -lineMode:false -script:%s',
                        \ g:KustoCli_executable_path,
                        \ g:KustoCli_cluster_conn_string->shellescape(),
                        \ l:input_filename->shellescape())
            silent let l:results = systemlist(l:command)
            if has('win32')
                " remove trailing <CR> from cmd output
                let l:results = l:results->map({_, val -> val[:-2]})
            endif
            execute a:mods . ' new'
            setlocal nobuflisted buftype=nofile bufhidden=delete noswapfile nowrap
            call setline(1, l:results[2:])
        finally
            call delete(l:input_filename)
        endtry
    finally
        let @a = l:a_save
    endtry
endfunction

command! -buffer -complete=command KustoQuery call <SID>kustoquery('<mods>')
nnoremap <silent> <buffer> <S-CR> :bel KustoQuery<CR>

command! -bar -nargs=? KustoCliInstall call KustoCli#Install(<f-args>)
