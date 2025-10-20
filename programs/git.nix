{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    prompt.enable = true;

    config = {
      core = {
        autocrlf = "input";
        editor = "${pkgs.vim}/bin/vim";
        untrackedCache = true;
        fsmode = true;
        fsmonitor = true;
        preloadIndex = true;
        pager = "${pkgs.delta}/bin/delta";
      };

      init.defaultBranch = "main";
      push.autoSetupRemote = "true";

      checkout = {
        defaultRemote = "origin";
        workers = 0;
      };

      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;

      fetch = {
        writeCommitGraph = true;
        all = true;
        prune = true;
        parallel = 0;
      };
      submodule.fetchJobs = 0;

      diff.algorithm = "histogram";
      column.ui = "auto";
      rerere.enabled = true;

      alias = {
        st = "status";
        d = "diff";
        dmy = "diff --diff-algorithm=myers";
        dmi = "diff --diff-algorithm=minimal";
        dp = "diff --diff-algorithm=patience";
        dh = "diff --diff-algorithm=histogram";
        ds = "diff --staged";
        dsmy = "diff --staged --diff-algorithm=myers";
        dsmi = "diff --staged --diff-algorithm=minimal";
        dsp = "diff --staged --diff-algorithm=patience";
        dsh = "diff --staged --diff-algorithm=histogram";

        ch = "checkout";
        br = "branch";
        bvs = "!git branch -v --sort=committerdate";
        bvas = "!git branch -va --sort=committerdate";

        fap = "!git fetch --all -p && git pull";
        fep = "!git fetch --all -p && git pull";
        puf = "push --force-with-lease";

        as = "!git add . && git status";
        ads = "!git add . && git diff --staged";

        co = "commit";
        ca = "commit --amend";
        cm = "commit -m";
        cowip = "commit -m \"WIP\"";

        rba = "rebase --abort";
        rbc = "rebase --continue";

        ma = "merge --abort";
        mc = "merge --continue";

        logwalk = "log --walk-reflogs --oneline --decorate";
        find-lost = "fsck --lost-found";

        rebaseToMain = "!git fetch --all -p && git stash && git pull && git checkout main && git pull && git checkout - && git rebase main && git stash pop";
        rebaseToMaster = "!git fetch --all -p && git stash && git pull && git checkout master && git pull && git checkout - && git rebase master && git stash pop";
        rebaseToStaging = "!git fetch --all -p && git stash && git pull && git checkout staging && git pull && git checkout - && git rebase staging && git stash pop";

        mergeFromMain = "!git fetch --all -p && git stash && git pull && git checkout main && git pull && git checkout - && git merge main && git stash pop";
        mergeFromMaster = "!git fetch --all -p && git stash && git pull && git checkout master && git pull && git checkout - && git merge master && git stash pop";
        mergeFromStaging = "!git fetch --all -p && git stash && git pull && git checkout staging && git pull && git checkout - && git merge staging && git stash pop";
      };
    };
  };
}
