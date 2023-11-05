" Author: Guillaume Duranceau
" Description: Support for the Eclipse language server https://github.com/eclipse/eclipse.jdt.ls through jdtls

call ale#Set('java_jdtls_executable', '/opt/homebrew/bin/jdtls')
call ale#Set('java_jdtls_workspace_path', '')

function! ale_linters#java#jdtls#Executable(buffer) abort
    return ale#Var(a:buffer, 'java_jdtls_executable')
endfunction

function! ale_linters#java#jdtls#WorkspacePath(buffer) abort
    let l:wspath = ale#Var(a:buffer, 'java_jdtls_workspace_path')

    if !empty(l:wspath)
        return l:wspath
    endif

    return ale#path#Dirname(ale#java#FindProjectRoot(a:buffer))
endfunction

function! ale_linters#java#jdtls#Command(buffer) abort
    let l:executable = ale_linters#java#jdtls#Executable(a:buffer)
    let l:wsPath = ale_linters#java#jdtls#WorkspacePath(a:buffer)

    return ale#Escape(l:executable) . ' -data ' . ale#Escape(l:wsPath)
endfunction

call ale#linter#Define('java', {
\   'name': 'jdtls',
\   'lsp': 'stdio',
\   'executable': function('ale_linters#java#jdtls#Executable'),
\   'command': function('ale_linters#java#jdtls#Command'),
\   'language': 'java',
\   'project_root': function('ale#java#FindProjectRoot'),
\   'initialization_options': {
\     'extendedClientCapabilities': {
\       'classFileContentsSupport': v:true
\     }
\   }
\})
