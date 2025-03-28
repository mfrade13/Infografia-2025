-----------------------------------------------------------------------------------------
-- main.lua
-----------------------------------------------------------------------------------------

-- Your code here
print("Hola mundo!, desde visual studio")

cadena_de_texto = 'Hola mundo!'
print(cadena_de_texto); print("segunda instruccion")

print(1231)
print(1231.232)
print(type(123.34))
print(type(cadena_de_texto))
	
arreglo = {1,2,3,4, "Nombre", true, false}
print(arreglo[5])
print(arreglo)
persona = {
	nombre = "Marcos",
	edad = 22,
	altura = 1.74,
	carnet = 6123232,
	cabello = "oscuro"
}

print(persona["nombre"], persona.altura)
print(type(print))

for valor =10,1,-1 do
	print(valor)
--	valor = valor +1
end

for i,v in ipairs( arreglo ) do
	print(i,v)
end

for k,v in pairs(persona) do
	print( k,v )
end

numero = 1
repeat
	print( numero )
	numero = numero +1
until numero > 10

for indice=1, #arreglo, 1 do
	print(arreglo[indice])
end
print(tonumber( 17, 15 ))

if persona.altura ~= 1.7 or false then
	print(persona.nombre .. " es mas alta que 1.7 " .. tostring(tonumber( 32 , 2  ) ))
else
	print("entramos al else")
end

function factorial( n )
	resultado = 1
	for i=n, 1, -1 do
		resultado = resultado*i
	end
	return resultado
end

function recursiva_factorial(n)
	if n ==1 then
		return 1
	else
		return n * recursiva_factorial(n-1)  -- 5 fact(4). -- 5 * 4 * fact(3) -- 20 * 3 * fact(2)
	--	return recursiva_factorial(n-1) * n	 -- fact(4) *fact(3) * 4
	end
end
print(factorial(5))
print("funcion recursiva factorial " .. tostring( recursiva_factorial(6) ))


-- Ejercio 1 funcion factorial
function factorial( n )
	resultado = 1
	for i=n, 1, -1 do
		resultado = resultado*i
	end
	return resultado
end

--ejemplo factorial(5) = 120
print(factorial(5))

function isPrime(n)
	if n<2 then
		return false
	elseif n%2==0 and n>2 then 
		return false 
	else 
		for i=3, math.sqrt( n ), 2 do
			if n %i ==0 then
				return false
			end
		end
	return true

	end

end

print(isPrime(59))

--ejemplo numero capicua
function isCapicua(n)
	local aux = tostring(n)
	--return string.reverse(aux) == n
	return aux:reverse() == n
end

print(isCapicua(124421))

--ejemplo

lista = {1,2,9,3,3,2,2,3,4,5,6,7,5}

function contarRepeticiones(l)
	aux = {}
--	max = -1
--	tamanho = 1

	for i=1, #lista,1 do
		indice = lista[i]
		print("valor de la lista" .. indice)
--		if lista[i]> max then max = i end
		if aux[indice] == nil then
			aux[indice] = 1
		else
			aux[indice] = aux[indice] + 1
		end
		print(aux[9])
	end
	-- indice = 1
	-- repeat
	-- 	table.insert( aux, indice, 0 )
	-- 	indice = indice +10
	-- until max<=0
	return aux
end

print("tamanho respuesta " ..  #contarRepeticiones(lista))

for i,v in ipairs( contarRepeticiones(lista) ) do
	print(i,v)
end


function colineales (x1,y1,x2,y2,x3,y3)
	if x1==x2 then 
		return x2 == x3
	end
	if y1==y2 then
		return y2==y3
	end

	pendiente = (y2-y1)/(x2-x1)
	delta_y = pendiente * (x3-x1) + y1
	return delta_y == y3

end

print(colineales(0,0,0,1,0,3))

