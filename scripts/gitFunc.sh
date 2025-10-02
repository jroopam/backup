# Since telescope can't run functions directly from script, this script is intended to run in 2 ways:
# 1. source it in the shell's config, this is for running the commands from shell
# 2. Add it to the path, so that it is treated like a command(like git) and can be executed from telescope. Ref: https://github.com/nvim-telescope/telescope.nvim/issues/435#issuecomment-761163181
# sudo ln -s ~/backup/scripts/gitFunc.sh /usr/local/bin/gitFunc
# Telescope find_files find_command=gitFunc

gsof() {
    # Ref: https://stackoverflow.com/questions/73680105/how-to-show-only-filenames-with-git-status
    git diff --name-only --diff-filter=u
}
gsof
