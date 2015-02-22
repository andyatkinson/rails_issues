## Tips

 - Running a single test? `cd` into the module, e.g. `activerecord` and you can run a single test like `ruby -Itest test/cases/base_test.rb`.
 - `cd` into `activerecord` and run `rake -T` to see some of the rake tasks, like `test:postgresql`

Script to generate Rails app to test issues

Copied from [this gist](https://gist.github.com/bronzle/b911103cdbec55edd8b9). To use, run: `ruby sample_app.rb`

Issues being investigated:

 * [17098](https://github.com/rails/rails/issues/17098). `schema_dumper.rb` has the column object in the columns array. `pk` is also pointing at the ID column.
 It is skipped though in the primary key columns loop where it wasn't skipped before.
 The columns object does preserve the properties that were set in the migration (limit: 8, null: false)

``` ruby
=> #<ActiveRecord::ConnectionAdapters::PostgreSQLColumn:0x007f9a31da4468
 @array=false,
 @cast_type=#<ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Integer:0x007f9a31da6d80 @limit=8, @precision=nil, @scale=nil>,
 @default=nil,
 @default_function=nil,
 @name="id",
 @null=false,
 @sql_type="bigint">
```

 * [18611](https://github.com/rails/rails/issues/18611). postgres accepts `RETURNING` option on `INSERT`. http://www.postgresql.org/docs/8.2/static/sql-insert.html

  Notes: this test case, which uses sqlite3 by default, seems to indicate the sequence name does not change when set explicitly in the model, via the class method configuration. This is what the reporter is doing, except that he is using postgres and not sqlite.
  So it could be related to a code difference in the postgres database adapater specifically.
  https://github.com/rails/rails/blob/master/activerecord/test/cases/base_test.rb#L1041

  Postgres notes about creating a sequence.
  http://www.postgresql.org/docs/8.1/static/sql-createsequence.html

  What is a sequence?
  http://www.neilconway.org/docs/sequences/

``` sql
  CREATE TABLE users ( id SERIAL, name TEXT, age INT4);
  INSERT INTO users (name, age, id) VALUES ('Mozart', 20, DEFAULT);
  SELECT currval(pg_get_serial_sequence('users', 'id'));
```

``` bash
andy@[local]:5432 andy# \d+ users
                                             Table "public.users"
 Column |  Type   |                     Modifiers                      | Storage  | Stats target | Description
--------+---------+----------------------------------------------------+----------+--------------+-------------
 id     | integer | not null default nextval('users_id_seq'::regclass) | plain    |              |
 name   | text    |                                                    | extended |              |
 age    | integer |
```


  ALTER TABLE users ALTER COLUMN id SET DEFAULT nextval('public.really_cool_id_seq'::text);

  INSERT INTO users (name, age, id) VALUES ('Beethoven', 15, DEFAULT);

  Now the inserts will fail unless the sequence is created.

``` bash
  andy@[local]:5432 andy# CREATE SEQUENCE public.really_cool_id_seq START 101;
  CREATE SEQUENCE
  Time: 2.889 ms
  andy@[local]:5432 andy# INSERT INTO users (name, age, id) VALUES ('Beethoven', 15, DEFAULT);
  INSERT 0 1
  Time: 1.437 ms

  andy@[local]:5432 andy# select * from users;
   id  |   name    | age
  -----+-----------+-----
     1 | Mozart    |  20
   101 | Beethoven |  15
```

  Now we can see that the second record was inserted, with the starting value from the new sequence. So for AR configuration, I think it would have to create the new sequence, and do an alter table on it. It could take an option of a starting value.

  PR: [https://github.com/andyatkinson/rails/tree/18611_postgres_sequence_issue](https://github.com/andyatkinson/rails/tree/18611_postgres_sequence_issue)
