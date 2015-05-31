source $(dirname $0)/nvmish.sh

PROMPT_COMMAND="$(read newVal <<<"$PROMPT_COMMAND"; echo "${newVal%;}; __nvmish \"chpwd\"")"

