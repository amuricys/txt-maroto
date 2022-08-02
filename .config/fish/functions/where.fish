function where
    if test (count $argv) -gt (test "$argv[1]" = "--" && echo 2 || echo 1) || test (count $argv) -eq 0
        printf "%s\n" (_ "Usage: 'where <command-name> (single argument)'")
        return 1
    end
    command ls -la $(which $argv)
end
