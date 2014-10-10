Script to generate Rails app to test issues

Copied from [this gist](https://gist.github.com/bronzle/b911103cdbec55edd8b9). To use, run: `ruby sample_app.rb`

Issues being investigated:

 * [17098](https://github.com/rails/rails/issues/17098). `schema_dumper.rb` may have started ignoring the `id` key. Unclear if the problem is on the generation side or the dumper side.
