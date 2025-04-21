{
    coredns = {
        ip = "10.1.1.99";
        nameservers = [ "1.1.1.1" "8.8.8.8" ];
        tags = [ "critical" "VM" ];
    };

    omni = {
        ip = "10.5.5.200";
    };
    
    docker = {
        ip = "10.1.1.90";
    };
}