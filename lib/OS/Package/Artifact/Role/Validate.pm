use v5.14.0;
use warnings;

package OS::Package::Artifact::Role::Validate;

# ABSTRACT: Default Abstract Description, Please Change.
# VERSION

use Digest::MD5;
use Digest::SHA;
use OS::Package::Log;
use Path::Tiny;
use Role::Tiny;

sub validate {
    my $self = shift;

    if ( defined $self->md5 ) {
        $self->validate_md5;
    }

    if ( defined $self->sha1 ) {
        $self->validate_sha1;
    }

    return 1;
}

sub validate_md5 {
    my $self = shift;

    my $md5 = Digest::MD5->new();
    my $fh  = path( $self->savefile )->openr;

    $md5->addfile($fh)
        or
        $LOGGER->logcroak( sprintf 'cannot open file %s', $self->savefile );

    if ( $md5->hexdigest eq $self->md5 ) {
        $LOGGER->info( sprintf 'md5 checksum ok: %s', $self->distfile );
        return 1;
    }

    $LOGGER->fatal( sprintf 'md5 checksum bad: %s', $self->distfile );
    return 0;
}

sub validate_sha1 {
    my $self = shift;

    my $sha = Digest::SHA->new;

    $sha->addfile( $self->savefile );

    if ( $sha->hexdigest eq $self->sha1 ) {
        $LOGGER->info( sprintf 'sha1 checksum ok: %s', $self->distfile );
        return 1;
    }

    $LOGGER->fatal( sprintf 'sha1 checksum bad: %s', $self->distfile );
    return 0;

}

1;