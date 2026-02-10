{ config, lib, ... }:
let
  cfg = config.services.openssh;
in
{
  config = lib.mkIf cfg.enable {
    users.users.sshd.uid = lib.mkForce 974;
    users.groups.sshd.gid = lib.mkForce 974;

    systemd.services.sshd = lib.mkIf (!cfg.startWhenNeeded) {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };

    systemd.services.sshd-keygen = lib.mkIf cfg.generateHostKeys {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };

    systemd.sockets.sshd = lib.mkIf cfg.startWhenNeeded {
      wantedBy = lib.mkForce [ "system-manager.target" ];
    };

    # privsep directory
    systemd.tmpfiles.rules = [
      "d /var/empty 0755 root root -"
    ];
  };
}
