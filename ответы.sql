Задача: Используя схему БД склада с таблицами goods (товары), warehouse (склады), product
        (продукты), brand (бренды продуктов), составить запрос, который выводит список брендов
        (brand.name) с указанием количества единиц продукта в порядке убывания их количества на
        каждом складе для текущего бренда. Необходимо учитывать, что по некоторым брендам на
        складах могут отсутствовать товары на единицу времени, при этом в вывод такие бренды
        также должны попадать. Под отсутствием понимать отсутствие записи продукта в таблице
        товаров (goods), а не нулевое количество.

'''
   brand             product                   goods                       warehouse               
   -----             -----------               -----------------           ---------                         
   id(PK)  <---,     id(PK)       <----,       id(PK)               ,----> id(PK)                                           
   name        |     name              |       warehouse_id (FK) ---       name                                                 
   country      ---- brand_id (FK)      -------product_id   (FK)                                               
                                               quantity
'''
Решение: используется postgres

select
    b.country as Страна,
    b.name as Бренд,
    p.name as Продукт, 
    g.quantity as Количество, 
    w.name as Склады 
from
    product as p, 
    goods as g, 
    warehouse as w,
    brand as b
where
    p.id = g.product_id and g.warehouse_id = w.id and p.brand_id = b.id
order by
    b.name, 
    g.quantity desc;


Задача: для приведенной в Задаче 1 схемы данных:
        a.  вывести список складов (warehouse.name) с суммарными 
            остатками продуктов немецких брендов (brand.country="DE").
        b.  вывести продукты (product.name) с указанием их бренда (brand.name), 
            которые в данный момент отсутствуют на всех складах. 
            Под отсутствием понимать отсутствие записи продукта в таблице 
            товаров (goods), а не нулевое количество.
        c.  вывести те продукты (product.name), остатки по которым по 
            всем складам суммарно превышают 100 единиц (goods.quantity) 
            с указанием склада (warehouse.name), на котором находится наибольшее количество единиц.


a) 
select 
    sum(g.quantity) Количество,
    w.name Склад
from 
    brand b,
    goods g,
    product p,
    warehouse w
where 
    b.id = p.brand_id 
    and p.id = g.product_id 
    and w.id = g.warehouse_id
    and b.country = 'DE'
group by 
    w.name
order by 
    w.name;

b)
select 
    p.name Продукт, 
    b.name Бренд
from 
    product p, 
    brand b 
where 
    p.brand_id = b.id and p.id not in   (select 
                                            product_id
                                        from    
                                            goods
                                        )       
order by 
    p.name;

c)
select 
    p.name Продукт, 
    query_in.sum Количество,
    w.name Склад
from 
    (
        select 
            sum(g.quantity) sum,
            max(g.quantity) max,
            g.product_id product_id
        from 
            goods g
        group by
            g.product_id
    ) query_in,
    product p,
    goods g,
    warehouse w
where 
    query_in.product_id = p.id 
    and query_in.max = g.quantity 
    and query_in.sum > 100 
    and w.id = g.warehouse_id;






