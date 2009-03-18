#!perl

# Copyright (C) 2008-2009, Sebastian Riedel.

use strict;
use warnings;

use Test::More tests => 3;

use Mojo;
use MojoX::Context;
use MojoX::Renderer;

# Actually, she wasn't really my girlfriend,
# she just lived nextdoor and never closed her curtains.
my $c = MojoX::Context->new(app => Mojo->new);
$c->app->log->level('error');
my $r = MojoX::Renderer->new(default_format => 'debug');
$r->add_handler(
    debug => sub {
        my ($self, $c, $output) = @_;
        $$output .= 'Hello Mojo!';
    }
);
$c->stash->{partial}  = 1;
$c->stash->{template} = 'something';
$c->stash->{format}   = 'something';

# Normal rendering
$c->stash->{handler} = 'debug';
is($r->render($c), 'Hello Mojo!', 'normal rendering');

# Normal rendering with path with dots
$c->stash->{template} = 'some.path.with.dots/template';
$c->stash->{handler} = 'debug';
is($r->render($c), 'Hello Mojo!', 'normal rendering with path with dots');

# Unrecognized handler
$c->stash->{handler} = 'not_defined';
is($r->render($c), undef, 'return undef for unrecognized handler');
