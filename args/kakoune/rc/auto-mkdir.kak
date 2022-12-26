define-command mkdir %{ nop %sh{ mkdir -p "$(dirname "$kak_buffile")" } }

hook global BufWritePre .* %{ mkdir }
