#!/bin/bash
function regmp {
	declare -a data
	cnt=0
	file="mp.dat"
	prov="prov.dat"
	if [ -f "$file" ]; then
		printf "\n" >> $file
		echo "Ingrese tipo de materia prima, cantidad comprada y proveedor, en ese orden."
		while [ $cnt -lt 3 ]; do
			read data[cnt]
			line="$line${data[cnt]}:"	#Se va definiendo string con la linea a ingresar.	
			((cnt++))
		done
		ctrl=$(grep -w "${data[2]}" $prov | grep -w "${data[0]}" | cut -d ":" -f 1,4)
		num="${data[2]}:${data[0]}"
		if [ "$ctrl" == "$num" ]; then
			ctrl=$(grep -w "${data[0]}" $file | grep -w "${data[2]}")
			if [ -n "$ctrl" ]; then
				grep -v -w "$ctrl" $file > temp.txt
				mv temp.txt $file
				var=$(echo "$ctrl" | cut -d ":" -f 2)	
				var=$(echo "$var+${data[1]}" | bc)
				line=$(echo "${data[0]}:$var:${data[2]}")	
			fi
			echo "$line" >> $file
		else
			echo "El producto adquirido no es vendido por ese vendedor."
		fi	
	else
		printf "#Tipo de materia prima:Cantidad:Proveedor" >> $file
		regmp
	fi
}
echo "Hola, gracias por su preferencia"
regmp
#Ahora limpiamos el archivo (le sacamos todas las lineas blancas).
grep -v '^$' mp.dat > temp.txt
mv temp.txt mp.dat
echo "Bonitos y gorditos"
