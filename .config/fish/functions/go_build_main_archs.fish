function go_build_main_archs
    for dist in (go tool dist list)
        set -l pwd (pwd)
        set -l name (string split '/' $pwd -r -m1 -f2)
        set -l os (string split '/' $dist -f1)
        set -l arch (string split '/' $dist -f2)

        switch $os
        case linux darwin windows
            switch $arch
            case amd64 arm arm64
                set -l output (string join "_" $name $os $arch)
                set -l GOOS_BKP $GOOS
                set -l GOARCH_BKP $GOARCH
                set -x GOOS $os
                set -x GOARCH $arch

                go build -o $output main.go

                set -x GOOS $GOOS_BKP
                set -x GOARCH $GOARCH_BKP
            end
        end
    end
    for f in (fd windows)
        mv $f $f.exe
    end
end
