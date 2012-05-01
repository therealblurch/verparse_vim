if !exists ("g:VPPreCommand")
   let g:VPPreCommand = ""
endif
if !exists ("g:VPTop")
   let g:VPTop = "test"
endif

function! s:VPModuleListOpen(new_win)
   let split_win = a:new_win

   if !split_win && &modified
      let split_win = 1
   endif

   let scr_bufnum = bufnr(g:VPModuleListName)
   if scr_bufnum == -1
      if split_win
         exe "new " . g:VPModuleListName
      else
         exe "edit " . g:VPModuleListName
      endif
   else
      let scr_winnum = bufwinnr(scr_bufnum)
      if scr_winnum != -1
         if winnr() != scr_winnum
            exe scr_winnum . "wincmd w"
         endif
      else
         if split_win
            exe "split +buffer" . scr_bufnum
         else
            exe "buffer " . scr_bufnum
         endif
      endif
   endif
endfunction

function! s:VPModuleMarkBuffer()
   setlocal buftype=nofile
   setlocal bufhidden=hide
   setlocal noswapfile
   setlocal buflisted
endfunction

autocmd BufNewFile ModuleList call s:VPModuleMarkBuffer()

function! verparse#VPSignalSearch()
   let s:VPWordUnderCursor = expand("<cword>")
   let s:VPCurrFile = expand('%:p')
   let s:VPCmd = g:VPPreCommand . ";verparse -t signal -f " . s:VPCurrFile . " -s " . s:VPWordUnderCursor
   let s:VPOutputTemp = system(s:VPCmd)
   let s:VPOutput = strpart (s:VPOutputTemp, 0, strlen(s:VPOutputTemp)-1)
   let s:VPLastSpace = strridx(s:VPOutput, " ")
   let s:VPSpace2 = strridx(s:VPOutput, " ", s:VPLastSpace-1)
   let s:VPPathStart = strridx(s:VPOutput, g:VPResponseStart)
   let s:VPTargetFile = strpart(s:VPOutput,s:VPPathStart,s:VPSpace2-s:VPPathStart)
   let s:VPLine = str2nr(strpart(s:VPOutput,s:VPSpace2+1,s:VPLastSpace-s:VPSpace2))
   let s:VPTargetName = strpart(s:VPOutput,s:VPLastSpace+1,strlen(s:VPOutput)-s:VPLastSpace-1)
   silent exec "edit " . s:VPTargetFile
   call cursor(s:VPLine, 0)
   call search(s:VPTargetName)
endfunction

function! verparse#VPModuleSearch()
   let s:VPWordUnderCursor = expand("<cword>")
   let s:VPCurrFile = expand('%:p')
   let s:VPCmd = g:VPPreCommand . ";verparse -t module " . " -s " . s:VPWordUnderCursor
   let s:VPOutputTemp = system(s:VPCmd)
   let s:VPOutput = strpart (s:VPOutputTemp, 0, strlen(s:VPOutputTemp)-1)
   let s:VPLastSpace = strridx(s:VPOutput, " ")
   let s:VPPathStart = strridx(s:VPOutput, g:VPResponseStart)
   let s:VPTargetFile = strpart(s:VPOutput,s:VPPathStart,s:VPLastSpace-s:VPPathStart)
   let s:VPLine = str2nr(strpart(s:VPOutput,s:VPLastSpace+1,strlen(s:VPOutput)-s:VPLastSpace-1))
   silent exec "edit " . s:VPTargetFile
   call cursor(s:VPLine, 0)
endfunction

function! verparse#VPDefineSearch()
   let s:VPWordUnderCursor = expand("<cword>")
   let s:VPCurrFile = expand('%:p')
   let s:VPCmd = g:VPPreCommand . ";verparse -t define " . " -s " . s:VPWordUnderCursor
   let s:VPOutput= system(s:VPCmd)
   let s:VPPathStart = strridx(s:VPOutput, g:VPResponseStart)
   let s:VPDefine = strpart(s:VPOutput, s:VPPathStart,strlen(s:VPOutput)-s:VPPathStart)
   echo s:VPDefine
endfunction

function! verparse#VPModuleList()
   let s:VPCmd = g:VPPreCommand . ";verparse -t module_list"
   let s:VPOutputTemp = system (s:VPCmd)
   let s:VPOutput = strpart (s:VPOutputTemp, stridx (s:VPOutputTemp, "* " . g:VPTop))
   let s:VPList = split (s:VPOutput, " 0 ")
   call s:VPModuleListOpen(0)
   setlocal nowrap
   setlocal modifiable
   call cursor(1,1)
   exec 'silent! normal! "_dG'
   call setline (1,s:VPList)
   setlocal nomodifiable
endfunction

function! verparse#VPJumpOneLevel()
   let s:VPCurrFile = expand('%:p')
   let s:VPCmd = g:VPPreCommand . ";verparse -t up -f " . s:VPCurrFile
   let s:VPOutputTemp = system(s:VPCmd)
   let s:VPOutput = strpart (s:VPOutputTemp, 0, strlen(s:VPOutputTemp)-1)
   let s:VPLastSpace = strridx(s:VPOutput, " ")
   let s:VPLastReturn = strridx(s:VPOutput, "\n")
   let s:VPReturn2 = strridx(s:VPOutput, "\n", s:VPLastReturn-1)
   let s:VPTargetFile = strpart(s:VPOutput,s:VPReturn2+1,s:VPLastSpace-s:VPReturn2)
   let s:VPLine = str2nr(strpart(s:VPOutput,s:VPLastSpace+1))
   silent exec "edit " . s:VPTargetFile
   call cursor(s:VPLine, 0)
endfunction

