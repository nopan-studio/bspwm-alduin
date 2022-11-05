bspc subscribe monitor | while read -r line; do
  case $line in
      monitor_add*|monitor_geometry*)
        if [ "$(bspc query -M | wc -l)" -eq "3" ]; then
          bspc monitor $(bspc query -M | sed -n 1p) -d 00 03
          bspc monitor $(bspc query -M | sed -n 2p) -d 01 04
          bspc monitor $(bspc query -M | sed -n 3p) -d 02 05
        elif [ "$(bspc query -M | wc -l)" -eq "2" ]; then
          bspc monitor $(bspc query -M | sed -n 1p) -d 00 02 04
          bspc monitor $(bspc query -M | sed -n 2p) -d 01 03 05
        else
          bspc monitor -d 00 01 02 03 04 05
        fi
        ;;
      *)
      ;;
  esac
done &