if exists("g:loaded_GFMTabPlugin")
    finish
endif
let g:loaded_GFMTabPlugin = 1

function! s:GetNestedIndents()
    let l:rowNum = line(".")
    if l:rowNum == 1
        return 0
    endif

    let l:unorderListPattern = "^[ ]*[*-+]\\{1}[ ]\\+"
    let l:orderedListPattern = "^[ ]*[[:digit:]]\\+\\.[ ]\\+"
    let l:spacingLinePattern = "^[ ]*$"

    let l:col = col(".")

    while l:rowNum > 1
        let l:rowNum = l:rowNum - 1
        let l:line = getline(l:rowNum)

        let l:itemStartPos = matchend(l:line, l:unorderListPattern)
        if l:itemStartPos != -1
            return l:itemStartPos - l:col + 1
        else
            let l:itemStartPos = matchend(l:line, l:orderedListPattern)
            if l:itemStartPos != -1
                return l:itemStartPos - l:col + 1
            endif

            if l:line !~ l:spacingLinePattern
                return 0
            endif
        endif
    endwhile

    return 0
endfunction

function! s:GFMTab()
    let l:indents = <SID>GetNestedIndents()
    if l:indents <= 0
        return "\<Tab>"
    else
        return repeat(' ', l:indents)
    endif
endfunction

inoremap <leader><Tab> <C-R>=<SID>GFMTab()<CR>
