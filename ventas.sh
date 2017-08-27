#!/bin/bash
function venta {
	op=0
	aux=0
	prod="prod.dat"
	file="ventas.dat"
	if [ -f "$prod" ]; then
		if [ -f "$file" ]; then
			echo "Ingrese su cedula..."
			read ci
			echo " "
			x=$(cat -n $prod | tail -1 | cut -d ":" -f 1) 
			echo "$x"
			printf "\nElija el producto que desee por medio de ingresar el numero de linea del producto que escoja.\n"
			read op
			aux=$(echo "$x" | wc -l)
			((aux++))
			if [ $op -le $aux ]; then
				x=$(head -n $op $prod | tail -1)
				echo "Cuanto quiere?"
				read op
				aux=$(echo "$x" | cut -d ":" -f 3)	
				if [ $aux -gt $op ]; then
					aux=$(echo "$aux-$op" | bc)
					line="$ci:$(echo "$x" | cut -d ":" -f 1):$op"
					lineprod="$(echo "$x" | cut -d ":" -f 1,2):$aux"	
					grep -v "$x" $prod > temp.txt
					mv temp.txt $prod
					echo "$lineprod" >> $prod
					echo "$line" >> $file
				else
					echo "No le podemos ofrecer tanto..."
				fi 
			else
				echo "No ha ingresado una linea valida."
			fi	
		else
			printf "#Identificacion:Producto:Cantidad\n" > $file	
			venta
		fi	
	else
		echo "No hay productos para ofrecerle. Lo lamentamos profundamente."
	fi
}
echo "Hola"
venta
echo "Gracias, bonito y gordito."
