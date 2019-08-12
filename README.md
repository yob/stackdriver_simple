# stackdriver_simple

It's surprisingly hard to submit metrics directly to stackdriver using ruby.

The [official docs](https://cloud.google.com/monitoring/custom-metrics/open-census)
recommend using [opencensus](https://opencensus.io/), but the stackdriver
backend for the ruby opencensus implementation is incomplete.

I eventually worked out the right voodoo, but it's not the kind of code you want
to re-implement in multiple projects.

## Installation

Manually:

    gem install stackdriver_simple

or, in your Gemfile:

    gem "stackdriver_simple"

## Usage

### Authentication

This is just a wrapper around an official google gem that knows the well-known
places to look for valid credentials.

One option is to have credentials in a JSON file. If you have the `gcloud` SDK
installed, the following command will save some credentials to disk in a place
where the gem will find them:

    gcloud auth application-default login

If you have a JSON file with gcloud credentials in another location, set the GOOGLE_APPLICATION_CREDENTIALS environment variable like this:

    GOOGLE_APPLICATION_CREDENTIALS=/path/to/credentials.json ruby my-script.rb

Alternatively, if you're running a program on Google Compute Engine the
instance metadata will contain valid credentials too.

### Gauges

Submit a gauge like this:

    require 'stackdriver_simple'

    StackdriverSimple.new(google_cloud_project: "my-project-id").submit_gauge("gauge_name", 123)

### Other metric types

There are other metrics types that could be submitted, I just haven't
implemented them yet. Pull requests are welcome!
