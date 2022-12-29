function sextou
    for name in ezz boteco
        if not type -q $name
            echo "$name not installed"
            return 1
        end
    end

    boteco (ezz --name Boteco --on Friday --at 17:00 --timezone America/Sao_Paulo --duration 480 --password 42)
end

