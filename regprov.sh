#!/bin/bash
function regprov {
	declare -a data #Define un array
	cnt=0
	file="prov.dat" #Define la constante del nombre del archivo
	if [ -f "$file" ] #Si existe el archivo.
	then
		echo "Ingrese nombre de proveedor, telefono, direccion y producto, en ese orden"
		while [ $cnt -lt 4 ]
		do
			read data[cnt] #Permite que el usuario ingrese al array
			line="$line${data[cnt]}:" #Se va definiendo un string con la linea que va al archivo. Este tiene el contenido anterior de la variable concatenado con lo ingresado en el momento.
			((cnt++))
		done
		#echo "$line"
		if grep -w -q "$line" $file; then
			echo "Error, ingreso repetido." #Si se repite, avisa y termina.
		else
			echo "$line" >> $file #Ingresa al archivo.
		fi
	else
		echo "#Proveedor:Telefono:Direccion:Producto" >> $file
		regprov
	fi
}
echo "Hola"
regprov
echo "Gracias, bonito y gordito eh?"
