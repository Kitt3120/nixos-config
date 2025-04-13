{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.mkMinecraftServer = lib.mkOption {
    default =
      name: directory: jarurl: jarhash: java: RAM: debug:
      let
        jar = pkgs.fetchurl {
          url = jarurl;
          sha256 = jarhash;
        };

        script-cli =
          with pkgs;
          (writeShellScriptBin "minecraft-${name}" ''
            function start_attach {
              if ! ${screen}/bin/screen -list | grep -q minecraft-${name}; then
                echo Seems like the ${name} is not running. Starting ${name}...
                systemctl --user start minecraft-${name}
                ${coreutils}/bin/sleep 1
                echo Attaching to console...
              else
                echo ${name} running! Attaching to console...
              fi

              ${screen}/bin/screen -rx minecraft-${name}
            }

            function start {
              systemctl --user start minecraft-${name}
              echo ${name} started
            }

            function stop {
              systemctl --user stop minecraft-${name}
              echo ${name} stopped
            }

            function restart {
              systemctl --user restart minecraft-${name}
              echo ${name} restarted
            }

            function view_log {
              less +G ${directory}/server.log
            }

            function menu {
              echo "1) Start and/or attach to process"
              echo "2) Just start the process"
              echo "3) Stop process"
              echo "4) Restart process"
              echo "5) View log"

              read option
              case "$option" in
                1) start_attach ;;
                2) start ;;
                3) stop ;;
                4) restart ;;
                5) view_log ;;
                *) menu ;;
              esac
            }

            menu
          '');

        script-start =
          with pkgs;
          (writeShellScriptBin "minecraft-${name}-start" ''
            COMMAND_MKDIR="${coreutils}/bin/mkdir -p ${directory}"
            COMMAND_CD="cd ${directory}"
            COMMAND_EULA="echo eula=true > eula.txt"
            COMMAND_JAVA="${java}/bin/java -Xms${RAM} -Xmx${RAM}"
            COMMAND_IPV6="-Djava.net.preferIPv4Stack=true -Djava.net.preferIPv6Addresses=false"
            COMMAND_MCFLAGS="-XX:+UnlockExperimentalVMOptions -XX:+UnlockDiagnosticVMOptions -XX:+AlwaysActAsServerClassMachine -XX:+AlwaysPreTouch -XX:+DisableExplicitGC -XX:+UseNUMA -XX:NmethodSweepActivity=1 -XX:ReservedCodeCacheSize=400M -XX:NonNMethodCodeHeapSize=12M -XX:ProfiledCodeHeapSize=194M -XX:NonProfiledCodeHeapSize=194M -XX:-DontCompileHugeMethods -XX:MaxNodeLimit=240000 -XX:NodeLimitFudgeFactor=8000 -XX:+UseVectorCmov -XX:+PerfDisableSharedMem -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority -XX:ThreadPriorityPolicy=1"
            COMMAND_GC="-XX:AllocatePrefetchStyle=3 -XX:+UseG1GC -XX:MaxGCPauseMillis=130 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=28 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=20 -XX:G1MixedGCCountTarget=3 -XX:InitiatingHeapOccupancyPercent=10 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150"
            COMMAND_HUGE_PAGES="-XX:+UseTransparentHugePages -Xlog:gc+init"
            COMMAND_JAR="-jar ${jar} nogui"
            COMMAND_TEE="tee ./server.log${if debug then "^M" else "; exit^M"}"

            if ${screen}/bin/screen -list | ${gnugrep}/bin/grep -q minecraft-${name};
            then
              echo -n "Process is already running, stopping it for a restart..."
              systemctl --user stop minecraft-${name}
            fi

            ${screen}/bin/screen -dmS minecraft-${name} ${bash}/bin/bash
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_MKDIR"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " && "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_CD"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " && "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_EULA"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " && "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_JAVA"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_IPV6"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_MCFLAGS"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_GC"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_HUGE_PAGES"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_JAR"
            ${screen}/bin/screen -S minecraft-${name} -X stuff " | "
            ${screen}/bin/screen -S minecraft-${name} -X stuff "$COMMAND_TEE"
            echo ${name} started
          '');

        script-stop =
          with pkgs;
          (writeShellScriptBin "minecraft-${name}-stop" ''
            if ${screen}/bin/screen -list | ${gnugrep}/bin/grep -q minecraft-${name};
            then
              ${screen}/bin/screen -S minecraft-${name} -X stuff "stop^M" && while ${screen}/bin/screen -list | ${gnugrep}/bin/grep -q minecraft-${name}; do ${coreutils}/bin/sleep 1; done && echo ${name} stopped
            else
              echo ${name} is not running
            fi
          '');
      in
      {
        scripts = {
          cli = script-cli;
          start = script-start;
          stop = script-stop;
        };

        systemd.unit = {
          Unit = {
            Description = "Minecraft ${name}";
            After = [ "network.target" ];
            Wants = [ "network.target" ];
          };

          Service = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${script-start}/bin/minecraft-${name}-start";
            ExecStop = "${script-stop}/bin/minecraft-${name}-stop";
          };

          Install = {
            WantedBy = [ "default.target" ];
          };
        };
      };
    type = lib.types.anything;
  };
}
