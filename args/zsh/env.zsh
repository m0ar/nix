export EDITOR=kak

if [[ `uname` == Darwin ]]; then
    MAX_MEMORY_UNITS=KB
else
    MAX_MEMORY_UNITS=MB
fi
export TIMEFMT='time results for "%J":'$' \n'\
'%U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M '$MAX_MEMORY_UNITS''$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'


