drop database if exists supermercado_triggers;
create database supermercado_triggers;
use supermercado_triggers;

create table if not exists tipo_productos(
	id int primary key auto_increment,
    nombre varchar(50) not null
);

create table if not exists productos(
	id int primary key auto_increment,
    id_tipo_producto int not null,
    nombre varchar(50) not null,
    valor_venta int not null,
    foreign key (id_tipo_producto) references tipo_productos(id)
		on delete cascade
		on update cascade
);

create table if not exists inventario(
	id int primary key auto_increment,
	id_producto int not null,
    cantidad int not null,
    valor int,
    foreign key (id_producto) references productos(id)
		on delete cascade
        on update cascade
);

insert into tipo_productos(nombre) values ('carnes');
insert into tipo_productos(nombre) values ('frutas');

insert into productos(id_tipo_producto, nombre, valor_venta) values (1, 'molida', 14985);
insert into productos(id_tipo_producto, nombre, valor_venta) values (1, 'costilla de res', 14650);
insert into productos(id_tipo_producto, nombre, valor_venta) values (2, 'banano criollo (1lb)', 1900);
insert into productos(id_tipo_producto, nombre, valor_venta) values (2, 'fresa (1lb)', 12500);

-- select * from tipo_productos;
-- select * from productos;
-- select * from inventario;

-- Trigger
delimiter !
create trigger insercion_valor_total_productos before insert 
on inventario for each row
begin
	declare unidades int;
    declare valor_unidad int;
    declare precio_total int;
    
    --  Error: select new.cantidad into unidades from inventario;
    set unidades = new.cantidad;
    select P.valor_venta into valor_unidad from productos as P where P.id = new.id_producto;
    
    set precio_total = (unidades * valor_unidad);
	
    -- Error: update inventario set valor = precio_total where id = new.id;
    set new.valor = precio_total;
end
!
delimiter ;

insert into inventario(id_producto, cantidad) values (1, 2);
insert into inventario(id_producto, cantidad) values (2, 3);
insert into inventario(id_producto, cantidad) values (3, 14);
insert into inventario(id_producto, cantidad) values (4, 7);
-- drop trigger insercion_valor_total_productos;
