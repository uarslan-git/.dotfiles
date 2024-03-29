{pkgs}:

pkgs.writeShellScriptBin "scale" ''
	if [ -z $1 ]; then
		echo "set a dpi"
		return 1
	fi

	factor=$1
	dpi=$((factor * 96))

	if [ ! -f ~/.Xresources ]; then
		echo "Creating .Xresources"
		touch ~/.Xresources
	fi

	if grep -q '^Xft.dpi:' ~/.Xresources; then
		sed -i "s/^Xft.dpi:.*/Xft.dpi: $dpi/" ~/.Xresources
	else
		echo "Xft.dpi: $dpi" >> ~/.Xresources
	fi

	xrdb $HOME/.Xresources
	i3-msg restart

	echo "xft.dpi set to $dpi"
''
