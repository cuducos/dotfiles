function pihole
    set help "Usage: pihole <enable|disable>"

    if test (count $argv) -ne 1
        echo $help
        return 1
    end

    set dns
    switch $argv[1]
    case enable
        set dns "10.0.0.101"
    case disable
        set dns "Empty"
    case '*'
        echo $help
        return 1
    end

    for interface in (networksetup -listallnetworkservices | rg "(Wi-Fi|Ethernet)")
        networksetup -setdnsservers $interface $dns
    end
end
