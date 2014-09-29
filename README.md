Smallest possible Rails app

Copied from [this gist](https://gist.github.com/bronzle/b911103cdbec55edd8b9). The purpose of this is to be able to have a reference to an easy way to create the smallest possible Rails app to reproduce an issue.

Issues being investigated:

 * [17098](https://github.com/rails/rails/issues/17098). `schema_dumper.rb` may have started ignoring the `id` key. Unclear if the problem is on the generation side or the dumper side.
