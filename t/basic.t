package main;
use strict;
use warnings;
use lib 't/lib';
use Test::More;
use base 'Test::Class';
use TestModule3;
use File::Path;
    
    my $cache_namespace_base = 't/cache/Test';
    
    __PACKAGE__->runtests;
    
    sub oop_basic : Test(9) {
        
        if (-d $cache_namespace_base) {
            rmtree($cache_namespace_base);
        }
        
        is(TestModule3->get_class, 'TestModule3'); # must be cached
        is(TestModule3->get_class, 'TestModule3');
        
        is(TestModule3::get_class_count, 1);
        
        is(TestModule3->sub1('test'), 'test'); # must be cached
        is(TestModule3->sub1('test2'), 'test');
        
        is(TestModule3::sub1_count, 1);
        
        my $instance = TestModule3->new;
        like($instance->get_instance, qr{^TestModule3}); # must be cached
        like($instance->get_instance, qr{^TestModule3});
        
        is(TestModule3::get_instance_count, 1);
    }
    