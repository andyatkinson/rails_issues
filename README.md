Script to generate Rails app to test issues

Copied from [this gist](https://gist.github.com/bronzle/b911103cdbec55edd8b9). To use, run: `ruby sample_app.rb`

Issues being investigated:

 * [17098](https://github.com/rails/rails/issues/17098). `schema_dumper.rb` has the column object in the columns array. `pk` is also pointing at the ID column. It is skipped though in the primary key columns loop where it wasn't skipped before. The columns object doesn't preserve the properties that were set in the migration.

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
