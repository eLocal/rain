# Rain

Rain is a deployment engine for Rails applications. It leverages
Capistrano and Git to cleanly deploy new versions across multiple
servers. Essentially a command-line interface to both of these tools,
Rain emphasizes convention over configuration and attempts to make
continuous deployment between teams more organized and therefore, more
effective.

Designed for [eLocal](http://elocal.com), it is
currently in production use on several of our large applications. 

## Installation

Add to Gemfile

```ruby
gem 'rain'
```

Generate configuration

```bash
$ rake rain:config
```

This file tells Rain which versions are currently deployed. To start on
a different version, edit the file.

## Usage

Rain is basically CLI glue for Capistrano and Git. In essence, it
creates a new Git tag with the version number as the name, pushes that
tag to `origin/master` (or whatever your default remote is), then
commits the name of that tag to a `versions.yml` file (editing the one
you created) and pushes that to your origin as well. When all is said
and done, you'll have a commit in your master branch marking when the
release occurred, as well as a tag on origin (and locally) with the
exact commit that was deployed with Capistrano. It allows you to easily
roll back changes without keeping a bunch of directories on the server
filled with ancient app code, as well as see at-a-glance when new
deployments occurred.

### Creating the deploy task

You need a `to_{env}` task in your `config/deploy.rb` for whatever
environment you wish to deploy. The Rails environment, task and
environment in the versions.yml file must be the same name. This task 
will tell Capistrano which servers to deploy to before it runs its
`deploy` task. It basically configures Capistrano on a per-environment
basis.

### Deploying

Run the following command in your Terminal to deploy your app to every
server listed in the `to_production` task:

```bash
$ rain on production
```

Rain uses [Semantic Versioning](http://semver.org), so it is possible to
programatically increment the major or minor version instead of the
patch. In a continuous deployment setting, it is best to establish rules
for when minor or major versions are bumped. You can see the "best
practice" rules established by semver.org if you run `rain help on`.

## In The Wild

We use this deployment script at [eLocal](http://elocal.com) to deploy a
cluster of staging and production web app servers. Not only do we use it
for our main site, but the API application as well, which was the
primary motivation in developing this gem: the ability to share its code
across all of our applications.

## Contributors

- Tom Scott
- Rob Di Marco

## License

    Copyright 2012 eLocal USA, LLC

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
