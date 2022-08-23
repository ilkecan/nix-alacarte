{
  nix-utils,
  ...
}:

let
  inherit (nix-utils)
    bsd
    libc
    lsb
    mergeListOfAttrs
  ;
in

{
  systemd = {
    # https://www.freedesktop.org/software/systemd/man/systemd.exec.html#Process%20Exit%20Codes
    exitCodes = mergeListOfAttrs [
      libc.exitCodes
      lsb.exitCodes
      {
        EXIT_CHDIR = 200;
        EXIT_NICE = 201;
        EXIT_FDS = 202;
        EXIT_EXEC = 203;
        EXIT_MEMORY = 204;
        EXIT_LIMITS = 205;
        EXIT_OOM_ADJUST = 206;
        EXIT_SIGNAL_MASK = 207;
        EXIT_STDIN = 208;
        EXIT_STDOUT = 209;
        EXIT_CHROOT = 210;
        EXIT_IOPRIO = 211;
        EXIT_TIMERSLACK = 212;
        EXIT_SECUREBITS = 213;
        EXIT_SETSCHEDULER = 214;
        EXIT_CPUAFFINITY = 215;
        EXIT_GROUP = 216;
        EXIT_USER = 217;
        EXIT_CAPABILITIES = 218;
        EXIT_CGROUP = 219;
        EXIT_SETSID = 220;
        EXIT_CONFIRM = 221;
        EXIT_STDERR = 222;
        EXIT_PAM = 224;
        EXIT_NETWORK = 225;
        EXIT_NAMESPACE = 226;
        EXIT_NO_NEW_PRIVILEGES = 227;
        EXIT_SECCOMP = 228;
        EXIT_SELINUX_CONTEXT = 229;
        EXIT_PERSONALITY = 230;
        EXIT_APPARMOR_PROFILE = 231;
        EXIT_ADDRESS_FAMILIES = 232;
        EXIT_RUNTIME_DIRECTORY = 233;
        EXIT_CHOWN = 235;
        EXIT_SMACK_PROCESS_LABEL = 236;
        EXIT_KEYRING = 237;
        EXIT_STATE_DIRECTORY = 238;
        EXIT_CACHE_DIRECTORY = 239;
        EXIT_LOGS_DIRECTORY = 240;
        EXIT_CONFIGURATION_DIRECTORY = 241;
        EXIT_NUMA_POLICY = 242;
        EXIT_CREDENTIALS = 243;
        EXIT_BPF = 245;
      }
      bsd.exitCodes
    ];
  };
}
