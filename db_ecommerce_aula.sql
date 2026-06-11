create database db_ecommerce;
use db_ecommerce;

-- Tabela Clientes
create table clients(
	idClient int auto_increment,
	Fname varchar(10) not null,
	Lname varchar(20) not null,
	FedId char(11) not null,
	BirthDate date not null,
	ZipCode char(8) not null,
	AdressNumb int not null,
	AdressComp varchar(10),
	constraint pk_clients primary key(idClient),
	constraint uq_FedId unique(FedId)
);

-- correção para auto incrementar +1
alter table clients auto_increment = 1;

-- Tabela Pagamentos
create table payments(
	idPayment int auto_increment,
	idClient int,
	PayMethods enum('Crédito', 'Débito', 'Pix', 'Boleto') default 'Pix',
	PayStatus enum('Em Aprovação', 'Confirmado', 'Estornado', 'Cancelado') default 'Em Aprovação',
	constraint pk_payments primary key( idPayment, idClient),
	constraint fk_payments_client foreign key (idClient) references clients(idClient)
);
-- correção para auto incrementar
alter table payments auto_increment = 1;

-- Tabela Produtos 
create table products(
	idProduct int auto_increment,
	Pname varchar(40) not null,
	UnCost float not null,
	UnPrice float not null,
	GroupKids boolean default false,
	Category enum(
	'Casa e Decoração',
	'Vesturio',
	'Eletronicos',
	'Livros',
	'Papelaria'
	) default 'Eletronicos',
	Reting float default 0.0,
	Psize varchar(15),
	constraint pk_products primary key(idProduct)
);

--  Correção para auto incrementar +1
alter table products auto_increment =1;

-- Tabela Pedidos
create table orders(
	idOrder int auto_increment,
    idClient int,
    OrDescription varchar(255),
    Shipping float default 15.00,
    OrStatus enum(
		'Em Processamento',
        'Aprovado',
        'Cancelado',
        'Enviado'
    ) default 'Em Processamento',
    constraint pk_orders primary key(idOrder),
    constraint fk_orders_client foreign key(idClient) references clients(idClient)
);

-- Correção para auto incrementar
alter table orders auto_increment = 1;

create table warehouses(
	idWarehouse int auto_increment,
    idProduct int,
    ZipCode char(8) not null,
    Location varchar(10),
    QtProduct int default 0,
    constraint pk_warehouse primary key(idWarehouse),
    constraint fk_productWarehouse foreign key(idProduct) references products(idProduct)
);

-- correção para auto incrementar +1
alter table warehouses auto_increment =1;

-- tabela fornecedor
create table suppliers(
	idSupplier int auto_increment,
    Sname varchar(50) not null,
    RegisterEntity char(15),
    FedId char(11),
    ZipCode char(8) not null,
    constraint pk_supplier primary key(idSupplier),
    constraint uq_supplier unique(Sname)
);

-- Taberla vendedor
create table retailers(
	idRetailer int auto_increment,
    Rname varchar(50) not null,
    RegisterEntity char(15),
    FedId char(11),
    ZipCode char(8) not null,
    constraint pk_retailer primary key(idRetailer),
    constraint uq_retailer unique (Rname)
);

-- tabela relação entre pedido e produto
create table productOrder(
	idPOrder int,
    idPOproduct int,
    OQuantity int,
    POStatus enum('Disponivel', 'Em Produção', 'Sem Estoque') default 'Disponivel',
    constraint pk_ProductOrder primary key(idPOrder, idPOproduct),
    constraint fk_POrder foreign key (idPOrder) references orders(idOrder),
    constraint fk_POproduct foreign key(idPOproduct) references products(idProduct)
);

-- tabela Relaçãoo entre vendedor e produto
create table productRetailer(
	idPRetailer int,
    idPRproduct int,
    RQuantity int,
    constraint pk_ProductRetailer primary key(idPRetailer, idPRproduct),
    constraint fk_PRetailer foreign key(idPRetailer) references retailers(idRetailer),
    constraint fk_PRproduct foreign key(idPRproduct) references products(idProduct)
);

-- tabela relação entre fornecedor e produto
create table productSupplier(
	idPSupplier int,
    idPSproduct int,
    SQuantity int,
    constraint pk_ProductSupplier primary key(idPSupplier, idPSproduct),
    constraint fk_PSupplier foreign key (idPSproduct) references suppliers(idPSproduct),
    constraint fk_PSproduct foreign key (idPSproduct) references products(idProduct)
);

show databases;
show table status;
show tables;
select * from C;
insert into clients(Fname, Lname, FedId, BirthDate, ZipCode, AdressNumb, AdressComp) values
('João', 'Silva', '12345678901', '1985-03-15', '12345678', 100, 'Apto 101'),
('Maria', 'Santos', '23456789012', '1990-07-22', '87654321', 200, 'Casa 2'),
('Pedro', 'Oliveira', '34567890123', '1982-11-10', '13579246', 50, 'Sala 5'),
('Ana', 'Ferreira', '45678901234', '1995-01-05', '24681357', 300, 'Bloco B'),
('Lucas', 'Rodrigues', '56789012345', '1988-09-18', '98765432', 75, null);

insert into payments(idClient, PayMethods, PayStatus) values
(1, 'Crédito', 'Confirmado'),
(1, 'Pix', 'Confirmado'),
(2, 'Débito', 'Confirmado'),
(3, 'Boleto', 'Em Aprovação'),
(4, 'Pix', 'Estornado');

insert into products(Pname, UnCost, UnPrice, GroupKids, Category, Reting, Psize) values
('Smartphone XYZ', 800.00, 1500.00, false, 'Eletronicos', 4.5, '15cm'),
('Camiseta Polo', 25.00, 79.90, true, 'Vesturio', 4.2, 'M'),
('Livro SQL Avançado', 35.00, 89.90, false, 'Livros', 4.8, '21cm'),
('Luminária LED', 15.00, 49.90, false, 'Casa e Decoração', 4.0, '30cm'),
('Caderno Capa Dura', 8.00, 24.90, true, 'Papelaria', 4.3, 'A4');

insert into orders(idClient, OrDescription, Shipping, OrStatus) values
(1, 'Pedido de smartphone e capa', 20.00, 'Aprovado'),
(2, 'Comprei 3 camisetas', 15.00, 'Enviado'),
(3, 'Livro técnico', 10.00, 'Em Processamento'),
(4, 'Luminária para escritório', 25.00, 'Cancelado'),
(5, 'Material escolar completo', 18.00, 'Aprovado');

insert into warehouses(idProduct, ZipCode, Location, QtProduct) values
(1, '12345678', 'A1', 50),
(2, '87654321', 'B2', 200),
(3, '13579246', 'C3', 30),
(4, '24681357', 'D4', 100),
(5, '98765432', 'E5', 75);

insert into suppliers(Sname, RegisterEntity, FedId, ZipCode) values
('TechFornecedores Ltda', '123456789012345', '11122233344', '12345678'),
('ModaBrasil Comércio', '234567890123456', '22233344455', '87654321'),
('Livros & Cia', '345678901234567', '33344455566', '13579246'),
('Casa & Cia Ltda', '456789012345678', '44455566677', '24681357'),
('Papelaria Central', '567890123456789', '55566677788', '98765432');

insert into retailers(Rname, RegisterEntity, FedId, ZipCode) values
('EletroShop', '678901234567890', '66677788899', '12345678'),
('Fashion Store', '789012345678901', '77788899900', '87654321'),
('Livraria Cultura', '890123456789012', '88899900011', '13579246'),
('Decora Lar', '901234567890123', '99900011122', '24681357'),
('Papel Express', '012345678901234', '00011122233', '98765432');

insert into productOrder(idPOrder, idPOproduct, OQuantity, POStatus) values
(1, 1, 2, 'Disponivel'),
(1, 2, 1, 'Disponivel'),
(2, 3, 1, 'Em Produção'),
(3, 4, 3, 'Disponivel'),
(4, 5, 2, 'Sem Estoque');

insert into productRetailer(idPRetailer, idPRproduct, RQuantity) values
(1, 1, 150),
(2, 2, 300),
(3, 3, 80),
(4, 4, 120),
(5, 5, 250);

insert into productSupplier(idPSupplier, idPSproduct, SQuantity) values
(1, 1, 500),
(2, 2, 1000),
(3, 3, 200),
(4, 4, 400),
(5, 5, 600);

-- Corrigindo a foreign key da tabela productSupplier
alter table productSupplier drop foreign key fk_PSupplier;
alter table productSupplier add constraint fk_PSupplier foreign key (idPSupplier) references suppliers(idSupplier);

alter table clients
add column ClientType enum('PF', 'PJ') default 'PF',
add column CompanyName varchar(100);
