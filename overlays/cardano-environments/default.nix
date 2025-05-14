{ wget, writeShellApplication, ... }: 

writeShellApplication { 
  name = "fetch-cardano-cfg.sh";
  runtimeInputs = [ wget ];
  text = builtins.readFile ./fetch-cardano-cfg.sh;
}
