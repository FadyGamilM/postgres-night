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