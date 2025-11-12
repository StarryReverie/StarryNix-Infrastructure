{ lib, pkgs, ... }:
{
  wrappers.fastfetch.basePackage = pkgs.fastfetchMinimal;
}
