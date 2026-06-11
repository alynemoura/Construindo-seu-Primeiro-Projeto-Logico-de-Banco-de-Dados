use db_ecommerce;

select * from clients 
where ClientType = 'PF';

select Pname, UnPrice from products 
where UnPrice > 100;

Select idOrder, OrDescription from orders
where OrStatus = 'Enviado';

select concat(Fname, ' ', Lname) as NomeCompleto, ZipCode
from clients 
where ZipCode like '123%';

select Pname, Category, Reting
from products
where Category = 'Eletronicos' and Reting > 4;

select Pname,
	   UnPrice as PrecoVenda,
       UnCost as PrecoCusto,
       (UnPrice - Uncost) as LucroUnitario,
       ((UnPrice - Uncost) / Uncost * 100) as MargemPercentual
from products; 

select Pname, UnPrice 
from products 
order by UnPrice desc;

select c.idClient,
	   concat(c.Fname, ' ' , c.Lname) as NomeCliente,
       count(o.idOrder)  as TotalPedidos
from clients c
left join orders o on c.idClient = o.idClient
group by c.idClient
having TotalPedidos > 1;

select p.idProduct,
	   p.Pname,
       avg(w.QtProduct) as MediaEstoque
from products p
join warehouses w on p.idProduct = w.idProduct
group by p.idProduct
having MediaEstoque > 50;

select * from payments where PayStatus = 'Confirmado';

select idOrder,
	   Shipping,
       Shipping * 1.1 as FreteComTaxa,
       OrStatus
from orders;

select idClient,
	count(*) as TotalPedidos,
    avg(Shipping) as MediaFrete
from orders
group by idClient;

select * from orders
order by OrStatus, idOrder desc;

select * from clients
order by Fname, Lname;

select idClient,
	count(*) as TotalPedidos
from orders
group by idClient
having TotalPedidos > 1;

select PayMethods,
	count(*) as Quantidade,
    count(distinct idClient) as ClientessUnicoss
from payments
group by PayMethods
having Quantidade > 1;

select o.idOrder,
	concat(c.Fname, ' ' , c.Lname) as NomeCliente,
    c.FedId as Documento,
    o.OrDescription,
    o.Shipping,
    o.OrStatus as StatusPedido,
    p.PayMethods as FormaPagamento,
    p.PayStatus as StatusPagamento
from orders o
inner join clients c on o.idClient = c.idClient
left join payments p on c.idClient = p.idClient
order by o.idOrder desc;



select
	(select count(*) from clients) as TotaklClientes,
    (select count(*) from orders) as TotalPedidos,
    (select count(*) from payments where PayStatus = 'Confirmado') as PagamentosConfirmados,
    (select avg(shipping) from orders) as MediaFreteGeral;
    
