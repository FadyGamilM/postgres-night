# postgres-night
today i will be good at postgres - back to relational dbs

# Data Types : 

## Numeric data types :
- integeres representation
```sql
age int2 -- this means an integer that stores only 2 bytes, so from -2^15 to 2^15 
id_card integer -- this means an integer that stores 4 bytes 
file_size bigint -- this means an integer that stores 8 bytes 
```

- decimals representation
```sql
salary numeric(5, 3) -- means 5 digits in total, 3 digits after the percision 
bonus numeric 
-- so numeric(percision, scale)
```

- floating numbers
```sql
salary real -- real is a float number with 4 bytes
salary double percision  -- 8 bytes 
```

> when dealing with financials and money, use `numeric` not `float` because its more accurate, **BUT** `float` is faster than `numeric` when it comes to do operations on it.

- money storing in database ?
> don't use money type to represent money in your system because you will lose percision 
```sql
test=# select 199.96::money;
  money  
---------
 $199.96
(1 row)

test=# select 199.964::money;
  money  
---------
 $199.96
(1 row)

test=# select 199.966::money;
  money  
---------
 $199.97
(1 row)
```
so to store money, you have 2 options, either `numeric` or `integer` becasue `floating` are not percise too !

Let's see how we store money as integers : 
- in the way in the database (From app to db)
let's say we agreed we need to store up to 4 percisions 
```sql
-- salary entered from app is 40000.456 where its 40k dollars and 456 cents :) 
test=# select (40000.456*10000)::integer as dollarsWithCents from employees;
 dollarswithcents 
------------------
        400004560
(1 row)
```

- in the way out from the database (From db to app)
```go
package main

import "log"

func main() {
	salary := int64(db.query('select dollarsWithCents from employees'))
	log.Printf("%.4f\n", float64(salary)/10000)
}
```

## Constraints [Column level and Table level] : 
- It's good to use constraints to enforce data integrity on your domains.
```sql
postgres=# create table users(
postgres(#   username varchar(255),
postgres(#   salary numeric constraint salary_must_be_positive check(salary > 0),
postgres(#   kpi numeric constraint kpi_must_be_positive check(kpi > 0), -- column level constraint 
postgres(#   -- table level constraint is used when we need to add constraints between columns against each others
postgres(#   check(salary > (kpi * 2))
postgres(# );
CREATE TABLE
```

## Search text in postgres: 
- we use `ts_vector` type to store our text as vector data type which is a `sorted list` of the atomic words with their locations from the sentence.
- then we can use the `ts_query` type to check if our query param is inside the ts_vector list 
```sql
postgres=# select to_tsvector('fady gamil mahrous is a backend engineer at halan, fady is responsible');
                                  to_tsvector                                   
--------------------------------------------------------------------------------
 'backend':6 'engin':7 'fadi':1,10 'gamil':2 'halan':9 'mahrous':3 'respons':12
(1 row)

postgres=# select to_tsquery('fady');
 to_tsquery 
------------
 'fadi'
(1 row)

postgres=# select to_tsvector('fady gamil mahrous is a backend engineer at halan, fady is responsible') @@ to_tsquery('fady');
 ?column? 
----------
 t
(1 row) 

postgres=# select to_tsvector('fady gamil mahrous is a backend engineer at halan, fady is responsible') @@ to_tsquery('fadi');
 ?column? 
----------
 t
(1 row)

postgres=# select to_tsvector('fady gamil mahrous is a backend engineer at halan, fady is responsible') @@ to_tsquery('fadia');
 ?column? 
----------
 f
(1 row)
```


## Foreign Key Constraints:
- foreign key is a concept to enforce the `referential integrity`.
```sql
test=# CREATE TABLE A (
  id bigint generated always as identity primary key, -- primary key constraint 
  x text 
);
CREATE TABLE
test=# CREATE TABLE B (
  id bigint generated always as identity primary key, -- primary key constraint 
  a_id bigint references A(id) -- foreign key constraint
);
```

- we cannot delete or update the parent row if it references by a child row unless we specify the level of restrictions on the FK
1. No-Action === Restrict
the following schema will return an error if you tried to remove parent table row before removing the childs the references this row
```sql
test=# CREATE TABLE A (
  id bigint generated always as identity primary key, -- primary key constraint 
  x text 
);
CREATE TABLE
test=# CREATE TABLE B (
  id bigint generated always as identity primary key, -- primary key constraint 
  a_id bigint references A(id) on delete no action -- foreign key constraint
);
```