package TestModule3;
use strict;
use warnings;
use base 'Class::MemoryCacheable';

    my $sub1 = 0;
    my $get_class = 0;
    my $get_instance = 0;
    
    sub new {
        return bless {}, shift;
    }
    
    sub sub1 : MemoryCacheable {
        $sub1++;
        my $class = shift;
        return shift;
    }

    sub get_class : MemoryCacheable {
        $get_class++;
        return shift;
    }

    sub get_instance : MemoryCacheable {
        $get_instance++;
        return shift;
    }
    
    sub sub1_count {
        $sub1;
    }
    sub get_class_count {
        $get_class;
    }
    sub get_instance_count {
        $get_instance;
    }
    
    sub file_cache_options {
        return {
            'namespace' => 'Test',
        };
    }

1;
