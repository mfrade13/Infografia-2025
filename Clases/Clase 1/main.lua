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
		return n * recursiva_factorial(n-1)
	end
end
print(factorial(5))
print("funcion recursiva factorial " .. tostring( recursiva_factorial(6) ))

