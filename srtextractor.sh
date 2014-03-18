
for file in *.mkv
do
	name=`echo $file | cut -f1 -d'.'` 	
	mkvextract tracks "$file" 4:"$name".ass

done

for file in *.ass
do
	./SRTExtractor.rb "$file"
done