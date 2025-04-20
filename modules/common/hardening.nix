{ pkgs, ... }:

{
    environment.systemPackages = [
        pkgs.lynis
    ];

    environment.memoryAllocator.provider = "graphene-hardened-light";
}