#!/bin/bash
function regprod {
	declare -a data
	cnt=0
	prov="prov.dat"
	mp="mp.dat"
	file="prod.dat"
	segui=true
	gtg=true
	if [ -f $prov ] && [ -f $mp ]; then
		if [ -f $file ]; then
			echo "Ingrese el nombre del producto, la materia prima que usara y la cantidad a producir"
			while [ $cnt -lt 3 ]; do
				read data[cnt]
				line="$line${data[cnt]}:"
				((cnt++))
			done					
			cnt=1
			var=$(echo "${data[1]}" | cut -d "," -f 1) #Carga a var la primer materia prima
			while [ $segui = true ]; do #hasta que sea nulo
				x=$(grep -w "$var" $mp) #Carga a x las lineas que contienen esa materia prima.
				if [ -n "$x" ]; then #mientras no sea nulo.
					n=$(echo "$x" | wc -l) # Guarda en n el numero de lineas de lo cargado en x.
					if [ $n -gt 1 ]; then #Si tiene mas de una linea.
						echo "De que marca es $var?"
						read marca
						x=$(echo "$x" | grep -w "$marca") #Pide ingreso de la marca para elegir en que linea trabajar.
						n=$(echo "$x" | cut -d ":" -f 2) #se toma el numero de unidades que hay en esa linea.
						n=$(echo "$n-${data[2]}" | bc) # se calcula cuanto queda luego de preparar el producto.
						if [ $n -le 0 ]; then #Si ese numero es menor o igual a 0 no se puede hacer el producto.
							echo "No hay suficiente materia prima."
							gtg=false
							break
						else
							echo "$x" >> temp.txt
							y=$(echo "$x" | cut -d ":" -f 1)
							y="$y:$n:$(echo "$x" | cut -d ":" -f 3)"
							echo "$y" >> temp.txt
						fi	
					else
						n=$(echo "$x" | cut -d ":" -f 2)
						n=$(echo "$n-${data[2]}" | bc)
						if [ $n -le 0 ]; then
							echo "No hay suficiente materia prima."
							gtg=false
							break	
						else
							echo "$x" >> temp.txt
							y=$(echo "$x" | cut -d ":" -f 1)
							y="$y:$n:$(echo "$x" | cut -d ":" -f 3)"
							echo "$y" >> temp.txt	
						fi
					fi
				else
					echo "No se dispone de la materia prima necesaria."
					gtg=false
					break	
				fi	
				((cnt++))		
				if $(echo "${data[1]}" | grep -q ",");  then 
					var=$(echo "${data[1]}" | cut -d "," -f $cnt)
					if [ -z "$var" ]; then
						segui=false
					fi
				else
					break
				fi
			done	
			if [ $gtg = true ]; then
				cnt=1
				n=$(wc -l "temp.txt" | cut -d " " -f 1)
				while [ $cnt -le $n ]; do 
					x=$(head -n $cnt temp.txt | tail -1)
					grep -v -w "$x" $mp >> tmp.txt
					mv tmp.txt $mp 
					((cnt++))
					x=$(head -n $cnt temp.txt | tail -1)
					echo "$x" >> $mp
					((cnt++))	
				done 
				var=$(echo "$line" | cut -d ":" -f 1,2)
				if grep -q "$var" $file; then 
					n=$(echo "$line" | cut -d ":" -f 3)
					x=$(grep "$var" $file | cut -d ":" -f 3)
					n=$(echo "$n+$x" | bc)
					line="$var:$n"
					grep -v "$var" $file > temp.txt
					mv temp.txt $file	
				else
					rm temp.txt
				fi
				echo "$line" >> $file
			else
				rm temp.txt
			fi	
		else
			printf "#Nombre:Materia prima:Cantidad\n" >> $file
			regprod		
		fi
	else
		echo "No has ingresado ni proveedor ni materia prima, no podes hacer nada."
	fi
}
echo "Hola"
regprod
#Ahora se limpia el archivo (se le borran todas las lineas blancas)
grep -v '^$' prod.dat > temp.txt
mv temp.txt prod.dat
echo "Gracias, bonitos y gorditos"
