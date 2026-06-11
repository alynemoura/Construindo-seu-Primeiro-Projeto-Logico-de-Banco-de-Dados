use ecommerce;
show tables;

-- gatilho para atualizar estoque:
delimiter //
create trigger atualizar_estoque after insert on item_pedido
for each row
begin
	update estoque
    set quantidade = quantidade - new.quantidade
    where id_pedido = new.id_produto;
end//

select * from pedido;

select * from pedido
where id_pedido = 7;

select * from pagamento
where status_pagamento = "Pago";

select * from status_historico
where idStatus_historico = 2 
order by data_hora desc;

select * from produto
where nome like '%phone%';

select * from pedido 
where status_pedido = 'Pendente';

show tables;
describe pedido;

select count(*) from cliente;
select count(*) from pedido;

alter table cliente
add column nome_cliente varcchar(100);

select * from cliente;
alter table cliente
drop column nome_cliente;

describe pagamento_cartao;

select
	p.id_pedido,
    c.email,
    c.telefone,
    p.data_pedido,
    p.valor_total,
    p.status_pedido,
    pg.id_pagamento,
    pg.forma,
    pg.parcela,
    pg.status_pagamento
from pedido p
inner join cliente c on p.cliente_id_cliente = c.id_cliente
inner join pagamento pg on p.id_pedido = pg.pedido_id_pedido
where p.status_pedido in ('Pendente')
order by p.data_pedido desc;

select 
	c.id_cliente,
    c.email,
    c.telefone,
    count(p.id_pedido) as total_gasto
from cliente c
left join pedido p on c.id_cliente = p.cliente_id_cliente
group by c.id_cliente, c.email, c.telefone
having count(p.id_pedido) = 0
order by c.data_cadastro;

select 
	c.id_cliente,
    c.email,
    count(p.id_pedido) as total_pedidos,
    sum(p.valor_total) as total_gasto,
    avg(p.valor_total) as ticket_medio
from cliente c
inner join pedido p on c.id_cliente = p.cliente_id_cliente
group by c.id_cliente, c.email
having count(p.id_pedido) > 1
order by total_gasto desc;

select
	p.id_pedido,
    c.email,
    p.valor_total,
    pg.forma,
    pg.parcela,
    pg.status_pagamento,
    pc.numero,
    pc.validade
from pedido p
inner join cliente c on p.cliente_id_cliente = c.id_cliente
inner join pagamento pg on p.id_pedido = pg.pedido_id_pedido
inner join pagamento_cartao pc on pg.id_pagamento = pc.pagamento_id_pagamento
where pg.forma = 'CARTÃO'
	and pg.status_pagamento = 'Pago'
order by p.data_pedido desc;

select 
    pg.forma,
    count(distinct p.id_pedido) as total_pedidos,
    sum(p.valor_total) as valor_total,
    avg(p.valor_total) as valor_medio,
    avg(pg.parcela) as media_parcelas,
    count(pc.id_pagamentocartao) as cartoes_cadastrados 
from pagamento pg 
inner join pedido p on pg.pedido_id_pedido = p.id_pedido 
left join pagamento_cartao pc on pg.id_pagamento = pc.pagamento_id_pagamento 
group by pg.forma 
order by valor_total desc;


select
	p.id_pedido,
    c.email,
    p.data_pedido,
    p.valor_total,
    p.status_pedido,
    pg.forma,
    pg.status_pagamento
from pedido p
inner join cliente c on p.cliente_id_cliente = c.id_cliente
inner join pagamento pg on p.id_pedido = pg.pedido_id_pedido
where p.data_pedido >= date_sub(curdate(), interval 30 day)
	and p.status_pedido != 'Cancelada'
order by p.data_pedido desc;

select 
	p.id_pedido,
    c.email,
    p.valor_total,
    p.status_pedido,
    pg.forma,
    pg.parcela
from pedido p
inner join cliente c on p.Cliente_id_cliente = c.id_cliente
inner join pagamento pg on p.id_pedido = pg.pedido_id_pedido
group by p.id_pedido, c.email, p.valor_total, p.status_pedido, pg.forma, pg.parcela
having p.valor_total > (select avg(valor_total) from pedido)
order by p.valor_total desc;

select 
	p.id_pedido,
    c.email,
    p.data_pedido,
    p.valor_total,
    p.status_pedido
from pedido p
inner join cliente c on p.cliente_id_cliente = c.id_cliente
left join pagamento pg on p.id_pedido = pg.pedido_id_pedido
where pg.id_pagamento is null
order by p.data_pedido desc;

select 
	coalesce(p.status_pedido, 'TOTAL GERAL') as status_pedido,
    count(*) as quantidade_pedidos,
    sum(p.valor_total) as valor_total,
    avg(p.valor_total) as valor_medio,
    count(distinct p.cliente_id_cliente) as clientes_distintos
from pedido p
group by p.status_pedido with rollup
order by quantidade_pedidos desc;

select
	date_format(p.data_pedido, '%y-%m') as ano_mes,
    pg.forma,
    count(distinct p.id_pedido) as total_pedidos,
    sum(p.valor_total) as faturamento,
    avg(p.valor_total) as ticket_medio,
    count(distinct p.cliente_id_cliente) as clientes_ativos,
    avg(pg.parcela) as media_parcelas
from pedido p
inner join pagamento pg on p.id_pedido = pg.pedido_id_pedido
where p.data_pedido >= date_sub(curdate(), interval 6 month)
	and p.status_pedido != 'Cancelado'
group by date_format(p.data_pedido, '%y-%m'), pg.forma
having faturamento > 0
order by ano_mes desc, faturamento desc;

select count(*) from pedido;
select count(*) from cliente;
select count(*) from pagamento;    
select distinct status_pedido from pedido;

select p.id_pedido, c.email
from pedido p
inner join cliente c on p.cliente_id_cliente = c.id_cliente
limit 5;