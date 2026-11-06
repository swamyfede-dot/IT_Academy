USE world;

SELECT *
FROM country;

#1)Muestra todos los datos de las ciudades que comienzan por "al-", de la tabla city.
SELECT *
FROM city
WHERE Name LIKE "al%";



#2) De la consulta anterior, muestra los "countryCode" únicos.
SELECT DISTINCT CountryCode
FROM city
WHERE Name LIKE "al%";

#3) Muestra el "name" de las ciudades que tienen menos de 10.000 personas de "population".
SELECT Name, Population
FROM city
WHERE population < 10000;

#4) Muestra las ciudades de los "countryCode" AUS, DOM, GMB y SLV.
SELECT Name, CountryCode
FROM city 
WHERE CountryCode IN ("AUS", "DOM", "GMB", "SLV");

#5) Muestra todos los datos de los países que tienen entre 70 y 80 años de "LifeExpectancy".
SELECT Name 
FROM country 
WHERE LifeExpectancy BETWEEN 70 AND 80;

#6) Muestra los nombres de los países que están en el continente europeo y en la región nórdica.
SELECT Name 
FROM country
WHERE Continent = "Europe" AND Region = "Nordic Countries";

#7) Muestra los 3 países con más "LifeExpectancy" del grupo de países de Europa báltica y norte américa caribe.
SELECT Name 
FROM country 
WHERE Region IN ("Baltic Countries", "Caribbean")
ORDER BY LifeExpectancy DESC
LIMIT 3;

#8) Muestra los países que comienzan por letra "y" o comienzan por letra "o".
SELECT Name 
FROM country
WHERE Name LIKE ("y%") OR Name LIKE ("o%");

SELECT *
FROM countrylanguage;

#9) Muestra todos los lenguajes que se hablan en el mundo (que son lenguaje oficial en su país).
SELECT DISTINCT Language
FROM countrylanguage
WHERE IsOfficial = "T";