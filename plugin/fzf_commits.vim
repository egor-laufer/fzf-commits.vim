" Global settings
let g:fzf_commits_git_bin = get(g:, 'fzf_commits_git_bin', 'git')
let g:fzf_commits_git_options = get(g:, 'fzf_commits_git_options', '')
let g:fzf_commits_previous_ref_first = get(g:, 'fzf_commits_previous_ref_first', v:true)
let g:fzf_commits_merge_settings = get(g:, 'fzf_commits_merge_settings', v:true)

let s:commit_actions = {
      \ 'checkout': {
      \   'prompt': 'Checkout> ',
      \   'execute': 'echo system("{git} checkout {commit}")',
      \   'multiple': v:false,
      \   'keymap': 'enter',
      \   'required': ['commit'],
      \   'confirm': v:false
      \ },
      \ 'branch': {
      \   'prompt': 'Create branch> ',
      \   'execute': 'echo system("{git} branch {input} {commit}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-n',
      \   'required': ['input', 'commit'],
      \   'confirm': v:false,
      \ },
      \ 'tag': {
      \   'prompt': 'Create tag> ',
      \   'execute': 'echo system("{git} tag {input} {commit}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-n',
      \   'required': ['input', 'commit'],
      \   'confirm': v:false,
      \ },
  \}

let s:branch_actions = {
      \ 'checkout': {
      \   'prompt': 'Checkout> ',
      \   'execute': 'echo system("{git} checkout {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'enter',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'alt-enter',
      \   'required': ['branch'],
      \   'confirm': v:false,
      \ },
      \ 'create': {
      \   'prompt': 'Create> ',
      \   'execute': 'echo system("{git} checkout -b {input}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-n',
      \   'required': ['input'],
      \   'confirm': v:false,
      \ },
      \ 'delete': {
      \   'prompt': 'Delete> ',
      \   'execute': 'echo system("{git} branch -D {branch}")',
      \   'multiple': v:true,
      \   'keymap': 'ctrl-d',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \ 'merge':{
      \   'prompt': 'Merge> ',
      \   'execute': 'echo system("{git} merge {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-e',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \ 'rebase':{
      \   'prompt': 'Rebase> ',
      \   'execute': 'echo system("{git} rebase {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-r',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \}

let s:tag_actions = {
      \ 'checkout': {
      \   'prompt': 'Checkout> ',
      \   'execute': 'echo system("{git} checkout {tag}")',
      \   'multiple': v:false,
      \   'keymap': 'enter',
      \   'required': ['tag'],
      \   'confirm': v:false,
      \ },
      \ 'create': {
      \   'prompt': 'Create> ',
      \   'execute': 'echo system("{git} tag {input}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-n',
      \   'required': ['input'],
      \   'confirm': v:false,
      \ },
      \ 'delete': {
      \   'prompt': 'Delete> ',
      \   'execute': 'echo system("{git} branch -D {tag}")',
      \   'multiple': v:true,
      \   'keymap': 'ctrl-d',
      \   'required': ['tag'],
      \   'confirm': v:true,
      \ },
      \}

if g:fzf_commits_merge_settings
  for [s:action, s:value] in items(get(g:, 'fzf_commit_actions', {}))
    if has_key(s:commit_actions, s:action)
      call extend(s:commit_actions[s:action], s:value)
    else
      let s:commit_actions[s:action] = s:value
    endif
  endfor

  for [s:action, s:value] in items(get(g:, 'fzf_branch_actions', {}))
    if has_key(s:branch_actions, s:action)
      call extend(s:branch_actions[s:action], s:value)
    else
      let s:branch_actions[s:action] = s:value
    endif
  endfor

  for [s:action, s:value] in items(get(g:, 'fzf_tag_actions', {}))
    if has_key(s:tag_actions, s:action)
      call extend(s:tag_actions[s:action], s:value)
    else
      let s:tag_actions[s:action] = s:value
    endif
  endfor

  let g:fzf_commit_actions = s:commit_actions
  let g:fzf_branch_actions = s:branch_actions
  let g:fzf_tag_actions = s:tag_actions
else
  let g:fzf_commit_actions = get(g:, 'fzf_commit_actions', s:commit_actions)
  let g:fzf_branch_actions = get(g:, 'fzf_branch_actions', s:branch_actions)
  let g:fzf_tag_actions = get(g:, 'fzf_tag_actions', s:tag_actions)
endif


let s:prefix = get(g:, 'fzf_command_prefix', '')

let s:commit_command = s:prefix . 'GCommits'
let s:branch_command = s:prefix . 'GBranches'
let s:tag_command = s:prefix . 'GTags'
execute 'command! -bang -nargs=* -complete=custom,fzf_commits#complete_commits ' . s:commit_command . ' call fzf_commits#list(<bang>0, "commit", <q-args>, v:false)'
execute 'command! -bang -nargs=* -complete=custom,fzf_commits#complete_branches ' . s:branch_command . ' call fzf_commits#list(<bang>0, "branch", <q-args>, v:false)'
execute 'command! -bang -nargs=? -complete=custom,fzf_commits#complete_tags ' . s:tag_command . ' call fzf_commits#list(<bang>0, "tag", <q-args>, v:false)'
