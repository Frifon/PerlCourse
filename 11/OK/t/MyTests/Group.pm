package MyTests::Group;

use utf8::all;
use Test::More;
use Test::MockModule;
use base qw(Test::Class);

use feature 'say';

sub class
{
    return 'Local::OK::Group';
}

sub startup : Test(startup => no_plan)
{
    my $test = shift;
    use_ok $test->class;
    return;
}

sub constructor : Test(5)
{
    my $test = shift;
    my $class = $test->class;
       
    my $module = Test::MockModule->new($class);
    $module->mock(
                'content', 
                sub {
                    open(my $fh, '<:encoding(UTF-8)', 'html');
                    my $html = '';
                    while (my $line = <$fh>) {
                        $html .= $line;
                    }
                    close($fh);
                    return $html;
                });

    can_ok $class, 'new';
    ok my $group = $class->new('http://ok.ru/group/123123123123123'), 'group init';
    isa_ok $group, $class, 'TestGroup';
    is $group->id, 123123123123123, 'group id';
    is $group->name, 'Худей вкусно', 'group name';

}

1;