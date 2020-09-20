--CONSULTAS

--Consulta Simples
select * from public.orders o;

--Junção da Tabela 'orders' e 'order_details'
select * from orders o join order_details od on od.order_id = o.order_id; 

--O id e o Valor do produto
select o.order_id,((od.unit_price * od.quantity) - od.discount)::numeric(18,2) 
from orders o 
join order_details od 
on od.order_id = o.order_id;
--::numeric(18,2) ele formata o valor calculado para apenas 18 numeros antes da virgula e apenas 2 numeros após a virgula

--Mas mesmo assim alguns ID se repeti, por que em um pedido teve varios produtos com valores diferente, então temos que agrupar e somar
--Usando 'group by' e 'SUM()'
select o.order_id, SUM(((od.unit_price * od.quantity) - od.discount))::numeric(18,2) 
from orders o 
join order_details od 
on od.order_id = o.order_id
group by o.order_id;

--Para saber as 10 maiores vendas
select o.order_id, SUM(((od.unit_price * od.quantity) - od.discount))::numeric(18,2) 
from orders o 
join order_details od 
on od.order_id = o.order_id
group by o.order_id
order by SUM(((od.unit_price * od.quantity) - od.discount))::numeric(18,2) desc
limit 10;


--Os 10 Produtos menos vendido
select p.product_name, SUM(((od.unit_price * od.quantity) - od.discount))::numeric(18,2) 
from orders o 
join order_details od 
join products p on p.product_id = od.product_id 
on od.order_id = o.order_id
group by p.product_name 
order by SUM(((od.unit_price * od.quantity) - od.discount))::numeric(18,2)
limit 10;

--Total de vendas por Categorias
select c.category_name, SUM(((od.unit_price * od.quantity) - od.discount))::numeric(18,2) 
from orders o 
join order_details od 
join products p on p.product_id = od.product_id 
join categories c on c.category_id = p.category_id 
on od.order_id = o.order_id
group by c.category_name 
order by SUM(((od.unit_price * od.quantity) - od.discount))::numeric(18,2) desc;

--Quais as 10 maiores cidades em termos de valores para a qual vendemos
select city, SUM((od.unit_price * od.quantity) - od.discount)::numeric(18,2) as vlr
from orders o
join order_details od on od.order_id = o.order_id
join customers c on c.customer_id = o.customer_id
group by city
order by SUM((od.unit_price * od.quantity) - od.discount)::numeric(18,2)  desc
limit 10;
