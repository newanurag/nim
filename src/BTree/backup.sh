ext=`date +'%d_%m_%Y_%H_%M_%S'`
TARFILE="backup.tar.$ext"
echo "Creating Backup with time extension: $ext"
SRCFILES = ""
for f in `ls *.nim btree.log`
do
	echo "cp $f $f-$ext"
	#cp $f backup/$f.$ext
    SRCFILES="$SRCFILES $f"
done
tar -cvf ${TARFILE} ${SRCFILES}
mv ${TARFILE}  backup/
