function fish_prompt
  set -l last_status $status
  set_color -o cyan
  echo -n -s (basename (prompt_pwd)) ' '
  set_color normal

  if not test -z (fish_git_prompt)
    echo -n -s (string trim --chars ')( ' (fish_git_prompt)) ' '
  end

  if test $last_status = 0
    set_color -o white
  else
    set_color -o magenta
  end
  echo -n '$ '
  set_color normal
end
