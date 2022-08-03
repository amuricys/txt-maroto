for PID in `pgrep taffybar`; do
    kill ${PID} > /dev/null &
done

taffybar &