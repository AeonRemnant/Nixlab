{ pkgs, ... }:

{
    environment.memoryAllocator.provider = "graphene-hardened-light";
}