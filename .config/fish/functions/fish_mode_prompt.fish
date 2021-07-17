function fish_mode_prompt
  if test "$fish_key_bindings" = "fish_vi_key_bindings"
    switch $fish_bind_mode
      case default
        set_color --bold magenta
        echo '● '
      case replace_one
        set_color --bold green
        echo '● '
      case visual
        set_color --bold yellow
        echo '● '
    end
    set_color normal
  end
end
