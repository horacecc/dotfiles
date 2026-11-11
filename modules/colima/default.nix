{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      # Runs containers in a Linux VM like Docker Desktop, without its root helper.
      # The VM runs only between colima start and colima stop
      services.colima = {
        enable = true;
        profiles.default = {
          isService = false;
          # docker finds the VM's socket through DOCKER_HOST
          setDockerHost = true;
        };
      };

      # On macOS only the client, with the compose and buildx plugins
      home.packages = [ pkgs.docker ];
    }
  ];
}
