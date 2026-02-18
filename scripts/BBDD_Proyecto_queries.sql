/*
=============================================================================
PROYECTO: Análisis de Datos - Negocio de Alquiler de Películas
AUTORA:   Sara García Carretero
FECHA:    Enero 2026
HERRAMIENTAS: PostgreSQL | DBeaver
DESCRIPCIÓN: 
    Este script contiene una serie de 64 ejercicios de complejidad progresiva
    diseñados para extraer insights de negocio, optimizar inventario y 
    analizar el comportamiento de los clientes.
=============================================================================
*/
------------------------------------------------------------
-- INICIO DEL SCRIPT
------------------------------------------------------------

-- 1.Crea el esquema de la BBDD. Creado como Esquema Entidad Relacion BBDD Proyecto.erd
-- 2.Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ
select  "title" as "nombre_pelicula"
from "film"
where "rating" = 'R';

-- 3.Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
select concat("first_name", ' ',"last_name") as "nombre_actor"
from "actor"
where "actor_id" between 30 and 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
select 
f."film_id" as "id_pelicula", 
f."title" as "nombre_pelicula" 
from "film" f
join "language" l on f."language_id" = l."language_id"
where l."language_id" = f."original_language_id";
-- todos los valores de la columna "original_language_id" son NULL por eso no aparecen datos al ejecutar

-- 5.Ordena las películas por duración de forma ascendente.
select 
"film_id" as "id_pelicula",
"title"  as "nombre_pelicula"
from "film"
order by "length";

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su  apellido.
select 
"first_name" as "nombre", 
"last_name" as "apellido"
from "actor"
where "last_name" ilike '%Allen%';

-- 7.Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
select "rating" as "clasificacion", 
count ("film_id") as "numero_peliculas"
from "film"
group by "rating"
order by "numero_peliculas" desc;

-- 8.Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.
select "title" as "titulo"
from "film"
where "rating" = 'PG-13'
or "length" > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
-- para ello calculamos los valores minimos y maximos, el promedio, la varianza, y desviación estandard
select 
MIN("replacement_cost") as "coste_min", 
MAX("replacement_cost") as "Coste_max", 
round(AVG("replacement_cost"),2) as "promedio_coste", 
round (variance("replacement_cost"),2) as "varianza", 
round(stddev("replacement_cost"),2) as "desviación_estandard"
from "film";

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select 
MAX("length") as "duracion_maxima",
MIN("length") as "duracion_minima"
from "film";

-- 11.  Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select "amount" as "importe_pagado"
from "payment" 
order by "payment_date" desc
limit 1
offset 2;


-- 12.  Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.
select "title" as "titulo"
from "film"
where "rating" not in  ('NC-17', 'G');

/* 13. Encuentra el promedio de duración de las películas para cada 
clasificación de la tabla film y muestra la clasificación junto con el 
promedio de duración.*/
select 
"rating" as "clasificacion",
round( AVG("length"),2) as "promedio_duracion"
from "film"
group by "rating";

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select "title" as "peliculas_mas_180min"
from "film"
where "length" > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
select SUM("amount") as "facturacion_total"
from "payment";

-- 16. Muestra los 10 clientes con mayor valor de id.
select 
"customer_id"as "id_cliente", 
concat("first_name", ' ', "last_name") as "nombre_cliente"
from "customer"
order by "customer_id" desc
limit 10;

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
select concat(a."first_name", ' ', a."last_name") as "nombre_actor"
from "actor" a
join "film_actor" fa on a."actor_id" = fa."actor_id"
join "film" f on fa."film_id" = f."film_id"
where f."title" ilike 'Egg Igby';

-- 18. Selecciona todos los nombres de las películas únicos.
select distinct "title" as "nombres_unicos_peliculas"
from "film";

-- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
select 
f."title" as "nombre_pelicula"
from "film" f
join "film_category" fc on f."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
where c."name" = 'Comedy' and f."length" > 180;

/* 20.  Encuentra las categorías de películas que tienen un promedio de 
duración superior a 110 minutos y muestra el nombre de la categoría 
junto con el promedio de duración.*/
select 
c."name" as "nombre_categoria",
round(AVG(f."length"),2) as "promedio_duracion"
from "film" f
join "film_category" fc on f."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
group by c."name"
having AVG(f."length") > 110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas? 
--la duración teorica promedio la podemos extraer de la tabla "film"
select round(avg("rental_duration"),2) as "duración_promedio_alquiler_teorica"
from "film";
-- la duracion real es la resta entre fecha de devolucion y fecha de alquiler, excluyendo las peliculas sin devolver (fecha de devoulucion null)
select round(avg(EXTRACT(epoch FROM ("return_date" - "rental_date")) / 86400)::numeric, 2) as "duracion_promdio_alquiler_real"
from "rental"
where "return_date" is not null;

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select distinct concat("first_name", ' ', "last_name") as "nombre_actor"
from "actor";

--23.Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select 
count(rental_id) as "total_alquileres",
date("rental_date") as "fecha_alquiler"
from "rental"
group by date("rental_date")
order by "total_alquileres" desc;

-- 24. Encuentra las películas con una duración superior al promedio.
select 
"film_id" as "id_pelicula", 
"title" as "nombre_pelicula"
from "film"
where "length" > (
select AVG("length")
from "film"
);

-- 25. Averigua el número de alquileres registrados por mes.
select 
to_char ("rental_date",'YYYY-MM') as "mes_alquiler",
count ("rental_id") as "numero_alquileres"
from "rental"
group by to_char ("rental_date",'YYYY-MM')
order by "mes_alquiler";

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select 
round(AVG("amount"),2) as "promedio",
round(stddev("amount"),2) as "desviacion_estandar",
round(variance("amount"),2) as "varianza"
from "payment";

-- 27.  ¿Qué películas se alquilan por encima del precio medio?
select 
"film_id" as "id_pelicula", 
"title" as "nombre_pelicula"
from "film"
where "rental_rate"> (
select AVG("rental_rate")
from "film"
);

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
select "actor_id" as "id_actor"
from "film_actor"
group by "actor_id"
having count("film_id") > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select 
f."film_id" as "id_pelicula",
f."title" as "nombre_pelicula",
count(i."film_id") as "total_disponibles"
from "film" as f
left join "inventory" as i on f."film_id" = i."film_id"
group by f."film_id", f."title"
order by f."film_id";

-- 30. Obtener los actores y el número de películas en las que ha actuado.
select 
a."actor_id", 
concat(a."Nombre", ' ', a."Apellido") as "nombre_actor",
count(fa."film_id") as "total_peliculas"
from "actor" a
left join "film_actor" fa on a."actor_id" = fa."actor_id"
group by a."actor_id", a."Nombre", a."Apellido"
order by "total_peliculas" desc;


-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.

select 
f."film_id",
f."title"as "nombre_pelicula", 
string_agg(
distinct concat(a."first_name", ' ', a."last_name"),
', '
) as "actores"
from "film" f
left join "film_actor" fa
on f."film_id" = fa."film_id"
left join "actor" a on fa."actor_id" = a."actor_id"
group by f."film_id", f."title";

-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
select
concat("first_name", ' ',"last_name") as "nombre_actor",
array_agg(distinct f."title") as "peliculas"
from "actor" a
left join "film_actor" fa
on fa."actor_id" = a."actor_id"
left join "film" f
on f."film_id" = fa."film_id"
group by a."actor_id", "nombre_actor";

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
/* al principio usé un full join pero tras analizarlo consideré que no aportaba valor real ya que no deberían existir alquileres sin pelicula (la mitad del full join
 no proporciona nueva info), así que finalmente lo cambié por un left join que es mas eficiente */
select 
f."film_id" as "id_pelicula",
f."title" as "nombre_pelicula",
array_agg(r."rental_id") filter (where r."rental_id" is not null) as "registros_alquiler"
from "film" f
left join "inventory" i
on i."film_id" = f."film_id"
left join "rental" r
on r."inventory_id" = i."inventory_id"
group by f."film_id",f."title"
order by "id_pelicula";

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select
c."customer_id" as "id_cliente",
concat (c."first_name", ' ' , c."last_name") as "nombre_cliente",
SUM(p."amount") as "total_gastado"
from "customer" c
join "payment" p on p."customer_id" = c."customer_id"
group by c."customer_id", c."first_name", c."last_name"
order by "total_gastado" desc
limit 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select 
"actor_id" as "id_actor",
concat("first_name", ' ', "last_name") as "nombre_actor"
from "actor"
where "first_name" ilike 'Johnny';

-- 36.  Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
--Existen varias tablas con esas mismas columnas, por lo que lo realizaré sobre la tabla "actor"
alter table "actor"
rename column "first_name" to "Nombre"; -- renombramos la columna "first_name"
alter table "actor"
rename column "last_name" to "Apellido"; -- renombramos la columna "lasta_name"
-- para la tablas "customer" y "taff" se realizaria de la misma manera, reemplazando "actor" por el nombre de cada tabla.

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select 
MAX("actor_id") as "id_mas_alto", 
MIN("actor_id") as "id_mas_bajo"
from "actor";

-- 38. Cuenta cuántos actores hay en la tabla “actorˮ.
select count("actor_id") as "numero_actores"
from "actor";

-- 39.  Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select concat("Nombre", ' ' ,"Apellido") as "nombre_actor"
from "actor"
order by "Apellido";

-- 40.  Selecciona las primeras 5 películas de la tabla “filmˮ.
select "title" as "nombre_pelicula"
from "film"
order by "film_id" -- para garantizar la consistencia, sino cada vez que ejecutemos la consulta serían 5 distintos
limit 5;

-- 41.  Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
select 
"Nombre" as "nombre_actor",
count ("Nombre") as "numero_actores"
from "actor"
group by "Nombre"
order by "numero_actores" desc;
/* hay 3 actores que se repiten 4 veces: Kenneth, Penelope y Julia */

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select 
r."rental_id" as "id_alquiler",
concat(c."first_name", ' ', c."last_name") as "nombre_cliente"
from "rental" r
join "customer" c on r."customer_id" = c."customer_id"
order by "rental_id";

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select 
c."customer_id" as "id_cliente",
concat(c."first_name", ' ', c."last_name") as "nombre_cliente",
coalesce (string_agg(r."rental_id"::text,','), 'no tiene alquileres') as "alquileres"
from "customer" c
left join "rental" r
on c."customer_id" = r."customer_id"
group by c."customer_id", "nombre_cliente";

-- 44.  Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select *
from "film"
cross join "category";
/* en mi opinion esta consulta no aporta ningun valor ya que cada pelicula pertenece a una categoria concreta y la combinacion con otras categorias
 representa un escenario inexistente en la practica*/

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select distinct
a."actor_id" as "id_actor", 
concat (a."Nombre",' ' , a."Apellido") as "nombre_actor"
from "actor" a
join "film_actor" fa on a."actor_id" = fa."actor_id"
join "film_category" fc on fa."film_id"= fc."film_id"
join "category" c on fc."category_id" = c."category_id"
where c."name" = 'Action'
order by a."actor_id";

-- 46. Encuentra todos los actores que no han participado en películas.
select 
a."actor_id" as "id_actor",
concat(a."Nombre", ' ', a."Apellido") as "nombre_actor"
from "actor" a 
left join "film_actor" fa on a."actor_id" = fa."actor_id"
where fa."actor_id" is null;
 -- todos los actores han participado en peliculas, la consulta no devuelve 0 filas

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select 
concat(a."Nombre", ' ' , a."Apellido") as "nombre_actor",
count(fa."film_id") as "cantidad_peliculas"
from "actor" a
join "film_actor" fa on a."actor_id" = fa."actor_id"
group by a."actor_id", "nombre_actor"
order by "cantidad_peliculas" desc;

-- 48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
create or replace view actor_numero_peliculas as
select 
concat(a."Nombre", ' ' , a."Apellido") as "nombre_actor",
count(f."film_id") as "cantidad_peliculas"
from "actor" a
join "film_actor" fa
on a."actor_id" = fa."actor_id"
join "film" f
on f."film_id" = fa."film_id"
group by a."actor_id","nombre_actor";

-- 49. Calcula el número total de alquileres realizados por cada cliente.
select 
c."customer_id" as "id_cliente",
concat(c."first_name", ' ' ,c."last_name") as "nombre_cliente",
count (r."rental_id") as "numero_alquileres"
from "customer" c
left join "rental" r on c."customer_id" = r."customer_id"
group by "id_cliente", "nombre_cliente"
order by "numero_alquileres" desc;

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select 
sum (f."length") as "minutos_totales_accion"
from "film" f
where f."film_id" in(
select fc."film_id"
from "film_category" fc
join "category" c on fc."category_id" = c."category_id"
where c."name" = 'Action');

-- 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.
drop table if exists cliente_rentas_temporal; -- he creado la tabla varias veces, con esto limpio para ejecutar varias veces sin errores
create temporary table cliente_rentas_temporal as
select 
c."customer_id" as "id_cliente",
concat(c."first_name", ' ' ,c."last_name") as "nombre_cliente",
count (r."rental_id") as "numero_alquileres"
from "customer" c
left join "rental" r on c."customer_id" = r."customer_id" -- el left join garantiza incluir todos los clientes tengan o no alquileres
group by "id_cliente", "nombre_cliente"
order by "numero_alquileres";
select * from cliente_rentas_temporal; -- verifico

-- 52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.
drop table if exists peliculas_alquiladas;
create temporary table peliculas_alquiladas as
select
f."film_id" as "id_pelicula",
f."title" as "nombre_pelicula",
count(r."rental_id") as "numero_alquileres"
from "film" f 
join "inventory" i on f."film_id" = i."film_id"
join "rental" r on i."inventory_id" =r."inventory_id"
group by "id_pelicula", "nombre_pelicula"
having count(r."rental_id") >= 10
order by "numero_alquileres" desc;
select * from peliculas_alquiladas; -- paso de vertificacion

/*53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. 
 Ordena los resultados alfabéticamente por título de película.*/
select distinct
f."title" as "nombre_pelicula"
from "film" f
join "inventory" i on f."film_id" = i."film_id"
join "rental" r on i."inventory_id" = r."inventory_id"
join "customer" c on r."customer_id" = c."customer_id"
where 
c."first_name" ilike 'Tammy'
and c."last_name" ilike 'Sanders'
and r."return_date" is null
order by "nombre_pelicula";

/* 54.  Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. 
Ordena los resultados alfabéticamente por apellido.*/
select 
concat (a."Nombre", ' ' , a."Apellido") as "nombre_actor"
from "actor" a 
where exists (
select 1
from
"film_actor" fa  
join "film_category" fc on fa."film_id" = fc."film_id"
join "category" c on fc."category_id" = c."category_id"
where fa."actor_id" = a."actor_id"
and c."name" ilike 'Sci-Fi')
order by a."Apellido";

/* 55.  Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus 
Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.*/
with FechaRef as (
select min ("rental_date") as "primer_alquiler"
from "rental" r
join "inventory" i on r."inventory_id" = i."inventory_id"
join "film" f on i."film_id" = f."film_id"
where f."title" ilike 'Spartacus Cheaper'
)
select distinct
a."Nombre" as "nombre_actor", 
a."Apellido" as "apellido_actor"
from "actor" a
join "film_actor" fa on a."actor_id" = fa."actor_id"
join "inventory" i2 on fa."film_id"= i2."film_id"
join "rental" r2 on i2."inventory_id" = r2."inventory_id"
where r2."rental_date" > (select "primer_alquiler" from FechaRef )
order by a."Apellido";

-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.
select
concat (a."Nombre",' ', a."Apellido") as "nombre_actor"
from "actor" a
where not exists (
select 1
from "film_actor" fa
join "film_category" fc on fa."film_id"= fc."film_id"
join "category" c on fc."category_id" = c."category_id"
where fa."actor_id" = a."actor_id" 
and c."name" ilike 'Music'
);

/* 57.  Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
-- En este caso hay dos escenarios, que se haya alquilado por mas de 8 dias y se haya devuelto, o que aun no se haya devuelto, 
usamos COALESCE para que nos devuetva el primer valor que no sea nulo */
select distinct 
f."film_id",
f."title"
from "film" f
join "inventory" i on f."film_id" = i."film_id"
join "rental" r on i."inventory_id" = r."inventory_id"
where coalesce(r."return_date", current_timestamp) - r."rental_date" >interval '8 days';

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ.
select f."title" as "nombre_pelicula"
from "film" f
join "film_category" fc on f."film_id"= fc."film_id"
where fc."category_id" = (select c."category_id"
from "category" c
where c."name" ilike 'Animation'
);

/* 59. Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados 
alfabéticamente por título de película.*/
select f."title" as "nombre_pelicula"
from "film" f
where f."length" = (select f2."length"
from "film" f2
where f2."title" ilike 'Dancing Fever'
)
and f."title" not ilike 'Dancing Fever'
order by f."title";

-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
select concat(c."first_name", ' ' , c."last_name") as "nombre_cliente"
from "customer" c
join "rental" r on c."customer_id" = r."customer_id"
join "inventory" i on r."inventory_id" = i."inventory_id"
group by c."customer_id", "nombre_cliente"
having count (distinct i."film_id")>= 7
order by c."last_name";

-- 61. Encuentra la cantidad total de películas alquilad:as por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
-- Con una CTE obtenemos codigo mas ordenado y escalable
with categorias_alquiladas as (
select 
c."name" as "categoría", 
r."rental_id"
from "category" c
join "film_category" fc on c."category_id" = fc."category_id"
join "inventory" i on fc."film_id" = i."film_id"
join "rental" r on i."inventory_id" = r."inventory_id"
)
select "categoría", count("rental_id") as "total_alquileres"
from categorias_alquiladas
group by "categoría"
order by "total_alquileres" desc;
-- pero como solo es una operacion (contar) creo que es mas eficiente y tiene mayor rendimiento la opcion directa sin CTE:
select 
c."name" as "categoría", 
count (r."rental_id") as "total_alquileres"
from "category" c
join "film_category" fc on c."category_id" = fc."category_id"
join "inventory" i on fc."film_id" = i."film_id"
join "rental" r on i."inventory_id" = r."inventory_id"
group by "categoría"
order by "total_alquileres" desc;

-- 62. Encuentra el número de películas por categoría estrenadas en 2006
select 
c."name" as "categoría",
count (f."film_id") as "numero_peliculas"
from "category" c
join "film_category" fc on c."category_id" = fc."category_id"
join "film" f on fc."film_id" = f."film_id"
where f."release_year" = 2006
group by c."category_id", c."name";

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select 
s."staff_id",
concat(s."first_name", ' ', s."last_name") as "nombre_trabajador",
s2."store_id" as "id_tienda"
from "staff" s
cross join "store" s2; 

/*64.  Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
 su nombre y apellido junto con la cantidad de  películas alquiladas.*/
with peliculas_clientes as(
select
c."customer_id"as "id_cliente",
concat(c."first_name", ' ', c."last_name") as "nombre_cliente",
r."rental_id" as "id_alquiler"
from "customer" c
join "rental" r on c."customer_id" = r."customer_id"
)
select "id_cliente", 
"nombre_cliente", 
count("id_alquiler") as "numero_peliculas"
from peliculas_clientes
group by "id_cliente", "nombre_cliente"
order by "numero_peliculas" desc;



