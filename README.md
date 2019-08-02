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

First you'll need a set of valid GCP credentials. These are usually kept in a
JSON file on disk, but if you're running a program on Google Compute Engine the
instance metadata will contain them too.

If you have the `gcloud` SDK installed, the following command will save some credentials to disk in a place where the gem will find them:

    gcloud auth application-default login

### Gauges

Submit a gauge like this:

    require 'stackdriver_simple'

    StackdriverSimple.new(google_cloud_project: "my-projetc-id").submit_gauge("gause_name", 123)
