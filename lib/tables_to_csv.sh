for TT in $(mdb-tables "$@"); do
  mdb-export -D '%Y-%m-%d %H:%M:%S' "$@" "$TT" > "${@:2}/${TT}.csv"
done
