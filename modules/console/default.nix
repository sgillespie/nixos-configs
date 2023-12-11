{ config, pkgs, ... }:

{
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
}
