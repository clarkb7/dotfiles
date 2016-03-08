# Credit: https://github.com/eoswald/dotfiles/blob/master/scripts/print.sh
# Changes: Ask for RCS password, get temp filename, and print NUM copies

EXPECTED_ARGS=2
E_BADARGS=65
RCS_ID=RCS_ID_HERE

if [ $# -lt $EXPECTED_ARGS ]; then
	echo "Usage: $(basename $0) PDF_FILE PRINTER [NUM]"
	exit $E_BADARGS
fi

# Get ps file
RCS_SERVER=rcs.rpi.edu
TMP_FILE=$(mktemp)
TMP_BASE=$(basename $TMP_FILE)
pdf2ps "$1" "$TMP_FILE"

# Get RCS Password
read -s -p "RCS Password: " RCS_PASS

# Print over RCS
sshpass -p $RCS_PASS scp "$TMP_FILE" $RCS_ID@$RCS_SERVER:~/$TMP_BASE
sshpass -p $RCS_PASS ssh $RCS_ID@$RCS_SERVER "
lpr -#${3:-1} -P$2 $TMP_BASE
lpq -P$2
rm $TMP_BASE"

#Cleanup
RCS_PASS=
rm $TMP_FILE
