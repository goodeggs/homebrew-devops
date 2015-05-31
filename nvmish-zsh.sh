source $(dirname $0)/nvmish.sh

function __nvmish() { nvmish "chpwd" }
chpwd_functions=(${chpwd_functions[@]} "__nvmish")

