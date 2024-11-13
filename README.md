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

- money / decimals representation
```sql
salary numeric(5, 3) -- means 5 digits in total, 3 digits after the percision 
bonus numeric 
-- so numeric(percision, scale)
```