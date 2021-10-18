if get(b:, 'KustoCli_ftplugin_loaded', 0) | finish | endif
let b:KustoCli_ftplugin_loaded = 1

let g:KustoCli_cluster_conn_string = get(g:, 'KustoCli_cluster_conn_string', 'https://help.kusto.windows.net/Samples')

if !exists('g:KustoCli_executable_path')
    let g:KustoCli_executable_path = KustoCli#FindOrInstallLocalKustoCliExe()
endif

function! s:kustoquery(mods) abort
    try
        let a_save = @a
        silent! normal! "ayip
        let query_lines = split(@a, "\n")
        let temp_query_file = tempname()
        try
            call writefile(query_lines, temp_query_file)
            silent let query_results = systemlist(g:KustoCli_executable_path . ' "' . g:KustoCli_cluster_conn_string . '" -focus:true -banner:false -lineMode:false -script:"' . temp_query_file . '"')
            execute a:mods . ' new'
            setlocal nobuflisted buftype=nofile bufhidden=delete noswapfile nowrap
            call setline(1, query_results[2:])
        finally
            call delete(temp_query_file)
        endtry
    finally
        let @a = a_save
    endtry
endfunction

command! -buffer -complete=command KustoQuery call <SID>kustoquery('<mods>')
nnoremap <silent> <buffer> <S-CR> :bel KustoQuery<CR>

command! -bar -nargs=? KustoCliInstall call KustoCli#Install(<f-args>)
