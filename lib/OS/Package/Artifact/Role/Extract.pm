use v5.14.0;
use warnings;

package OS::Package::Artifact::Role::Extract;

use Archive::Extract;
use File::Path qw( make_path );
use OS::Package::Config;
use OS::Package::Log;
use Role::Tiny;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

local $Archive::Extract::PREFER_BIN = 1;

sub extract {

    my $self = shift;

    if ( !-d $self->workdir ) {
        make_path $self->workdir;
    }

    my $archive = Archive::Extract->new( archive => $self->artifact );

    $LOGGER->info( sprintf 'extracting archive: %s', $self->distfile );

    $archive->extract( to => $self->workdir );

    $self->archive($archive);

    $LOGGER->info( sprintf 'extracted archive: %s',
        $self->archive->extract_path );

    return;

}

1;

=method extract