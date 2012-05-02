if !exists('g:VPMapKeys')
   let g:VPMapKeys = 1
endif

if !exists('g:VPMapPrefix')
   let g:VPMapPrefix = '<leader>v'
endif

if !exists('g:VPModuleListName')
   let g:VPModuleListName = "ModuleList"
endif

if !exists('g:VPResponseStart')
   let g:VPResponseStart = "/home"
endif

if g:VPMapKeys
   execute "autocmd FileType verilog" "nnoremap <buffer>" g:VPMapPrefix."f" ":VPSignalSearch<CR>"
   execute "autocmd FileType verilog" "nnoremap <buffer>" g:VPMapPrefix."d" ":VPDefineSearch<CR>"
   execute "nnoremap <script> <silent> <unique>" g:VPMapPrefix."w" ":VPModuleList<CR>"
   execute "nnoremap <script> <silent> <unique>" g:VPMapPrefix."m" ":VPModuleSearch<CR>"
   execute "autocmd FileType verilog" "nnoremap <buffer>" g:VPMapPrefix."j" ":VPJumpOneLevel<CR>"
endif

command! VPSignalSearch :call verparse#VPSignalSearch()
command! VPDefineSearch :call verparse#VPDefineSearch()
command! VPModuleSearch :call verparse#VPModuleSearch()
command! VPModuleList :call verparse#VPModuleList()
command! VPJumpOneLevel :call verparse#VPJumpOneLevel()
