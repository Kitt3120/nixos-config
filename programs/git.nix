{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    prompt.enable = true;
    config = {
      core = {
        autocrlf = "input";
        editor = "nano";
        untrackedCache = true;
        fsmonitor = true;
      };

      init.defaultBranch = "main";
      checkout.defaultRemote = "origin";
      push.autoSetupRemote = "true";

      gpg.format = "ssh";
      commit.gpgsign = true;
      tag.gpgsign = true;

      rerere.enabled = true;

      fetch.writeCommitGraph = true;
      column.ui = "auto";

      alias = {
        as = "!git add . && git status";
        ds = "diff --staged";
        ads = "!git add . && git diff --staged";
        fp = "!git fetch --all -p && git pull";
        pf = "push --force-with-lease";
        bvs = "!git branch -v --sort=committerdate";
        bvas = "!git branch -va --sort=committerdate";
        rebaseToMain = "!git stash && git checkout main && git fetch --all -p && git pull && git checkout - && git rebase main && git stash pop";
        rebaseToMaster = "!git stash && git checkout master && git fetch --all -p && git pull && git checkout - && git rebase master && git stash pop";
        rebaseToStaging = "!git stash && git checkout staging && git fetch --all -p && git pull && git checkout - && git rebase staging && git stash pop";
        mergeFromMain = "!git stash && git checkout main && git fetch --all -p && git pull && git checkout - && git merge main && git stash pop";
        mergeFromMaster = "!git stash && git checkout master && git fetch --all -p && git pull && git checkout - && git merge master && git stash pop";
        mergeFromStaging = "!git stash && git checkout staging && git fetch --all -p && git pull && git checkout - && git merge staging && git stash pop";
      };
    };
  };
}
