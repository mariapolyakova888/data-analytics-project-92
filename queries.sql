/* 4-й шаг проекта:
 Подсчет общего количества покупателей */

select COUNT(customer_id) as customers_count
from customers;

/* Запросы для 5-го шага проекта:

1. Отчет о десятке лучших продавцов, выполнивших наибольшую выручку.
Отсортирован по убыванию выручки */

select CONCAT(e.first_name, ' ', null, e.last_name) as name,
       COUNT(s.sales_id) as operations, 
       SUM(s.quantity * p.price) as income
from sales s
left join employees e
on s.sales_person_id = e.employee_id
inner join products p
on s.product_id = p.product_id
group by 1
order by 3 desc
limit 10
;

/* 2. Отчет о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам.
Отсортирован по возрастанию выручки */

with tab as (
    select CONCAT(e.first_name, ' ', null, e.last_name) as name,
           round(AVG(s.quantity*p.price), 0) as average_income,
           round(AVG(s.quantity * p.price), 0) as avg_income_all_employees
    from sales s
    left join employees e
    on s.sales_person_id = e.employee_id
    left join products p
    on s.product_id = p.product_id
    group by 1
    )
    
select name, average_income
from tab
group by 1, 2, avg_income_all_employees
having 2 < avg_income_all_employees
order by 2 asc
limit 10
;

/* 3. Отчет о выручке по дням недели, отсортированный по порядковому номеру дня недели */

with tab as (
    select to_char(s.sale_date, 'id') as num_weekday,
           to_char(date(s.sale_date), 'day') as weekday,
           CONCAT(e.first_name, ' ', null, e.last_name) as name,
           round(AVG(s.quantity*p.price), 0) as income
    from sales s
    left join employees e
    on s.sales_person_id = e.employee_id
    left join products p
    on s.product_id = p.product_id
    group by 1, 2, 3
    order by 1, 3
    )

select tab.name,
       tab.weekday,
       income
from tab
group by tab.name, tab.weekday, tab.num_weekday, income
order by tab.name, tab.num_weekday asc
;