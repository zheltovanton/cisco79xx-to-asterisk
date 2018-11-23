#!/usr/bin/perl

use strict;
use POSIX;
use English qw/-no_match_vars/;
use IO::File;

our $GZIP_HEADER = "\x1f\x8b";

eval {
    my $cop_sgn = shift;

    die 'no input file' unless (length $cop_sgn);
    die 'invalid suffix (must be .cop.sgn)' unless ($cop_sgn =~ m/\.cop.sgn$/);

    (my $tar_gz = $cop_sgn) =~ s/\.cop\.sgn$/.tar.gz/;

    die 'open: ' . $OS_ERROR unless (my $input = IO::File->new ($cop_sgn, '<'));
    die 'read: ' . $OS_ERROR unless ($input->read (my $content, 512));

    if ($content =~ m/$GZIP_HEADER/g) { # need /g to make pos() work
	my $offset = pos ($content) - length ($GZIP_HEADER);

	die 'open: ' . $OS_ERROR unless (my $output = IO::File->new ($tar_gz, '>', 0600));

	$output->print (substr ($content, $offset));

	while ($input->read (my $content, 4096)) {
	    $output->print ($content);
	}

	$output->close;
    } else {
	STDERR->print ('gzip header not found', "\n");
    }

    $input->close;
};

if (length $EVAL_ERROR) {
    STDERR->print ($EVAL_ERROR);
    exit EXIT_FAILURE;
}

exit EXIT_SUCCESS;
