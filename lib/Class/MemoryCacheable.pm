package Class::MemoryCacheable;
use strict;
use warnings;
use Attribute::Handlers;
use Data::Dumper;
use Cache::MemoryCache;
use 5.005;
our $VERSION = '0.01';
    
    my %cache_obj;
    
    ### ---
    ### Define FileCacheable attribute
    ### ---
    sub MemoryCacheable : ATTR(CHECK) {
        
        my($pkg, $sym, $ref, undef, undef, undef) = @_;
        
        no warnings 'redefine';
        
        *{$sym} = sub {
            my $self = shift;
            my $opt = $self->file_cache_options;
            $cache_obj{$pkg} ||= new Cache::MemoryCache($opt);
            my $cache_id = *{$sym}. "\t". ($opt->{default_key} || '');
            my $output = $cache_obj{$pkg}->get($cache_id);

            ### generate cache
            if (! defined($output)) {
                no strict 'refs';
                $output = $self->$ref(@_);
                $cache_obj{$pkg}->set($cache_id, $output);
            }
            
            return $output;
        }
    }
    
    sub file_cache_options {
        
    }

1;

__END__

=head1 NAME

Class::MemoryCacheable - Make your method Memory Cacheable easily

=head1 SYNOPSIS

    use base 'Class::MemoryCacheable';
    
    sub file_cache_options {
        return {
            'namespace' => 'MyNamespace',
            #...
        };
    }
    
    sub some_sub1 : MemoryCacheable {
        
        my $self = shift;
    }
    
=head1 DESCRIPTION

This module defines an attribute "MemoryCacheable" which redefines your
functions cacheable. This module depends on L<Cache::MemoryCache> for managing
caches.

To use this, do following steps.

=over

=item use base 'Class::MemoryCacheable';

=item override the method I<file_cache_option>

=item define your subs as follows

    sub your_sub : MemoryCacheable {
        my $self = shift;
        # do something
    }

=back

That's it.

=head1 METHODS

=head2 file_cache_options

This is a callback method for specifying L<Cache::MemoryCache> options. Your
module can override the method if necessary.

    sub file_cache_options {
        return {
            'namespace' => 'Test',
        };
    }

=head2 file_cache_purge

Not implemented yet

=head1 EXAMPLE

    package GetExampleDotCom;
    use strict;
    use warnings;
    use base 'Class::MemoryCacheable';
    use LWP::Simple;
        
        sub new {
            my ($class, $url) = @_;
            return bless {url => $url}, $class;
        }
        
        sub get_url : MemoryCacheable {
            my $self = shift;
            return LWP::Simple::get($self->{url});
        }
    
        sub file_cache_options {
            my $self = shift;
            return {
                namespace => 'Test',
                default_key => $self->{url},
            };
        }

=head1 SEE ALSO

L<Cache::MemoryCache>

=head1 AUTHOR

Sugama Keita, E<lt>sugama@jamadam.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Sugama Keita.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
